Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85787C4CECD
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AE5F21670
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbfIPMxN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:53:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732709AbfIPMxN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:53:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DC9318CB8F5;
        Mon, 16 Sep 2019 12:53:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C82A060600;
        Mon, 16 Sep 2019 12:53:12 +0000 (UTC)
Date:   Mon, 16 Sep 2019 08:53:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_release
Message-ID: <20190916125311.GB41978@bfoster>
References: <20190916122041.24636-1-hch@lst.de>
 <20190916122041.24636-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916122041.24636-2-hch@lst.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Mon, 16 Sep 2019 12:53:13 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 02:20:40PM +0200, Christoph Hellwig wrote:
> We can just move the code directly to xfs_file_release.  Additionally
> remove the pointless i_mode verification, and the error returns that
> are entirely ignored by the calller of ->release.
> 

The caller might not care if this call generates errors, but shouldn't
we care if something fails? IOW, perhaps we should have an exit path
with a WARN_ON_ONCE() or some such to indicate that an unhandled error
has occurred..?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c  | 66 ++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_inode.c | 80 ----------------------------------------------
>  fs/xfs/xfs_inode.h |  1 -
>  3 files changed, 63 insertions(+), 84 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index d952d5962e93..72680edf2ceb 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1060,10 +1060,70 @@ xfs_dir_open(
>  
>  STATIC int
>  xfs_file_release(
> -	struct inode	*inode,
> -	struct file	*filp)
> +	struct inode		*inode,
> +	struct file		*file)
>  {
> -	return xfs_release(XFS_I(inode));
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		return 0;
> +	

Whitespace damage on the above line.

> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return 0;
> +
> +	/*
> +	 * If we previously truncated this file and removed old data in the
> +	 * process, we want to initiate "early" writeout on the last close.
> +	 * This is an attempt to combat the notorious NULL files problem which
> +	 * is particularly noticeable from a truncate down, buffered (re-)write
> +	 * (delalloc), followed by a crash.  What we are effectively doing here
> +	 * is significantly reducing the time window where we'd otherwise be
> +	 * exposed to that problem.
> +	 */
> +	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
> +		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> +		if (ip->i_delayed_blks > 0)
> +			filemap_flush(inode->i_mapping);
> +		return 0;
> +	}
> +
> +	if (inode->i_nlink == 0 || !xfs_can_free_eofblocks(ip, false))
> +		return 0;
> +
> +	/*
> +	 * Check if the inode is being opened, written and closed frequently and
> +	 * we have delayed allocation blocks outstanding (e.g. streaming writes
> +	 * from the NFS server), truncating the blocks past EOF will cause
> +	 * fragmentation to occur.
> +	 *
> +	 * In this case don't do the truncation, but we have to be careful how
> +	 * we detect this case. Blocks beyond EOF show up as i_delayed_blks even
> +	 * when the inode is clean, so we need to truncate them away first
> +	 * before checking for a dirty release.  Hence on the first dirty close
> +	 * we will still remove the speculative allocation, but after that we
> +	 * will leave it in place.
> +	 */
> +	if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
> +		return 0;
> +
> +	/*
> +	 * If we can't get the iolock just skip truncating the blocks past EOF
> +	 * because we could deadlock with the mmap_sem otherwise.  We'll get
> +	 * another chance to drop them once the last reference to the inode is
> +	 * dropped, so we'll never leak blocks permanently.
> +	 */
> +	if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +		xfs_free_eofblocks(ip);
> +		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	}
> +
> +	/*
> +	 * Delalloc blocks after truncation means it really is dirty.
> +	 */

This isn't necessarily true now that we ignore errors. I.e., this also
subtly changes the logic of the function.

Brian

> +	if (ip->i_delayed_blks)
> +		xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> +	return 0;
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 18f4b262e61c..b21405540c37 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1590,86 +1590,6 @@ xfs_itruncate_extents_flags(
>  	return error;
>  }
>  
> -int
> -xfs_release(
> -	xfs_inode_t	*ip)
> -{
> -	xfs_mount_t	*mp = ip->i_mount;
> -	int		error;
> -
> -	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
> -		return 0;
> -
> -	/* If this is a read-only mount, don't do this (would generate I/O) */
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		return 0;
> -
> -	if (!XFS_FORCED_SHUTDOWN(mp)) {
> -		int truncated;
> -
> -		/*
> -		 * If we previously truncated this file and removed old data
> -		 * in the process, we want to initiate "early" writeout on
> -		 * the last close.  This is an attempt to combat the notorious
> -		 * NULL files problem which is particularly noticeable from a
> -		 * truncate down, buffered (re-)write (delalloc), followed by
> -		 * a crash.  What we are effectively doing here is
> -		 * significantly reducing the time window where we'd otherwise
> -		 * be exposed to that problem.
> -		 */
> -		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
> -		if (truncated) {
> -			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> -			if (ip->i_delayed_blks > 0) {
> -				error = filemap_flush(VFS_I(ip)->i_mapping);
> -				if (error)
> -					return error;
> -			}
> -		}
> -	}
> -
> -	if (VFS_I(ip)->i_nlink == 0)
> -		return 0;
> -
> -	if (xfs_can_free_eofblocks(ip, false)) {
> -
> -		/*
> -		 * Check if the inode is being opened, written and closed
> -		 * frequently and we have delayed allocation blocks outstanding
> -		 * (e.g. streaming writes from the NFS server), truncating the
> -		 * blocks past EOF will cause fragmentation to occur.
> -		 *
> -		 * In this case don't do the truncation, but we have to be
> -		 * careful how we detect this case. Blocks beyond EOF show up as
> -		 * i_delayed_blks even when the inode is clean, so we need to
> -		 * truncate them away first before checking for a dirty release.
> -		 * Hence on the first dirty close we will still remove the
> -		 * speculative allocation, but after that we will leave it in
> -		 * place.
> -		 */
> -		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
> -			return 0;
> -		/*
> -		 * If we can't get the iolock just skip truncating the blocks
> -		 * past EOF because we could deadlock with the mmap_sem
> -		 * otherwise. We'll get another chance to drop them once the
> -		 * last reference to the inode is dropped, so we'll never leak
> -		 * blocks permanently.
> -		 */
> -		if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -			error = xfs_free_eofblocks(ip);
> -			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> -			if (error)
> -				return error;
> -		}
> -
> -		/* delalloc blocks after truncation means it really is dirty */
> -		if (ip->i_delayed_blks)
> -			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> -	}
> -	return 0;
> -}
> -
>  /*
>   * xfs_inactive_truncate
>   *
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 558173f95a03..4299905135b2 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -410,7 +410,6 @@ enum layout_break_reason {
>  	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
>  	 (VFS_I(pip)->i_mode & S_ISGID))
>  
> -int		xfs_release(struct xfs_inode *ip);
>  void		xfs_inactive(struct xfs_inode *ip);
>  int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
>  			   struct xfs_inode **ipp, struct xfs_name *ci_name);
> -- 
> 2.20.1
> 
