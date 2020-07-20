Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F6FC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2189820758
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 05:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNPFbDWv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgGTFia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 01:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGTFia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 01:38:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66168C0619D2
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w17so8142547ply.11
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2020 22:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHavFBz4lVXGlWJKgvN9JTdGbCfJxIJEYuUbcHITUTc=;
        b=UNPFbDWvuYv48qr8FEB31Xx2VAEWTYgdVdJYzKTZBBXecUxfIeeIW9eCkljARP5n4N
         GNz+wj4VRQ6iNXepdojv8GgZ/CmqjGelMZkHcvjc4tAJiwRmH22LEokYrjAFAzfHVyR7
         6A7B47dVGoOqXkWCImdO998cLwTayt7MhDa0IMasAnHlMxI67i2goLWQkw9Wpmdwbl7V
         ecMcVzF/UuiW1e6Hyz5/b8LBgmOKEXEyg0l3Xu8Zw4QPNvuiQIL0A/jPn6PsRFRhS/Tu
         Xv73/Uem+IZwotr/HuOpcPcuinh9NRVREPtclTHNwF4CxXiMwqpnZVgmIpEUXlysTQeI
         1llA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHavFBz4lVXGlWJKgvN9JTdGbCfJxIJEYuUbcHITUTc=;
        b=TsfHPRDTvmJz+b2joivRPoimcWGysDX3NjVyO0voG+UkRvnU7pd31wkDNiGCLUo6/s
         K61Z7cP4DR/SPicBkR7GuyFGj5/MLuO3TugC9r0DclsIXrU1tiZqMVpY7+zkpm1Q7pUb
         NE0qu9n3aRVzZZuM+QFoXH8Q0S4qIjsi0h10KpzRLXYG/eZHD7SoS96oqobTOjaSQKUg
         IOwZKHR5WS2pD2LuaabVHDgtAPw0gMI+4t47meJfSYvGtH/dJNq1MHdi/uPQp+nfZ+B7
         JwSFY8XaA5pGr3l8O90/yfIobusc3CR+EOX7sLSn+zkvH5MNV5ZM5n8jnqcz2p7fAzPX
         yakw==
X-Gm-Message-State: AOAM533MBcNYnEqUsFG5quRKfm0fxihGurwtA7d4UhXTL0GWxdz8MkC6
        afqnj0GLIBrSZRrMW02dIOk=
X-Google-Smtp-Source: ABdhPJwesGDBXJ1B/kUk1bQLVnTu0epUo4ALVCDdUyX/CLViGKUTq7zjlu7oTj9pDT4MbCHGYgR0yA==
X-Received: by 2002:a17:90b:4ace:: with SMTP id mh14mr21892881pjb.139.1595223509994;
        Sun, 19 Jul 2020 22:38:29 -0700 (PDT)
Received: from garuda.localnet ([122.171.166.148])
        by smtp.gmail.com with ESMTPSA id d12sm15375520pfh.196.2020.07.19.22.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 22:38:29 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/26] xfs: stop using q_core.d_flags in the quota code
Date:   Mon, 20 Jul 2020 11:07:55 +0530
Message-ID: <2350111.MRUA8jnVdy@garuda>
In-Reply-To: <159477790082.3263162.2486913704651505901.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477790082.3263162.2486913704651505901.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:21:40 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the incore dq_flags to figure out the dquot type.  This is the first
> step towards removing xfs_disk_dquot from the incore dquot.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_dquot.c      |   34 ++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_dquot.h      |    2 ++
>  fs/xfs/xfs_dquot_item.c |    6 ++++--
>  3 files changed, 38 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 6fcea0d3989e..93b5b7277cb8 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -568,6 +568,15 @@ xfs_dquot_from_disk(
>  	return 0;
>  }
>  
> +/* Copy the in-core quota fields into the on-disk buffer. */
> +void
> +xfs_dquot_to_disk(
> +	struct xfs_disk_dquot	*ddqp,
> +	struct xfs_dquot	*dqp)
> +{
> +	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> +}
> +
>  /* Allocate and initialize the dquot buffer for this in-core dquot. */
>  static int
>  xfs_qm_dqread_alloc(
> @@ -1122,6 +1131,19 @@ xfs_dquot_done(
>  	}
>  }
>  
> +/* Check incore dquot for errors before we flush. */
> +static xfs_failaddr_t
> +xfs_qm_dqflush_check(
> +	struct xfs_dquot	*dqp)
> +{
> +	if (dqp->q_type != XFS_DQTYPE_USER &&
> +	    dqp->q_type != XFS_DQTYPE_GROUP &&
> +	    dqp->q_type != XFS_DQTYPE_PROJ)
> +		return __this_address;
> +
> +	return NULL;
> +}
> +
>  /*
>   * Write a modified dquot to disk.
>   * The dquot must be locked and the flush lock too taken by caller.
> @@ -1180,8 +1202,16 @@ xfs_qm_dqflush(
>  		goto out_abort;
>  	}
>  
> -	/* This is the only portion of data that needs to persist */
> -	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> +	fa = xfs_qm_dqflush_check(dqp);
> +	if (fa) {
> +		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> +				be32_to_cpu(dqp->q_core.d_id), fa);
> +		xfs_buf_relse(bp);
> +		error = -EFSCORRUPTED;
> +		goto out_abort;
> +	}
> +
> +	xfs_dquot_to_disk(ddqp, dqp);
>  
>  	/*
>  	 * Clear the dirty field and remember the flush lsn for later use.
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 7f3f734bced8..84399d1d8188 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -151,6 +151,8 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
>  	return false;
>  }
>  
> +void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
> +
>  #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
>  #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
>  #define XFS_QM_ISUDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_USER)
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index d7e4de7151d7..fc21e48c889c 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -45,6 +45,7 @@ xfs_qm_dquot_logitem_format(
>  	struct xfs_log_item	*lip,
>  	struct xfs_log_vec	*lv)
>  {
> +	struct xfs_disk_dquot	ddq;
>  	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
>  	struct xfs_log_iovec	*vecp = NULL;
>  	struct xfs_dq_logformat	*qlf;
> @@ -58,8 +59,9 @@ xfs_qm_dquot_logitem_format(
>  	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
>  	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_dq_logformat));
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT,
> -			&qlip->qli_dquot->q_core,
> +	xfs_dquot_to_disk(&ddq, qlip->qli_dquot);
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT, &ddq,
>  			sizeof(struct xfs_disk_dquot));
>  }
>  
> 
> 


-- 
chandan



