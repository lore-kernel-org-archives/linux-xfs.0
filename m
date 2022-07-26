Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34C7C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 02:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiGZCKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jul 2022 22:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiGZCKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 22:10:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514BC6541;
        Mon, 25 Jul 2022 19:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6E5EB8117B;
        Tue, 26 Jul 2022 02:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A104C341C6;
        Tue, 26 Jul 2022 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658801410;
        bh=DGxOyu7XcB2H4H/7Fr9clUI2L6FcH4nBdxoxbaUCJFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZXeAcFHiBZvS6AUd/TzJicJqF/C6+lPU1+PCoW4HQqSvIB8G8VUjlRwUitLnvmS+k
         Inge9azQ5LJROnH25R6Yzb0YMZJTeCQp/ZpV6zTwLf3mYdziuwnKQWPTcuF8eMlo7w
         rM+hiG15ksPPOO2yS6bDWgRaI6NcMSG23ZKpiasRmWIdeHO5a7xZ9udCLPncMtEjj4
         Oox7vBPQPvd/s5fwR1bsohlc7n7fkJ2LtHPr2iE4MjcXIOt/y0whLPuVd92huVbzx6
         I2XzDIDBjRfCBV5LfQhhXm/L8ngOwn/cbdGYRMmWqASjBSBl6p5QBaZwJmb6tNTt1P
         Md16eQML8wmiQ==
Date:   Mon, 25 Jul 2022 19:10:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.10 CANDIDATE 00/11] xfs stable candidate patches for
 5.10.y (v5.15+)
Message-ID: <Yt9NAQrBxlVUIKou@magnolia>
References: <20220617100641.1653164-1-amir73il@gmail.com>
 <YrOpmMzn9ArsR9Dy@magnolia>
 <CAOQ4uxhOAaYkWeKXz6M8681ZjFiOSOJQqmewoq+-P1O2oXhsOg@mail.gmail.com>
 <YrSPNFZ+Hium1rhE@magnolia>
 <CAOQ4uxj2vk4ZPXu20PM0hHCawTVdaY+z5=0WuN__UxwNRDK5+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj2vk4ZPXu20PM0hHCawTVdaY+z5=0WuN__UxwNRDK5+g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 24, 2022 at 10:36:15AM +0200, Amir Goldstein wrote:
> On Thu, Jun 23, 2022 at 6:05 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Jun 23, 2022 at 10:33:47AM +0300, Amir Goldstein wrote:
> > > On Thu, Jun 23, 2022 at 2:45 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > On Fri, Jun 17, 2022 at 01:06:30PM +0300, Amir Goldstein wrote:
> > > > > Hi all,
> > > > >
> > > > > Previously posted candidates for 5.10.y followed chronological release
> > > > > order.
> > > > >
> > > > > Parts 1 and 2 of fixes from v5.10..v5.12 have already been applied to
> > > > > v5.10.121.
> > > > >
> > > > > Part 3 (from 5.13) has already been posted for review [3] on June 6,
> > > > > but following feedback from Dave, I changed my focus to get the same
> > > > > set of patches tested and reviewed for 5.10.y/5.15.y.
> > > > >
> > > > > I do want to ask you guys to also find time to review part 3, because
> > > > > we have a lot of catching up to do for 5.10.y, so we need to chew at
> > > > > this debt at a reasonable rate.
> > > > >
> > > > > This post has the matching set of patches for 5.10.y that goes with
> > > > > Leah's first set of candidates for 5.15.y [1].
> > > > >
> > > > > Most of the fixes are from v5.15..v5.17 except for patch 11 (v5.18-rc1).
> > > > > All fix patches have been tagged with Fixes: by the author.
> > > > >
> > > > > The patches have been soaking in kdepops since Sunday. They passed more
> > > > > than 30 auto group runs with several different versions of xfsprogs.
> > > > >
> > > > > The differences from Leah's 5.15.y:
> > > > > - It is 11 patches and not 8 because of dependencies
> > > > > - Patches 6,7 are non-fixes backported as dependency to patch 8 -
> > > > >   they have "backported .* for dependency" in their commit message
> > > > > - Patches 3,4,11 needed changes to apply to 5.10.y - they have a
> > > > >   "backport" related comment in their commit message to explain what
> > > > >   changes were needed
> > > > > - Patch 10 is a fix from v5.12 that is re-posted as a dependency for
> > > > >   patch 11
> > > > >
> > > > > Darrick,
> > > > >
> > > > > As the author patches 4,11 and sole reviewer of patch 3 (a.k.a
> > > > > the non-cleanly applied patches), please take a closer look at those.
> > > > >
> > > > > Patch 10 has been dropped from my part 2 candidates following concerns
> > > > > raised by Dave and is now being re-posted following feedback from
> > > > > Christian and Christoph [2].
> > > > >
> > > > > If there are still concerns about patches 10 or 11, please raise a flag.
> > > > > I can drop either of these patches before posting to stable if anyone
> > > > > feels that they need more time to soak in master.
> > > >
> > > > At the current moment (keep in mind that I have 2,978 more emails to get
> > >
> > > Oh boy! Thank you for getting to my series so soon.
> > >
> > > > through before I'm caught up), I think it's safe to say that for patches
> > > > 1-5:
> > > >
> > > > Acked-by: Darrick J. Wong <djwong@kernel.org>
> > > >
> > > > (patch 9 also, but see the reply I just sent for that one about grabbing
> > > > the sync_fs fixes too)
> > > >
> > > > The log changes are going to take more time to go through, since that
> > > > stuff is always tricky and /not/ something for me to be messing with at
> > > > 4:45pm.
> > >
> > > Let's make it easier for you then.
> > > I already decided to defer patches 9-11.
> > >
> > > Since you already started looking at patches 6-8, if you want to finish
> > > that review let me know and I will wait, but if you prefer, I can also defer
> > > the log changes 6-8 and post them along with the other log fixes from 5.14.
> 
> Hi Darrick,
> 
> FYI, I started testing the log fixes backports from v5.14 along with
> the deferred
> patches 6-8 [1] with extra focus on recoveryloop tests.
> 
> I know that Leah is also testing another batch of 5.15-only patches, so she
> may yet post another 5.15-only series before my 5.10-only series.
> 
> In the meanwhile, if you have some spare time due to rc8, please try to
> look at the already posted patches 6-8 [2] that were deferred from the original
> stable submission per your request.

This is pretty difficult request -- while I /think/ the LSN->CSN
conversion for the upper layers in patch 7 is correct, I'm not as
familiar with where 5.10 is right now as I was when that series was
being proposed for upstream.

It /looks/ ok, but were I maintaining the 5.10 tree I'd be a lot more
comfortable if I had in hand all the results from running the long-soak
log recovery tests for a week.

(Which itself might be fairly difficult for 5.10...)

--D

> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/linux/commits/xfs-5.10.y-for-review
> [2] https://lore.kernel.org/linux-xfs/20220617100641.1653164-1-amir73il@gmail.com/
