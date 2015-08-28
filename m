Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 238E17F37
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 10:11:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 110C88F804B
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 08:11:27 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id LFpp95lXLAXKIPus for
	<xfs@oss.sgi.com>; Fri, 28 Aug 2015 08:11:22 -0700 (PDT)
Date: Fri, 28 Aug 2015 08:11:20 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH V2] xfs: timestamp updates cause excessive fdatasync log
	traffic
In-Reply-To: <20150828043253.GB26895@dastard>
Message-ID: <alpine.DEB.2.00.1508280804040.13116@cobra.newdream.net>
References: <1440724990-25073-1-git-send-email-david@fromorbit.com>
	<20150828043253.GB26895@dastard>
MIME-Version: 1.0
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

Hi Dave,

On Fri, 28 Aug 2015, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Sage Weil reported that a ceph test workload was writing to the
> log on every fdatasync during an overwrite workload. Event tracing
> showed that the only metadata modification being made was the
> timestamp updates during the write(2) syscall, but fdatasync(2)
> is supposed to ignore them. The key observation was that the
> transactions in the log all looked like this:
> 
> INODE: #regs: 4   ino: 0x8b  flags: 0x45   dsize: 32
> 
> And contained a flags field of 0x45 or 0x85, and had data and
> attribute forks following the inode core. This means that the
> timestamp updates were triggering dirty relogging of previously
> logged parts of the inode that hadn't yet been flushed back to
> disk.
> 
> This is caused by xfs_trans_log_inode(), where it folds the dirty
> fields that have previously been logged back into the current
> transaction dirty fields from the inode item ili_last_fields. The
> issue is that ili_last_fields only contains a non-zero value when
> the inode is in the process of being flushed. The typical state
> progression is this, using a core field update as the modification
> occuring:
> 
> state			ili_fields		ili_last_fields
> clean			    0			      0
> modified, logged	XFS_ILOG_CORE		      0
> flushed to buffer	    0			XFS_ILOG_CORE
> <buffer submitted>
> buffer IO done (clean)	    0			      0
> 
> However, if we run a new transaction after it has been flushed to
> buffer but before the buffer IO is done, we don't know if the
> modifications in the inode buffer (i.e. what is in ili_last_fields)
> will reach the disk before the new transaction reaches the log.
> Hence to keep transactional ordering correct in recovery, we need to
> ensure the new transaction re-logs the modifications that are being
> flushed to disk.
> 
> By relogging, we ensure that if the transaction makes it to disk and
> the buffer doesn't, then recovery replays all the changes upto that
> point correctly. If the transaction does not make it disk, but the
> buffer does, then recovery will see that the inode on disk is more
> recent than in the log and won't overwrite it with changes that it
> already contains.
> 
> The upshot of this is that while the inode buffer sits in memory
> with the inode in the "flushed" state, fdatasync is going to see
> the relogged state in the ili_fields. i.e:
> 
> What is happening here is this:
> 
> state			ili_fields		ili_last_fields
> clean			    0			      0
> modified, logged	   CORE			      0
> flushed to buffer	    0			     CORE
> <write>
> timestamp update	 TIMESTAMP		     CORE
> <xfs_trans_inode_log pulls in ili_last_fields>
> 		       CORE|TIMESTAMP		     CORE
> <fdatasync>
>   sees field other than TIMESTAMP in ili_fields,
>   triggers xfs_log_force_lsn to flush inode
> 
> <buffer submittted>
> buffer IO done (clean) CORE|TIMESTAMP		      0
> .....
> <write>
> timestamp update       CORE|TIMESTAMP		      0
> <fdatasync>
>   sees field other than TIMESTAMP in ili_fields,
>   triggers xfs_log_force_lsn to flush inode
> .....
> <write>
> timestamp update       CORE|TIMESTAMP		      0
> <fdatasync>
>   sees field other than TIMESTAMP in ili_fields,
>   triggers xfs_log_force_lsn to flush inode
> 
> So, essentially, once a race condition on the buffer flush has
> occurred, the condition is not cleared until the inode is flushed to
> the buffer again and it is written without racing against the inode
> being dirtied again.
> 
> The behaviour we really want here is to capture the timestamp
> update transactionally, but not trigger fdatasync because of the
> relogged fields that haven't been modified since the inode was
> flushed to the buffer. We still need to relog them, but we don't
> need to force the log in the fdatasync case.
> 
> To do this, don't fold the ili_last_fields value into ili_fields
> when logging the inode. Instead, fold it into the fields that get
> logged during formatting of the inode item. This means that we will
> stop logging those fields the moment we know that there is a more
> recent version of the inode on disk than we have in the log and so
> we don't need to log those fields anymore as the next transaction on
> disk doesn't need to replay them.
> 
> Doing this separates changes that are in memory but are not being
> flushed from those that have been flushed. Hence we can now look at
> ili_fields and hence see what fields have been modified since the
> last flush, and hence whether fdatasync needs to force the log or
> not. If non-timestamp changes have been made since the inode was
> flushed to the backing buffer, then fdatasync will do exactly the
> right thing (i.e. force the log).
> 
> Reported-by: Sage Weil <sage@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> Version 2:
> - include the hunk from fs/xfs/xfs_trans_inode.c that I missed
>   when committing the patch locally the first time.

I gave this a go on my machine but I'm still seeing the same symptom.  
I've gathered the trace, strace, and other useful bits at

   http://newdream.net/~sage/drop/rocksdb.2/

This is pretty easy to reproduce with the ceph_test_keyvaluedb binary 
(built on fedora 22), also in that dir:

   rm -rf kv_test_temp_dir/
   ./ceph_test_keyvaluedb --gtest_filter=KeyValueDB/KVTest.BenchCommit/1

Thanks for looking into this!
sage

> 
>  fs/xfs/xfs_inode_item.c  | 161 +++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_inode_item.h  |   1 +
>  fs/xfs/xfs_trans_inode.c |   8 ---
>  3 files changed, 115 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 62bd80f..be04eb2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -29,6 +29,63 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
>  
> +/*
> + * Notes on ili_fields, ili_format_fields and ili_last_fields.
> + *
> + * ili_fields contains the flags that reflect the current changes that are in
> + * memory and have been logged, but have not been flushed to the backing buffer
> + * for writeback yet. When a transaction is done, the fields that are modified
> + * are added to ili_fields and all those fields are logged. This results in
> + * repeated transactions correctly relogging all the other changes in memory and
> + * allows the inode to be re-ordered (moved forward) in the AIL safely.
> + * ili_fields is copied to ili_last_fields when the inode is flushed to the
> + * backing buffer and is then cleared, indicating that the inode in memory is
> + * now clean from a transactional change point of view and does not need to
> + * relog those fields anymore on tranaction commit.
> + *
> + * ili_last_fields, therefore, is only set while there is an unresolved inode
> + * flush being done (i.e. flush lock is held). We need to keep this state
> + * available to avoid a transaction recovery vs inode buffer IO completion race
> + * if we crash. If the inode is logged again makes it to disk before the inode
> + * buffer IO complete, log recovery will replay the latest inode transaction and
> + * can lose the changes that were in the inode buffer. Hence we still need to
> + * log the changes that have been flushed so that transactions issued during the
> + * inode buffer write still contain the modifications being flushed. Once the
> + * inode buffer IO completes, we no longer need to log those changes as the
> + * inode on disk the same as the inode in memory apart from the changes made
> + * since the inode was flushed (i.e. those recorded in ili_fields).
> + *
> + * ili_format_fields is only used during transaction commit. It is the
> + * aggregation of ili_fields and ili_last_fields, as sampled during the sizing
> + * of the inode item to be logged. We need this field definition to be constant
> + * between sizing and formatting, but inode buffer IO can complete
> + * asynchronously with transaction commit and so we must only read it once so
> + * that the different stages of the item formatting work correctly. We don't
> + * care about the async completion clearing ili_last_fields after we've sampled
> + * it - if we log too much then so be it - we won't log it next time. Once we've
> + * formatted the inode item, we need to propagate the ili_format_fields value to
> + * the on-disk inode log item format field, and then use it to clear all the
> + * fields that we marked for logging but were not dirty from ili_fields.
> + *
> + * This separation of changes allows us to accurately determine what fields in
> + * the inode have changed since it was last flushed to disk. This is important
> + * for fdatasync() performance as there are certain fields that, if modified,
> + * should not trigger log forces because they contain metadata that fdatasync()
> + * does not need to guarantee is safe on disk. This is, currently, just
> + * XFS_ILOG_TIMESTAMP, though may be extended in future to cover other metadata.
> + *
> + * If we simply fold ili_last_fields back into ili_fields when we log the inode
> + * in a transaction, then if we have a flush/modification race it results in
> + * every timestamp update causing fdatasync to flush the log because ili_fields
> + * has fields other than XFS_ILOG_TIMESTAMP set in it. This behaviour will
> + * persist until the inode is next flushed to it's backing buffer and that
> + * buffer is written and completed without another flush/modification race
> + * occuring.  Hence we keep the change state separate and only combine them when
> + * formatting the inode into the log.
> + *
> + * For more information, there's another big comment in xfs_iflush_int() about
> + * this flush/modification race condition.
> + */
>  
>  kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
>  
> @@ -40,6 +97,7 @@ static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
>  STATIC void
>  xfs_inode_item_data_fork_size(
>  	struct xfs_inode_log_item *iip,
> +	unsigned int		fields,
>  	int			*nvecs,
>  	int			*nbytes)
>  {
> @@ -47,7 +105,7 @@ xfs_inode_item_data_fork_size(
>  
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
> -		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
> +		if ((fields & XFS_ILOG_DEXT) &&
>  		    ip->i_d.di_nextents > 0 &&
>  		    ip->i_df.if_bytes > 0) {
>  			/* worst case, doesn't subtract delalloc extents */
> @@ -56,14 +114,14 @@ xfs_inode_item_data_fork_size(
>  		}
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
> +		if ((fields & XFS_ILOG_DBROOT) &&
>  		    ip->i_df.if_broot_bytes > 0) {
>  			*nbytes += ip->i_df.if_broot_bytes;
>  			*nvecs += 1;
>  		}
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
> +		if ((fields & XFS_ILOG_DDATA) &&
>  		    ip->i_df.if_bytes > 0) {
>  			*nbytes += roundup(ip->i_df.if_bytes, 4);
>  			*nvecs += 1;
> @@ -82,6 +140,7 @@ xfs_inode_item_data_fork_size(
>  STATIC void
>  xfs_inode_item_attr_fork_size(
>  	struct xfs_inode_log_item *iip,
> +	unsigned int		fields,
>  	int			*nvecs,
>  	int			*nbytes)
>  {
> @@ -89,7 +148,7 @@ xfs_inode_item_attr_fork_size(
>  
>  	switch (ip->i_d.di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
> -		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
> +		if ((fields & XFS_ILOG_AEXT) &&
>  		    ip->i_d.di_anextents > 0 &&
>  		    ip->i_afp->if_bytes > 0) {
>  			/* worst case, doesn't subtract unused space */
> @@ -98,14 +157,14 @@ xfs_inode_item_attr_fork_size(
>  		}
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
> +		if ((fields & XFS_ILOG_ABROOT) &&
>  		    ip->i_afp->if_broot_bytes > 0) {
>  			*nbytes += ip->i_afp->if_broot_bytes;
>  			*nvecs += 1;
>  		}
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
> +		if ((fields & XFS_ILOG_ADATA) &&
>  		    ip->i_afp->if_bytes > 0) {
>  			*nbytes += roundup(ip->i_afp->if_bytes, 4);
>  			*nvecs += 1;
> @@ -133,13 +192,17 @@ xfs_inode_item_size(
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
>  	struct xfs_inode	*ip = iip->ili_inode;
>  
> +	iip->ili_format_fields = iip->ili_fields | iip->ili_last_fields;
> +
>  	*nvecs += 2;
>  	*nbytes += sizeof(struct xfs_inode_log_format) +
>  		   xfs_icdinode_size(ip->i_d.di_version);
>  
> -	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
> +	xfs_inode_item_data_fork_size(iip, iip->ili_format_fields,
> +				      nvecs, nbytes);
>  	if (XFS_IFORK_Q(ip))
> -		xfs_inode_item_attr_fork_size(iip, nvecs, nbytes);
> +		xfs_inode_item_attr_fork_size(iip, iip->ili_format_fields,
> +					      nvecs, nbytes);
>  }
>  
>  STATIC void
> @@ -151,14 +214,14 @@ xfs_inode_item_format_data_fork(
>  {
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	size_t			data_bytes;
> +	unsigned int		fields = iip->ili_format_fields;
>  
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID);
> +		fields &= ~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> +			    XFS_ILOG_DEV | XFS_ILOG_UUID);
>  
> -		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
> +		if ((fields & XFS_ILOG_DEXT) &&
>  		    ip->i_d.di_nextents > 0 &&
>  		    ip->i_df.if_bytes > 0) {
>  			struct xfs_bmbt_rec *p;
> @@ -175,15 +238,14 @@ xfs_inode_item_format_data_fork(
>  			ilf->ilf_dsize = data_bytes;
>  			ilf->ilf_size++;
>  		} else {
> -			iip->ili_fields &= ~XFS_ILOG_DEXT;
> +			fields &= ~XFS_ILOG_DEXT;
>  		}
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID);
> +		fields &= ~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
> +			    XFS_ILOG_DEV | XFS_ILOG_UUID);
>  
> -		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
> +		if ((fields & XFS_ILOG_DBROOT) &&
>  		    ip->i_df.if_broot_bytes > 0) {
>  			ASSERT(ip->i_df.if_broot != NULL);
>  			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IBROOT,
> @@ -192,16 +254,15 @@ xfs_inode_item_format_data_fork(
>  			ilf->ilf_dsize = ip->i_df.if_broot_bytes;
>  			ilf->ilf_size++;
>  		} else {
> -			ASSERT(!(iip->ili_fields &
> -				 XFS_ILOG_DBROOT));
> -			iip->ili_fields &= ~XFS_ILOG_DBROOT;
> +			ASSERT(!(fields & XFS_ILOG_DBROOT));
> +			fields &= ~XFS_ILOG_DBROOT;
>  		}
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID);
> -		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
> +		fields &= ~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
> +			    XFS_ILOG_DEV | XFS_ILOG_UUID);
> +
> +		if ((fields & XFS_ILOG_DDATA) &&
>  		    ip->i_df.if_bytes > 0) {
>  			/*
>  			 * Round i_bytes up to a word boundary.
> @@ -218,27 +279,28 @@ xfs_inode_item_format_data_fork(
>  			ilf->ilf_dsize = (unsigned)data_bytes;
>  			ilf->ilf_size++;
>  		} else {
> -			iip->ili_fields &= ~XFS_ILOG_DDATA;
> +			fields &= ~XFS_ILOG_DDATA;
>  		}
>  		break;
>  	case XFS_DINODE_FMT_DEV:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEXT | XFS_ILOG_UUID);
> -		if (iip->ili_fields & XFS_ILOG_DEV)
> +		fields &= ~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> +			    XFS_ILOG_DEXT | XFS_ILOG_UUID);
> +		if (fields & XFS_ILOG_DEV)
>  			ilf->ilf_u.ilfu_rdev = ip->i_df.if_u2.if_rdev;
>  		break;
>  	case XFS_DINODE_FMT_UUID:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEXT | XFS_ILOG_DEV);
> -		if (iip->ili_fields & XFS_ILOG_UUID)
> +		fields &= ~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> +			    XFS_ILOG_DEXT | XFS_ILOG_DEV);
> +		if (fields & XFS_ILOG_UUID)
>  			ilf->ilf_u.ilfu_uuid = ip->i_df.if_u2.if_uuid;
>  		break;
>  	default:
>  		ASSERT(0);
>  		break;
>  	}
> +
> +	/* reflect the logged fields back in ili_format_fields */
> +	iip->ili_format_fields = fields;
>  }
>  
>  STATIC void
> @@ -250,13 +312,13 @@ xfs_inode_item_format_attr_fork(
>  {
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	size_t			data_bytes;
> +	unsigned int		fields = iip->ili_format_fields;
>  
>  	switch (ip->i_d.di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
> +		fields &= ~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
>  
> -		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
> +		if ((fields & XFS_ILOG_AEXT) &&
>  		    ip->i_d.di_anextents > 0 &&
>  		    ip->i_afp->if_bytes > 0) {
>  			struct xfs_bmbt_rec *p;
> @@ -272,14 +334,13 @@ xfs_inode_item_format_attr_fork(
>  			ilf->ilf_asize = data_bytes;
>  			ilf->ilf_size++;
>  		} else {
> -			iip->ili_fields &= ~XFS_ILOG_AEXT;
> +			fields &= ~XFS_ILOG_AEXT;
>  		}
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_ADATA | XFS_ILOG_AEXT);
> +		fields &= ~(XFS_ILOG_ADATA | XFS_ILOG_AEXT);
>  
> -		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
> +		if ((fields & XFS_ILOG_ABROOT) &&
>  		    ip->i_afp->if_broot_bytes > 0) {
>  			ASSERT(ip->i_afp->if_broot != NULL);
>  
> @@ -289,14 +350,13 @@ xfs_inode_item_format_attr_fork(
>  			ilf->ilf_asize = ip->i_afp->if_broot_bytes;
>  			ilf->ilf_size++;
>  		} else {
> -			iip->ili_fields &= ~XFS_ILOG_ABROOT;
> +			fields &= ~XFS_ILOG_ABROOT;
>  		}
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -		iip->ili_fields &=
> -			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
> +		fields &= ~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
>  
> -		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
> +		if ((fields & XFS_ILOG_ADATA) &&
>  		    ip->i_afp->if_bytes > 0) {
>  			/*
>  			 * Round i_bytes up to a word boundary.
> @@ -313,13 +373,16 @@ xfs_inode_item_format_attr_fork(
>  			ilf->ilf_asize = (unsigned)data_bytes;
>  			ilf->ilf_size++;
>  		} else {
> -			iip->ili_fields &= ~XFS_ILOG_ADATA;
> +			fields &= ~XFS_ILOG_ADATA;
>  		}
>  		break;
>  	default:
>  		ASSERT(0);
>  		break;
>  	}
> +
> +	/* reflect the logged fields back in ili_format_fields */
> +	iip->ili_format_fields = fields;
>  }
>  
>  /*
> @@ -359,12 +422,16 @@ xfs_inode_item_format(
>  	if (XFS_IFORK_Q(ip)) {
>  		xfs_inode_item_format_attr_fork(iip, ilf, lv, &vecp);
>  	} else {
> -		iip->ili_fields &=
> +		iip->ili_format_fields &=
>  			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
>  	}
>  
>  	/* update the format with the exact fields we actually logged */
> -	ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
> +	ilf->ilf_fields |= (iip->ili_format_fields & ~XFS_ILOG_TIMESTAMP);
> +
> +	/* clear any fields we didn't log from ili_fields */
> +	iip->ili_fields &= iip->ili_format_fields;
> +	iip->ili_format_fields = 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 488d812..43a9e1c 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -34,6 +34,7 @@ typedef struct xfs_inode_log_item {
>  	unsigned short		ili_logged;	   /* flushed logged data */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
>  	unsigned int		ili_fields;	   /* fields to be logged */
> +	unsigned int		ili_format_fields; /* combined log fields */
>  } xfs_inode_log_item_t;
>  
>  static inline int xfs_inode_clean(xfs_inode_t *ip)
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 17280cd..77f1e8a 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -123,13 +123,5 @@ xfs_trans_log_inode(
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	ip->i_itemp->ili_item.li_desc->lid_flags |= XFS_LID_DIRTY;
>  
> -	/*
> -	 * Always OR in the bits from the ili_last_fields field.
> -	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
> -	 * routines in the eventual clearing of the ili_fields bits.
> -	 * See the big comment in xfs_iflush() for an explanation of
> -	 * this coordination mechanism.
> -	 */
> -	flags |= ip->i_itemp->ili_last_fields;
>  	ip->i_itemp->ili_fields |= flags;
>  }
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
