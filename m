Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B5AC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 03:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D0260BD3
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 03:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhHBD1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 23:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhHBD1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 23:27:15 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FE8C06175F
        for <linux-xfs@vger.kernel.org>; Sun,  1 Aug 2021 20:27:06 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u16so9591511ple.2
        for <linux-xfs@vger.kernel.org>; Sun, 01 Aug 2021 20:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=n8pHZwJMvaunt3vjmGkjK0wb5HSBQFaZeLHBqclFZIs=;
        b=GZUu9AiPc4ggZfhrDZKgJbPFSNaK5xTytQqPDXxUUU3sAbEQtu25KyWSc1CUsVWSSM
         Ez6LpTw9hP1NGsoJyv5tRTehj1oxMAuVGs8my0W/yaPLWNehxiyf+Y287cPIpJeAaf26
         UOQ6YLuu8R6PyjzeH0RSIWadhNy/fufgXM8gMk+nDZBL3R07zx+9XB2cb48Dnv5YqJfc
         cMPM609zSvGAGT6EFaePRcW7waaUoXzJLe+4P/mEW2p6LY0uctChYxuUuX6cvBy1q7Qw
         6qSEcqSAaLboVDqWBUE3d/jLf678/xq85ipVt80E8xvHKxByPmtH/kAIpLo7guR9kgmE
         ddPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=n8pHZwJMvaunt3vjmGkjK0wb5HSBQFaZeLHBqclFZIs=;
        b=Mhe0c+m3KoRhtETwa/FxtS+Na7e+ROJWR8tdPpVeh3tLeENXM8HTmZnXsJgpmSFNhh
         RD16oHWqdT0i1EF80Z3GEfaEKo8uZ/Nd2WE95YiAz1UhoDdBsTK0R41M1R0eWGw/DbLm
         0OWzcLIN2dxeLORcwkpu5yUoJgWwtsnZL4NtD7IAUiFyIXrY8Dj+mMU1XXcrx3pEOnCI
         /8/29epApf+Kc5+rVkd/X0qOaBFagtgEj0rBCeaqmMDFJzvoXqJC0fkNQ2XHh3gXFPIZ
         klN1bhRB7rbWAv/AdI3NFzMAoq2dpURgjYfVAlJnZ06al65iUpEHT3Gy1i8wShHqeYi0
         QEYA==
X-Gm-Message-State: AOAM531BbCp0BrSyWCfiYqyafvquBC6ZI2jgScETJRlA4Kl2pqaXGgjE
        1PUDSOxSVxbULUOlH6oDKlDAkV74uaB69Q==
X-Google-Smtp-Source: ABdhPJzALJuC1lRShszD18xo1SzzokxvFvouq/XQnFla9vSuUo70aJujb/aes1jesefWO9CTpdsu2Q==
X-Received: by 2002:a17:90a:c206:: with SMTP id e6mr15513229pjt.159.1627874826136;
        Sun, 01 Aug 2021 20:27:06 -0700 (PDT)
Received: from garuda ([122.172.177.63])
        by smtp.gmail.com with ESMTPSA id n123sm10964304pga.69.2021.08.01.20.27.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 01 Aug 2021 20:27:05 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-14-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 13/16] xfs: Add delayed attributes error tag
In-reply-to: <20210727062053.11129-14-allison.henderson@oracle.com>
Date:   Mon, 02 Aug 2021 08:57:03 +0530
Message-ID: <871r7co7aw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> This patch adds an error tag that we can use to test delayed attribute
> recovery and replay
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_attr_item.c       | 7 +++++++
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index a23a52e..46f359c 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -59,7 +59,8 @@
>  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
> -#define XFS_ERRTAG_MAX					39
> +#define XFS_ERRTAG_DELAYED_ATTR				39
> +#define XFS_ERRTAG_MAX					40
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -103,5 +104,6 @@
>  #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
>  #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>  #define XFS_RANDOM_AG_RESV_FAIL				1
> +#define XFS_RANDOM_DELAYED_ATTR				1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 12a0151..2efd94f 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -34,6 +34,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
>  #include "xfs_trans_space.h"
> +#include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> @@ -296,6 +297,11 @@ xfs_trans_attr_finish_update(
>  	if (error)
>  		return error;
>  
> +	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> @@ -310,6 +316,7 @@ xfs_trans_attr_finish_update(
>  		break;
>  	}
>  
> +out:
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index ce3bc1b..eca5e34 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
>  	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>  	XFS_RANDOM_AG_RESV_FAIL,
> +	XFS_RANDOM_DELAYED_ATTR,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -170,6 +171,7 @@ XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
> +XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -211,6 +213,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
>  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
> +	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
>  	NULL,
>  };


-- 
chandan
