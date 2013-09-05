Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9AA047F5D
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 11:22:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 776F08F8040
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:22:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vTaxlH9SIQMYsvDp for
	<xfs@oss.sgi.com>; Thu, 05 Sep 2013 09:22:25 -0700 (PDT)
Message-ID: <5228AEE7.2070207@redhat.com>
Date: Thu, 05 Sep 2013 12:18:47 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 09/11] xfs: use and update the finobt on inode
	allocation
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-10-git-send-email-bfoster@redhat.com>
	<20130905022719.GW23571@dastard>
In-Reply-To: <20130905022719.GW23571@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/2013 10:27 PM, Dave Chinner wrote:
> On Tue, Sep 03, 2013 at 02:25:06PM -0400, Brian Foster wrote:
>> Replace xfs_dialloc_ag() with an implementation that looks for a
>> record in the finobt. The finobt only tracks records with at least
>> one free inode. This eliminates the need for the intra-ag scan in
>> the original algorithm. Once the inode is allocated, update the
>> finobt appropriately (possibly removing the record) as well as the
>> inobt.
>>
>> Move the original xfs_dialloc_ag() algorithm to
>> xfs_dialloc_ag_slow() and fall back as such if finobt support is
>> not enabled.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_ialloc.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 135 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
>> index e64a728..516f4af 100644
>> --- a/fs/xfs/xfs_ialloc.c
>> +++ b/fs/xfs/xfs_ialloc.c
>> @@ -708,7 +708,7 @@ xfs_ialloc_get_rec(
>>   * available.
>>   */
...
> 
> Why do we need to initialise both cursors at once? We only do the
> operations one at a time, and you should actually use 2 cursors
> for the finobt lookup.....
> 

No good reason. I probably just did that to simplify error handling.

>> +
>> +	/*
>> +	 * Search the finobt.
>> +	 */
>> +	error = xfs_inobt_lookup(fcur, pagino, XFS_LOOKUP_LE, &i);
>> +	if (error)
>> +		goto error;
>> +	if (i == 0) {
>> +		error = xfs_inobt_lookup(fcur, pagino, XFS_LOOKUP_GE, &i);
>> +		if (error)
>> +			goto error;
>> +		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
>> +	}
> 
> .... because this biases allocation to lower inode numbers than the
> target. i.e we only ever search for higher numbers if here are none
> lower. That's quite different to the current algorithm which first
> searches for the *closest* free inode.
> 
> That is, we should be using two cursors for the free inode search,
> one for LE, the other for GT. If they both return records then, like
> the "slow" algorithm, calculate the diff between them and the target
> inode, and select the closer one (smallest diff). Destroy the cursor
> you don't need.
> 

Ah, Ok. I hadn't taken a close enough look at the existing algorithm
yet, to be honest. I'll do so and incorporate the closest free inode
heuristic.

...
>> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
>> +	xfs_perag_put(pag);
>> +
>> +	error = xfs_check_agi_freecount(fcur, agi);
>> +	if (error)
>> +		goto error;
>> +	error = xfs_check_agi_freecount(icur, agi);
>> +	if (error)
>> +		goto error;
> 
> Failures here will result in 2 calls to xfs_perag_put(pag);
> 

Yeah, thanks.

Brian

>> +
>> +	xfs_btree_del_cursor(icur, XFS_BTREE_NOERROR);
>> +	xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
>> +	*inop = ino;
>> +	return 0;
>> +error:
>> +	xfs_perag_put(pag);
>> +	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
>> +	xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
>> +	return error;
>> +}
> 
> Otherwise it looks good.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
