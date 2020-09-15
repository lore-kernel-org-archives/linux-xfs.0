Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0327C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 08:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 569B521974
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 08:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvjBo05B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgIOIrL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgIOIrI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 04:47:08 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C6FC06174A;
        Tue, 15 Sep 2020 01:47:08 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b6so3178162iof.6;
        Tue, 15 Sep 2020 01:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kC1uOmT40aXZvmAxC8YaRFqenEQ+tpjhKt+iEmW08g=;
        b=MvjBo05B4QOyUFTax1NPP6xtURSGiJSy4Sb4B80R5BssySgDGYME4ZVA4YZGTxXuNi
         sivQlfHXD2uE7khWh7DcnKHslr7ciZqrBe8PPy43RswT42GbR224rlBvaWFB6P8U7918
         KUuw+NgkkeoUk7B12Skd1yMb6Il6dB35YQm99LTTR2wbesu2Ru47wEOs2NZeSq7SzI4u
         g+BbYQBdRSv0zox8h7wDIboplrDmbv8Ge/+kFQO7DgussGs8aOoGPHCKEaGmBkuFn4a7
         tXm9d32NRvGurXzFx1uM7DlocXuaDeCdhTvx8/5WNdI1SzVmKwuq1RZYF9x6s9TXimcr
         YDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kC1uOmT40aXZvmAxC8YaRFqenEQ+tpjhKt+iEmW08g=;
        b=DkgIPAQCT8ktLW6JEBQJrVXoLBOiyCXkRjJEUP/ng6wtE74Phv7cWqhnHwf47EsEqA
         YNFjp/PrKUL6w4Ykg4HPnRQZ0+9IrUEEMeO2El+ua4lwK/8dcpgXgf6BuOlCnNy+sW+U
         oN7Is694h2r2n24MXxbHjwUHQrX7txIX3yE9cU9YeQYjwskdeKAUQlwPyZOl+N0zDvdU
         SwqGa4hohJaAM9i9AXNn8R/fC9MRMVAOnwTT4bVKoeWYVzeJxk5MbbP4++0EF5Gb0aNC
         NT774P7aZMzaDcJWgMLd3k4QZvotvz9hTnGoi9qG/RPWiQcTsQOub3t+m9oaRnQ+jt/C
         tV6Q==
X-Gm-Message-State: AOAM531583E+FpCpyibOnn2RS5SbFQXO7KmrF3T/B7Gx1AjBUu+yD9TH
        MUxzbZt7kiqNtPffZyRBeCFT4iGNKK/dC4O4e6Ny2DNXNZk=
X-Google-Smtp-Source: ABdhPJwlBmiRPEceDa/AxxJH2s1tYpUp7UnTcp34xv5lGC97qg7Gn7UT9CYWojCJBvk1dMxMUKvqEcJ5yZtbaZPjLSY=
X-Received: by 2002:a6b:5a0d:: with SMTP id o13mr14405161iob.186.1600159627981;
 Tue, 15 Sep 2020 01:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <160013417420.2923511.6825722200699287884.stgit@magnolia> <160013425217.2923511.11863740582450765597.stgit@magnolia>
In-Reply-To: <160013425217.2923511.11863740582450765597.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Sep 2020 11:46:56 +0300
Message-ID: <CAOQ4uxg8UvZ6uKL4h-9BV5kB9e4RMgARp5c361ug22ghYkDXtQ@mail.gmail.com>
Subject: Re: [PATCH 12/24] overlay/020: make sure the system supports the
 required namespaces
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 15, 2020 at 4:44 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Don't run this test if the kernel doesn't support namespaces.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

>  tests/overlay/020 |    6 ++++++
>  1 file changed, 6 insertions(+)
>
>
> diff --git a/tests/overlay/020 b/tests/overlay/020
> index 85488b83..9029f042 100755
> --- a/tests/overlay/020
> +++ b/tests/overlay/020
> @@ -32,10 +32,16 @@ rm -f $seqres.full
>
>  # real QA test starts here
>
> +require_unshare() {
> +       unshare -f -r "$@" true &>/dev/null || \
> +               _notrun "unshare $@: not supported"
> +}
> +

I guess we can defer making this common until xfstests catches up on
testing FS_USERNS_MOUNT...

Thanks,
Amir.
