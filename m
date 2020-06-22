Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E351BC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 10:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA07320675
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 10:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJsK6liD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgFVKxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 06:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgFVKxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 06:53:11 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D92C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 03:53:11 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k1so7423939pls.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 03:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=StnBrDReAC07XFCOSTOOgsDL+UeeebKk2zwvx2NbEOk=;
        b=FJsK6liDm8eNFLAFmjnmVZaOU6UJME6ZbeoR9TcfhyGPJbNMNnbIc66FiE8z6ok2pJ
         L2NxeH3ql/WQmHj5DtwfrVln8S344gzvsAGpFU1yzJnk6BpiCfsJreUxoc8xomPbaw23
         c4t5unzjxqUGA7pciz2nSCZmGxwOJJc8HkM/5U7Q0JiLlBcMNQzC6AgBXW+Ovj15LktC
         YyFoZdB8tdrgxtfV4AOK0UnIpjjBWNtPNzkQbxPBI0GOlfKdWZkUQuWL+/5TQOa1U1bU
         4pzJDkOgB3p4wldmzdMJNyVGhzQr/Yl4rEq+X6blaDYNf3658Y6E+298DmQE+c5aQBxW
         qrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=StnBrDReAC07XFCOSTOOgsDL+UeeebKk2zwvx2NbEOk=;
        b=dnBQ4aOMoXSuGpChcizEPiWbVu5QPYtq0krc7p33o4CP2zPPl1Ra2zu7k+xU2WQeuS
         5+JpGOhCPGRVyXLabaOx/UtMhf9xZ5nHGs2x5rBSNQJ8Tv8PXDIsvfRbfxcP/qa1r/AN
         WRJUfX/cTGuy7kHM3Go72OLopb2bSdAngKupHVj4wy9xeqQ4IHm+Dopxr6a8ZTOFOXP8
         QSt6/nyMHQBY4JhsIhRfd3gz89HuRoQMQuiFsaV9r3EkspT69zzq4+4qRfk/CR1EfIpQ
         69Nqgxqaqq5Wi0LZuTiGhFyhDb0khd9vk3psIcIZJ6EjLhxxYXbZq6VKTRLQ1TCECelI
         UQag==
X-Gm-Message-State: AOAM531+14cHmeBl4W0zyrJWq2jekIJyc+5nmfFAr64vqTOYadSuaoOZ
        yNunSBC3c8ibugJiiziUa6g=
X-Google-Smtp-Source: ABdhPJztDFs8AiBvpOr6VW6j9gk90cCsrrdTtlhymJEFup7BhP39gRUWRJSKKWnizMLujZpEpAr6Rg==
X-Received: by 2002:a17:90a:fa8f:: with SMTP id cu15mr18725021pjb.9.1592823190740;
        Mon, 22 Jun 2020 03:53:10 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id y18sm13115418pfn.177.2020.06.22.03.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:53:10 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs: use a union for i_cowextsize and i_flushiter
Date:   Mon, 22 Jun 2020 16:23:08 +0530
Message-ID: <3974096.m9y19ncQGm@garuda>
In-Reply-To: <20200620071102.462554-9-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-9-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:55 PM IST Christoph Hellwig wrote:
> The i_cowextsize field is only used for v3 inodes, and the i_flushiter
> field is only used for v1/v2 inodes.  Use a union to pack the inode a
> littler better after adding a few missing guards around their usage.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 3 ++-
>  fs/xfs/xfs_inode.c            | 6 ++++--
>  fs/xfs/xfs_inode.h            | 7 +++++--
>  fs/xfs/xfs_ioctl.c            | 6 +++++-
>  4 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 03bd7cdd0ddc81..8c4b7bd69285fa 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -205,7 +205,8 @@ xfs_inode_from_disk(
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
>  	 * with the unitialized part of it.
>  	 */
> -	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
> +	if (!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb))
> +		ip->i_flushiter = be16_to_cpu(from->di_flushiter);
>  	inode->i_generation = be32_to_cpu(from->di_gen);
>  	inode->i_mode = be16_to_cpu(from->di_mode);
>  	if (!inode->i_mode)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5e0336e0dbae44..fd111e05c0bb2e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3794,8 +3794,10 @@ xfs_iflush_int(
>  	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
>  
>  	/* Wrap, we never let the log put out DI_MAX_FLUSH */
> -	if (ip->i_flushiter == DI_MAX_FLUSH)
> -		ip->i_flushiter = 0;
> +	if (!xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +		if (ip->i_flushiter == DI_MAX_FLUSH)
> +			ip->i_flushiter = 0;
> +	}
>  
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 581618ea1156da..a0444b9ce3f792 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,8 +58,11 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> -	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
> -	uint16_t		i_flushiter;	/* incremented on flush */
> +	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> +	union {
> +		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
> +		uint16_t	i_flushiter;	/* incremented on flush */
> +	};
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a1937900ad84be..60544dd0f875b8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1108,7 +1108,11 @@ xfs_fill_fsxattr(
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> +	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
> +	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
> +		fa->fsx_cowextsize =
> +			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> +	}
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> 


-- 
chandan



