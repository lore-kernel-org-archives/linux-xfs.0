Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8222AC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F2522DFB
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbhAYSSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:18:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730901AbhAYSQs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611598521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VHBECobd8x6cxAan+4ZgW2YXTO+BTmtMvlKylykXXEo=;
        b=XR1pKjEZVlKje3MAI/f27HTiKtohpwVWomFidthYFWsvu6vLgzuCanIWrSTM+zUMN8ZYaN
        CjhUP8/kSaUbrZt+CDY3Rb0Fk+bg/3v0r5q5QZFuQzK3DjBJKSaZWYUxcpEjTaAlA3tqAZ
        3+PwIgNHs33pybsMS9WNEw+FvFCA82o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-KAou652SOJyoLTdzlAhlfg-1; Mon, 25 Jan 2021 13:15:19 -0500
X-MC-Unique: KAou652SOJyoLTdzlAhlfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B69E9B8101;
        Mon, 25 Jan 2021 18:15:18 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCD725D9DB;
        Mon, 25 Jan 2021 18:15:17 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:15:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
Message-ID: <20210125181515.GK2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142794741.2171939.10175775024910240954.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142794741.2171939.10175775024910240954.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:27AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Change the signature of xfs_blockgc_free_quota in preparation for the
> next few patches.  Callers can now pass EOF_FLAGS into the function to
> control scan parameters; and the function will now pass back any
> corruption errors seen while scanning, though for our retry loops we'll
> just try again unconditionally.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c   |    7 +++----
>  fs/xfs/xfs_icache.c |   20 ++++++++++++--------
>  fs/xfs/xfs_icache.h |    2 +-
>  3 files changed, 16 insertions(+), 13 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index aba901d5637b..68b6f72593dc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1651,19 +1651,21 @@ xfs_start_block_reaping(
>   * failure. We make a best effort by including each quota under low free space
>   * conditions (less than 1% free space) in the scan.
>   */
> -bool
> +int
>  xfs_blockgc_free_quota(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	unsigned int		eof_flags)
>  {
>  	struct xfs_eofblocks	eofb = {0};
>  	struct xfs_dquot	*dq;
>  	bool			do_work = false;
> +	int			error;
>  
>  	/*
> -	 * Run a sync scan to increase effectiveness and use the union filter to
> +	 * Run a scan to increase effectiveness and use the union filter to

The original comment referred to the increased effectiveness of a sync
scan. It doesn't make a whole lot of sense without that qualification
IMO (even though the scan is still sync). We could move that bit of
comment to the caller where the flag is now set, but it's probably fine
to just remove that text also. With that tweak:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	 * cover all applicable quotas in a single scan.
>  	 */
> -	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
> +	eofb.eof_flags = XFS_EOF_FLAGS_UNION | eof_flags;
>  
>  	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
>  		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
> @@ -1693,9 +1695,11 @@ xfs_blockgc_free_quota(
>  	}
>  
>  	if (!do_work)
> -		return false;
> +		return 0;
>  
> -	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> -	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
> -	return true;
> +	error = xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> +	if (error)
> +		return error;
> +
> +	return xfs_icache_free_cowblocks(ip->i_mount, &eofb);
>  }
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 21b726a05b0d..d64ea8f5c589 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -54,7 +54,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
>  
>  void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
>  
> -bool xfs_blockgc_free_quota(struct xfs_inode *ip);
> +int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
>  
>  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
>  void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
> 

