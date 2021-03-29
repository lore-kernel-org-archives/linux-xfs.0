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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB58C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 14:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD806195B
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 14:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhC2OmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 10:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhC2OmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 10:42:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451D2C061574
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 07:42:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bt4so6085713pjb.5
        for <linux-xfs@vger.kernel.org>; Mon, 29 Mar 2021 07:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=TDNAOc4UObP9WAFzSILUyj/OPWlsDZd0udnWYvyEZos=;
        b=sIc2vrmNUKsBg6/KTAsDwHiQQFFIm6EL/QfmpXyfp2EcixLHb1y7BDUPaW6JkYOHMi
         +/ayZ4pRprA2LauC9cUzY7VPuLKG+t5ZYuxPLBFmGCGq4m88o1/9kRMDTMNh5aU59xBi
         70FcHqKiOVJq6ho8COy0gZdYN0wjs76U0J0DdvNcBl2emT7bOTq96gvYE4MaKb7Nyjge
         F/VTLFRnCvjQwmlRyxSbgH9YKrMtM2CdWg5e1kGEw0DxkJdKQn2KCYub7LljammWeaGM
         w/QDi1PAnQLgBqxh/OfibDO+J47o5vZCn/SuSPcoENXtVFiuvgAImKbdmXuHNGweBPGd
         Fg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=TDNAOc4UObP9WAFzSILUyj/OPWlsDZd0udnWYvyEZos=;
        b=WfckfnEg3M7p8dqLiuu4hqoSOZF88ux3DssAq0QH7Tj6zckmKmUrbuwVKjUgzxr648
         MPZlOUHlvEcLai5C5youX48Lh1HLC8bH+q9Wr+WcIgyzZ32chT8bE7QYOaQ2zecbg7fu
         EZYfireE2F30BV3rPJO/rEOBpF9vYrhXTljBGBQGvqJGOHu7Wg0lTYOxie6jEx9qaU4N
         dzzGy0jAEr0xqMZfL7AF+7rFpvG7yXfvjjz5DUJpiAiKvst/KVpgqufmGE1t+aJ857jh
         wFAvY5Y5ctDt9bLiO5a+sE4X6BsXN4EgIIp7n+GF5XWXd3r/CNrGnX5qCrEFg/5QtOBW
         FMFg==
X-Gm-Message-State: AOAM532wk0Mmz3Pptn2hV/m7QJvCEOQ/cmWt7Y08/aT7USdtZ/3bIUco
        GiFs5G5VgKdX+eUNP8d52k6Poy3f7Iw=
X-Google-Smtp-Source: ABdhPJyUztehf6wzlYPbIqNxRCU8s28mVEU1ZI2nWmWzCthXkvKOWHrJS6qbjDTeNl/d8sC/yV5/SA==
X-Received: by 2002:a17:90a:f184:: with SMTP id bv4mr26030877pjb.43.1617028925716;
        Mon, 29 Mar 2021 07:42:05 -0700 (PDT)
Received: from garuda ([122.171.151.73])
        by smtp.gmail.com with ESMTPSA id b140sm17681423pfb.98.2021.03.29.07.42.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 07:42:05 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-6-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
In-reply-to: <20210326003308.32753-6-allison.henderson@oracle.com>
Date:   Mon, 29 Mar 2021 20:12:02 +0530
Message-ID: <87ft0eauo5.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch separate xfs_attr_node_addname into two functions.  This will
> help to make it easier to hoist parts of xfs_attr_node_addname that need
> state management
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d46324a..531ff56 100644
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
> @@ -1061,6 +1062,25 @@ xfs_attr_node_addname(
>  			return error;
>  	}
>
> +	error = xfs_attr_node_addname_clear_incomplete(args);
> +out:
> +	if (state)
> +		xfs_da_state_free(state);
> +	if (error)
> +		return error;
> +	return retval;

Lets say the user is performing a xattr rename operation and the call to
xfs_attr3_leaf_add() resulted in returning -ENOSPC. xfs_attr_node_addname()
would later allocate a new leaf and insert the new instance of xattr
name/value into this leaf. However, 'retval' will continue to have -ENOSPC as
its value which is incorrectly returned by the above return statement.

--
chandan
