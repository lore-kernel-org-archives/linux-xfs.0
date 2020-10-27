Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE78C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 07:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6697521655
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 07:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/wjeBVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387705AbgJ0HDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 03:03:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36366 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409081AbgJ0HDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 03:03:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id z24so248544pgk.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2020 00:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cBgC0Ia3/Jtp0rg6CIbU/SNzFFyueoyWvAjfsCoclbI=;
        b=E/wjeBVx+tXbDsvU8fhKIVROfBd5+jlTKvDTcI+5ez1mxNiqPMNenP+gIoGphHIj7y
         O5qA7MRaBa3j1CAeixeiZDz416I+KYgJIASxvDFz6xvvSAVIWurbVbcZ58ExFbtLP3u6
         sWIG63tgkeWC4H1KU6zSfbomUU/+aBr+vEZ4rbfIoWxxSNgcE2NECKEvzbTuRWp1exuN
         /xwgUh63YUEK4R70tv4WxnbThsFucUMDXhUooXMlisW4j1AWLo8Evv0/9JfsjIy+MWBT
         TbVR74x/raGigoQNGEKz29izzABbAgldok5vq0WmtWQvvDFQN1zoWtv6NmCB4aLX8gW+
         hj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cBgC0Ia3/Jtp0rg6CIbU/SNzFFyueoyWvAjfsCoclbI=;
        b=cnixM01WgsbrV/CVxQX1AUEjsrPw4icpbFEPTc6Pcm/2OG6OWPwScoiTCz71O2i2aN
         jeJwHsj/zFHaGsSabJ7RWQHKvdzNl3kLPdoWS4YzkortvKIrW6juC/vbCMPSyrsRRMpP
         t5iMlhfzoBP5lRF0/Mgj0pPEO9tB6m7d707/f9KQLT6q843R1bKz8R0EUJt707uGr6+c
         iZV8CYT53MVV0Y2WTGrFZ3l2o5cw6tEpx1n1bnN35iLQR4KvkyvMDoxmnC2Z57igSt1j
         +xoZwgAIP5ErMO+ZzVJHi133o/zhIB9CHNFDaMcHjK8YJ6auVviQqo4Lb5AIik6vX4tA
         ifAg==
X-Gm-Message-State: AOAM533P0zvXvV2v5e8uvf17z8s+rpLm1caaUI9kZRIIAJ+uaYcdP2zA
        WlI3DmxHUOKRMOm9l+pE9f1qb7xQ+Yw=
X-Google-Smtp-Source: ABdhPJwWRAZwb8r+i3Jo7NfwwoOATiFkf19+zpVJrg553MML1R7pu3FWCJw76rQTEOYaOkpW8vMVKw==
X-Received: by 2002:aa7:96f6:0:b029:164:2def:5ef7 with SMTP id i22-20020aa796f60000b02901642def5ef7mr1009232pfq.44.1603782203518;
        Tue, 27 Oct 2020 00:03:23 -0700 (PDT)
Received: from garuda.localnet ([122.179.70.119])
        by smtp.gmail.com with ESMTPSA id nm4sm863332pjb.44.2020.10.27.00.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 00:03:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 01/10] xfs: Add helper xfs_attr_node_remove_step
Date:   Tue, 27 Oct 2020 12:33:19 +0530
Message-ID: <2702981.IminquKMG5@garuda>
In-Reply-To: <20201023063435.7510-2-allison.henderson@oracle.com>
References: <20201023063435.7510-1-allison.henderson@oracle.com> <20201023063435.7510-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 23 October 2020 12:04:26 PM IST Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> This patch adds a new helper function xfs_attr_node_remove_step.  This
> will help simplify and modularize the calling function
> xfs_attr_node_remove.

The above should have been "xfs_attr_node_removename".

The code changes themselves are logically correct.
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e641..f4d39bf 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
>   * the root node (a special case of an intermediate node).
>   */
>  STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +xfs_attr_node_remove_step(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
>  {
> -	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
> -	trace_xfs_attr_node_removename(args);
> -
> -	error = xfs_attr_node_removename_setup(args, &state);
> -	if (error)
> -		goto out;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
>  	if (args->rmtblkno > 0) {
>  		error = xfs_attr_node_remove_rmt(args, state);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
>  	/*
> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>  	if (retval && (state->path.active > 1)) {
>  		error = xfs_da3_join(state);
>  		if (error)
> -			goto out;
> +			return error;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out;
> +			return error;
>  		/*
>  		 * Commit the Btree join operation and start a new trans.
>  		 */
>  		error = xfs_trans_roll_inode(&args->trans, dp);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
> +	return error;
> +}
> +
> +/*
> + * Remove a name from a B-tree attribute list.
> + *
> + * This routine will find the blocks of the name to remove, remove them and
> + * shirnk the tree if needed.
> + */
> +STATIC int
> +xfs_attr_node_removename(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state;
> +	int			error;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_node_removename(args);
> +
> +	error = xfs_attr_node_removename_setup(args, &state);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_attr_node_remove_step(args, state);
> +	if (error)
> +		goto out;
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> 


-- 
chandan



