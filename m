Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79FEC43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 08:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 930482080C
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 08:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlrCqRB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgIOImt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgIOImr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 04:42:47 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94152C06174A;
        Tue, 15 Sep 2020 01:42:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y74so3114835iof.12;
        Tue, 15 Sep 2020 01:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TxvELiQQCpKIQ2PIcU5w8yXvAo5J5ryBhw8d6VbDApk=;
        b=GlrCqRB38IO7haHUudurnYdqmZEA9qYt2tvbmWqPpY1DDHYG86lEUZ72sB30Zs0AL+
         fBZ/TO8Z+oqd9FCVUkntfhWTZnF79TiLP5ngIuv6FCSBpUJK9N2yR67Md3szTGM3C0l3
         uSuvfspKFy+qzN+iCF6x1QaXP22DqtrjJhIdeHFbYpDo847RB+6wRbtHvmGKG3TXe5hi
         D+WjS0pm08xRI3QA0slDQ6kS6vpL0c5QZaFh2nLnnJZlitITx2TEDV/YIw0MecCHlNHV
         yU/24rGPw2NicphR3CXC1ouMXkwgsiZRcuhN+xIqS/WeuOHfB/Nn1J7xYSUQFB1AJdhz
         9wYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TxvELiQQCpKIQ2PIcU5w8yXvAo5J5ryBhw8d6VbDApk=;
        b=YKlh200eSQdgbJRqlYwcU7WRMbDhDvgPodcP75vrhhpcad/WvGbbuROwT/tS5Kgqjd
         mQTrOaLYKVh++sbXc03KA+xUnNGvQL9blJipO6VRDgg6FfCTWN53e7kv8ZFw1eqliOEM
         91eWGOWMoTYNriDZXFHWtM9TiLsRVrz8WBuwQRk/aTYQWMLgKJaTHfi/cPyx4OAMzH6I
         2+y8I6EUJSXt++zGEeGZAK+PiFyfL9QDrfytuZCTz/QJPRAIWKGSyXyzh236KL0VW5Fn
         kr+qNvf/V5sNXuhuv3uJ2PbOZ4S5q7r0pNTcidd2+vVh3M+vzieNSzy1bLSrakcwh5Bf
         5fSw==
X-Gm-Message-State: AOAM533DYQSyvoV2pNPcb89+vJkJBsGMsLLYGCt13BLqWvdFW6KVp4p9
        vG/sHhwS5NC6WXaZqCHOH7mldq6h/1Aacz+sAHk=
X-Google-Smtp-Source: ABdhPJxSjeTjY1SGv3i6KhNFpfXdtI3pD6lVRUlgDktQYmnmdQ9igapEHeW2o1E/Gj8uD3DZTXWA5UEO8J5XKoT5HHg=
X-Received: by 2002:a6b:5a0d:: with SMTP id o13mr14397683iob.186.1600159366000;
 Tue, 15 Sep 2020 01:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <160013417420.2923511.6825722200699287884.stgit@magnolia> <160013432812.2923511.2856221820399528798.stgit@magnolia>
In-Reply-To: <160013432812.2923511.2856221820399528798.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Sep 2020 11:42:35 +0300
Message-ID: <CAOQ4uxjcg8ydFb4=y0rfC1HKUuQZhTSKxasBSZF-_XV_XFJ3Cg@mail.gmail.com>
Subject: Re: [PATCH 24/24] check: try reloading modules
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 15, 2020 at 4:47 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Optionally reload the module between each test to try to pinpoint slab
> cache errors and whatnot.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  README |    3 +++
>  check  |    9 +++++++++
>  2 files changed, 12 insertions(+)
>
>
> diff --git a/README b/README
> index d0e23fcd..4af331b4 100644
> --- a/README
> +++ b/README
> @@ -106,6 +106,9 @@ Preparing system for tests:
>               - set USE_KMEMLEAK=yes to scan for memory leaks in the kernel
>                 after every test, if the kernel supports kmemleak.
>               - set KEEP_DMESG=yes to keep dmesg log after test
> +             - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
> +               it between test invocations.  This assumes that the name of
> +               the module is the same as FSTYP.
>
>          - or add a case to the switch in common/config assigning
>            these variables based on the hostname of your test
> diff --git a/check b/check
> index 5ffa8777..29306262 100755
> --- a/check
> +++ b/check
> @@ -810,6 +810,15 @@ function run_section()
>                         _check_dmesg || err=true
>                 fi
>
> +               # Reload the module after each test to check for leaks or
> +               # other problems.
> +               if [ -n "${TEST_FS_MODULE_RELOAD}" ]; then
> +                       _test_unmount 2> /dev/null
> +                       _scratch_unmount 2> /dev/null
> +                       modprobe -r $FSTYP
> +                       modprobe $FSTYP

It is safer to use fs-$FSTYP namespaced module alias.

Thanks,
Amir.
