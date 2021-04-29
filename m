Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36765C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 07:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 028A161441
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 07:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhD2Hlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 03:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbhD2Hlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 03:41:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61629C06138B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:40:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id i14so2037204pgk.5
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=7jaeX3D28dJ0L+RSgBGy+CaIIMQn6MypaDnA9wqqQow=;
        b=iitN9QU2XNFo7LOKiFEQcanXAlsNtYLSKOmyN37JdrKsSsTqfVS/tOPS7TNULRgVZK
         9z4iL5QHld4zcVIWy0WjEglsFblnlvgfPTlCBUcviMXxycxo0EF/5UhprkuojwEG81q8
         94RwCO/PAktbhr5R8N/uLgvBuIWpcsFe4YUo52eCZRU6dUa2+im9ZeRASZYHT+/8C5N0
         emYv/LtVFXuzYpuBK/wBfCLLjrjdS4SLDqV1oZogiAKRW0NiRpiPZcItT3TysQTma5OU
         r2M0Dnm3Yga9eWK4wC2I15wTjslbQPnSzRw/s+WL3yuqlYh+bf+cRWB1cheiK8gzKb/z
         F7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=7jaeX3D28dJ0L+RSgBGy+CaIIMQn6MypaDnA9wqqQow=;
        b=g0KB+S2RM7nL4BLRb94mzvmn7XPqOw546mSx5bv/0ROk4SvdK8qWuA7RZYKa6RWrQg
         aDKPfRETTQUKI05yraVvMXOEVrzDAHN08Rs1QVTuR3pIFPzGbtvD9r4vMkIRHxXKGWds
         R8+rBQt92QyLJXZuhU7/Ma5vXIrRA7hNM4eqZ3C8dSCcyTEJopvbnEDxVH/Kq4OvyYWo
         OWFwoKL33DZsGftvLvaqSH/E9tO5ob6vNj7F/nGaoJI8yY/0c5vxGLO4/uTzMdnHvXsS
         XEqMvXl+dVGMnI83rPN0Iq/dEPwADz4s5CMo6T+n0VtHTaDWrW2Lzp6F56Hpcx6dDCDn
         ZTdg==
X-Gm-Message-State: AOAM530u+HBB+I20cPg35KwaIDsFuPCMTpxLUG/z02QWULceietNfTIs
        K9DrYX2kS/4QdSqTOYU+OW6vRt3uk0c=
X-Google-Smtp-Source: ABdhPJwAC60+mtiuGlf4x7hDhz9sYOLCmT0Tqc1DGWCNU5Q5a1Tdt0DCsQTQRh2fzacVkWBw/gohsQ==
X-Received: by 2002:aa7:91d4:0:b029:25a:d5bb:7671 with SMTP id z20-20020aa791d40000b029025ad5bb7671mr31390525pfa.65.1619682031679;
        Thu, 29 Apr 2021 00:40:31 -0700 (PDT)
Received: from garuda ([122.179.68.135])
        by smtp.gmail.com with ESMTPSA id b5sm1838105pgb.0.2021.04.29.00.40.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Apr 2021 00:40:31 -0700 (PDT)
References: <20210428080919.20331-1-allison.henderson@oracle.com> <20210428080919.20331-6-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v18 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
In-reply-to: <20210428080919.20331-6-allison.henderson@oracle.com>
Date:   Thu, 29 Apr 2021 13:10:28 +0530
Message-ID: <87im45a68j.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Apr 2021 at 13:39, Allison Henderson wrote:
> This patch separate xfs_attr_node_addname into two functions.  This will
> help to make it easier to hoist parts of xfs_attr_node_addname that need
> state management
>

Error handling seems to be correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1a618a2..5cf2e71 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> @@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
>  			return error;
>  	}
>  
> +	error = xfs_attr_node_addname_clear_incomplete(args);
> +	if (error)
> +		goto out;
> +	retval = 0;
> +out:
> +	if (state)
> +		xfs_da_state_free(state);
> +	if (error)
> +		return error;
> +	return retval;
> +}
> +
> +
> +STATIC
> +int xfs_attr_node_addname_clear_incomplete(
> +	struct xfs_da_args		*args)
> +{
> +	struct xfs_da_state		*state = NULL;
> +	struct xfs_da_state_blk		*blk;
> +	int				retval = 0;
> +	int				error = 0;
> +
>  	/*
>  	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>  	 * flag means that we will find the "old" attr, not the "new" one.


-- 
chandan
