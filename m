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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFED9C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 14:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D66A560E98
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 14:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhH3OSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 10:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237093AbhH3OSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 10:18:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62F8C061575
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 07:17:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bg1so3329877plb.13
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 07:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=fh8Ie8IHyv5Uqd83TFeQS1BX0weoKgGqDLg5QteoWXY=;
        b=k7Yr22AYwYtm9gio4fw7UbpsJSRUAOUzKM9d0h4d0xVgREFzfdFfZL2XL9K9qe8F5e
         2hUR7R3ccRnC6gRupOv1T7tcPPdNb/5KVa69lTIEmhgXU3YQAayY2LOKWMixx5cR19lX
         teFOMUoaByyn1mfLSt+UMYGLTTigwkiBoPmqT5yR+HG4uz8b+CbIBv0hhsC5n7RvFinn
         zZvmzOAYmH5NmwofHsZzO27Tq7gK4USZScjVqKabb4oUWaAnealnnTwXup2S6pHDBIPJ
         0JFdaQFTzL8/m+O2B8nWz9fQbq6nloN9W/hE/ae7RHeSCqH7SUvRmVSRqxazni4ftwLz
         k9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=fh8Ie8IHyv5Uqd83TFeQS1BX0weoKgGqDLg5QteoWXY=;
        b=tDlTX4fHa3QoCOpOBSfx1quxhUIgX7TU1pnf8CqgdynWQQIghIbZnjOCVPQnEsn2b7
         bunxre4P32Vp2CFfSTZfIXeYybm6Cgg+Z/zqDKRIQJOmS5Qfk3pf8UkfoXc5Ok/73jmb
         Yh4z4Z/fKpEefuf4XJxP3KTccdszbhbE2tUqEHPRQL6sOePOnK8cBMCoYf4vqN1yi01X
         uAA6kH8HyfyfDnp6P6EJ/Cj58q/+zzw4Rr3lxoADPhu7jZc0AoBWl/np5p6IZeKdmsgS
         dVbEuGhybsRhYYKetdJ5PlLIb/CvnbtBNrl44ZeOTr1LUDY/DE1pR/FSYeKLKTS6ej+x
         DJ/g==
X-Gm-Message-State: AOAM530M6znQ8It6uHLEe5tDWlnVVvdainKL2yP4zMrCxtganT8I5k0n
        /Axwj/IYPzT155vRDLokRGVRTe08xJA=
X-Google-Smtp-Source: ABdhPJyo4HQcwVInUqWsn2c88YEHXOBqAsvvrT4QYM/Nc2jc2Q7yKyD8X7uSrimUBqN6VGxzXrRq0g==
X-Received: by 2002:a17:90b:384a:: with SMTP id nl10mr39745681pjb.65.1630333075034;
        Mon, 30 Aug 2021 07:17:55 -0700 (PDT)
Received: from garuda ([122.171.149.36])
        by smtp.gmail.com with ESMTPSA id j16sm15559644pfi.165.2021.08.30.07.17.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Aug 2021 07:17:54 -0700 (PDT)
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-12-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 11/11] xfs: Add helper function xfs_attr_leaf_addname
In-reply-to: <20210824224434.968720-12-allison.henderson@oracle.com>
Message-ID: <8735qr9fu9.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 30 Aug 2021 19:47:50 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Aug 2021 at 04:14, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_leaf_addname.  While this
> does help to break down xfs_attr_set_iter, it does also hoist out some
> of the state management.  This patch has been moved to the end of the
> clean up series for further discussion.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
>  fs/xfs/xfs_trace.h       |   1 +
>  2 files changed, 61 insertions(+), 50 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c3fdf232cd51..7150f0e051a0 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -284,6 +284,65 @@ xfs_attr_sf_addname(
>  	return -EAGAIN;
>  }
>  
> +STATIC int
> +xfs_attr_leaf_addname(
> +	struct xfs_attr_item	*attr)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +	struct xfs_inode	*dp = args->dp;
> +	int			error;
> +
> +	if (xfs_attr_is_leaf(dp)) {
> +		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
> +		if (error == -ENOSPC) {
> +			error = xfs_attr3_leaf_to_node(args);
> +			if (error)
> +				return error;
> +
> +			/*
> +			 * Finish any deferred work items and roll the
> +			 * transaction once more.  The goal here is to call
> +			 * node_addname with the inode and transaction in the
> +			 * same state (inode locked and joined, transaction
> +			 * clean) no matter how we got to this step.
> +			 *
> +			 * At this point, we are still in XFS_DAS_UNINIT, but
> +			 * when we come back, we'll be a node, so we'll fall
> +			 * down into the node handling code below
> +			 */
> +			trace_xfs_attr_set_iter_return(
> +				attr->xattri_dela_state, args->dp);
> +			return -EAGAIN;
> +		}
> +
> +		if (error)
> +			return error;
> +
> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> +	} else {
> +		error = xfs_attr_node_addname_find_attr(attr);
> +		if (error)
> +			return error;
> +
> +		error = xfs_attr_node_addname(attr);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * If addname was successful, and we dont need to alloc or
> +		 * remove anymore blks, we're done.
> +		 */
> +		if (!args->rmtblkno &&
> +		    !(args->op_flags & XFS_DA_OP_RENAME))
> +			return 0;
> +
> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +	}
> +
> +	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
> +	return -EAGAIN;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may return
> @@ -319,57 +378,8 @@ xfs_attr_set_iter(
>  			attr->xattri_leaf_bp = NULL;
>  		}
>  
> -		if (xfs_attr_is_leaf(dp)) {
> -			error = xfs_attr_leaf_try_add(args,
> -						      attr->xattri_leaf_bp);
> -			if (error == -ENOSPC) {
> -				error = xfs_attr3_leaf_to_node(args);
> -				if (error)
> -					return error;
> -
> -				/*
> -				 * Finish any deferred work items and roll the
> -				 * transaction once more.  The goal here is to
> -				 * call node_addname with the inode and
> -				 * transaction in the same state (inode locked
> -				 * and joined, transaction clean) no matter how
> -				 * we got to this step.
> -				 *
> -				 * At this point, we are still in
> -				 * XFS_DAS_UNINIT, but when we come back, we'll
> -				 * be a node, so we'll fall down into the node
> -				 * handling code below
> -				 */
> -				trace_xfs_attr_set_iter_return(
> -					attr->xattri_dela_state, args->dp);
> -				return -EAGAIN;
> -			} else if (error) {
> -				return error;
> -			}
> -
> -			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> -		} else {
> -			error = xfs_attr_node_addname_find_attr(attr);
> -			if (error)
> -				return error;
> +		return xfs_attr_leaf_addname(attr);
>  
> -			error = xfs_attr_node_addname(attr);
> -			if (error)
> -				return error;
> -
> -			/*
> -			 * If addname was successful, and we dont need to alloc
> -			 * or remove anymore blks, we're done.
> -			 */
> -			if (!args->rmtblkno &&
> -			    !(args->op_flags & XFS_DA_OP_RENAME))
> -				return 0;
> -
> -			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> -		}
> -		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> -					       args->dp);
> -		return -EAGAIN;
>  	case XFS_DAS_FOUND_LBLK:
>  		/*
>  		 * If there was an out-of-line value, allocate the blocks we
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 1033a95fbf8e..77a78b5b1a29 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4132,6 +4132,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
>  	TP_ARGS(das, ip))
>  DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);


-- 
chandan
