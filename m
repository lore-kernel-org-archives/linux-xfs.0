Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E856AC43334
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 09:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbiFCJkH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 05:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243124AbiFCJkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 05:40:06 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5BF3A708;
        Fri,  3 Jun 2022 02:40:05 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id br33so3763732qkb.0;
        Fri, 03 Jun 2022 02:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NgSKsAc7gDewGfKHy6geKvhpHPniCMotsC5LkPk1zn0=;
        b=Gn/pxj2vSvmcwe9fC8VRAhL7FSKGjzpeuieh37dgajH3B0aKWxooOakV5wyI62qnFD
         RRsatD7znpfDASl4DGURVGP80HS636dWGg321wI6XY7pejLcApzklposbwJ+Hj1MLodn
         qbRaPqFSXFJTou5vOXOsLhwHaVbQ9fI2papK4M48dsEfvn9TLehMhpb6uW4GjX5PrrQD
         rb7cg8v3eL8rIQ+Z5J7NFCbfE6S+KuI49mDhs2EPj+xFpT+9zflq8ItPrmDjtRnN2hi+
         fWzixOybMTHX+prLs+pSpNnA5eh/NGKMrissZuY4ZpPQ/T1l7lc5EA3OSqpxvLJDwB9W
         D/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NgSKsAc7gDewGfKHy6geKvhpHPniCMotsC5LkPk1zn0=;
        b=SGY4xNKfE7N2H7W2oytiEtwo9v6WoKvDDYqzaYzVuA1CkdbVW46MYDoBBnH7fPPTUS
         BbT/bD+AzFQAstGxP70fhxSFDfRnKEq3AT2hTcwsY1cfMElJOVgxLvjv3glJBHK0j2ra
         pxOf2prMnhTyqoBeFe4v99V1SUalvBtO+/AmlFGauvoBB0xT0aKQIvPkFnDxYs8uGimp
         KOh0d09HPgitsNFM8QGKI2rQsMyo2syN1+kFl5WR6aKKJTNJHk62Vhs4U1UVIYN1WAv4
         p15a0BvbjH3g79qtEP2LDDYan5tknm+8PSyXH2j3MgPeHWOZEEFQwqIli5te7/t5NYgA
         t/UQ==
X-Gm-Message-State: AOAM532AQNayd//3fpuV09OpEfIAMmiAAZQf2/KVoktUjOiVpyYHKIYV
        fEt6jxsfgeWs0ZxokkOhrgChMet4ftoVdj29GU8=
X-Google-Smtp-Source: ABdhPJz/KxYumBff+Ps2NMjARJAVelWVb8zgtbn7GCtt94t9vwPaZP143JNGtNL3A9DCI9hNeYvwM8ZneZmiyILJ+Jk=
X-Received: by 2002:a05:620a:c52:b0:6a6:6b8f:eac2 with SMTP id
 u18-20020a05620a0c5200b006a66b8feac2mr5771352qki.643.1654249204506; Fri, 03
 Jun 2022 02:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220601104547.260949-1-amir73il@gmail.com> <20220601104547.260949-8-amir73il@gmail.com>
 <20220602003804.GJ227878@dread.disaster.area> <CAOQ4uxg8Y_7mkf+ieWBAuspCDG+H5Ci2P7xMudxF49nV5M0czg@mail.gmail.com>
 <20220602051504.GL227878@dread.disaster.area> <CAOQ4uxgzLaGHaUEuVNJ39On9Dt3xoSTpVWJGsc6t+=4v-AGHKg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgzLaGHaUEuVNJ39On9Dt3xoSTpVWJGsc6t+=4v-AGHKg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 3 Jun 2022 12:39:53 +0300
Message-ID: <CAOQ4uxhxLRTUfyhSy9D6nsGdVANrUOgRM8msVPVmFmw0oaky+w@mail.gmail.com>
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

On Thu, Jun 2, 2022 at 8:55 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jun 2, 2022 at 8:15 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Jun 02, 2022 at 07:24:26AM +0300, Amir Goldstein wrote:
> > > On Thu, Jun 2, 2022 at 3:38 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Wed, Jun 01, 2022 at 01:45:46PM +0300, Amir Goldstein wrote:
> > > > > From: Brian Foster <bfoster@redhat.com>
> > > > >
> > > > > commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.
> > > > >
> > > > > The assert in xfs_btree_del_cursor() checks that the bmapbt block
> > > > > allocation field has been handled correctly before the cursor is
> > > > > freed. This field is used for accurate calculation of indirect block
> > > > > reservation requirements (for delayed allocations), for example.
> > > > > generic/019 reproduces a scenario where this assert fails because
> > > > > the filesystem has shutdown while in the middle of a bmbt record
> > > > > insertion. This occurs after a bmbt block has been allocated via the
> > > > > cursor but before the higher level bmap function (i.e.
> > > > > xfs_bmap_add_extent_hole_real()) completes and resets the field.
> > > > >
> > > > > Update the assert to accommodate the transient state if the
> > > > > filesystem has shutdown. While here, clean up the indentation and
> > > > > comments in the function.
> > > > >
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
> > > > >  1 file changed, 12 insertions(+), 21 deletions(-)
> > > >
> > > > https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=56486f307100e8fc66efa2ebd8a71941fa10bf6f
> > > >
> > >
> > > Warm from the over :)
> > >
> > > I will need more time to verify that this new fix is not breaking LTS
> > > but I don't think that it should be blocking taking the old 5.12 fix now.
> > > Right?
> >
> > Rule #1: don't introduce new bugs into stable kernels.
> >
> > This commit has a known (and fixed) bug in it. If you are going to
> > back port it to a stable kernel, then you need to also pull in the
> > fix for that commit, too.
>
> Oh. I misunderstood.
> I thought this wasn't a Fixes: situation.
> I thought you pointed me to another related bug fix.
>

Just to make sure we are all on the same page.

I have applied both patches to my test tree:
1. 1cd738b13ae9 xfs: consider shutdown in bmapbt cursor delete assert
2. 56486f307100 xfs: assert in xfs_btree_del_cursor should take into
account error

Patch #2 looks pretty safe and it only affects builds with XFS_WARN/DEBUG,
so I am not too concerned about a soaking period.
I plan to send it along with patch #1 to stable after a few more test runs.

If my understanding is correct, the ASSERT has been there since git epoc.
The too strict ASSERT was relaxed two times by patch #1 and then by patch #2.

Maybe I am missing something, but I do not see how applying patch #1
introduces a bug, but anyway, I am going to send both patches together.

Thanks,
Amir.
