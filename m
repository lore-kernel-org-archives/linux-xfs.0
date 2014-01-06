Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 989707F3F
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 00:23:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77BFD8F8039
	for <xfs@oss.sgi.com>; Sun,  5 Jan 2014 22:23:31 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zlw4PsKcn6ViGfCD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 05 Jan 2014 22:23:30 -0800 (PST)
Message-ID: <52CA4BDB.7010804@oracle.com>
Date: Mon, 06 Jan 2014 14:23:23 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/10] xfs: consolidate xfs_inumbers
References: <52BEB3FA.5080402@oracle.com> <52C72362.2000005@redhat.com>
In-Reply-To: <52C72362.2000005@redhat.com>
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

On 01/04 2014 04:53 AM, Brian Foster wrote:
> On 12/28/2013 06:20 AM, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> To fetch the file system number tables, we currently just ignore the
>> errors and proceed to loop over the next AG or bump agino to the next
>> chunk in case of btree operations failed, that is not properly because
>> those errors might hint us potential file system problems.
>>
>> This patch rework xfs_inumbers() to handle the btree operation errors
>> as well as the loop conditions.  Also, add pre-checkups for the given
>> inode, we can save alloc/free the format buffer once against an invalid
>> inode number.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_itable.c | 163 +++++++++++++++++++++++-----------------------------
>>  1 file changed, 72 insertions(+), 91 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index 692671c..4d262f6 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -558,12 +558,12 @@ xfs_bulkstat_single(
>>  int
>>  xfs_inumbers_fmt(
>>  	void			__user *ubuffer, /* buffer to write to */
>> -	const xfs_inogrp_t	*buffer,	/* buffer to read from */
>> +	const struct xfs_inogrp	*buffer,	/* buffer to read from */
>>  	long			count,		/* # of elements to read */
>>  	long			*written)	/* # of bytes written */
>>  {
>>  	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
>> -		return -EFAULT;
>> +		return XFS_ERROR(EFAULT);
>>  	*written = count * sizeof(*buffer);
>>  	return 0;
>>  }
>> @@ -573,121 +573,102 @@ xfs_inumbers_fmt(
>>   */
>>  int					/* error status */
>>  xfs_inumbers(
>> -	xfs_mount_t	*mp,		/* mount point for filesystem */
>> -	xfs_ino_t	*lastino,	/* last inode returned */
>> -	int		*count,		/* size of buffer/count returned */
>> -	void		__user *ubuffer,/* buffer with inode descriptions */
>> -	inumbers_fmt_pf	formatter)
>> +	struct xfs_mount	*mp,/* mount point for filesystem */
>> +	xfs_ino_t		*lastino,/* last inode returned */
>> +	int			*count,/* size of buffer/count returned */
>> +	void			__user *ubuffer,/* buffer with inode desc */
>> +	inumbers_fmt_pf		formatter)
>>  {
>> -	xfs_buf_t	*agbp;
>> -	xfs_agino_t	agino;
>> -	xfs_agnumber_t	agno;
>> -	int		bcount;
>> -	xfs_inogrp_t	*buffer;
>> -	int		bufidx;
>> -	xfs_btree_cur_t	*cur;
>> -	int		error;
>> -	xfs_inobt_rec_incore_t r;
>> -	int		i;
>> -	xfs_ino_t	ino;
>> -	int		left;
>> -	int		tmp;
>> -
>> -	ino = (xfs_ino_t)*lastino;
>> -	agno = XFS_INO_TO_AGNO(mp, ino);
>> -	agino = XFS_INO_TO_AGINO(mp, ino);
>> -	left = *count;
>> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastino);
>> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastino);
>> +	int			left = *count;
>> +	struct xfs_btree_cur	*cur = NULL;
>> +	struct xfs_buf		*agbp = NULL;
>> +	struct xfs_inogrp	*buffer;
>> +	int			bcount;
>> +	int			bufidx;
>> +	int			error;
>> +
>>  	*count = 0;
>> +	if (agno >= mp->m_sb.sb_agcount ||
>> +	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
>> +		return 0;
>> +
>>  	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
>>  	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
>> -	error = bufidx = 0;
>> -	cur = NULL;
>> -	agbp = NULL;
>> -	while (left > 0 && agno < mp->m_sb.sb_agcount) {
>> -		if (agbp == NULL) {
>> +	bufidx = error = 0;
>> +	do {
>> +		struct xfs_inobt_rec_incore	r;
>> +		int				stat;
>> +
>> +		if (!agbp) {
>>  			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
>> -			if (error) {
>> -				/*
>> -				 * If we can't read the AGI of this ag,
>> -				 * then just skip to the next one.
>> -				 */
>> -				ASSERT(cur == NULL);
>> -				agbp = NULL;
>> -				agno++;
>> -				agino = 0;
>> -				continue;
>> -			}
>> +			if (error)
>> +				break;
>>  			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno);
>> -			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
>> -						 &tmp);
>> -			if (error) {
>> -				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>> -				cur = NULL;
>> -				xfs_buf_relse(agbp);
>> -				agbp = NULL;
>> -				/*
>> -				 * Move up the last inode in the current
>> -				 * chunk.  The lookup_ge will always get
>> -				 * us the first inode in the next chunk.
>> -				 */
>> -				agino += XFS_INODES_PER_CHUNK - 1;
>> -				continue;
>> -			}
>>  		}
>> -		error = xfs_inobt_get_rec(cur, &r, &i);
>> -		if (error || i == 0) {
>> -			xfs_buf_relse(agbp);
>> -			agbp = NULL;
>> -			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> -			cur = NULL;
>> -			agno++;
>> -			agino = 0;
>> -			continue;
>> +		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &stat);
>> +		if (error)
>> +			break;
> 
> Isn't this lookup only needed after cursor initialization? i.e., we
> lookup once and increment through the records via xfs_btree_increment()
> below.

Yes, but please see my comments below.
> 
>> +		if (!stat) {
>> +			/* Done, proceed to look up the next AG */
>> +			goto next_ag;
>>  		}
>> +
>> +		error = xfs_inobt_get_rec(cur, &r, &stat);
>> +		if (error)
>> +			break;
>> +		XFS_WANT_CORRUPTED_GOTO(stat == 1, error0);
>> +
>>  		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
>>  		buffer[bufidx].xi_startino =
>>  			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
>>  		buffer[bufidx].xi_alloccount =
>>  			XFS_INODES_PER_CHUNK - r.ir_freecount;
>>  		buffer[bufidx].xi_allocmask = ~r.ir_free;
>> -		bufidx++;
>> -		left--;
>> -		if (bufidx == bcount) {
>> -			long written;
>> -			if (formatter(ubuffer, buffer, bufidx, &written)) {
>> -				error = XFS_ERROR(EFAULT);
>> +		if (++bufidx == bcount) {
>> +			long	written;
>> +			error = formatter(ubuffer, buffer, bufidx, &written);
>> +			if (error)
>>  				break;
>> -			}
>>  			ubuffer += written;
>>  			*count += bufidx;
>>  			bufidx = 0;
>>  		}
>> -		if (left) {
>> -			error = xfs_btree_increment(cur, 0, &tmp);
>> -			if (error) {
>> -				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>> -				cur = NULL;
>> -				xfs_buf_relse(agbp);
>> -				agbp = NULL;
>> -				/*
>> -				 * The agino value has already been bumped.
>> -				 * Just try to skip up to it.
>> -				 */
>> -				agino += XFS_INODES_PER_CHUNK;
>> -				continue;
>> -			}
>> +		if (!--left)
>> +			break;
>> +
>> +		error = xfs_btree_increment(cur, 0, &stat);
>> +		if (error)
>> +			break;
>> +		if (stat) {
>> +			/*
>> +			 * The agino value has already been bumped, just try
>> +			 * to skip up to it.
>> +			 */
>> +			agino += XFS_INODES_PER_CHUNK;
>> +			continue;
>>  		}
> 
> Maybe it's just me, but this reads a little funny to me. In particular
> because we only get here if stat == 1. I wonder if this would look a bit
> cleaner if we pulled the next_ag labeled block below up into the goto,
> since that appears to be the only reference. Then just let the loop fall
> through.

Actually, we would never hint xfs_btree_increment() at all no matter the default
or with my current change, because the left variable value is 1 as per the user
space imap implementation, thus, it should be decreased to 0 in this point.

The problem is, how we define the user call interface originally, why it does not
support a 2nd argument which can be used to specified a desired icount to return a
limited number of inode mapping tables? i.e,

imap_f() {

        if (argc != 2)
                nent = 1;
        else
                nent = atoi(argv[1]);

	....
}

The imap command does not support another options but initialize bulkreq.icount = nent = 1;
In kernel, the bcount is evaluated to 1 and if (bufidx == bcount) should be true anyway as
below code logic:
 
bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));

if (bufidx == bcount) {
	....
	formatter();
	....
}

But, if the left value could be specified from the user progs, maybe we cannot simply
assuming "stat == 1" is always be true, in particular, in next path for implementing
per AG inumber mechanism, xfs_btree_increment() would probably succeed but "stat == 0"
if there is no right neighbors, and if the user could specified the 2nd imap option.

Hence, in this patch, I only intended to fix the btree error handling mechanism as a
preparation step to implement per AG inumber.

>  
> Also, I think the agino addition here becomes unnecessary when the
> lookup issue above is addressed.
> 
>> -	}
>> +
>> +next_ag:
>> +		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +		cur = NULL;
>> +		xfs_buf_relse(agbp);
>> +		agbp = NULL;
>> +		agino = 0;
>> +	} while (++agno < mp->m_sb.sb_agcount);
>> +
> 
> ... and just thinking about the logic that way highlights the bug here,
> where we bump agno due to the continue above (where IIUC, we intend to
> only move forward within the ag). Perhaps the ++agno should be part of
> the broken off 'next_ag' logic as well.

Can you please point out a bit more about the bug?  We bump agno due to
current run out of the current AG but the user want to show more imaps.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
