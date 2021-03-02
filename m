Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D595C4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E422361477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343559AbhCCDQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360967AbhCBXI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 18:08:28 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB82DC061788
        for <linux-xfs@vger.kernel.org>; Tue,  2 Mar 2021 15:07:47 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id r25so25190024ljk.11
        for <linux-xfs@vger.kernel.org>; Tue, 02 Mar 2021 15:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5pZrjjEXxeGRqF4m3hpMHzH4jL5bRTSPjbV5MW0021o=;
        b=EMKY2f0QC3SaZfHlEf4NoKPeSBayQgqo+7fZ2cHuv05qNY4wtPYwFhtJ1IR8qNHEeG
         Ow3cowMzWPmHToA7o7UjD+Uog5aUwFWpOWFxgSjgbp/VEsypPGBB9WAHBvVPiD4rImSf
         dqefdK+bYhI1vpP3FKuXvewW7vioUZbT8qICo3Rc6f9jufHlagRMdKSPHPDG9xUu6/vn
         drhrpIaNC9gilfC0iBRrK6BhAHoHneNDz5IYOo1GPdEKCJU32vGXZHCr/URhA2skaSW3
         u+ZZ+7SzqLuvkpc69htZh83zGJF4PYCnbq0nRWLiL49rX0HlSv1DXYO/OiUaUFgLH5W/
         AiXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5pZrjjEXxeGRqF4m3hpMHzH4jL5bRTSPjbV5MW0021o=;
        b=ndYJDqElNOR17ibqMcK5uVZSH/i460BV7guZxkb+00BGumjQ+Wyu2br1JwFA+YA7Al
         F6Td6h/G54Xw1T5NoaRkwQT303Jdp6Sgh6EKA9kcZG6QsKKItm24R1uDJ0xtoEuy/Qzv
         1RRXqVDGf/qROxrYUxm8UM1sMNmWMAfk+ha71eNeRsMLBaovxrUvzs2BDYlV7epX/1jC
         BNmrPbGPEkVQEX01n6VX0lsY/jSY+j+4Xy8YTy2CnzyvQkdcYLwSo370ZBxD9Y9VE7UL
         OoXczZ5ekyK1HWyLAvXeuZde82BWaH9u82lWItDc9gZTWvBcurY8m3rm6yYmc/ZfvdfK
         7MxQ==
X-Gm-Message-State: AOAM533vHwxg5fwYXRMmVmacAipOfdDDptgtRjh9LeH8mSWMuabc/3Jc
        JNb+2YIXJ4soMFRFMyeh0CGmeqkgIRXrhsg1ze/SDWW6dF4=
X-Google-Smtp-Source: ABdhPJyBxgS39jsQ+xMMNXaj8FF46l0fcsMuPVhHBTbeUwGUlvKhLf6Ltl5EGRkgjzMqSIxr3+rcTAtGuzCIqBMtMoI=
X-Received: by 2002:a05:651c:2125:: with SMTP id a37mr13480659ljq.19.1614726466193;
 Tue, 02 Mar 2021 15:07:46 -0800 (PST)
MIME-Version: 1.0
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
In-Reply-To: <161472409643.3421449.2100229515469727212.stgit@magnolia>
From:   Christian Brauner <christian@brauner.io>
Date:   Wed, 3 Mar 2021 00:07:35 +0100
Message-ID: <CAHrFyr5saBTbVFSO4UGgH9z8Nxf3-OE=__jeUn9+6cfqGHSyHg@mail.gmail.com>
Subject: Re: [PATCHSET 0/3] xfs: small fixes for 5.12
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 2, 2021 at 11:28 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Hi all,
>
> Here's a handful of bug fixes for 5.12.  The first one fixes a bug in
> quota accounting on idmapped mounts; the second avoids a buffer deadlock
> in bulkstat/inumbers if the inobt is corrupt; and the third fixes a
> mount hang if mount fails after creating (or otherwise dirtying) the
> quota inodes.
>
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
>
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

Thanks for doing this, Darrick.
I haven't forgotten the xfstests addition for quotas I promised yesterday.
While writing the tests I got bitten by the swapfile bug (Yes yes, I
was insane enough
to run -rc1 for the first time at that.) and now I'm in the process of
recovering my
development machine, emails and all. I'll try to review this tomorrow!

Thanks again!
Christian

>
> --D
>
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.12
> ---
>  fs/xfs/xfs_inode.c   |   14 ++++++++------
>  fs/xfs/xfs_itable.c  |   46 ++++++++++++++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_mount.c   |   10 ++++++++++
>  fs/xfs/xfs_symlink.c |    3 ++-
>  4 files changed, 62 insertions(+), 11 deletions(-)
>
