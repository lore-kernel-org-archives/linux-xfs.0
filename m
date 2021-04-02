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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36B4C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 04:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E774610E8
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 04:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhDBE0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 00:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhDBE0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 00:26:13 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86999C0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 21:26:12 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h25so2897512pgm.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 Apr 2021 21:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Se4Hp5+Ge63h8ZHsk3IFW6LtUJs7arxVDSFalD+Efvs=;
        b=rsNA+/unDySt22e1iW2YPtzEX097iPPR3Xco8qsJCJ+7UHAIO/aVwmNBD+ACYpMao+
         Bkf6UkBsT8Olkky19YLH/1rulDythj6oYlyzndrgVBzJaISGdA+5kOcYGUrWAJthd7DM
         iL3iY1FWXtnKQCqNix3B7Bcye6N6bwglxWI6UVfQvODyalj4tjIEf2LnVe08rA4hRTrs
         AxMVmtAcSks1G0rShfNqbmxv5i5DOhanZ679gp3smsa27zsg6519+4j26qVk0H7NGHgz
         Emwa0JxZvgJQ8XNDS+87dKQTJN0BoLPKIlatJCiVMtD4cU3v/MC8ECAI4b4bAP2RhEzm
         MKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Se4Hp5+Ge63h8ZHsk3IFW6LtUJs7arxVDSFalD+Efvs=;
        b=iOIC/+w1z2FeGvC7eHMqEC1hnF2Jb5QiP3aq+UBJpqL6BJkHB5uXfXzk4mEifZ09Sc
         LHCnqpOliYJaNEbpPAQ2Ig2Ekoo4DcU72p5b0bfexdKcfDPyf+OsmDXkLwMtQ0zOObD7
         UICPDGl7Mh+4Ras5+fNVkV2j9RIbHpZY59NmZGkTpwiZ9oTBFHrBnZAbXtwgufSEfMOw
         dXsiyPTTMqtPxEgnlVn+xil9MQWwBlbCsZ92+jifC5fmvX5SOcdViOABm2lkCbexnpGb
         QnFn08SOcnwEtV4yXQxlV+jy7aAUu+iPwjzcHZy3O12tf17Dn19YnPiRbeexjqVbVDdp
         rJiA==
X-Gm-Message-State: AOAM531ptnYq/HR9kejT0h9b0GPGTV6udZxlRZnN2393SS1X9F3oC18q
        PbCUi+jKM/ieJG9dYlGn35zIiSMMLOE=
X-Google-Smtp-Source: ABdhPJw1VdMUKYR8rc2BZJz1ljiRXA2zaq0Eux7jibl+FzE9Tdu6cYQhxlQGD+GTBG3VaQ/pnUgBgw==
X-Received: by 2002:a65:4203:: with SMTP id c3mr10333578pgq.65.1617337571834;
        Thu, 01 Apr 2021 21:26:11 -0700 (PDT)
Received: from garuda ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id 77sm2991407pgf.55.2021.04.01.21.26.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Apr 2021 21:26:11 -0700 (PDT)
References: <20210326003308.32753-1-allison.henderson@oracle.com> <20210326003308.32753-8-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 07/11] xfs: Hoist xfs_attr_node_addname
In-reply-to: <20210326003308.32753-8-allison.henderson@oracle.com>
Date:   Fri, 02 Apr 2021 09:56:09 +0530
Message-ID: <87sg4971ni.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Mar 2021 at 06:03, Allison Henderson wrote:
> This patch hoists the later half of xfs_attr_node_addname into
> the calling function.  We do this because it is this area that
> will need the most state management, and we want to keep such
> code in the same scope as much as possible
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 161 +++++++++++++++++++++++------------------------
>  1 file changed, 78 insertions(+), 83 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 16159f6..5b5410f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>  				 struct xfs_da_state *state);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
> @@ -270,8 +271,8 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_da_state     *state;
> -	int			error;
> +	struct xfs_da_state     *state = NULL;
> +	int			error = 0;
>
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -322,8 +323,79 @@ xfs_attr_set_args(
>  			return error;
>  		error = xfs_attr_node_addname(args, state);
>  	} while (error == -EAGAIN);
> +	if (error)
> +		return error;

Memory pointed to by 'state' is leaked if the call to either xfs_da3_split()
or xfs_defer_finish() inside xfs_attr_node_addname() return an error.

--
chandan
