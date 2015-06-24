Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 969317F60
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 08:12:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86FC48F8035
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 06:12:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id g72FVLhriQt0WkmM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 06:12:30 -0700 (PDT)
Date: Wed, 24 Jun 2015 09:12:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remote attribute headers contain an invalid LSN
Message-ID: <20150624131228.GC1888@bfoster.bfoster>
References: <1434948369-13931-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434948369-13931-1-git-send-email-david@fromorbit.com>
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

On Mon, Jun 22, 2015 at 02:46:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In recent testing, a system that crashed failed log recovery on
> restart with a bad symlink buffer magic number:
> 
> XFS (vda): Starting recovery (logdev: internal)
> XFS (vda): Bad symlink block magic!
> XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 2060
> 
> On examination of the log via xfs_logprint, none of the symlink
> buffers in the log had a bad magic number, nor were any other types
> of buffer log format headers mis-identified as symlink buffers.
> Tracing was used to find the buffer the kernel was tripping over,
> and xfs_db identified it's contents as:
> 
> 000: 5841524d 00000000 00000346 64d82b48 8983e692 d71e4680 a5f49e2c b317576e
> 020: 00000000 00602038 00000000 006034ce d0020000 00000000 4d4d4d4d 4d4d4d4d
> 040: 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d
> 060: 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d 4d4d4d4d
> .....
> 
> This is a remote attribute buffer, which are notable in that they
> are not logged but are instead written synchronously by the remote
> attribute code so that they exist on disk before the attribute
> transactions are committed to the journal.
> 
> The above remote attribute block has an invalid LSN in it - cycle
> 0xd002000, block 0 - which means when log recovery comes along to
> determine if the transaction that writes to the underlying block
> should be replayed, it sees a block that has a future LSN and so
> does not replay the buffer data in the transaction. Instead, it
> validates the buffer magic number and attaches the buffer verifier
> to it.  It is this buffer magic number check that is failing in the
> above assert, indicating that we skipped replay due to the LSN of
> the underlying buffer.
> 
> The problem here is that the remote attribute buffers cannot have a
> valid LSN placed into them, because the transaction that contains
> the attribute tree pointer changes and the block allocation that the
> attribute data is being written to hasn't yet been committed. Hence
> the LSN field int eh attribute block is completely unwritten,
> thereby leaving the underlying contents of the block in the LSN
> field. It could have any value, and hence a future overwrite of the
> block by log recovery may or may not work correctly.
> 
> Fix this by always writing an invalid LSN to the remote attribute
> block, as any buffer in log recovery that needs to write over the
> remote attribute should occur. We are protected from having old data
> written over the attribute by the fact that freeing the block before
> the remote attribute is written will result in the buffer being
> marked stale in the log and so all changes prior to the buffer stale
> transaction will be cancelled by log recovery.
> 
> Hence it is safe to ignore the LSN in the case or synchronously
> written, unlogged metadata such as remote attribute blocks, and to
> ensure we do that correctly, we need to write an invalid LSN to all
> remote attribute blocks to trigger immediate recovery of metadata
> that is written over the top.
> 
> As a further protection for filesystems that may already have remote
> attribute blocks with bad LSNs on disk, change the log recovery code
> to always trigger immediate recovery of metadata over remote
> attribute blocks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 30 ++++++++++++++++++++++++------
>  fs/xfs/xfs_log_recover.c        | 11 ++++++++---
>  2 files changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 20de88d..3854439 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -159,11 +159,10 @@ xfs_attr3_rmt_write_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> +	int		blksize = mp->m_attr_geo->blksize;
>  	char		*ptr;
>  	int		len;
>  	xfs_daddr_t	bno;
> -	int		blksize = mp->m_attr_geo->blksize;
>  
>  	/* no verification of non-crc buffers */
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
> @@ -175,16 +174,22 @@ xfs_attr3_rmt_write_verify(
>  	ASSERT(len >= blksize);
>  
>  	while (len > 0) {
> +		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
> +
>  		if (!xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
>  			xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  			xfs_verifier_error(bp);
>  			return;
>  		}
> -		if (bip) {
> -			struct xfs_attr3_rmt_hdr *rmt;
>  
> -			rmt = (struct xfs_attr3_rmt_hdr *)ptr;
> -			rmt->rm_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> +		/*
> +		 * Ensure we aren't writing bogus LSNs to disk. See
> +		 * xfs_attr3_rmt_hdr_set() for the explanation.
> +		 */
> +		if (rmt->rm_lsn != cpu_to_be64(NULLCOMMITLSN)) {
> +			xfs_buf_ioerror(bp, -EFSCORRUPTED);
> +			xfs_verifier_error(bp);
> +			return;
>  		}
>  		xfs_update_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF);
>  
> @@ -221,6 +226,19 @@ xfs_attr3_rmt_hdr_set(
>  	rmt->rm_owner = cpu_to_be64(ino);
>  	rmt->rm_blkno = cpu_to_be64(bno);
>  
> +	/*
> +	 * Remote attribute blocks are written synchronously, so we don't
> +	 * have an LSN that we can stamp in them that makes any sense to log
> +	 * recovery. To ensure that log recovery handles overwrites of these
> +	 * blocks sanely (i.e. once they've been freed and reallocated as some
> +	 * other type of metadata) we need to ensure that the LSN has a value
> +	 * that tells log recovery to ignore the LSN and overwrite the buffer
> +	 * with whatever is in it's log. To do this, we use the magic
> +	 * NULLCOMMITLSN to indicate that the LSN is invalid.
> +	 * of -1.

Looks like a stale last line in the comment above. The rest of the code
all looks fine to me, but a question to help me grok the bigger picture:

We allocate these attr blocks in xfs_attr_rmtval_set(). If the writes
are synchronous, shouldn't those allocation transactions be synchronous
as well? IOW, what prevents our synchronous writes going to freed blocks
or blocks allocated to something else (if a block were freed,
reallocated as an attr block and sync. written without making it to the
ail) due to a crash immediately following the sync. write?

Brian

> +	 */
> +	rmt->rm_lsn = cpu_to_be64(NULLCOMMITLSN);
> +
>  	return sizeof(struct xfs_attr3_rmt_hdr);
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 01dd228..480ebba 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1886,9 +1886,14 @@ xlog_recover_get_buf_lsn(
>  		uuid = &((struct xfs_dir3_blk_hdr *)blk)->uuid;
>  		break;
>  	case XFS_ATTR3_RMT_MAGIC:
> -		lsn = be64_to_cpu(((struct xfs_attr3_rmt_hdr *)blk)->rm_lsn);
> -		uuid = &((struct xfs_attr3_rmt_hdr *)blk)->rm_uuid;
> -		break;
> +		/*
> +		 * Remote attr blocks are written synchronously, rather than
> +		 * being logged. That means they do not contain a valid LSN
> +		 * (i.e. transactionally ordered) in them, and hence any time we
> +		 * see a buffer to replay over the top of a remote attribute
> +		 * block we should simply do so.
> +		 */
> +		goto recover_immediately;
>  	case XFS_SB_MAGIC:
>  		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
>  		uuid = &((struct xfs_dsb *)blk)->sb_uuid;
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
