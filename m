Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A06277F76
	for <xfs@oss.sgi.com>; Thu, 29 May 2014 09:27:48 -0500 (CDT)
Message-ID: <538743E0.70103@sgi.com>
Date: Thu, 29 May 2014 09:27:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
References: <1378132151-2685-1-git-send-email-linkinjeon@gmail.com>
	<53850F92.7010401@sgi.com> <20140527225138.GD8554@dastard>
	<53851836.2070301@sgi.com> <20140528002906.GH8554@dastard>
In-Reply-To: <20140528002906.GH8554@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/27/14 19:29, Dave Chinner wrote:
> On Tue, May 27, 2014 at 05:56:54PM -0500, Mark Tinguely wrote:
>> On 05/27/14 17:51, Dave Chinner wrote:
>>> On Tue, May 27, 2014 at 05:20:02PM -0500, Mark Tinguely wrote:
>>>> On 09/02/13 09:29, Namjae Jeon wrote:
>>>>> From: Namjae Jeon<namjae.jeon@samsung.com>
>>>>>
>>>>> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.
>>>>>
>>>>> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>>>>> Signed-off-by: Ashish Sangwan<a.sangwan@samsung.com>
>>>>> ---
>>>>
>>>>> +		/* Check if we can merge 2 adjacent extents */
>>>>> +		if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY)&&
>>>>> +		    left.br_startoff + left.br_blockcount == startoff &&
>>>>> +		    left.br_startblock + left.br_blockcount ==
>>>>> +		    xfs_bmbt_get_startblock(gotp) &&
>>>>> +		    xfs_bmbt_get_state(gotp) == left.br_state &&
>>>>> +		    left.br_blockcount + xfs_bmbt_get_blockcount(gotp)<=
>>>>> +		    MAXEXTLEN) {
>>>>> +			blockcount =
>>>>> +			left.br_blockcount + xfs_bmbt_get_blockcount(gotp);
>>>>> +			state |= BMAP_LEFT_CONTIG;
>>>>> +			xfs_iext_remove(ip, *current_ext, 1, 0);
>>>>> +			XFS_IFORK_NEXT_SET(ip, whichfork,
>>>>> +				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>>>>> +			gotp = xfs_iext_get_ext(ifp, --*current_ext);
>>>>> +		}
>>>>> +
>>>>> +		if (cur) {
>>>>> +			error = xfs_bmbt_lookup_eq(cur,
>>>>> +					xfs_bmbt_get_startoff(gotp),
>>>>> +					xfs_bmbt_get_startblock(gotp),
>>>>> +					xfs_bmbt_get_blockcount(gotp),
>>>>> +					&i);
>>>>> +			if (error)
>>>>> +				goto del_cursor;
>>>>> +			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>>>>
>>>> I can reliably trigger this XFS_WANT_CORRUPTED_GOTO() with a
>>>> fsstress that fills the filesystem:
>>>>
>>>> xfstests>   ltp/fsstress -d /mnt/scratch -s 1370236858 -p 512 -n 8192&
>>>
>>> Hasn't reproduced after 10 minutes of running at ENOSPC here - how
>>> long does it take to reproduce? What storage hardware are you
>>> testing on? How many CPUs? RAM? ....
>>>
>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>>
>>> Cheers,
>>>
>>> Dave.
>>
>> A 7-8 hours on spinning rust. This is my burn in test.
>
> Can you try to narrow the problem down? Otherwise it's going to be a
> case of looking for a needle in a haystack....
>
> Cheers,
>
> Dave.

Nod on the needle in a hay stack if it bmbt is really corrupt.

I am running fsstress from xfstests with the top commit 9b7f704, and I 
don't see any newer fsstress patches since then.

I moved the test to another box with a kdump that works on top of tree 
Linux and grabbed a vmcore. I grabbed a metadata dump of the filesystem 
after the ASSERT. That should give some idea of what inode/block it was 
looking up.

I sent email to Namjae when I first tripped over this problem in late 
April. No longer on the face of the earth and I can't look at this until 
the weekend.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
