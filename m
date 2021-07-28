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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB737C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 13:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99BED60EC0
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 13:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhG1Nmm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbhG1Nml (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 09:42:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8E1C061757
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 06:42:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so10112233pjb.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 06:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=0O0m2ZRYRa03nC9EEqJmZ36venICWNtxP70xn49cbxk=;
        b=tAyiWX2HE0PZim29EbkbzeiKfFgnb9SXArd0d1MAqViBQi24bz+UYgtIoIH/+xSCwB
         pZ36HFLXm3d5mS+1W4YxLU0LXU1pMUbD6r5sYlzQDOK5Nu5C/q+1Lvk8rQjP+IyEjmtE
         NwWa5s5z1qW1JA2lzgraaeg/5rehupBXVVA4oI3tQPC+SuAO1wcIx5rm4g47MNkDXZDY
         2n5ir5GLfHubrhDLZIgJ+KiIG4f79ARoItu+wBwNAOWjJrmpT/Z8w9fVk083qj14H+iv
         NOixt27yFblGKRA/21k+9+wPTOyzB3777OptQzakV1rVMlL2TTwMzSdYLGP9QmsJUzBq
         c2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=0O0m2ZRYRa03nC9EEqJmZ36venICWNtxP70xn49cbxk=;
        b=bEGjHxhRirqHzofdiwYIffhLJDgZ8pjX37kOL28NDYHQaky3x1hpJ2ti2RNATmnW79
         2sW/se8YsRBxQnBR2pPdrEheCrqtYUefzLOUxoxjt6lCYBxcWAVZUxCQg9xQYnpo46j/
         MGIR5wCU885OmDtsgatCfhNa3wjLDFpLllq5aky8yufuWtohfPvRHlZeNX+jEz/7yDnC
         4Suq1BNQS1UjLzS/dLiHh8or9WXrKrmnmacuoToF32vB2lP9twyEJweAa4Pupkwc93n2
         uB+FFwFmSjC5fOcKdCWgEXBeegL7lgXNwSmTt5fVPE5HEy1mLqi4woExLTUCZDNfRgFv
         0DEQ==
X-Gm-Message-State: AOAM530AAOEWMvzgbplzQJS/YQd3VMHiujfuRNu6o4wSVlbF2G5/Dp4a
        d6EbYpV7E0rvfnQMFBjod1h8IwWD2bogtw==
X-Google-Smtp-Source: ABdhPJzurx5aOGKI6r4NAoz4JR2u993endkLa8ngnLG/l9cj9kshtDWKV2xclbPwQM4D4kyAL2vYrw==
X-Received: by 2002:a63:134e:: with SMTP id 14mr28771445pgt.312.1627479758918;
        Wed, 28 Jul 2021 06:42:38 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id x9sm26341pfd.100.2021.07.28.06.42.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Jul 2021 06:42:38 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-6-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 05/16] xfs: Add state machine tracepoints
In-reply-to: <20210727062053.11129-6-allison.henderson@oracle.com>
Date:   Wed, 28 Jul 2021 19:12:36 +0530
Message-ID: <87v94uv9kj.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> This is a quick patch to add a new xfs_attr_*_return tracepoints.  We
> use these to track when ever a new state is set or -EAGAIN is returned
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 28 ++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_attr_remote.c |  1 +
>  fs/xfs/xfs_trace.h              | 24 ++++++++++++++++++++++++
>  3 files changed, 51 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5040fc1..b0c6c62 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -335,6 +335,7 @@ xfs_attr_sf_addname(
>  	 * the attr fork to leaf format and will restart with the leaf
>  	 * add.
>  	 */
> +	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
>  	dac->flags |= XFS_DAC_DEFER_FINISH;
>  	return -EAGAIN;
>  }
> @@ -394,6 +395,8 @@ xfs_attr_set_iter(
>  				 * handling code below
>  				 */
>  				dac->flags |= XFS_DAC_DEFER_FINISH;
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
>  				return -EAGAIN;
>  			} else if (error) {
>  				return error;
> @@ -418,6 +421,7 @@ xfs_attr_set_iter(
>  
>  			dac->dela_state = XFS_DAS_FOUND_NBLK;
>  		}
> +		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
>  		return -EAGAIN;
>  	case XFS_DAS_FOUND_LBLK:
>  		/*
> @@ -445,6 +449,8 @@ xfs_attr_set_iter(
>  			error = xfs_attr_rmtval_set_blk(dac);
>  			if (error)
>  				return error;
> +			trace_xfs_attr_set_iter_return(dac->dela_state,
> +						       args->dp);
>  			return -EAGAIN;
>  		}
>  
> @@ -479,6 +485,7 @@ xfs_attr_set_iter(
>  		 * series.
>  		 */
>  		dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  	case XFS_DAS_FLIP_LFLAG:
>  		/*
> @@ -496,6 +503,9 @@ xfs_attr_set_iter(
>  		dac->dela_state = XFS_DAS_RM_LBLK;
>  		if (args->rmtblkno) {
>  			error = __xfs_attr_rmtval_remove(dac);
> +			if (error == -EAGAIN)
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
>  			if (error)
>  				return error;

if __xfs_attr_rmtval_remove() successfully removes all the remote blocks, we
transition over to XFS_DAS_RD_LEAF state and return -EAGAIN. A tracepoint
is probably required for this as well?

>  
> @@ -549,6 +559,8 @@ xfs_attr_set_iter(
>  				error = xfs_attr_rmtval_set_blk(dac);
>  				if (error)
>  					return error;
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
>  				return -EAGAIN;
>  			}
>  
> @@ -584,6 +596,7 @@ xfs_attr_set_iter(
>  		 * series
>  		 */
>  		dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  
>  	case XFS_DAS_FLIP_NFLAG:
> @@ -603,6 +616,10 @@ xfs_attr_set_iter(
>  		dac->dela_state = XFS_DAS_RM_NBLK;
>  		if (args->rmtblkno) {
>  			error = __xfs_attr_rmtval_remove(dac);
> +			if (error == -EAGAIN)
> +				trace_xfs_attr_set_iter_return(
> +					dac->dela_state, args->dp);
> +
>  			if (error)
>  				return error;

A transition to XFS_DAS_CLR_FLAG state probably requires a tracepoint call.

>  
> @@ -1183,6 +1200,8 @@ xfs_attr_node_addname(
>  			 * this point.
>  			 */
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			trace_xfs_attr_node_addname_return(
> +					dac->dela_state, args->dp);
>  			return -EAGAIN;
>  		}
>  
> @@ -1429,10 +1448,13 @@ xfs_attr_remove_iter(
>  			 * blocks are removed.
>  			 */
>  			error = __xfs_attr_rmtval_remove(dac);
> -			if (error == -EAGAIN)
> +			if (error == -EAGAIN) {
> +				trace_xfs_attr_remove_iter_return(
> +						dac->dela_state, args->dp);
>  				return error;
> -			else if (error)
> +			} else if (error) {
>  				goto out;
> +			}
>

if the call to __xfs_attr_rmtval_remove() is successful, we transition over to
XFS_DAS_RM_NAME state and return -EAGAIN. Maybe tracepoint is required here as
well?

>  			/*
>  			 * Refill the state structure with buffers (the prior
> @@ -1473,6 +1495,8 @@ xfs_attr_remove_iter(
>  
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			dac->dela_state = XFS_DAS_RM_SHRINK;
> +			trace_xfs_attr_remove_iter_return(
> +					dac->dela_state, args->dp);
>  			return -EAGAIN;
>  		}
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 0c8bee3..70f880d 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -696,6 +696,7 @@ __xfs_attr_rmtval_remove(
>  	 */
>  	if (!done) {
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>  		return -EAGAIN;
>  	}
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f9d8d60..f9840dd 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3987,6 +3987,30 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
>  DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
>  DEFINE_ICLOG_EVENT(xlog_iclog_write);
>  
> +DECLARE_EVENT_CLASS(xfs_das_state_class,
> +	TP_PROTO(int das, struct xfs_inode *ip),
> +	TP_ARGS(das, ip),
> +	TP_STRUCT__entry(
> +		__field(int, das)
> +		__field(xfs_ino_t, ino)
> +	),
> +	TP_fast_assign(
> +		__entry->das = das;
> +		__entry->ino = ip->i_ino;
> +	),
> +	TP_printk("state change %d ino 0x%llx",
> +		  __entry->das, __entry->ino)
> +)
> +
> +#define DEFINE_DAS_STATE_EVENT(name) \
> +DEFINE_EVENT(xfs_das_state_class, name, \
> +	TP_PROTO(int das, struct xfs_inode *ip), \
> +	TP_ARGS(das, ip))
> +DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH


-- 
chandan
