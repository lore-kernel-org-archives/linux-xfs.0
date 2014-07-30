Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45A857F59
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 11:30:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 257AC8F806F
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 09:30:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0N0bTrQIBHHvXMll (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 09:30:07 -0700 (PDT)
Date: Wed, 30 Jul 2014 12:30:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: ensure verifiers are attached to recovered
	buffers
Message-ID: <20140730163002.GB2830@bfoster.bfoster>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
	<1406684929-11133-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406684929-11133-3-git-send-email-david@fromorbit.com>
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

On Wed, Jul 30, 2014 at 11:48:47AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Crash testing of CRC enabled filesystems has resulted in a number of
> reports of bad CRCs being detected after the filesystem was mounted.
> Errors such as the following were being seen:
> 
> XFS (sdb3): Mounting V5 Filesystem
> XFS (sdb3): Starting recovery (logdev: internal)
> XFS (sdb3): Metadata CRC error detected at xfs_agf_read_verify+0x5a/0x100 [xfs], block 0x1
> XFS (sdb3): Unmount and run xfs_repair
> XFS (sdb3): First 64 bytes of corrupted metadata buffer:
> ffff880136ffd600: 58 41 47 46 00 00 00 01 00 00 00 00 00 0f aa 40  XAGF...........@
> ffff880136ffd610: 00 02 6d 53 00 02 77 f8 00 00 00 00 00 00 00 01  ..mS..w.........
> ffff880136ffd620: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 03  ................
> ffff880136ffd630: 00 00 00 04 00 08 81 d0 00 08 81 a7 00 00 00 00  ................
> XFS (sdb3): metadata I/O error: block 0x1 ("xfs_trans_read_buf_map") error 74 numblks 1
> 
> The errors were typically being seen in AGF, AGI and their related
> btree block buffers some time after log recovery had run. Often it
> wasn't until later subsequent mounts that the problem was
> discovered. The common symptom was a buffer with the correct
> contents, but a CRC and an LSN that matched an older version of the
> contents.
> 
> Some debug added to _xfs_buf_ioapply() indicated that buffers were
> being written without verifiers attached to them from log recovery,
> and Jan Kara isolated the cause to log recovery readahead an dit's
> interactions with buffers that had a more recent LSN on disk than
> the transaction being recovered. In this case, the buffer did not
> get a verifier attached, and os when the second phase of log
> recovery ran and recovered EFIs and unlinked inodes, the buffers
> were modified and written without the verifier running. Hence they
> had up to date contents, but stale LSNs and CRCs.
> 
> Fix it by attaching verifiers to buffers we skip due to future LSN
> values so they don't escape into the buffer cache without the
> correct verifier attached.
> 
> This patch is based on analysis and a patch from Jan Kara.
> 
> cc: <stable@vger.kernel.org>
> Reported-by: Jan Kara <jack@suse.cz>
> Reported-by: Fanael Linithien <fanael4@gmail.com>
> Reported-by: Grozdan <neutrino8@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 47 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index fbc2362..0a015cc 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2126,6 +2126,17 @@ xlog_recover_validate_buf_type(
>  	__uint16_t		magic16;
>  	__uint16_t		magicda;
>  
> +	/*
> +	 * We can only do post recovery validation on items on CRC enabled
> +	 * fielsystems as we need to know when the buffer was written to be able
> +	 * to determine if we should have replayed the item. If we replay old
> +	 * metadata over a newer buffer, then it will enter a temporarily
> +	 * inconsistent state resulting in verification failures. Hence for now
> +	 * just avoid the verification stage for non-crc filesystems
> +	 */
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return;
> +

This function has a couple other similar *_hascrc() checks further down
that we should probably kill now. Otherwise, looks Ok...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
>  	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
>  	magicda = be16_to_cpu(info->magic);
> @@ -2197,10 +2208,6 @@ xlog_recover_validate_buf_type(
>  #endif
>  		break;
>  	case XFS_BLFT_DINO_BUF:
> -		/*
> -		 * we get here with inode allocation buffers, not buffers that
> -		 * track unlinked list changes.
> -		 */
>  		if (magic16 != XFS_DINODE_MAGIC) {
>  			xfs_warn(mp, "Bad INODE block magic!");
>  			ASSERT(0);
> @@ -2388,16 +2395,7 @@ xlog_recover_do_reg_buffer(
>  	/* Shouldn't be any more regions */
>  	ASSERT(i == item->ri_total);
>  
> -	/*
> -	 * We can only do post recovery validation on items on CRC enabled
> -	 * fielsystems as we need to know when the buffer was written to be able
> -	 * to determine if we should have replayed the item. If we replay old
> -	 * metadata over a newer buffer, then it will enter a temporarily
> -	 * inconsistent state resulting in verification failures. Hence for now
> -	 * just avoid the verification stage for non-crc filesystems
> -	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		xlog_recover_validate_buf_type(mp, bp, buf_f);
> +	xlog_recover_validate_buf_type(mp, bp, buf_f);
>  }
>  
>  /*
> @@ -2505,12 +2503,29 @@ xlog_recover_buffer_pass2(
>  	}
>  
>  	/*
> -	 * recover the buffer only if we get an LSN from it and it's less than
> +	 * Recover the buffer only if we get an LSN from it and it's less than
>  	 * the lsn of the transaction we are replaying.
> +	 *
> +	 * Note that we have to be extremely careful of readahead here.
> +	 * Readahead does not attach verfiers to the buffers so if we don't
> +	 * actually do any replay after readahead because of the LSN we found
> +	 * in the buffer if more recent than that current transaction then we
> +	 * need to attach the verifier directly. Failure to do so can lead to
> +	 * future recovery actions (e.g. EFI and unlinked list recovery) can
> +	 * operate on the buffers and they won't get the verifier attached. This
> +	 * can lead to blocks on disk having the correct content but a stale
> +	 * CRC.
> +	 *
> +	 * It is safe to assume these clean buffers are currently up to date.
> +	 * If the buffer is dirtied by a later transaction being replayed, then
> +	 * the verifier will be reset to match whatever recover turns that
> +	 * buffer into.
>  	 */
>  	lsn = xlog_recover_get_buf_lsn(mp, bp);
> -	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0)
> +	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> +		xlog_recover_validate_buf_type(mp, bp, buf_f);
>  		goto out_release;
> +	}
>  
>  	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
>  		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
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
