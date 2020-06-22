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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B9EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568B32071A
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EdmhNwJD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgFVJr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 05:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgFVJr1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 05:47:27 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EE4C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:47:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j12so5952803pfn.10
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhjTI2AhFBciT5C2jL9dqL4kOtfCiOHpWcjTl5GuWD0=;
        b=EdmhNwJDgfPQax6SYAdbNrHDWdCvgPmquaNEisTIPFE8DPgqJGlZT/SOuRUUrELyiH
         IEHZU9SGQ/30sncKEsQMjYIk90fSNWxrhZqBEOiskbTCCVHnBBRLD0ScyCinLL23qbFo
         OYe8zB+57HcsdaUXQ1PYy1fEjFZBpeOP+NGJHosVaq3CtpiQbcesQkm09brUWXVCjNF+
         jrlH5ZnDfwuUUqk2guytX/C+tOwf8uuaW+hmM0COFy2Mj0GEHuH1nqIQ7leBNfB4J+MM
         R/6jdCfPiGk0bUU/cUdONs5nbJmmplwsztJix+KbSMd/o3Zbb9zTSsIMjp8EZg/xzexF
         tgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhjTI2AhFBciT5C2jL9dqL4kOtfCiOHpWcjTl5GuWD0=;
        b=hMiXJBypDD2RhYj0WgM9AzcipSXc9CW3NZ73i2GELAYWn6gPDzQSBYSD69WFwgBQef
         c3dmIebDMoEBIfC5dqPbTqpPCTVYNszcgyUGTllOfeqeQ0vl4UXSq8NuhZhXN1RJYwNh
         RgBW5J+zn52S/7Mt8Oc0V47kQ6Ro3qRnvTJv0O2FpT0IWEAoGnS7HkPRdtIRHDsnhsLA
         FOZaG10cM4KzhZwrzvksSRPvna73jQlavMLWE81mGUM+1Ic1UxLFA5oDH6VCSul0aMQD
         57qp9dQdBnpSgPz/St8p9ESQgkT+gpjayw0/ZC/WKLLhzOdQDDQkoyiSBY/1kfI7zNPH
         ZjZw==
X-Gm-Message-State: AOAM531EEZrF1hAgY5+qEeFEcD2pnI8CW44Ug99ECT0AooGf5ATblx6Z
        jQwkeTpt80nwEuqFh6Gd8dTEApU9
X-Google-Smtp-Source: ABdhPJw52Iwz+K57kGh/LPbcDdaVv9OlgV0JOW3uP7Dh6OY/rTT7k4YXRZbDw10eODamEzFi+PWv8g==
X-Received: by 2002:a63:e153:: with SMTP id h19mr12490431pgk.167.1592819245747;
        Mon, 22 Jun 2020 02:47:25 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id n37sm10613508pgl.82.2020.06.22.02.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:47:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] xfs: move the di_cowextsize field to struct xfs_inode
Date:   Mon, 22 Jun 2020 15:17:23 +0530
Message-ID: <1854084.dlrHvGrZUC@garuda>
In-Reply-To: <20200620071102.462554-7-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-7-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:53 PM IST Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> cowextsize field into the containing xfs_inode structure.  Also
> switch to use the xfs_extlen_t instead of a uint32_t.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_file.c             | 2 +-
>  fs/xfs/xfs_inode.c            | 6 +++---
>  fs/xfs/xfs_inode.h            | 1 +
>  fs/xfs/xfs_inode_item.c       | 2 +-
>  fs/xfs/xfs_ioctl.c            | 8 +++-----
>  fs/xfs/xfs_itable.c           | 2 +-
>  fs/xfs/xfs_reflink.c          | 2 +-
>  9 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index e51b15c44bb3e1..860e35611e001a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -255,7 +255,7 @@ xfs_inode_from_disk(
>  		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
>  		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
> -		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> +		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
>  
>  	error = xfs_iformat_data_fork(ip, from);
> @@ -321,7 +321,7 @@ xfs_inode_to_disk(
>  		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> -		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index d420ea835c8390..663a97fa78f05f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -23,7 +23,6 @@ struct xfs_icdinode {
>  	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
>  
>  	uint64_t	di_flags2;	/* more random flags */
> -	uint32_t	di_cowextsize;	/* basic cow extent size for file */
>  
>  	struct timespec64 di_crtime;	/* time created */
>  };
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 14b533a8ce8e6a..b0384306d6622f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1055,7 +1055,7 @@ xfs_file_remap_range(
>  	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
>  	    pos_out == 0 && len >= i_size_read(inode_out) &&
>  	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> -		cowextsize = src->i_d.di_cowextsize;
> +		cowextsize = src->i_cowextsize;
>  
>  	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
>  			remap_flags);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6d1891f902aaa9..f1893824cd4e2f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -82,7 +82,7 @@ xfs_get_cowextsz_hint(
>  
>  	a = 0;
>  	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> -		a = ip->i_d.di_cowextsize;
> +		a = ip->i_cowextsize;
>  	b = xfs_get_extsz_hint(ip);
>  
>  	a = max(a, b);
> @@ -842,7 +842,7 @@ xfs_ialloc(
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		inode_set_iversion(inode, 1);
>  		ip->i_d.di_flags2 = 0;
> -		ip->i_d.di_cowextsize = 0;
> +		ip->i_cowextsize = 0;
>  		ip->i_d.di_crtime = tv;
>  	}
>  
> @@ -901,7 +901,7 @@ xfs_ialloc(
>  		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
>  				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> -				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
> +				ip->i_cowextsize = pip->i_cowextsize;
>  			}
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
>  				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index af90c6f745549b..2cdb7b6b298852 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,6 +58,7 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> +	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 8b8c99809f273e..ab0d8cf8ceb6ab 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -343,7 +343,7 @@ xfs_inode_to_log_dinode(
>  		to->di_crtime.t_sec = from->di_crtime.tv_sec;
>  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
>  		to->di_flags2 = from->di_flags2;
> -		to->di_cowextsize = from->di_cowextsize;
> +		to->di_cowextsize = ip->i_cowextsize;
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index efe3b5bc1178dc..a1937900ad84be 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1108,8 +1108,7 @@ xfs_fill_fsxattr(
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
> -			ip->i_mount->m_sb.sb_blocklog;
> +	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> @@ -1574,10 +1573,9 @@ xfs_ioctl_setattr(
>  		ip->i_extsize = 0;
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> -		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
> -				mp->m_sb.sb_blocklog;
> +		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
>  	else
> -		ip->i_d.di_cowextsize = 0;
> +		ip->i_cowextsize = 0;
>  
>  	code = xfs_trans_commit(tp);
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index b0f0c19fd7822e..7937af9f2ea779 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -112,7 +112,7 @@ xfs_bulkstat_one_int(
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> -			buf->bs_cowextsize_blks = dic->di_cowextsize;
> +			buf->bs_cowextsize_blks = ip->i_cowextsize;
>  	}
>  
>  	switch (ip->i_df.if_format) {
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 8598896156e29a..0e07fa7e43117e 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -942,7 +942,7 @@ xfs_reflink_update_dest(
>  	}
>  
>  	if (cowextsize) {
> -		dest->i_d.di_cowextsize = cowextsize;
> +		dest->i_cowextsize = cowextsize;
>  		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  	}
>  
> 


-- 
chandan



