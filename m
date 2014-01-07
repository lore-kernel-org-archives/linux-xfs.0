Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B82117F37
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 00:58:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA6A38F8035
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 22:58:28 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7BYl7EvCYiFxgNG4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jan 2014 22:58:26 -0800 (PST)
Message-ID: <52CBA58B.30504@oracle.com>
Date: Tue, 07 Jan 2014 14:58:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/10] xfs: consolidate xfs_inumbers
References: <52BEB3FA.5080402@oracle.com>
	<52C72362.2000005@redhat.com>	<52CA4BDB.7010804@oracle.com>
	<52CAC622.2020805@redhat.com>
In-Reply-To: <52CAC622.2020805@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 01/06 2014 23:05 PM, Brian Foster wrote:
> On 01/06/2014 01:23 AM, Jeff Liu wrote:
>> On 01/04 2014 04:53 AM, Brian Foster wrote:
>>> On 12/28/2013 06:20 AM, Jeff Liu wrote:
>>>> From: Jie Liu <jeff.liu@oracle.com>
>>>>
>>>> To fetch the file system number tables, we currently just ignore the
>>>> errors and proceed to loop over the next AG or bump agino to the next
>>>> chunk in case of btree operations failed, that is not properly because
>>>> those errors might hint us potential file system problems.
>>>>
>>>> This patch rework xfs_inumbers() to handle the btree operation errors
>>>> as well as the loop conditions.  Also, add pre-checkups for the given
>>>> inode, we can save alloc/free the format buffer once against an invalid
>>>> inode number.
>>>>
>>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>>> ---
>>>>  fs/xfs/xfs_itable.c | 163 +++++++++++++++++++++++-----------------------------
>>>>  1 file changed, 72 insertions(+), 91 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>>>> index 692671c..4d262f6 100644
>>>> --- a/fs/xfs/xfs_itable.c
>>>> +++ b/fs/xfs/xfs_itable.c
> ...
>>>> -		error = xfs_inobt_get_rec(cur, &r, &i);
>>>> -		if (error || i == 0) {
>>>> -			xfs_buf_relse(agbp);
>>>> -			agbp = NULL;
>>>> -			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>>>> -			cur = NULL;
>>>> -			agno++;
>>>> -			agino = 0;
>>>> -			continue;
>>>> +		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &stat);
>>>> +		if (error)
>>>> +			break;
>>>
>>> Isn't this lookup only needed after cursor initialization? i.e., we
>>> lookup once and increment through the records via xfs_btree_increment()
>>> below.
>>
>> Yes, but please see my comments below.
>>>
> ...
>>>> +		if (!--left)
>>>> +			break;
>>>> +
>>>> +		error = xfs_btree_increment(cur, 0, &stat);
>>>> +		if (error)
>>>> +			break;
>>>> +		if (stat) {
>>>> +			/*
>>>> +			 * The agino value has already been bumped, just try
>>>> +			 * to skip up to it.
>>>> +			 */
>>>> +			agino += XFS_INODES_PER_CHUNK;
>>>> +			continue;
>>>>  		}
>>>
>>> Maybe it's just me, but this reads a little funny to me. In particular
>>> because we only get here if stat == 1. I wonder if this would look a bit
>>> cleaner if we pulled the next_ag labeled block below up into the goto,
>>> since that appears to be the only reference. Then just let the loop fall
>>> through.
>>
>> Actually, we would never hint xfs_btree_increment() at all no matter the default
>> or with my current change, because the left variable value is 1 as per the user
>> space imap implementation, thus, it should be decreased to 0 in this point.
>>
>> The problem is, how we define the user call interface originally, why it does not
>> support a 2nd argument which can be used to specified a desired icount to return a
>> limited number of inode mapping tables? i.e,
>>
>> imap_f() {
>>
>>         if (argc != 2)
>>                 nent = 1;
>>         else
>>                 nent = atoi(argv[1]);
>>
>> 	....
>> }
>>
>> The imap command does not support another options but initialize bulkreq.icount = nent = 1;
>> In kernel, the bcount is evaluated to 1 and if (bufidx == bcount) should be true anyway as
>> below code logic:
>>  
>> bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
>>
>> if (bufidx == bcount) {
>> 	....
>> 	formatter();
>> 	....
>> }
> 
> Hi Jeff,

Hi Brian,
> 
> I see, but this is just a characteristic of the imap command in xfs_io.
> I can use an argument just by changing argmax from 0 to 1. Perhaps this
> is just a bug, since 'help imap' provides syntax that allows a parameter:
> 
> xfs_io> help imap
> imap [nentries] -- inode map for filesystem of current file

I also thought we should fix the command usage in terms of the help menu,
though I missed a long history of XFS development... > >>
>> But, if the left value could be specified from the user progs, maybe we cannot simply
>> assuming "stat == 1" is always be true, in particular, in next path for implementing
>> per AG inumber mechanism, xfs_btree_increment() would probably succeed but "stat == 0"
>> if there is no right neighbors, and if the user could specified the 2nd imap option.
>>
> 
> Hmm, that looked odd to me as well once you pointed that out. A quick
> printk check shows that xfs_btree_increment() does not fail in this
> scenario, but the subsequent xfs_inobt_get_rec() in the following
> iteration sets i == 0 and skips to the next ag appropriately. I agree
> that a tmp == 0 check in this scenario would be slightly more intuitive
> though.
> 
> But either way, we should probably maintain the general algorithm of
> walking the btree explicitly rather than incrementing agino and issuing
> the lookup each iteration of the loop.
> 
>> Hence, in this patch, I only intended to fix the btree error handling mechanism as a
>> preparation step to implement per AG inumber.
>>
> 
> Right... I see that the following patches clean this up further (though
> I haven't looked in detail yet).
> 
>>>  
>>> Also, I think the agino addition here becomes unnecessary when the
>>> lookup issue above is addressed.
>>>
>>>> -	}
>>>> +
>>>> +next_ag:
>>>> +		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>>>> +		cur = NULL;
>>>> +		xfs_buf_relse(agbp);
>>>> +		agbp = NULL;
>>>> +		agino = 0;
>>>> +	} while (++agno < mp->m_sb.sb_agcount);
>>>> +
>>>
>>> ... and just thinking about the logic that way highlights the bug here,
>>> where we bump agno due to the continue above (where IIUC, we intend to
>>> only move forward within the ag). Perhaps the ++agno should be part of
>>> the broken off 'next_ag' logic as well.
>>
>> Can you please point out a bit more about the bug?  We bump agno due to
>> current run out of the current AG but the user want to show more imaps.
>>
> 
> agno is bumped in the while condition at the end of the loop. This will
> also be executed in the following block if xfs_btree_increment()
> succeeds and finds a record to the right:
> 
>                 error = xfs_btree_increment(cur, 0, &stat);
>                 if (error)
>                         break;
>                 if (stat) {
>                         ...
>                         agino += XFS_INODES_PER_CHUNK;
> ------>                 continue;
>                 }
> 
> The continue statement will execute the loop condition to determine
> whether it should iterate the loop again or break. In this case, you're
> still moving along the original AG, but agno has been bumped
> erroneously. This error looks to be hidden by the non-looping scenario
> where nentries is 1, but make the xfsprogs fix I described above and
> you'll probably see what I'm describing. I only see a subset of the
> original imap output using a record count of 10 on an fs with a couple
> thousand inodes spread across a couple AGs.
> 
> FWIW, it does look like the following patch fixes this particular
> problem via the introduction of xfs_perag_inumbers(), but we shouldn't
> introduce transient errors into the patch stream if we can help it.

Thanks for your so much detailed clarifications, now I can see what you
mean. :)  and Yep, that is really a problem should be fixed here.

> It looks like the comments about the repeated inobt lookups still apply
> though (and the implementation as of patch 4 is still skipping inodes
> with nentries > 1, perhaps due to advancing agino multiple times per
> iteration..?).

Hmm...,now I think it does not needed, and the forth patch would be changed
in next round of post just as you pointed out, i.e, the xfs_inobt_lookup()
only need to call once, and then it could be moved out of the loop, and the
agino don't need to bump again so, an increased patch against [patch 4] would
looks like below:

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 764e169..ff7efaf 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -595,6 +595,7 @@ xfs_perag_inumbers(
 	struct xfs_agi		*agi;
 	struct xfs_buf		*agbp;
 	struct xfs_btree_cur	*cur;
+	int			stat;
 	int			error;
 
 	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
@@ -602,14 +603,13 @@ xfs_perag_inumbers(
 		return error;
 	agi = XFS_BUF_TO_AGI(agbp);
 	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
+	/* Done if failed to lookup or no inode chuck is found */
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &stat);
+	if (error || stat == 0)
+		goto error0;
+
 	for (;;) {
 		struct xfs_inobt_rec_incore	r;
-		int				stat;
-
-		/* Done if failed to lookup or no inode chuck is found */
-		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &stat);
-		if (error || stat == 0)
-			break;
 
 		error = xfs_inobt_get_rec(cur, &r, &stat);
 		if (error)
@@ -629,9 +629,9 @@ xfs_perag_inumbers(
 			error = formatter(ubuffer, buffer, bufidx, &written);
 			if (error)
 				break;
-			ubuffer += written;
 			count += bufidx;
 			bufidx = 0;
+			break;
 		}
 		if (!--ubleft)
 			break;
@@ -641,12 +641,6 @@ xfs_perag_inumbers(
 			/* Done if failed or there are no rightward entries */
 			break;
 		}
-
-		/*
-		 * The agino value has already been bumped.  Just try to skip
-		 * up to it.
-		 */
-		agino += XFS_INODES_PER_CHUNK;
 	}
 
 	if (!error) {


Above temporary patch is just for demonstration purpose, I'll run extra tests
combine with your xfs_io/imap fix.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
