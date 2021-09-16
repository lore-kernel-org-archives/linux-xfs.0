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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF829C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A088F611C6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhIPFyS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 01:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhIPFyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 01:54:18 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3790DC061574;
        Wed, 15 Sep 2021 22:52:58 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b15so5470268ils.10;
        Wed, 15 Sep 2021 22:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HysuB8/vaN/sHa2crtHM0+/De06RJAH1ORTdLeHewMA=;
        b=J/OYbGnpOSJOmvQINBFk8JeWtgFDmpECqFp1rV8CIETbiaPLLYzS5H+SlhOuQnwTKv
         NWZcwWeRTfHAPJiaHAcppj29rL8EWq5fx0npDQnRNkIvc2GXjd624YbktvXvQj6uuybZ
         DWgDuEFz61pTUZx2YVeCX2rNoixlEG63O0xU8l5DqKmGHPh34z76R+gIKjatXFHAlY8m
         aWcKTUtmfFWwX5Fi+RB7zWi5nimoFEw0N86zT39zQX9yjRwmoAKQpUBbUQ4NhcxwfTsc
         ze7Kb91F0e1VmhJwX5QxFyife00qCQ8Dm5upcZ3hKvZUYLQK5cV7Y6yhmiBRGeZye4O+
         n55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HysuB8/vaN/sHa2crtHM0+/De06RJAH1ORTdLeHewMA=;
        b=c9OxLe1ikqgeRgmNzERwqA/XLkzMR9SwR/xcbGpSni8MRtAb3MuQ5JjOwYPy/g//It
         jiQ9vV6jjp7kthvACtZLzcyJNYE5bclg/6/W+0eQ5DQ9uRElY1ZnPACaShsAUGXG+Db9
         H7PjrdG+SqBE+zlYu6ciPS71nZaxQoi4uJAycCWKPE0IFIGL7ZygamurGvOtAvr0tWoU
         9tY0WgFmqHUR6JW0nbHMbrJr6tUK4wSrRHv5In8WoYgqjXB9A4u16/PQ6u5uTHjKD3L+
         IfM6+/KhaAmILTv7ApNca1CJCfHMvipbLd6bZUlam64haSdNTC9ZOgOuAX+MVTs4V+pT
         lKmg==
X-Gm-Message-State: AOAM532SQV7KLj7kYCNXsYJ0GfdJNg1968LCjQE+F1/tkU7QXg0avNq4
        c5f/mcHTW/xVbVQAIE2E14g4PYGyFtwIi+8d9Kw=
X-Google-Smtp-Source: ABdhPJziXdlW0SBDlauGrWDrK6JNKX5XKy6Cka4fzzJTF6Ft6omjYGYgXhwxVOtT9LDNYreFMpkx39DIwM27fuiEsZc=
X-Received: by 2002:a92:d752:: with SMTP id e18mr2823086ilq.254.1631771577697;
 Wed, 15 Sep 2021 22:52:57 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174937934.380880.8949346653026672201.stgit@magnolia>
In-Reply-To: <163174937934.380880.8949346653026672201.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 08:52:46 +0300
Message-ID: <CAOQ4uxjDWLM4+ssHH4XM9VMsv=X_r7sdwB9LcJFWYvC70F5F7A@mail.gmail.com>
Subject: Re: [PATCH 4/9] btrfs: fix incorrect subvolume test group name
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
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
> The group for testing subvolume functionality is 'subvol', not
> 'subvolume'.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/btrfs/233 |    2 +-
>  tests/btrfs/245 |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/tests/btrfs/233 b/tests/btrfs/233
> index f3e3762c..6a414443 100755
> --- a/tests/btrfs/233
> +++ b/tests/btrfs/233
> @@ -9,7 +9,7 @@
>  # performed.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick subvolume
> +_begin_fstest auto quick subvol
>
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/btrfs/245 b/tests/btrfs/245
> index 2b9c63c7..f3380ac2 100755
> --- a/tests/btrfs/245
> +++ b/tests/btrfs/245
> @@ -8,7 +8,7 @@
>  # as subvolume and snapshot creation and deletion.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick idmapped subvolume
> +_begin_fstest auto quick idmapped subvol
>
>  # get standard environment, filters and checks
>  . ./common/rc
>
