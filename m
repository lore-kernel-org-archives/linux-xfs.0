Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83A6C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 04:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7960C229C9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 04:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbhAEEvm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 23:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbhAEEvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 23:51:41 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBE3C061574
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 20:51:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so15709677plp.8
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 20:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AZAh0Q57Fa9cg8jZ/6FNkWXJ0IlXU3XPZY2tO66aN4Y=;
        b=FwQTsmMJol++IPZzxC8FsmtYQY3OnUyM18auvbCEprDck5qpGdyh6rvZKzBuhzwbua
         IEUGkV9H9WR0kA7JM3UdcugKbu5+jee/19K1kUGX9Mhhu6wONJQv65qm0tdnjGU3GtLf
         44S1Ven6rJp90mmrEDBojfTfZMuiJNS3Pt3w7xNsPgAnDA3fZ6UfmNirGw60ZNgKtFOG
         J/kBZ5r+fiw9Dx9TjGpwXS2yBWpPVgsZU736ZGr6huL+RiEvDTYo9u/ui6WXZRM2kCt4
         MOmUahvHVu9+FmT9/C9hihlvKQ4dQ8IiGBP5C5mQXzGZ1VzRvZ22g7SGAFJXam746aS/
         nQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AZAh0Q57Fa9cg8jZ/6FNkWXJ0IlXU3XPZY2tO66aN4Y=;
        b=SqKPf5pKuuj8fuejXwSt2y//MZwExhgbgpOaUTb8W+r3vowdnOfXVDZSAgzQ+ycqhx
         CSwzTO31elGarGw+OLGZRd7FR59got9IeiP6Sls2fo/l5AWweD+35WFd8PMRrWeRs5j6
         MuiL7N9XNjFYtTtqXvq9fz8zKK5OEUcDHJ8npH8A/Yasv7KMzWJnoKfrUvoFDv7wpD0N
         c2shVYwzMibq2lcfWRwHmodz6bqM2l8cUX71eWBIUXyoT7X7BMuwSaXp5JrXVccoJW5q
         iYVyXQSBEy16G9Iu9ICvas20ODPAO8o33sG74wO/ZNgfvboF7mzL57iBTcTy0CeZyS0g
         IIkw==
X-Gm-Message-State: AOAM533voR0/T2oqZDywsQh6KMZxqiEJOwXfk5f0wazZxfTAOWRvXI8t
        Ply0T5cHZk0V4ekZlKaaQD1B/caUJO8=
X-Google-Smtp-Source: ABdhPJx6UMi3VGvLJGkcUmr3E/D/iHQG6qRd9uHX22hSzr/vdoSOrohvrrVTsBE0H2h06NKz80Hwew==
X-Received: by 2002:a17:90b:1987:: with SMTP id mv7mr2327170pjb.66.1609822261014;
        Mon, 04 Jan 2021 20:51:01 -0800 (PST)
Received: from garuda.localnet ([122.167.39.36])
        by smtp.gmail.com with ESMTPSA id s29sm64547788pgn.65.2021.01.04.20.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 20:51:00 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 06/15] xfs: Add state machine tracepoints
Date:   Tue, 05 Jan 2021 10:20:57 +0530
Message-ID: <4353133.qTs6tMSDRZ@garuda>
In-Reply-To: <20201218072917.16805-7-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com> <20201218072917.16805-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 18 Dec 2020 00:29:08 -0700, Allison Henderson wrote:
> This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
> use this to track when ever a new state is set or -EAGAIN is returned
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 22 +++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |  1 +
>  fs/xfs/xfs_trace.h              | 20 ++++++++++++++++++++
>  3 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index cd72512..8ed00bc 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -263,6 +263,7 @@ xfs_attr_set_shortform(
>  	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
>  	 * fork to leaf format and will restart with the leaf add.
>  	 */
> +	trace_xfs_das_state_return(XFS_DAS_UNINIT);
>  	return -EAGAIN;
>  }
>  
> @@ -409,9 +410,11 @@ xfs_attr_set_iter(
>  		 * down into the node handling code below
>  		 */
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return -EAGAIN;
>  	case 0:
>  		dac->dela_state = XFS_DAS_FOUND_LBLK;
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return -EAGAIN;
>  	}
>  	return error;
> @@ -841,6 +844,7 @@ xfs_attr_leaf_addname(
>  			return error;
>  
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return -EAGAIN;
>  	}
>  
> @@ -874,6 +878,7 @@ xfs_attr_leaf_addname(
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
>  	dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +	trace_xfs_das_state_return(dac->dela_state);
>  	return -EAGAIN;
>  das_flip_flag:
>  	/*
> @@ -891,6 +896,8 @@ xfs_attr_leaf_addname(
>  das_rm_lblk:
>  	if (args->rmtblkno) {
>  		error = __xfs_attr_rmtval_remove(dac);
> +		if (error == -EAGAIN)
> +			trace_xfs_das_state_return(dac->dela_state);
>  		if (error)
>  			return error;
>  	}
> @@ -1142,6 +1149,7 @@ xfs_attr_node_addname(
>  			 * this point.
>  			 */
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			trace_xfs_das_state_return(dac->dela_state);
>  			return -EAGAIN;
>  		}
>  
> @@ -1175,6 +1183,7 @@ xfs_attr_node_addname(
>  	state = NULL;
>  
>  	dac->dela_state = XFS_DAS_FOUND_NBLK;
> +	trace_xfs_das_state_return(dac->dela_state);
>  	return -EAGAIN;
>  das_found_nblk:
>  
> @@ -1202,6 +1211,7 @@ xfs_attr_node_addname(
>  				return error;
>  
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			trace_xfs_das_state_return(dac->dela_state);
>  			return -EAGAIN;
>  		}
>  
> @@ -1236,6 +1246,7 @@ xfs_attr_node_addname(
>  	 * Commit the flag value change and start the next trans in series
>  	 */
>  	dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +	trace_xfs_das_state_return(dac->dela_state);
>  	return -EAGAIN;
>  das_flip_flag:
>  	/*
> @@ -1253,6 +1264,10 @@ xfs_attr_node_addname(
>  das_rm_nblk:
>  	if (args->rmtblkno) {
>  		error = __xfs_attr_rmtval_remove(dac);
> +
> +		if (error == -EAGAIN)
> +			trace_xfs_das_state_return(dac->dela_state);
> +
>  		if (error)
>  			return error;
>  	}
> @@ -1396,6 +1411,8 @@ xfs_attr_node_remove_rmt (
>  	 * May return -EAGAIN to request that the caller recall this function
>  	 */
>  	error = __xfs_attr_rmtval_remove(dac);
> +	if (error == -EAGAIN)
> +		trace_xfs_das_state_return(dac->dela_state);
>  	if (error)
>  		return error;
>  
> @@ -1514,6 +1531,7 @@ xfs_attr_node_removename_iter(
>  
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			dac->dela_state = XFS_DAS_RM_SHRINK;
> +			trace_xfs_das_state_return(dac->dela_state);
>  			return -EAGAIN;
>  		}
>  
> @@ -1532,8 +1550,10 @@ xfs_attr_node_removename_iter(
>  		goto out;
>  	}
>  
> -	if (error == -EAGAIN)
> +	if (error == -EAGAIN) {
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return error;
> +	}
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 6af86bf..4840de9 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -763,6 +763,7 @@ __xfs_attr_rmtval_remove(
>  	 */
>  	if (!done) {
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return -EAGAIN;
>  	}
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9074b8b..4f6939b4 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3887,6 +3887,26 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
>  DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
>  DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
>  
> +
> +DECLARE_EVENT_CLASS(xfs_das_state_class,
> +	TP_PROTO(int das),
> +	TP_ARGS(das),
> +	TP_STRUCT__entry(
> +		__field(int, das)
> +	),
> +	TP_fast_assign(
> +		__entry->das = das;
> +	),
> +	TP_printk("state change %d",
> +		  __entry->das)
> +)
> +
> +#define DEFINE_DAS_STATE_EVENT(name) \
> +DEFINE_EVENT(xfs_das_state_class, name, \
> +	TP_PROTO(int das), \
> +	TP_ARGS(das))
> +DEFINE_DAS_STATE_EVENT(xfs_das_state_return);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 


-- 
chandan



