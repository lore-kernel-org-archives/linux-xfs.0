Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 654607F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 21:50:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 561E2304093
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 19:50:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nWGlvMeTHQPFxOZJ for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 19:50:53 -0700 (PDT)
Date: Fri, 26 Jul 2013 12:50:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: introduce object readahead to log recovery
Message-ID: <20130726025009.GE21982@dastard>
References: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
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
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 25, 2013 at 04:23:39PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   It can take a long time to run log recovery operation because it is
> single threaded and is bound by read latency. We can find that it took
> most of the time to wait for the read IO to occur, so if one object
> readahead is introduced to log recovery, it will obviously reduce the
> log recovery time.
> 
>   In dirty log case as below:
>     data device: 0xfd10
>     log device: 0xfd10 daddr: 20480032 length: 20480
> 
>     log tail: 7941 head: 11077 state: <DIRTY>

That's only a small log (10MB). As I've said on irc, readahead won't
show any real difference on this and you need to be testing with
large logs.

> 
> This dirty ratio is about 15%. I am trying to do tests in larger scale
> and dirtier filesystem environment.
> 
> Log recovery time stat:
> 
>             w/o this patch        w/ this patch
>   real         0m1.051s             0m0.965s
>   sys          0m0.033s             0m0.035s
> 
>   iowait       0m1.018s             0m0.930s

Well, it's not made much of a difference there. That's probably
within the noise of repeated log recovery runs.

My simple test is:

$ cat recovery_time.sh
#!/bin/bash

cd /home/dave/src/compilebench-0.6/

mkfs.xfs -f /dev/vdc;
mount /dev/vdc /mnt/scratch
chmod 777 /mnt/scratch;
./compilebench --no-sync -D /mnt/scratch &
sleep 55
/home/dave/src/xfstests-dev/src/godown /mnt/scratch
umount /mnt/scratch
xfs_logprint -t /dev/vdc |head -20
time mount /dev/vdc /mnt/scratch
umount /mnt/scratch
$

And the recovery time from this is between 15-17s:

....
    log device: 0xfd20 daddr: 107374182032 length: 4173824
                                                   ^^^^^^^ almost 2GB
        log tail: 19288 head: 264809 state: <DIRTY>
....
real    0m17.913s
user    0m0.000s
sys     0m2.381s

And runs at 3-4000 read IOPs for most of that time. It's largely IO
bound, even on SSDs.

With your patch:

log tail: 35871 head: 308393 state: <DIRTY>
real    0m12.715s
user    0m0.000s
sys     0m2.247s

And it peaked at ~5000 read IOPS.

It's definitely an improvement, but there's a lot of dead time still
spent waiting for IO that we should be able to remove. Let's have a
look at the code...


> +STATIC void
> +xlog_recover_inode_ra_pass2(
> +	struct xlog                     *log,
> +	struct xlog_recover_item        *item)
> +{
> +	xfs_inode_log_format_t	*in_f;
> +	xfs_mount_t		*mp = log->l_mp;
> +	int			error;
> +	int			need_free = 0;
> +
> +	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
> +		in_f = item->ri_buf[0].i_addr;
> +	} else {
> +		in_f = kmem_alloc(sizeof(xfs_inode_log_format_t), KM_SLEEP);
> +		need_free = 1;
> +		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
> +		if (error)
> +			goto error;
> +	}

I'd just put the conversion buffer on stack and avoid the need to
alloc/free memory here. There's plenty of stack space available
during recovery here, so let's use it to keep the overhead of
readahead down.

> +STATIC void
> +xlog_recover_dquot_ra_pass2(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	xfs_mount_t		*mp = log->l_mp;
> +	xfs_buf_t		*bp;
> +	struct xfs_disk_dquot	*recddq;
> +	int			error;
> +	xfs_dq_logformat_t	*dq_f;
> +	uint			type;
> +
> +
> +	if (mp->m_qflags == 0)
> +		return;
> +
> +	recddq = item->ri_buf[1].i_addr;
> +	if (recddq == NULL)
> +		return;
> +	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t))
> +		return;
> +
> +	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
> +	ASSERT(type);
> +	if (log->l_quotaoffs_flag & type)
> +		return;
> +
> +	dq_f = item->ri_buf[0].i_addr;
> +	ASSERT(dq_f);
> +	error = xfs_qm_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
> +			   "xlog_recover_dquot_ra_pass2 (log copy)");
> +	if (error)
> +		return;
> +	ASSERT(dq_f->qlf_len == 1);
> +
> +	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
> +				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
> +				   NULL);
> +	if (!error)
> +		xfs_buf_relse(bp);
> +}

That's not doing readahead - that's an integrity check followed by a
blocking read.  Shouldn't it just be calling xfs_buf_readahead() on
dq_f->qlf_blkno/dq_f->qlf_len, after checking whether it had been
cancelled?

>  STATIC int
>  xlog_recover_commit_pass1(
>  	struct xlog			*log,
> @@ -3140,10 +3255,14 @@ xlog_recover_commit_pass2(
>  	struct xlog			*log,
>  	struct xlog_recover		*trans,
>  	struct list_head		*buffer_list,
> -	struct xlog_recover_item	*item)
> +	struct xlog_recover_item	*item,
> +	struct xlog_recover_item	*next_item)
>  {
>  	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
>  
> +	if (next_item)
> +		xlog_recover_ra_pass2(log, next_item);
> +

Ah, that explains the limited improvement - it's only doing
readahead of a single item at a time. IOWs, we are completing
recovery of the current object before IO completion of the next
object has occurred. This generally means the read-ahead queue is
not deep enough...

>  	switch (ITEM_TYPE(item)) {
>  	case XFS_LI_BUF:
>  		return xlog_recover_buffer_pass2(log, buffer_list, item);
> @@ -3181,7 +3300,7 @@ xlog_recover_commit_trans(
>  	int			pass)
>  {
>  	int			error = 0, error2;
> -	xlog_recover_item_t	*item;
> +	xlog_recover_item_t	*item, *next_item, *temp_item;
>  	LIST_HEAD		(buffer_list);
>  
>  	hlist_del(&trans->r_list);
> @@ -3190,14 +3309,18 @@ xlog_recover_commit_trans(
>  	if (error)
>  		return error;
>  
> -	list_for_each_entry(item, &trans->r_itemq, ri_list) {
> +	list_for_each_entry_safe(item, temp_item, &trans->r_itemq, ri_list) {
>  		switch (pass) {
>  		case XLOG_RECOVER_PASS1:
>  			error = xlog_recover_commit_pass1(log, trans, item);
>  			break;
>  		case XLOG_RECOVER_PASS2:
> +			if (&temp_item->ri_list != &trans->r_itemq)
> +				next_item = temp_item;
> +			else
> +				next_item = NULL;
>  			error = xlog_recover_commit_pass2(log, trans,
> -							  &buffer_list, item);
> +					  &buffer_list, item, next_item);

Ok, so you've based the readahead on the transaction item list
having a next pointer. What I think you should do is turn this into
a readahead queue by moving objects to a new list. i.e.

	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {

		case XLOG_RECOVER_PASS2:
			if (ra_qdepth++ >= MAX_QDEPTH) {
				recover_items(log, trans, &buffer_list, &ra_item_list);
				ra_qdepth = 0;
			} else {
				xlog_recover_item_readahead(log, item);
				list_move_tail(&item->ri_list, &ra_item_list);
			}
			break;
		...
		}
	}
	if (!list_empty(&ra_item_list))
		recover_items(log, trans, &buffer_list, &ra_item_list);

I'd suggest that a queue depth somewhere between 10 and 100 will
be necessary to keep enough IO in flight to keep the pipeline full
and prevent recovery from having to wait on IO...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
