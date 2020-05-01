Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58367C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00AF1208C3
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:07:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YhnEW/3e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgEAIHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAIHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:07:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D917DC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DHybFtSPXgK3+tifb6XbVPhZDgPIgol/7Z4FFMfgmjg=; b=YhnEW/3eohPp4sbGaDAib8XL1B
        PP08fHX9H/3IL2OVHuA1C12/v4vmn1qnvfXEWbQBwnsYR83rYp9RWI27Lip7QzZa13dL+icxmE0vk
        JaIAXzmyKdxGkS3KIoLybIsDe7r8+Vx44ZRYJ0FAS4U7Pg5oYbrMs+vsquzJw1GJ4AV3LLF5i9deg
        CkLjDDQvFGsfu1yTLlMNlmL1q/mqbHlHsxAXd3NaPRW0PCn/eVZDzBsXYYnQdFCwOSo9ZgMG3TbVx
        4wtt5SdQXeK/VA9uJrL7U2mxOhcVAJWSAi75ZfUNpimku2d73PUD61KhNXBMo5iyPP743PBORg0i9
        r6M8dAAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQhL-0007fx-LY; Fri, 01 May 2020 08:07:03 +0000
Date:   Fri, 1 May 2020 01:07:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: pass a commit_mode to xfs_trans_commit
Message-ID: <20200501080703.GA17731@infradead.org>
References: <20200409073650.1590904-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409073650.1590904-1-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Any comments?

On Thu, Apr 09, 2020 at 09:36:50AM +0200, Christoph Hellwig wrote:
> Instead of marking the transaction sync using a flag, often based on
> copy and pasted mount options checks, pass an enum of sync modes
> to xfs_trans_commit that clearly documents the intent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c     | 15 ++--------
>  fs/xfs/libxfs/xfs_bmap.c     |  4 +--
>  fs/xfs/libxfs/xfs_refcount.c |  2 +-
>  fs/xfs/libxfs/xfs_sb.c       |  7 ++---
>  fs/xfs/libxfs/xfs_shared.h   |  1 -
>  fs/xfs/scrub/scrub.c         |  2 +-
>  fs/xfs/xfs_aops.c            |  2 +-
>  fs/xfs/xfs_attr_inactive.c   |  2 +-
>  fs/xfs/xfs_bmap_item.c       |  2 +-
>  fs/xfs/xfs_bmap_util.c       | 19 ++++--------
>  fs/xfs/xfs_dquot.c           |  2 +-
>  fs/xfs/xfs_extfree_item.c    |  2 +-
>  fs/xfs/xfs_file.c            |  4 +--
>  fs/xfs/xfs_fsops.c           |  6 ++--
>  fs/xfs/xfs_inode.c           | 58 +++++-------------------------------
>  fs/xfs/xfs_ioctl.c           |  9 ++----
>  fs/xfs/xfs_iomap.c           |  4 +--
>  fs/xfs/xfs_iops.c            | 11 ++-----
>  fs/xfs/xfs_log_recover.c     |  4 +--
>  fs/xfs/xfs_pnfs.c            |  3 +-
>  fs/xfs/xfs_qm.c              |  2 +-
>  fs/xfs/xfs_qm_syscalls.c     | 10 +++----
>  fs/xfs/xfs_refcount_item.c   |  2 +-
>  fs/xfs/xfs_reflink.c         | 14 ++++-----
>  fs/xfs/xfs_rmap_item.c       |  2 +-
>  fs/xfs/xfs_rtalloc.c         |  6 ++--
>  fs/xfs/xfs_super.c           |  2 +-
>  fs/xfs/xfs_symlink.c         | 13 ++------
>  fs/xfs/xfs_trans.c           | 32 +++++++++++++++-----
>  fs/xfs/xfs_trans.h           | 15 +++++-----
>  30 files changed, 94 insertions(+), 163 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e4fe3dca9883..a6a94bbea8a7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -175,7 +175,6 @@ xfs_attr_try_sf_addname(
>  	struct xfs_da_args	*args)
>  {
>  
> -	struct xfs_mount	*mp = dp->i_mount;
>  	int			error, error2;
>  
>  	error = xfs_attr_shortform_addname(args);
> @@ -189,10 +188,7 @@ xfs_attr_try_sf_addname(
>  	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(args->trans);
> -
> -	error2 = xfs_trans_commit(args->trans);
> +	error2 = xfs_trans_commit(args->trans, XFS_TRANS_COMMIT_WSYNC);
>  	args->trans = NULL;
>  	return error ? error : error2;
>  }
> @@ -382,13 +378,6 @@ xfs_attr_set(
>  			goto out_trans_cancel;
>  	}
>  
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * transaction goes to disk before returning to the user.
> -	 */
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(args->trans);
> -
>  	if (!(args->op_flags & XFS_DA_OP_NOTIME))
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
> @@ -396,7 +385,7 @@ xfs_attr_set(
>  	 * Commit the last in the sequence of transactions.
>  	 */
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(args->trans);
> +	error = xfs_trans_commit(args->trans, XFS_TRANS_COMMIT_WSYNC);
>  out_unlock:
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fda13cd7add0..aa16990e9b5f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1148,7 +1148,7 @@ xfs_bmap_add_attrfork(
>  			xfs_log_sb(tp);
>  	}
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> @@ -4644,7 +4644,7 @@ xfs_bmapi_convert_delalloc(
>  		goto out_finish;
>  
>  	xfs_bmapi_finish(&bma, whichfork, 0);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 2076627243b0..095ab1202643 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1749,7 +1749,7 @@ xfs_refcount_recover_cow_leftovers(
>  		/* Free the block. */
>  		xfs_bmap_add_free(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
>  
> -		error = xfs_trans_commit(tp);
> +		error = xfs_trans_commit(tp, 0);
>  		if (error)
>  			goto out_free;
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index c526c5e5ab76..c30ba1a6e819 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -990,9 +990,7 @@ xfs_sync_sb(
>  		return error;
>  
>  	xfs_log_sb(tp);
> -	if (wait)
> -		xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, wait ? XFS_TRANS_COMMIT_SYNC : 0);
>  }
>  
>  /*
> @@ -1087,8 +1085,7 @@ xfs_sync_sb_buf(
>  	bp = xfs_trans_getsb(tp, mp);
>  	xfs_log_sb(tp);
>  	xfs_trans_bhold(tp, bp);
> -	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_SYNC);
>  	if (error)
>  		goto out;
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c45acbd3add9..586d5c0c912b 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -61,7 +61,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
>  #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
>  #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
> -#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
>  #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 8ebf35b115ce..67bb71c98003 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -155,7 +155,7 @@ xchk_teardown(
>  	xchk_ag_free(sc, &sc->sa);
>  	if (sc->tp) {
>  		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
> -			error = xfs_trans_commit(sc->tp);
> +			error = xfs_trans_commit(sc->tp, 0);
>  		else
>  			xfs_trans_cancel(sc->tp);
>  		sc->tp = NULL;
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9d9cebf18726..c0504d5144ee 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -92,7 +92,7 @@ __xfs_setfilesize(
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, 0);
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index c42f90e16b4f..c07389d07724 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -380,7 +380,7 @@ xfs_attr_inactive(
>  	/* Reset the attribute fork - this also destroys the in-core fork */
>  	xfs_attr_fork_remove(dp, trans);
>  
> -	error = xfs_trans_commit(trans);
> +	error = xfs_trans_commit(trans, 0);
>  	xfs_iunlock(dp, lock_mode);
>  	return error;
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ee6f4229cebc..6d07581f8fc0 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -548,7 +548,7 @@ xfs_bui_recover(
>  
>  	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
>  	xfs_defer_move(parent_tp, tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 4f800f7fe888..f1b24fa01432 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -702,7 +702,7 @@ xfs_free_eofblocks(
>  			 */
>  			xfs_trans_cancel(tp);
>  		} else {
> -			error = xfs_trans_commit(tp);
> +			error = xfs_trans_commit(tp, 0);
>  			if (!error)
>  				xfs_inode_clear_eofblocks_tag(ip);
>  		}
> @@ -833,7 +833,7 @@ xfs_alloc_file_space(
>  		/*
>  		 * Complete the transaction
>  		 */
> -		error = xfs_trans_commit(tp);
> +		error = xfs_trans_commit(tp, 0);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
>  			break;
> @@ -890,7 +890,7 @@ xfs_unmap_extent(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> @@ -1098,7 +1098,7 @@ xfs_collapse_file_space(
>  			goto out_trans_cancel;
>  	}
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> @@ -1175,7 +1175,7 @@ xfs_insert_file_space(
>  			goto out_trans_cancel;
>  	} while (!done);
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> @@ -1753,14 +1753,7 @@ xfs_swap_extents(
>  			goto out_trans_cancel;
>  	}
>  
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * transaction goes to disk before returning to the user.
> -	 */
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(tp);
> -
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_WSYNC);
>  
>  	trace_xfs_swap_extent_after(ip, 0);
>  	trace_xfs_swap_extent_after(tip, 1);
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index af2c8e5ceea0..fec166e2dd11 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -530,7 +530,7 @@ xfs_qm_dqread_alloc(
>  	if (error)
>  		goto err_cancel;
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error) {
>  		/*
>  		 * Buffer was held to the transaction, so we have to unlock it
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6ea847f6e298..7572cddca074 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -645,7 +645,7 @@ xfs_efi_recover(
>  	}
>  
>  	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	return error;
>  
>  abort_error:
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4b8bdecc3863..45343e6d1643 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -61,9 +61,7 @@ xfs_update_prealloc_flags(
>  		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	if (flags & XFS_PREALLOC_SYNC)
> -		xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, XFS_TRANS_COMMIT_SYNC);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 3e61d0cc23f8..a45ab9397901 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -128,8 +128,7 @@ xfs_growfs_data_private(
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> -	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_SYNC);
>  	if (error)
>  		return error;
>  
> @@ -209,8 +208,7 @@ xfs_growfs_imaxpct(
>  
>  	dpct = imaxpct - mp->m_sb.sb_imax_pct;
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> -	xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, XFS_TRANS_COMMIT_SYNC);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d1772786af29..e04587a23bfa 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1216,14 +1216,6 @@ xfs_create(
>  		xfs_bumplink(tp, dp);
>  	}
>  
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * create transaction goes to disk before returning to
> -	 * the user.
> -	 */
> -	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
> -		xfs_trans_set_sync(tp);
> -
>  	/*
>  	 * Attach the dquot(s) to the inodes and modify them incore.
>  	 * These ids of the inode couldn't have changed since the new
> @@ -1231,7 +1223,7 @@ xfs_create(
>  	 */
>  	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_DIRSYNC);
>  	if (error)
>  		goto out_release_inode;
>  
> @@ -1311,9 +1303,6 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(tp);
> -
>  	/*
>  	 * Attach the dquot(s) to the inodes and modify them incore.
>  	 * These ids of the inode couldn't have changed since the new
> @@ -1325,7 +1314,7 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_WSYNC);
>  	if (error)
>  		goto out_release_inode;
>  
> @@ -1430,16 +1419,7 @@ xfs_link(
>  	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
>  
>  	xfs_bumplink(tp, sip);
> -
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * link transaction goes to disk before returning to
> -	 * the user.
> -	 */
> -	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
> -		xfs_trans_set_sync(tp);
> -
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, XFS_TRANS_COMMIT_DIRSYNC);
>  
>   error_return:
>  	xfs_trans_cancel(tp);
> @@ -1688,7 +1668,7 @@ xfs_inactive_truncate(
>  
>  	ASSERT(ip->i_d.di_nextents == 0);
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto error_unlock;
>  
> @@ -1773,7 +1753,7 @@ xfs_inactive_ifree(
>  	 * Just ignore errors at this point.  There is nothing we can do except
>  	 * to try to keep going. Make sure it's not a silent error.
>  	 */
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
>  			__func__, error);
> @@ -2957,15 +2937,7 @@ xfs_remove(
>  		goto out_trans_cancel;
>  	}
>  
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * remove transaction goes to disk before returning to
> -	 * the user.
> -	 */
> -	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
> -		xfs_trans_set_sync(tp);
> -
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_DIRSYNC);
>  	if (error)
>  		goto std_return;
>  
> @@ -3031,20 +3003,6 @@ xfs_sort_for_rename(
>  	}
>  }
>  
> -static int
> -xfs_finish_rename(
> -	struct xfs_trans	*tp)
> -{
> -	/*
> -	 * If this is a synchronous mount, make sure that the rename transaction
> -	 * goes to disk before returning to the user.
> -	 */
> -	if (tp->t_mountp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
> -		xfs_trans_set_sync(tp);
> -
> -	return xfs_trans_commit(tp);
> -}
> -
>  /*
>   * xfs_cross_rename()
>   *
> @@ -3147,7 +3105,7 @@ xfs_cross_rename(
>  	}
>  	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
> -	return xfs_finish_rename(tp);
> +	return xfs_trans_commit(tp, XFS_TRANS_COMMIT_DIRSYNC);
>  
>  out_trans_abort:
>  	xfs_trans_cancel(tp);
> @@ -3471,7 +3429,7 @@ xfs_rename(
>  	if (new_parent)
>  		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
>  
> -	error = xfs_finish_rename(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_DIRSYNC);
>  	if (wip)
>  		xfs_irele(wip);
>  	return error;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cdfb3cd9a25b..c2e3d8181dd8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1381,10 +1381,6 @@ xfs_ioctl_setattr_get_trans(
>  		error = -EPERM;
>  		goto out_cancel;
>  	}
> -
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(tp);
> -
>  	return tp;
>  
>  out_cancel:
> @@ -1620,7 +1616,8 @@ xfs_ioctl_setattr(
>  	else
>  		ip->i_d.di_cowextsize = 0;
>  
> -	code = xfs_trans_commit(tp);
> +
> +	code = xfs_trans_commit(tp, XFS_TRANS_COMMIT_WSYNC);
>  
>  	/*
>  	 * Release any dquot(s) the inode had kept before chown.
> @@ -1729,7 +1726,7 @@ xfs_ioc_setxflags(
>  		goto out_drop_write;
>  	}
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_WSYNC);
>  out_drop_write:
>  	mnt_drop_write_file(filp);
>  	return error;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index bb590a267a7f..52c0fabe9117 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -265,7 +265,7 @@ xfs_iomap_write_direct(
>  	/*
>  	 * Complete the transaction
>  	 */
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto out_unlock;
>  
> @@ -593,7 +593,7 @@ xfs_iomap_write_unwritten(
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> -		error = xfs_trans_commit(tp);
> +		error = xfs_trans_commit(tp, 0);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f7a99b3bbcf7..e95edd550ca8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -789,9 +789,7 @@ xfs_setattr_nonsize(
>  
>  	XFS_STATS_INC(mp, xs_ig_attrchg);
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_WSYNC);
>  
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
> @@ -1028,10 +1026,7 @@ xfs_setattr_size(
>  
>  	XFS_STATS_INC(mp, xs_ig_attrchg);
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(tp);
> -
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_WSYNC);
>  out_unlock:
>  	if (lock_flags)
>  		xfs_iunlock(ip, lock_flags);
> @@ -1125,7 +1120,7 @@ xfs_vn_update_time(
>  
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, log_flags);
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, 0);
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b1..0e7c10911345 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4768,7 +4768,7 @@ xlog_finish_defer_ops(
>  	/* transfer all collected dfops to this transaction */
>  	xfs_defer_move(tp, parent_tp);
>  
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, 0);
>  }
>  
>  /*
> @@ -4954,7 +4954,7 @@ xlog_recover_clear_agi_bucket(
>  	xfs_trans_log_buf(tp, agibp, offset,
>  			  (offset + sizeof(xfs_agino_t) - 1));
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto out_error;
>  	return;
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index bb3008d390aa..c24a760f5194 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -290,8 +290,7 @@ xfs_fs_commit_blocks(
>  		ip->i_d.di_size = iattr->ia_size;
>  	}
>  
> -	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_SYNC);
>  
>  out_drop_iolock:
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index c225691fad15..6eb0d44429de 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -818,7 +818,7 @@ xfs_qm_qino_alloc(
>  	spin_unlock(&mp->m_sb_lock);
>  	xfs_log_sb(tp);
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error) {
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5d5ac65aa1cc..982083b1c142 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -47,8 +47,7 @@ xfs_qm_log_quotaoff(
>  	 * return and actually stop quota accounting. So, make it synchronous.
>  	 * We don't care about quotoff's performance.
>  	 */
> -	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_SYNC);
>  	if (error)
>  		goto out;
>  
> @@ -81,8 +80,7 @@ xfs_qm_log_quotaoff_end(
>  	 * return and actually stop quota accounting. So, make it synchronous.
>  	 * We don't care about quotoff's performance.
>  	 */
> -	xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
> +	return xfs_trans_commit(tp, XFS_TRANS_COMMIT_SYNC);
>  }
>  
>  /*
> @@ -305,7 +303,7 @@ xfs_qm_scall_trunc_qfile(
>  	ASSERT(ip->i_d.di_nextents == 0);
>  
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> @@ -593,7 +591,7 @@ xfs_qm_scall_setqlim(
>  	dqp->dq_flags |= XFS_DQ_DIRTY;
>  	xfs_trans_log_dquot(tp, dqp);
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  
>  out_rele:
>  	xfs_qm_dqrele(dqp);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8eeed73928cd..9786c1e22ca4 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -581,7 +581,7 @@ xfs_cui_recover(
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
>  	xfs_defer_move(parent_tp, tp);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	return error;
>  
>  abort_error:
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index b0ce04ffd3cd..01e6691a1f61 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -414,7 +414,7 @@ xfs_reflink_allocate_cow(
>  		goto out_unreserve;
>  
>  	xfs_inode_set_cowblocks_tag(ip);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		return error;
>  
> @@ -570,7 +570,7 @@ xfs_reflink_cancel_cow_range(
>  	if (error)
>  		goto out_cancel;
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> @@ -683,7 +683,7 @@ xfs_reflink_end_cow_extent(
>  	/* Remove the mapping from the CoW fork. */
>  	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (error)
>  		return error;
> @@ -901,7 +901,7 @@ xfs_reflink_set_inode_flag(
>  		xfs_iunlock(dest, XFS_ILOCK_EXCL);
>  
>  commit_flags:
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto out_error;
>  	return error;
> @@ -948,7 +948,7 @@ xfs_reflink_update_dest(
>  
>  	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto out_error;
>  	return error;
> @@ -1088,7 +1088,7 @@ xfs_reflink_remap_extent(
>  			goto out_cancel;
>  	}
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (error)
>  		goto out;
> @@ -1493,7 +1493,7 @@ xfs_reflink_try_clear_inode_flag(
>  	if (error)
>  		goto cancel;
>  
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto out;
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4911b68f95dd..29931d4fa0e7 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -598,7 +598,7 @@ xfs_rui_recover(
>  
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
>  	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	return error;
>  
>  abort_error:
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6209e7b6b895..6039fca2b34f 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -800,7 +800,7 @@ xfs_growfs_rt_alloc(
>  		/*
>  		 * Free any blocks freed up in the transaction, then commit.
>  		 */
> -		error = xfs_trans_commit(tp);
> +		error = xfs_trans_commit(tp, 0);
>  		if (error)
>  			return error;
>  		/*
> @@ -835,7 +835,7 @@ xfs_growfs_rt_alloc(
>  			/*
>  			 * Commit the transaction.
>  			 */
> -			error = xfs_trans_commit(tp);
> +			error = xfs_trans_commit(tp, 0);
>  			if (error)
>  				return error;
>  		}
> @@ -1072,7 +1072,7 @@ xfs_growfs_rt(
>  		mp->m_rsumlevels = nrsumlevels;
>  		mp->m_rsumsize = nrsumsize;
>  
> -		error = xfs_trans_commit(tp);
> +		error = xfs_trans_commit(tp, 0);
>  		if (error)
>  			break;
>  	}
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index abf06bf9c3f3..e652ca8a1ef7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -633,7 +633,7 @@ xfs_fs_dirty_inode(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
> -	xfs_trans_commit(tp);
> +	xfs_trans_commit(tp, 0);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 13fb4b919648..24e228c0f477 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -312,16 +312,7 @@ xfs_symlink(
>  	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * symlink transaction goes to disk before returning to
> -	 * the user.
> -	 */
> -	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC)) {
> -		xfs_trans_set_sync(tp);
> -	}
> -
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, XFS_TRANS_COMMIT_DIRSYNC);
>  	if (error)
>  		goto out_release_inode;
>  
> @@ -439,7 +430,7 @@ xfs_inactive_symlink_rmt(
>  	 * rolls and commits the transaction that frees the extents.
>  	 */
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	error = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error) {
>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>  		goto error_unlock;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 28b983ff8b11..8aad8b3572ed 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -918,6 +918,23 @@ xfs_trans_committed_bulk(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> +static inline bool
> +xfs_trans_is_sync(
> +	struct xfs_mount	*mp,
> +	enum xfs_commit_mode	mode)
> +{
> +	switch (mode) {
> +	case XFS_TRANS_COMMIT_SYNC:
> +		return true;
> +	case XFS_TRANS_COMMIT_DIRSYNC:
> +		return mp->m_flags & (XFS_MOUNT_WSYNC | XFS_MOUNT_DIRSYNC);
> +	case XFS_TRANS_COMMIT_WSYNC:
> +		return mp->m_flags & XFS_MOUNT_WSYNC;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /*
>   * Commit the given transaction to the log.
>   *
> @@ -933,12 +950,12 @@ xfs_trans_committed_bulk(
>  static int
>  __xfs_trans_commit(
>  	struct xfs_trans	*tp,
> +	enum xfs_commit_mode	mode,
>  	bool			regrant)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	xfs_lsn_t		commit_lsn = -1;
>  	int			error = 0;
> -	int			sync = tp->t_flags & XFS_TRANS_SYNC;
>  
>  	trace_xfs_trans_commit(tp, _RET_IP_);
>  
> @@ -984,10 +1001,10 @@ __xfs_trans_commit(
>  	xfs_trans_free(tp);
>  
>  	/*
> -	 * If the transaction needs to be synchronous, then force the
> -	 * log out now and wait for it.
> +	 * If the transaction needs to be synchronous, then force the log out
> +	 * now and wait for it.
>  	 */
> -	if (sync) {
> +	if (xfs_trans_is_sync(mp, mode)) {
>  		error = xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
>  		XFS_STATS_INC(mp, xs_trans_sync);
>  	} else {
> @@ -1022,9 +1039,10 @@ __xfs_trans_commit(
>  
>  int
>  xfs_trans_commit(
> -	struct xfs_trans	*tp)
> +	struct xfs_trans	*tp,
> +	enum xfs_commit_mode	mode)
>  {
> -	return __xfs_trans_commit(tp, false);
> +	return __xfs_trans_commit(tp, mode, false);
>  }
>  
>  /*
> @@ -1111,7 +1129,7 @@ xfs_trans_roll(
>  	 * is in progress. The caller takes the responsibility to cancel
>  	 * the duplicate transaction that gets returned.
>  	 */
> -	error = __xfs_trans_commit(trans, true);
> +	error = __xfs_trans_commit(trans, 0, true);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 752c7fef9de7..499b5da72df0 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -143,12 +143,6 @@ typedef struct xfs_trans {
>  	unsigned long		t_pflags;	/* saved process flags state */
>  } xfs_trans_t;
>  
> -/*
> - * XFS transaction mechanism exported interfaces that are
> - * actually macros.
> - */
> -#define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
> -
>  #if defined(DEBUG) || defined(XFS_WARN)
>  #define	xfs_trans_agblocks_delta(tp, d)	((tp)->t_ag_freeblks_delta += (int64_t)d)
>  #define	xfs_trans_agflist_delta(tp, d)	((tp)->t_ag_flist_delta += (int64_t)d)
> @@ -230,7 +224,14 @@ void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
>  bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
>  void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
>  
> -int		xfs_trans_commit(struct xfs_trans *);
> +enum xfs_commit_mode {
> +	/* 0 means no sync required */
> +	XFS_TRANS_COMMIT_SYNC = 1,	/* always commit synchronously */
> +	XFS_TRANS_COMMIT_WSYNC,		/* ... only for wsync mounts */
> +	XFS_TRANS_COMMIT_DIRSYNC,	/* ... for dirsync and wsync mounts */
> +};
> +
> +int		xfs_trans_commit(struct xfs_trans *, enum xfs_commit_mode mode);
>  int		xfs_trans_roll(struct xfs_trans **);
>  int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
>  void		xfs_trans_cancel(xfs_trans_t *);
> -- 
> 2.25.1
> 
---end quoted text---
