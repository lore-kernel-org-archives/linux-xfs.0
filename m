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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E972C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45CE461421
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 06:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhDUGBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 02:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhDUGBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 02:01:49 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B69C06174A;
        Tue, 20 Apr 2021 23:01:17 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id k25so40947264iob.6;
        Tue, 20 Apr 2021 23:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TP+Yr/KpCypz005gHM5eLagP4F4fTGKSwecwkHVW+qQ=;
        b=Isd/R6mG8sCGEb2hD1mYYL6ECYG3H36QvE5LKbTH/VrQ1F0QFdPwxzXg9Ee6kEu4aD
         Ni9eTD7nfkh8NMQCIdM9zh9VlHUFf1kNVfDPXwZ2iWUsHtD67Fu8kV4itnL7hcjAh6Wt
         UkxywfzLv8rNNrbG+iDL+ia37k0bPbpuTJZJJb2E16jfagVv/q7Gyf1dHwFqxaA4TD9M
         l//9jlv/vfXzE8J62RVXrpmA76EodB+c7C3wUOAFXkkMyrQ3MnkNDnojF2YB29kh+Fmk
         MmJWCyehVYWZxI8BsiFD3C6Ca3AMHP+GAR7oeoL0gop2eyWL2m/bywluybFaBVHa2We0
         wzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TP+Yr/KpCypz005gHM5eLagP4F4fTGKSwecwkHVW+qQ=;
        b=jmSoVZZ2pfQOD0DaBVaKvgojf+c6kd2lcHMSWv3YBp3suMPn0L5UxC7y5P7yk1HaVH
         6+AzhYS/TsJb9rW7zA7c0VXDmotAhSnV0DF2yOZfuywYB4R4PACdtRedYH/kUer/vwZG
         dGGIyLRbZibl229K+AQ6PUvkUmKIv8zSxwWhHGub6SXDsQqhJgcypt/LG65cDorCD/9A
         7a2hyM5lVXRDMyzjbjnNtn5QGU66dPcP/a9tAU6AS4qm5L6dnzde/VX/qCTUH7AVOu1Y
         BaEcurGvHKYIAR1g09Sf9p5DMdkRjWFJ9IRQA7YQ+VTpZ4BBa5owTQkZVq9tm+PMaKCW
         nS9Q==
X-Gm-Message-State: AOAM531qO5bVq40TFeB23hCtHApu0LWFKtYvNtnBY2Baenjs3DobXbOC
        YyxjHDtCwb2lU+qQT3ShPabYT/gvJHUMaQUuBXk=
X-Google-Smtp-Source: ABdhPJyLsy5r3qihvn6ZWqYb5Kv96FoTt0Pkd70re4PdoWBYyIww0gvJkaXid8ZSNo9piBvvTsjS15GVBMVmyEJpu5c=
X-Received: by 2002:a6b:d213:: with SMTP id q19mr21663274iob.203.1618984876451;
 Tue, 20 Apr 2021 23:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <161896455503.776294.3492113564046201298.stgit@magnolia> <161896456107.776294.13840945585349427098.stgit@magnolia>
In-Reply-To: <161896456107.776294.13840945585349427098.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Apr 2021 09:01:05 +0300
Message-ID: <CAOQ4uxhvt0j7r6ZSTiwX8T7uPw5eVH+uMegt+ActLeopmpJy7Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs: test that the needsrepair feature works as advertised
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 3:23 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Make sure that the needsrepair feature flag can be cleared only by
> repair and that mounts are prohibited when the feature is set.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs        |   28 ++++++++++++++++++
>  tests/xfs/768     |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/768.out |    4 +++
>  tests/xfs/770     |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/770.out |    2 +
>  tests/xfs/group   |    2 +
>  6 files changed, 199 insertions(+)
>  create mode 100755 tests/xfs/768
>  create mode 100644 tests/xfs/768.out
>  create mode 100755 tests/xfs/770
>  create mode 100644 tests/xfs/770.out
>
>
> diff --git a/common/xfs b/common/xfs
> index 887bd001..c2384146 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -312,6 +312,13 @@ _scratch_xfs_check()
>         _xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
>  }
>
> +_require_libxfs_debug_flag() {
> +       local hook="$1"
> +
> +       grep -q LIBXFS_DEBUG_WRITE_CRASH "$(type -P xfs_repair)" || \
> +               _notrun "libxfs debug hook $hook not detected?"

You ignored the $hook arg.
And this is a bit of a strange test.
In _require_unionmount_testsuite() I also pass env vars to the test utility
and I made it so the usage message will print the non empty env vars
passed to the programm.

I can understand if nothing like that was done for xfs_repair and you want
this test to work with an already released version of xfs_repair, but if that
test is against a pre-released version of xfs_repair, I suggest to make it
more friendly for _require check.

Thanks,
Amir.
