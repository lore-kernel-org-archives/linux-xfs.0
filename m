Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FE7C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 05:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiFBF4B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 01:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiFBF4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 01:56:00 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B8E62CEA;
        Wed,  1 Jun 2022 22:55:58 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id b200so2983477qkc.7;
        Wed, 01 Jun 2022 22:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t6RAyF25ytXyKTJzA2P6dHrfEAgocqjrgR3cOBzPBf4=;
        b=PyOZ9ycyOYS9EX2bhpJwdU6mGXbMZ7RhKoRVF3cAshCxiscO0q6BaFu5DWCcVlgcVA
         nq5zSfL/5URua43qYjY2cypkztqdNrwr/3OuTXw4HjjP9HMvsz6QJGDOZUFiAd8BFmKQ
         7u3wouITEJQqJLIQWjzfpnxJv6xE915VoCZl+AV6JVhe0CqcKquJBeOUN3OL9b9kCmMu
         mNNf5URD05O9cK+bXf82U+gXXyPfwMGCkoF0W4tgduTScoyTqoFzM5ED6MYBJ67yV/h3
         mn00usSSVKFNhGf06HuAI4Y5a0zGD6l7432ip4KVHUuGK+xfb8Rfw04AlWKzighUlNa9
         iY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t6RAyF25ytXyKTJzA2P6dHrfEAgocqjrgR3cOBzPBf4=;
        b=0aCN4VocttmChswZ7OBndJIt0DUVvxOZeyWjQpr1eJX9yMKu0586LRPfgAQDZsGXpd
         512PoG4ME9IXQGsIrASxtoYsgLtl1au7LDlwkg2hR23E3VxVe3zH/6Z+YN+XBlgdFZLS
         Wqcc37IZ1oTejyU1s/ZzlnAIoJRO2/beBjdKAfGnTW1FY/qmdwpG4bt3ADFjGgNCg3Lj
         AISLrWpCu9HOL5VuiteYYrM0Van/nxS4xh7RDtQqSR7/RHL6se9nXAIb87S2wr8ibP+R
         Yv0uE9BNXs5dWcA0odvJPB+N1RZU+ALsEt4eY1jlL7wtMQMWKEKBELf3c7rFfJayzuYS
         wE+A==
X-Gm-Message-State: AOAM533m0hENzCVn2GfSy82un9ICM7oYY3hAMm7EBS8fBDQ+ue2Fy4Pl
        pa4RsPFradV2Gku9TUVJyy2hCQBwxCYeYR9E2sQ=
X-Google-Smtp-Source: ABdhPJzcP2eXAwR7p7/OoNemRoCsdw1HEjGXUge8NpX2JLsP+mOHUMcKnjaqUnmeRdO6Y83n/HZp7WzlAZqNWAgKKj8=
X-Received: by 2002:a37:6cc2:0:b0:6a3:769c:e5ba with SMTP id
 h185-20020a376cc2000000b006a3769ce5bamr2127098qkc.19.1654149358063; Wed, 01
 Jun 2022 22:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220601104547.260949-1-amir73il@gmail.com> <20220601104547.260949-8-amir73il@gmail.com>
 <20220602003804.GJ227878@dread.disaster.area> <CAOQ4uxg8Y_7mkf+ieWBAuspCDG+H5Ci2P7xMudxF49nV5M0czg@mail.gmail.com>
 <20220602051504.GL227878@dread.disaster.area>
In-Reply-To: <20220602051504.GL227878@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 2 Jun 2022 08:55:46 +0300
Message-ID: <CAOQ4uxgzLaGHaUEuVNJ39On9Dt3xoSTpVWJGsc6t+=4v-AGHKg@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 7/8] xfs: consider shutdown in bmapbt
 cursor delete assert
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 2, 2022 at 8:15 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Jun 02, 2022 at 07:24:26AM +0300, Amir Goldstein wrote:
> > On Thu, Jun 2, 2022 at 3:38 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Wed, Jun 01, 2022 at 01:45:46PM +0300, Amir Goldstein wrote:
> > > > From: Brian Foster <bfoster@redhat.com>
> > > >
> > > > commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.
> > > >
> > > > The assert in xfs_btree_del_cursor() checks that the bmapbt block
> > > > allocation field has been handled correctly before the cursor is
> > > > freed. This field is used for accurate calculation of indirect block
> > > > reservation requirements (for delayed allocations), for example.
> > > > generic/019 reproduces a scenario where this assert fails because
> > > > the filesystem has shutdown while in the middle of a bmbt record
> > > > insertion. This occurs after a bmbt block has been allocated via the
> > > > cursor but before the higher level bmap function (i.e.
> > > > xfs_bmap_add_extent_hole_real()) completes and resets the field.
> > > >
> > > > Update the assert to accommodate the transient state if the
> > > > filesystem has shutdown. While here, clean up the indentation and
> > > > comments in the function.
> > > >
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
> > > >  1 file changed, 12 insertions(+), 21 deletions(-)
> > >
> > > https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=56486f307100e8fc66efa2ebd8a71941fa10bf6f
> > >
> >
> > Warm from the over :)
> >
> > I will need more time to verify that this new fix is not breaking LTS
> > but I don't think that it should be blocking taking the old 5.12 fix now.
> > Right?
>
> Rule #1: don't introduce new bugs into stable kernels.
>
> This commit has a known (and fixed) bug in it. If you are going to
> back port it to a stable kernel, then you need to also pull in the
> fix for that commit, too.

Oh. I misunderstood.
I thought this wasn't a Fixes: situation.
I thought you pointed me to another related bug fix.

>
> But the bigger question is this: why propose backports of commits
> that only change debug code?
>
> ASSERT()s are not compiled into production kernels - they are only
> compiled into developer builds when CONFIG_XFS_DEBUG=y is set. It is
> test code, not production code, hence nobody will be using this in
> production kernels.
>
> I don't see the value in backporting debug fixes unless there
> is some other dependency that requires them.

The value is in testing of LTS kernel.

For my backport work to be serious, I need to do serious testing.
Serious means running as many tests as I can and running the tests
on many configs and many times over.

When I first joined Luis in testing LTS baseline, CONFIG_XFS_DEBUG
was not enabled on the tested kernels.

I enabled it so I could get better test coverage for fstests that use
error injection and tests that check for asserts.

This helped me find a regression with one of the backported patches [1].

IOW, for LTS code to be in good quality, it needs to also have the
correct assertions.

For the same reason, I am also going to queue the following as stable
candidate:

756b1c343333 xfs: use current->journal_info for detecting transaction recursion

Because it has already proved to be helpful in detecting bugs on
our internal product tests.

> But if you are going to back port them, Rule #1 applies.
>

Of course. I will defer sending this patch to stable and test
it along with the new fix.

Thanks!
Amir.

[1] https://lore.kernel.org/linux-xfs/YpY6hUknor2S1iMd@bfoster/T/#mf1add66b8309a75a8984f28ea08718f22033bce7
