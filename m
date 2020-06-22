Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C873EC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 12:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E1852070E
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 12:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uFV1efwC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgFVM6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 08:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgFVM6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 08:58:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF88C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 05:58:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v11so8107822pgb.6
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 05:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jYQ/h+JcWQaDFLnAfiCIdcNVWEm5xdvd4u2eogzGx/U=;
        b=uFV1efwCEmZIIXzcCHjhTqrx8TXvvexs4dXlrRHUKXc+YSH1Sab41SRvsY6/mC6g+l
         Y9wtk0opZf61iuIRl+JoPk/ofm1vypECqWPABlI52dof3yoH7Pv7zqUM9ZoIKzgDnEDb
         Ul3tr62ewFx7ARbZBZ+h8349XPBpE+EBu+di3tP565aZVn3bgirpfNOF2DUKk3sxY9GP
         p5jpxAyLafWmrpUyYu4pPKe2KA6qlcRqUPGcnxaQ45yxcIzbpUGee02vy9kflGe3u1Cm
         QEzbF42jgOUB2dj5jZGN9otGkBqHnoKmm7l/YqVIBky06oLT8/uLRB4fAMrr3NlKm5Vh
         xjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jYQ/h+JcWQaDFLnAfiCIdcNVWEm5xdvd4u2eogzGx/U=;
        b=WDdGeSJE35XvSECdi1vJ2K+HfvylVq6fII6HoHjHR7kAzQnaH3uwlmAnnjA2m1mJnE
         x0PR1fjf1qkc6SsoC8N9g7/ZE5apjsdweLjzvuAoVh5H4WD7x/U/h2pmZDpMXnQv+LZ/
         BmRvKwvHr9/vSjnoa57oaQPMzb9TBJ4VqXM3tOoQf0HeuUwiRUBg9h6vEcRue2ri12HD
         wXns7I1zgnWZg59y45zNlwkqueqXtQeaSOEGH65jSUeuqS151fh/lkmA2QNdx6+UoJP8
         9HpkRYzjW6YdgVG7REhn/UQx+R1c8n98xA1a9AuBNyDfyk/ao9QTIBtMrbarqikjY4oK
         59bQ==
X-Gm-Message-State: AOAM532LKPVLCv1aCEMjfhnCuLHK+9Z9IbisBhV+YpXZ12qaf6ifCkO9
        LamiBGL+MIGbdF6peuckjk8we4Mj
X-Google-Smtp-Source: ABdhPJwOUuTnQsXgky4V5DubromcTkl5lDkum19cPIDKgr8CwdQQ3zXg4ALDuMiV/133Qq7hLJ79gQ==
X-Received: by 2002:a05:6a00:807:: with SMTP id m7mr20923682pfk.246.1592830694470;
        Mon, 22 Jun 2020 05:58:14 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id x1sm13827328pju.3.2020.06.22.05.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 05:58:14 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: move the di_dmevmask field to struct xfs_inode
Date:   Mon, 22 Jun 2020 18:28:12 +0530
Message-ID: <8212436.TC6GVtpJTl@garuda>
In-Reply-To: <20200620071102.462554-15-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-15-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:41:01 PM IST Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> dmevmask field into the containing xfs_inode structure.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_inode.c            | 4 ++--
>  fs/xfs/xfs_inode.h            | 1 +
>  fs/xfs/xfs_inode_item.c       | 2 +-
>  fs/xfs/xfs_log_recover.c      | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index af595ee23635aa..d361803102d0e1 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -246,7 +246,7 @@ xfs_inode_from_disk(
>  	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
>  	ip->i_extsize = be32_to_cpu(from->di_extsize);
>  	ip->i_forkoff = from->di_forkoff;
> -	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> +	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	ip->i_diflags	= be16_to_cpu(from->di_flags);
>  
> @@ -312,7 +312,7 @@ xfs_inode_to_disk(
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> +	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
>  	to->di_dmstate = cpu_to_be16(from->di_dmstate);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 2a8e7a7ed8d18d..0cfc1aaff6c6f3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,6 @@ struct xfs_dinode;
>   * format specific structures at the appropriate time.
>   */
>  struct xfs_icdinode {
> -	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
>  };
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 59f11314750a46..db48c910c8d7b0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -833,7 +833,7 @@ xfs_ialloc(
>  	inode->i_ctime = tv;
>  
>  	ip->i_extsize = 0;
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  	ip->i_d.di_dmstate = 0;
>  	ip->i_diflags = 0;
>  
> @@ -2755,7 +2755,7 @@ xfs_ifree(
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_diflags = 0;
>  	ip->i_diflags2 = 0;
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  	ip->i_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 106a8d6cc010cb..e64df2e7438aa0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -67,6 +67,7 @@ typedef struct xfs_inode {
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  	struct timespec64	i_crtime;	/* time created */
> +	uint32_t		i_dmevmask;	/* DMIG event mask */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index dff3bc6a33720a..9b7860025c497d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -330,7 +330,7 @@ xfs_inode_to_log_dinode(
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = from->di_dmevmask;
> +	to->di_dmevmask = ip->i_dmevmask;
>  	to->di_dmstate = from->di_dmstate;
>  	to->di_flags = ip->i_diflags;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec015df55b77a9..d096b8c4013814 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2720,7 +2720,7 @@ xlog_recover_process_one_iunlink(
>  	 * Prevent any DMAPI event from being sent when the reference on
>  	 * the inode is dropped.
>  	 */
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  
>  	xfs_irele(ip);
>  	return agino;
> 


-- 
chandan



