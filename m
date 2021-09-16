Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F095C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E4661185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhIPGIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 02:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhIPGIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 02:08:09 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E04AC061574;
        Wed, 15 Sep 2021 23:06:49 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a20so5515030ilq.7;
        Wed, 15 Sep 2021 23:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sXGS7/NTxvn+at+OBJjhvMUltwvBiIcpCdjlRNLBG9w=;
        b=qDifrJ/ysCK0q8yavNw72UDM3avtgvZZA2rZu06ZympbsXtTuZSj1rvmoFw1Osagrl
         iKyUwdz97c1UXFg9nxzdqbxqHUERE0+iNnVFln/z6I+KzDPCN1BQMbXE9sKkA5bRGFWT
         0SJw2fFq2NubtBvNRoVuesIpwfcm/uITx/g05OUuuCzuo5iHMYhLwL5p464CVCqfUbPu
         Ndhi0TVBx2FrHr9WWxRCtRX44Nbz5jVTp9YmodYL5s7YvmOaKnILeALd/6+v/m7wVZYs
         aPjtffbsWjf6DzpbEAp1WlnR1KpKZYqptOwQ0D7P1n59lIE7gPEeh9VsyRstQPkj8Hyw
         sOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sXGS7/NTxvn+at+OBJjhvMUltwvBiIcpCdjlRNLBG9w=;
        b=tujqxeoOfKXdwzmfZZjVKpWu559xS85K5r1kSvFfvHY0dYOwjaYoIirIpy6o+wT92N
         +IO4inPvOUIHhSQj9p1aV0LOY8nVX3/AS9jk5Nxc7If9oNXL2I2f7gOa+wlJMxPGJMxm
         nMO1F8fzLvZWW4A7yY5w3Qb1+q4nZYSxHMPaOLHq/FWaSDMoMY93kJuFvI2u9d6OXv2z
         g+hhofQF3TOIOKptvRcQnzGr4Pa0upMHhX+jKO4UKQJfw2y4Dw1GIUTQEji2FKgaDLzh
         5PlFgFlflN4cITvCuuM8C7JXd6bTH/gPbZxV4B+L9L7tbst15GfQ0+MW7X9ynrMjKIyi
         LuDw==
X-Gm-Message-State: AOAM532zkvMtLkfH3odDnc/H0wylwhwBTpqqcthjJDaZ7ZJT1XmD60h0
        YdxCZ9Iw7c1Ns4ITd1UEks4fmCEihyRPdql4ptE5fk9HBCQ=
X-Google-Smtp-Source: ABdhPJyTlJIkDERQEfTaI1T4P64wk21kx598YGiooowU9+W7vGJsmwcu2wrjNm9AF3IswCxEgYj/OwZyC2oeBAPmA5w=
X-Received: by 2002:a05:6e02:1a67:: with SMTP id w7mr2771803ilv.24.1631772408806;
 Wed, 15 Sep 2021 23:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174939566.380880.290670167130749389.stgit@magnolia>
In-Reply-To: <163174939566.380880.290670167130749389.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 09:06:38 +0300
Message-ID: <CAOQ4uxh-_qHNRJF1Jn8A=NpFw4+8tneOMPTFE6B-Rj4ryWFeqw@mail.gmail.com>
Subject: Re: [PATCH 7/9] tools: add missing license tags to my scripts
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 2:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> I forgot to add spdx license tags and copyright statements to some of
> the tools that I've contributed to fstests.  Fix this to be explicit.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Is someone having an identity crisis? :-P

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/preamble     |   21 ++++++++
>  doc/group-names.txt |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/mkgroupfile   |   33 +++++++++---
>  3 files changed, 181 insertions(+), 8 deletions(-)
>  create mode 100644 doc/group-names.txt
>
>
> diff
> ---
>  tools/mkgroupfile |    4 +++-
>  tools/mvtest      |    5 ++++-
>  tools/nextid      |    4 +++-
>  3 files changed, 10 insertions(+), 3 deletions(-)
>
>
> diff --git a/tools/mkgroupfile b/tools/mkgroupfile
> index e4244507..634ec92c 100755
> --- a/tools/mkgroupfile
> +++ b/tools/mkgroupfile
> @@ -1,5 +1,7 @@
>  #!/bin/bash
> -
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
>  # Generate a group file from the _begin_fstest call in each test.
>
>  if [ "$1" = "--help" ]; then
> diff --git a/tools/mvtest b/tools/mvtest
> index 5088b45f..99b15414 100755
> --- a/tools/mvtest
> +++ b/tools/mvtest
> @@ -1,6 +1,9 @@
>  #!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2015 Oracle.  All Rights Reserved.
> +#

[...]

> diff --git a/tools/nextid b/tools/nextid
> index 9507de29..9e31718c 100755
> --- a/tools/nextid
> +++ b/tools/nextid
> @@ -1,5 +1,7 @@
>  #!/bin/bash
> -
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2015 Oracle.  All Rights Reserved.
> +#

I suppose 2015 is intentional?
Should it be 2015-2021? I have no idea what the legal implications
are, but anyway, very low probability that those scripts would end up
in litigation :)

Thanks,
Amir.
