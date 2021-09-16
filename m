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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05468C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D29C3611CE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhIPFx6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 01:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbhIPFx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 01:53:58 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E145C061574;
        Wed, 15 Sep 2021 22:52:38 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b200so6500228iof.13;
        Wed, 15 Sep 2021 22:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zK4umYWkiaA8UuiFU7EdJ+7rnXBMXDa3wq8/0CWvk30=;
        b=HuY2Wt+7H3u1niuQhBecPcNiLDnblZB3mU76EaHuI1/X8G8T5H1mSlC/fRyuGw1m09
         OIBIe30Yg2jqNYBN0ozjl++vVimnRYQCGMdqv8CRVaAqStrKYLxdmxJi7/VAu+9jevi+
         Vn54GnhMY/1hebTGV6kVRat1szW/y1NBdiYkFHgsUOYGzIzylJCecK6x0djsgIWZ9m+f
         AC3HOQTQml+qT1ihiv4rjrc9IWmDNUoq6Vw16LVQIBX8dp2kcQXf4HSJFfPdRADOi70n
         WyGby0ck1qnv5oNDQ3IlBxNYspSouSwtscQEl5uYbn9mpsDk0HhrS7+/VdViTf1Xou0o
         zMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zK4umYWkiaA8UuiFU7EdJ+7rnXBMXDa3wq8/0CWvk30=;
        b=hyJyn24WOOe1Xv1+ZBa6wvYI/mXfRgA5H1n9ifeTAZKHNBv9iHJ4vNKQr7rygOpQew
         2CPYUR5ojoTqBjKUmK1zdKWWWHSwtXF2bJG1dmX/u2Cwb0Kmd3V85WsGz/QQABM0XC+w
         XByKJ2/E6rcRRMaFch+rDXq6d4BMZkvf68fjVxQv2zR2MvUXlG8+7Cv2nZFa7nipD7GU
         6YqFOL5oMpgDosf/Z8ZINMDcIDQZMVyVCqt0jLaiyVjeM8+zFydIm9/36OQwLtXcfBrW
         rOvkGfz/18u/WAF89hgbEoYYNn3mu381MXzonW9qyiH0Movo6Y8gJwMTOPeYbxj5fwmf
         eh6Q==
X-Gm-Message-State: AOAM531qAJfshlaJR6E7rdylI1cxlJQ1/AQfEsZgggXUvWdeSHvF44Iq
        hn+OfVj7sXbc7FqARH8qRdqgYUrjxixfe0Lexb8=
X-Google-Smtp-Source: ABdhPJwUNamSQZHNKS+y8cSLfvuk1TrG+RHNQewv/A+LheviomAiuJSQYG/+jmnYx7RfIHyShxiEcM3SZ9a421r4V+A=
X-Received: by 2002:a5e:dc02:: with SMTP id b2mr3016436iok.197.1631771557696;
 Wed, 15 Sep 2021 22:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174937390.380880.10714985927715519622.stgit@magnolia>
In-Reply-To: <163174937390.380880.10714985927715519622.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 08:52:26 +0300
Message-ID: <CAOQ4uxgGOTMMUZXRsKsKd5Kgw_ZO8KzNQfXqeqn_eZd_sfqwhw@mail.gmail.com>
Subject: Re: [PATCH 3/9] xfs: fix incorrect fuzz test group name
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, Christoph Hellwig <hch@lst.de>,
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
> The group name for fuzz tests is 'fuzzers'.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/xfs/491 |    2 +-
>  tests/xfs/492 |    2 +-
>  tests/xfs/493 |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
>
> diff --git a/tests/xfs/491 b/tests/xfs/491
> index 5c7c5d1f..7402b09a 100755
> --- a/tests/xfs/491
> +++ b/tests/xfs/491
> @@ -7,7 +7,7 @@
>  # Test detection & fixing of bad summary block counts at mount time.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick fuzz
> +_begin_fstest auto quick fuzzers
>
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/492 b/tests/xfs/492
> index 8258e5d8..514ac1e4 100755
> --- a/tests/xfs/492
> +++ b/tests/xfs/492
> @@ -7,7 +7,7 @@
>  # Test detection & fixing of bad summary inode counts at mount time.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick fuzz
> +_begin_fstest auto quick fuzzers
>
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/493 b/tests/xfs/493
> index 58fd9c99..58091ad7 100755
> --- a/tests/xfs/493
> +++ b/tests/xfs/493
> @@ -8,7 +8,7 @@
>  # Corrupt the AGFs to test mount failure when mount-fixing fails.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick fuzz
> +_begin_fstest auto quick fuzzers
>
>  # Import common functions.
>  . ./common/filter
>
