Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A33C55178
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 11:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8686920809
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 11:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lB/3E2MX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgJ2LRx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgJ2LRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 07:17:52 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2933DC0613CF;
        Thu, 29 Oct 2020 04:17:52 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q1so2578226ilt.6;
        Thu, 29 Oct 2020 04:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ja0IuTkMsVvouNiYDdw++udVufz6MtP/nXId8HaBJ8=;
        b=lB/3E2MXVHaTyOTxq5hdr8RnIJ1ELQXnW8hCWavtb/4Dp/63MCa0lya4F+KMffmKIo
         f1s8Ow+2qp8bLiD+r6noM7c4QI5bUqaBntN4no2B/mvp8qLwRlgnybLl3tf+ZX0MbRvz
         7yUSr2diPJPzwEzkjGv9Uv8egCu8VFaUUxCfiZvSVH+4YHi7nsenO5eczx0F/VB4S/1X
         f+EWQFW5Ha4KdgjknxuPLvGsrf+rP0P/06bVrv1UlrQ28PdC2P4FfSeq5tidaBz2htjE
         9qlEU05DGM7FxnoBinN4HVKGQkpZJv/66EklAbh1bKsWbAQno9wjA5GPRiwguDUrZniI
         JyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ja0IuTkMsVvouNiYDdw++udVufz6MtP/nXId8HaBJ8=;
        b=B/Qrog+6YBEmBxL5PNdWiOt16BpdkQSj1x9atyW36hvRxHOn5WJBiNq9PpMdQOxKVG
         TzHtzO2VKQaojSHntbidCP1+Go2c3JE1X8Q1xG5ztrNSPCOXMTBRcNNa77UmbMed3Fce
         Gk4n145R1JxA9ypy6Vfc3QjB5x/DjPme7oUxY+wINYbz6VXsfxrEP5gl6wV0LtuE3o2N
         y2i8HzLsPnHHJdHEHZ5o2gTC+AvGPyK8kDzRqUtT2sXl7IDcPULo5Zw8SIiHFz3Q6YIT
         0kdobABrSQFh5ol2e93PyM1nRGNsc35jfgXCwHWN/obvuDxtBvbt7UMCPYbJRNLjIJ1Q
         nfMA==
X-Gm-Message-State: AOAM532FWXTnFc5QZrcddYqOErMYSPYAUmna9JuxveBG12DZnp/tTjrU
        LVk5ihT4Sph47xM6X7ff4w4LI1uhANT+z3CZquY=
X-Google-Smtp-Source: ABdhPJw9OuZeWXMyFb7pyGcEApUAoONp0en9QkZcbsTXPddffXjrHutgR5XOV4k8bFnmFkRUCU+bZiCy8I9q4rIW1PY=
X-Received: by 2002:a92:ddd1:: with SMTP id d17mr2684471ilr.275.1603970271605;
 Thu, 29 Oct 2020 04:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <160382535113.1203387.16777876271740782481.stgit@magnolia> <160382539620.1203387.14717204905418805283.stgit@magnolia>
In-Reply-To: <160382539620.1203387.14717204905418805283.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 29 Oct 2020 13:17:40 +0200
Message-ID: <CAOQ4uxgZ82k7y5QabzO0+2Xg6P0LDVf-ysyRvyMZeH6vm8os-g@mail.gmail.com>
Subject: Re: [PATCH 7/7] xfs/122: fix test for xfs_attr_shortform_t conversion
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 10:24 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> The typedef xfs_attr_shortform_t was converted to a struct in 5.10.
> Update this test to pass.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/122.out |    1 +
>  1 file changed, 1 insertion(+)
>
>
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index 45c42e59..cfe09c6d 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -62,6 +62,7 @@ sizeof(struct xfs_agfl) = 36
>  sizeof(struct xfs_attr3_leaf_hdr) = 80
>  sizeof(struct xfs_attr3_leafblock) = 88
>  sizeof(struct xfs_attr3_rmt_hdr) = 56
> +sizeof(struct xfs_attr_shortform) = 8
>  sizeof(struct xfs_btree_block) = 72
>  sizeof(struct xfs_btree_block_lhdr) = 64
>  sizeof(struct xfs_btree_block_shdr) = 48
>

Maybe remove comment

# missing:
# xfs_attr_shortform_t

While at it.

Thanks,
Amir.
