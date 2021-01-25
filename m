Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095C2C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC13422C9E
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbhAYSPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:15:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730874AbhAYSPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611598418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iA9Xf5UAbj82Ia0J6YrfDwUkw9md0lmd3lQL1WB56eY=;
        b=iFg6wTwnW9m3cj6Ntzd4UrKjIo0KG01wS+af51yXrEecVAbSLSaz7u/LcE/XznLxOr0+ty
        BBK3WfqA0WxbHTpe5JXnNlaYlsnNXXVGnbNrBB+FoCtxctbV/c0rjB+CJuwO4NoPj7tI6h
        aLe9LvExGvZB37d62SMwRsP1PjV1HYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-mCwfZiCsND-oFKuS7JQQWw-1; Mon, 25 Jan 2021 13:13:34 -0500
X-MC-Unique: mCwfZiCsND-oFKuS7JQQWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D144107ACE4;
        Mon, 25 Jan 2021 18:13:33 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C85BA10013C1;
        Mon, 25 Jan 2021 18:13:32 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:13:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 01/11] xfs: refactor messy xfs_inode_free_quota_*
 functions
Message-ID: <20210125181331.GG2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142792524.2171939.13857715099603482377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142792524.2171939.13857715099603482377.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:05AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The functions to run an eof/cowblocks scan to try to reduce quota usage
> are kind of a mess -- the logic repeatedly initializes an eofb structure
> and there are logic bugs in the code that result in the cowblocks scan
> never actually happening.
> 
> Replace all three functions with a single function that fills out an
> eofb if we're low on quota and runs both eof and cowblocks scans.
> 

It would be nice to be a bit more explicit about the scanning bug(s)
being fixed here. It looks like a couple potential issues are the first
scan clearing the low free space state on the associated quotas, and
also only falling back to the cowblocks scan if the eofblocks scan
doesn't do anything. If that's the gist of this patch, I'd suggest to
change the patch subject as well since "refactor messy functions"
doesn't really convey that we're fixing some logic issues. Perhaps
something like "xfs: trigger all block scans on low quota space" would
be more accurate?

Otherwise for the code changes:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c   |   15 ++++++---------
>  fs/xfs/xfs_icache.c |   46 ++++++++++++++++------------------------------
>  fs/xfs/xfs_icache.h |    4 ++--
>  3 files changed, 24 insertions(+), 41 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5d4a66c72c78..69879237533b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -713,7 +713,7 @@ xfs_file_buffered_write(
>  	struct inode		*inode = mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret;
> -	int			enospc = 0;
> +	bool			cleared_space = false;
>  	int			iolock;
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT)
> @@ -745,19 +745,16 @@ xfs_file_buffered_write(
>  	 * also behaves as a filter to prevent too many eofblocks scans from
>  	 * running at the same time.
>  	 */
> -	if (ret == -EDQUOT && !enospc) {
> +	if (ret == -EDQUOT && !cleared_space) {
>  		xfs_iunlock(ip, iolock);
> -		enospc = xfs_inode_free_quota_eofblocks(ip);
> -		if (enospc)
> -			goto write_retry;
> -		enospc = xfs_inode_free_quota_cowblocks(ip);
> -		if (enospc)
> +		cleared_space = xfs_inode_free_quota_blocks(ip);
> +		if (cleared_space)
>  			goto write_retry;
>  		iolock = 0;
> -	} else if (ret == -ENOSPC && !enospc) {
> +	} else if (ret == -ENOSPC && !cleared_space) {
>  		struct xfs_eofblocks eofb = {0};
>  
> -		enospc = 1;
> +		cleared_space = true;
>  		xfs_flush_inodes(ip->i_mount);
>  
>  		xfs_iunlock(ip, iolock);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index deb99300d171..c71eb15e3835 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1397,33 +1397,31 @@ xfs_icache_free_eofblocks(
>  }
>  
>  /*
> - * Run eofblocks scans on the quotas applicable to the inode. For inodes with
> - * multiple quotas, we don't know exactly which quota caused an allocation
> + * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
> + * with multiple quotas, we don't know exactly which quota caused an allocation
>   * failure. We make a best effort by including each quota under low free space
>   * conditions (less than 1% free space) in the scan.
>   */
> -static int
> -__xfs_inode_free_quota_eofblocks(
> -	struct xfs_inode	*ip,
> -	int			(*execute)(struct xfs_mount *mp,
> -					   struct xfs_eofblocks	*eofb))
> +bool
> +xfs_inode_free_quota_blocks(
> +	struct xfs_inode	*ip)
>  {
> -	int scan = 0;
> -	struct xfs_eofblocks eofb = {0};
> -	struct xfs_dquot *dq;
> +	struct xfs_eofblocks	eofb = {0};
> +	struct xfs_dquot	*dq;
> +	bool			do_work = false;
>  
>  	/*
>  	 * Run a sync scan to increase effectiveness and use the union filter to
>  	 * cover all applicable quotas in a single scan.
>  	 */
> -	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
> +	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
>  
>  	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
>  		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
>  		if (dq && xfs_dquot_lowsp(dq)) {
>  			eofb.eof_uid = VFS_I(ip)->i_uid;
>  			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> -			scan = 1;
> +			do_work = true;
>  		}
>  	}
>  
> @@ -1432,21 +1430,16 @@ __xfs_inode_free_quota_eofblocks(
>  		if (dq && xfs_dquot_lowsp(dq)) {
>  			eofb.eof_gid = VFS_I(ip)->i_gid;
>  			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> -			scan = 1;
> +			do_work = true;
>  		}
>  	}
>  
> -	if (scan)
> -		execute(ip->i_mount, &eofb);
> +	if (!do_work)
> +		return false;
>  
> -	return scan;
> -}
> -
> -int
> -xfs_inode_free_quota_eofblocks(
> -	struct xfs_inode *ip)
> -{
> -	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_eofblocks);
> +	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> +	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
> +	return true;
>  }
>  
>  static inline unsigned long
> @@ -1646,13 +1639,6 @@ xfs_icache_free_cowblocks(
>  			XFS_ICI_COWBLOCKS_TAG);
>  }
>  
> -int
> -xfs_inode_free_quota_cowblocks(
> -	struct xfs_inode *ip)
> -{
> -	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_cowblocks);
> -}
> -
>  void
>  xfs_inode_set_cowblocks_tag(
>  	xfs_inode_t	*ip)
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 3a4c8b382cd0..3f7ddbca8638 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -54,17 +54,17 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
>  
>  void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
>  
> +bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
> +
>  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
>  void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
>  int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
> -int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
>  void xfs_eofblocks_worker(struct work_struct *);
>  void xfs_queue_eofblocks(struct xfs_mount *);
>  
>  void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
>  void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
>  int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
> -int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
>  void xfs_cowblocks_worker(struct work_struct *);
>  void xfs_queue_cowblocks(struct xfs_mount *);
>  
> 

