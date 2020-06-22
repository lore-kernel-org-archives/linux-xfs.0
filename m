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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27156C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3764206F1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 09:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vEUF2KTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgFVJuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 05:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgFVJuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 05:50:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DA9C061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:50:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b7so6481953pju.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 02:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UnCCTNS8FBHBHH7rdslXQZ+Y/35jI3hOxgOcX2nr74g=;
        b=vEUF2KTWRrqc9oiN2q9zHuMZik2FUcX0RMSzk/hPtc+E49Fw+N6KARdA9wWArvdm4k
         JHhZbDgn1SFhUgKcjDdRKz2zsu+1IYh4UBRsT8re68ArF3IB9rfWo2JNdSA2BMEmCRb3
         q5+Icsll8YSC8z/0qhawUrkYgzCcfQH+MUCKu3ONVsnxpgW/gZ79vVkXbx1dsvDKMdQ8
         eL9gqTcPm+r4A1KjIoJtu4A+dFwODDiplisaTpNqCYvVliKUTsFmZ5AkwaMWYBunhOy5
         Bl4mySw/QiawbQjzphNDZWXj6NwMYpcet33KR/Oz0iMZwiH5yi+AtQuZ7Bp6DZFUXc0/
         nIJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnCCTNS8FBHBHH7rdslXQZ+Y/35jI3hOxgOcX2nr74g=;
        b=MGlP/KXCmv+S9oXLWloc2WJxncgL9IrReXoKRLkNp2icK2OIITWetsLARtdoCviQ9S
         Bg9PzkfA6bHYsIDgmhFmGwln9SKi35fnPhRDbFWnv1JipLEwzXYOQITx99RyOlrUGoeV
         /Allus6I5Nael50xTdmXCHEIQmbXSb3dJpB/bAOlVNscMRzKUeBijkeCWq8vzJi/WhgD
         NIWGIX+bXEvBbmZ4sRIKvF9nSIJroSPtUt4MRIEQVXp9zVtXIYu0fvNedn1PTwvFlm8i
         JKA0s/ihly6MrjQl6lp74LR6UlWaqycVJiMPh2vIPSJRZgZmwUuX0Uadqnk2Mo0iZuKX
         YiYw==
X-Gm-Message-State: AOAM532eVWg6x0jXUZshmoAdTtIrYkz20LEbScpVeOe/adSSyutntJ1d
        bLFj8Fq3rA21TEhGFOukbYs=
X-Google-Smtp-Source: ABdhPJzZ1u8KCXhtz//WLjFgOw+h55puxgo4gdOEFY2t9DQpqMIiXkruV1uUs1grDLtAM+AmWmRE0w==
X-Received: by 2002:a17:90a:474c:: with SMTP id y12mr17080544pjg.111.1592819402456;
        Mon, 22 Jun 2020 02:50:02 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id z8sm8276462pgz.7.2020.06.22.02.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:50:01 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] xfs: move the di_flushiter field to struct xfs_inode
Date:   Mon, 22 Jun 2020 15:19:59 +0530
Message-ID: <5207261.z8F0QaGh9B@garuda>
In-Reply-To: <20200620071102.462554-8-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-8-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:54 PM IST Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> flushiter field into the containing xfs_inode structure.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/xfs_icache.c           |  2 +-
>  fs/xfs/xfs_inode.c            | 19 +++++++++----------
>  fs/xfs/xfs_inode.h            |  1 +
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  6 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 860e35611e001a..03bd7cdd0ddc81 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -205,7 +205,7 @@ xfs_inode_from_disk(
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
>  	 * with the unitialized part of it.
>  	 */
> -	to->di_flushiter = be16_to_cpu(from->di_flushiter);
> +	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
>  	inode->i_generation = be32_to_cpu(from->di_gen);
>  	inode->i_mode = be16_to_cpu(from->di_mode);
>  	if (!inode->i_mode)
> @@ -329,7 +329,7 @@ xfs_inode_to_disk(
>  		to->di_flushiter = 0;
>  	} else {
>  		to->di_version = 2;
> -		to->di_flushiter = cpu_to_be16(from->di_flushiter);
> +		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
>  	}
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 663a97fa78f05f..8cc96f2766ff4f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,6 @@ struct xfs_dinode;
>   * format specific structures at the appropriate time.
>   */
>  struct xfs_icdinode {
> -	uint16_t	di_flushiter;	/* incremented on flush */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ad01e694f3ab9b..e6b40f7035aa5a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -521,7 +521,7 @@ xfs_iget_cache_miss(
>  	 * simply build the new inode core with a random generation number.
>  	 *
>  	 * For version 4 (and older) superblocks, log recovery is dependent on
> -	 * the di_flushiter field being initialised from the current on-disk
> +	 * the i_flushiter field being initialised from the current on-disk
>  	 * value and hence we must also read the inode off disk even when
>  	 * initializing new inodes.
>  	 */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f1893824cd4e2f..5e0336e0dbae44 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3765,16 +3765,15 @@ xfs_iflush_int(
>  	}
>  
>  	/*
> -	 * Inode item log recovery for v2 inodes are dependent on the
> -	 * di_flushiter count for correct sequencing. We bump the flush
> -	 * iteration count so we can detect flushes which postdate a log record
> -	 * during recovery. This is redundant as we now log every change and
> -	 * hence this can't happen but we need to still do it to ensure
> -	 * backwards compatibility with old kernels that predate logging all
> -	 * inode changes.
> +	 * Inode item log recovery for v2 inodes are dependent on the flushiter
> +	 * count for correct sequencing.  We bump the flush iteration count so
> +	 * we can detect flushes which postdate a log record during recovery.
> +	 * This is redundant as we now log every change and hence this can't
> +	 * happen but we need to still do it to ensure backwards compatibility
> +	 * with old kernels that predate logging all inode changes.
>  	 */
>  	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
> -		ip->i_d.di_flushiter++;
> +		ip->i_flushiter++;
>  
>  	/*
>  	 * If there are inline format data / attr forks attached to this inode,
> @@ -3795,8 +3794,8 @@ xfs_iflush_int(
>  	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
>  
>  	/* Wrap, we never let the log put out DI_MAX_FLUSH */
> -	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
> -		ip->i_d.di_flushiter = 0;
> +	if (ip->i_flushiter == DI_MAX_FLUSH)
> +		ip->i_flushiter = 0;
>  
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2cdb7b6b298852..581618ea1156da 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -59,6 +59,7 @@ typedef struct xfs_inode {
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
>  	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
> +	uint16_t		i_flushiter;	/* incremented on flush */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index ab0d8cf8ceb6ab..8357fe37d3eb8a 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -351,7 +351,7 @@ xfs_inode_to_log_dinode(
>  		to->di_flushiter = 0;
>  	} else {
>  		to->di_version = 2;
> -		to->di_flushiter = from->di_flushiter;
> +		to->di_flushiter = ip->i_flushiter;
>  	}
>  }
>  
> 


-- 
chandan



