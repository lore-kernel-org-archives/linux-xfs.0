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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA980C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 12:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28732071A
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 12:54:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAdjNMbg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgFVMyp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 08:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgFVMyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 08:54:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5903C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 05:54:44 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u8so8111488pje.4
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 05:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ss28y2wEX1WO27EDNOvzU6ibfXD0cPERc2a6Jmb98jQ=;
        b=LAdjNMbgAhbX7CjIz7aop5H8WMUtlKh7x7UmkUgaII2dWB0HJgauOg1hrzIYT8qR6G
         pG1JimTHIYitUsSeAEkmcxzId48W1G7N4gbqPG1PiVTSBKsaISfihdV09WMYXB3n8/T6
         1Gy0nzqqOmo6lVRZ0aFUwEm1wpMelZZXTKcMD4N/vd7TOog6tnsSxsgDL+lx1GiRASFW
         l/qCInAxfbOiLwsHlaWDDgCWrhPGhfCItMuaz7J++ynaTbi+NuBMefNCD68TiAYyLaJi
         5v2l9q8hdRceoUpNnA5sjWKMG7L4oETAZ0XTTjyMkYqnH9IgGG/30gk3hp2iDcAWQhF1
         cDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ss28y2wEX1WO27EDNOvzU6ibfXD0cPERc2a6Jmb98jQ=;
        b=aE/AVdwdB/EZ4KxPsMGSxOkQYpc5RNNUyBGOCbYZ8AwiQq2+XNPprlwOYOZeUfvUjI
         g4JMfMuyjiXP97/piam+GSqNiZM6j8gldJ0xTPd2pL+vjiluhH7cXs0kXCKqsaaNPkEI
         /TgzrKK8fcEU71eWivD2rs+lJ9HLiH54gyqbgEbgtE9r2UuwjM/LjXZczrCa4ld2WTU0
         uLEhzj5FT1AqiBNmUlB+jkyqLkIs8Bo8P0GyZHlq2rf/OOPYiIgdSdxX5k9SdMy+VrX2
         t5g810Mqwf3D+MxR3WBawJmGuLfDhSU7h0vHmzGNRZoDCPaMT04j8AtD8d6a31sbeodK
         mLMQ==
X-Gm-Message-State: AOAM531+OvQvXDIJj93vax+V4hMmS/5PczsYTqt29L9hM/XVeaPmY3Aw
        qd3G/Bex3WqA0z7WHuKHmZCxbk4y
X-Google-Smtp-Source: ABdhPJwZMY4eyyk+r0wgXkUpJMbOmvgLGj9w8IWwiW6xYr6H8E4cN5RRUYq/Siym7dvxGmQALqbRLQ==
X-Received: by 2002:a17:90a:260e:: with SMTP id l14mr18366247pje.76.1592830484530;
        Mon, 22 Jun 2020 05:54:44 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id q22sm13741595pfg.192.2020.06.22.05.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 05:54:44 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/15] xfs: move the di_crtime field to struct xfs_inode
Date:   Mon, 22 Jun 2020 18:24:41 +0530
Message-ID: <16422901.EUMinKNoVD@garuda>
In-Reply-To: <20200620071102.462554-14-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-14-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:41:00 PM IST Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the crtime
> field into the containing xfs_inode structure.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.h   | 2 --
>  fs/xfs/libxfs/xfs_trans_inode.c | 2 +-
>  fs/xfs/xfs_inode.c              | 2 +-
>  fs/xfs/xfs_inode.h              | 1 +
>  fs/xfs/xfs_inode_item.c         | 4 ++--
>  fs/xfs/xfs_iops.c               | 2 +-
>  fs/xfs/xfs_itable.c             | 4 ++--
>  8 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 79e470933abfa8..af595ee23635aa 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -253,8 +253,8 @@ xfs_inode_from_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
> -		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> -		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
> +		ip->i_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> +		ip->i_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
>  		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
>  		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
> @@ -319,8 +319,8 @@ xfs_inode_to_disk(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> -		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
> -		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> +		to->di_crtime.t_sec = cpu_to_be32(ip->i_crtime.tv_sec);
> +		to->di_crtime.t_nsec = cpu_to_be32(ip->i_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
>  		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 4bfad6d6d5710a..2a8e7a7ed8d18d 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -18,8 +18,6 @@ struct xfs_dinode;
>  struct xfs_icdinode {
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
> -
> -	struct timespec64 di_crtime;	/* time created */
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index b5dfb665484223..3c690829634cdc 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -67,7 +67,7 @@ xfs_trans_ichgtime(
>  	if (flags & XFS_ICHGTIME_CHG)
>  		inode->i_ctime = tv;
>  	if (flags & XFS_ICHGTIME_CREATE)
> -		ip->i_d.di_crtime = tv;
> +		ip->i_crtime = tv;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 593e8c5c2fd658..59f11314750a46 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -841,7 +841,7 @@ xfs_ialloc(
>  		inode_set_iversion(inode, 1);
>  		ip->i_diflags2 = 0;
>  		ip->i_cowextsize = 0;
> -		ip->i_d.di_crtime = tv;
> +		ip->i_crtime = tv;
>  	}
>  
>  	flags = XFS_ILOG_CORE;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 709f04fadde65e..106a8d6cc010cb 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -66,6 +66,7 @@ typedef struct xfs_inode {
>  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
> +	struct timespec64	i_crtime;	/* time created */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 04e671d2957ca2..dff3bc6a33720a 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -340,8 +340,8 @@ xfs_inode_to_log_dinode(
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		to->di_version = 3;
>  		to->di_changecount = inode_peek_iversion(inode);
> -		to->di_crtime.t_sec = from->di_crtime.tv_sec;
> -		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
> +		to->di_crtime.t_sec = ip->i_crtime.tv_sec;
> +		to->di_crtime.t_nsec = ip->i_crtime.tv_nsec;
>  		to->di_flags2 = ip->i_diflags2;
>  		to->di_cowextsize = ip->i_cowextsize;
>  		to->di_ino = ip->i_ino;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 3642f9935cae3f..6aace9c6586ca5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -559,7 +559,7 @@ xfs_vn_getattr(
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		if (request_mask & STATX_BTIME) {
>  			stat->result_mask |= STATX_BTIME;
> -			stat->btime = ip->i_d.di_crtime;
> +			stat->btime = ip->i_crtime;
>  		}
>  	}
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 4d1509437c3576..7945c6c4844940 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -97,8 +97,8 @@ xfs_bulkstat_one_int(
>  	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
>  	buf->bs_ctime = inode->i_ctime.tv_sec;
>  	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
> -	buf->bs_btime = dic->di_crtime.tv_sec;
> -	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
> +	buf->bs_btime = ip->i_crtime.tv_sec;
> +	buf->bs_btime_nsec = ip->i_crtime.tv_nsec;
>  	buf->bs_gen = inode->i_generation;
>  	buf->bs_mode = inode->i_mode;
>  
> 


-- 
chandan



