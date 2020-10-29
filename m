Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85F9C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 11:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5798E207BC
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 11:28:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jiXmTQpS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgJ2L2U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgJ2L2U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 07:28:20 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946C0C0613CF;
        Thu, 29 Oct 2020 04:28:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id p7so2930860ioo.6;
        Thu, 29 Oct 2020 04:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfi+UtL37/p8gDwiSQgVd9ExgUieCTKeWhlouG7mSq8=;
        b=jiXmTQpSaXOBu9pHohffNcwieSx4dv4YPeq3gl2FXe7ZgJOCzurCjj/KNwCn4EchRA
         DF+vuok80qNTw2r96c0slcvoDDpmH+EZ2UXe7OqNIsAX5f131LiNrmCWT9hmrMa4qukY
         2SrFeq+hcFJDaiBf68n6kY0ahQ/tgmNkbWQexBqU57ijiCPLtUTcUKbWNxuHYL8g6zd1
         8O0u0CNOwWtv6F39gWKuk123QjPKCCEQsC7mW3QgVW2iajRfvnjM0SbsuGAawNmhXdKD
         oS1CWN1jGif+Y2wEqTY7lvSocXCB9B+d6GKRJYGjv6zM1Y67ffAM3Nv1iKX+nffTsrBm
         fjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfi+UtL37/p8gDwiSQgVd9ExgUieCTKeWhlouG7mSq8=;
        b=VTZzUgKPN/BZnkMVBPI3poAgDnIIqm1JGhm/EPPBrH2Mn/srt2rvJbA7d5JZonc1Z2
         olRTiCee1sxNr4/xYnUZKkXNybDklE0q1kH2r5biTsKEPVQfyWKadaSOVHzZ1UEh5nS9
         QUsTZo2wFs+sqnwSkvV1TR4JbdVhMNqlCh5K8Eu/fDUaP0NJWx3yzs6gyLMY1JiAyMmf
         2J4YeNwef34Vc1QqCD2Q1VbleXj1Cx6AIOS0JGN+Bi/IjBc1JqhCQll/BbWjEWbVJCyr
         xjSHVunbRtC1I6uYpgU9RmHgDwX1VKko0i5tWuJEgmzmvgkCszialA3UhxI5pnOxzHBz
         8z2w==
X-Gm-Message-State: AOAM532X/97cI55df4oOkzBxDFTsj+ztLh6ON74GN4Ofhljo/UlRu4Tr
        GwWWRJxtnYGrCdZCGQjxppDuipp8rfwCRFu43jem+ktJ+7k=
X-Google-Smtp-Source: ABdhPJzOyKchjWQ2rMofI1cglsYAktjmXh0lvE8ihOlCN63XxYlzHeIRganUbbCag85OiRGE5YJkaksjVfezVYMl6NE=
X-Received: by 2002:a5e:c107:: with SMTP id v7mr2982186iol.203.1603970898054;
 Thu, 29 Oct 2020 04:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <160382543472.1203848.8335854864075548402.stgit@magnolia> <160382544732.1203848.9001133589345314135.stgit@magnolia>
In-Reply-To: <160382544732.1203848.9001133589345314135.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 29 Oct 2020 13:28:07 +0200
Message-ID: <CAOQ4uxi8=dYG95SJMc07oTidcc1nJheUzPVhNThykrtmT5a+kg@mail.gmail.com>
Subject: Re: [PATCH 2/4] xfs/122: add legacy timestamps to ondisk checker
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Add these new ondisk structures.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/xfs/122     |    1 +
>  tests/xfs/122.out |    1 +
>  2 files changed, 2 insertions(+)
>
>
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index a4248031..db21f2d5 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -182,6 +182,7 @@ struct xfs_iext_cursor
>  struct xfs_ino_geometry
>  struct xfs_attrlist
>  struct xfs_attrlist_ent
> +struct xfs_legacy_ictimestamp

<OCD move near xfs_ictimestamp_t similar to other adjacent struct and
typedefs />

Thanks,
Amir.
