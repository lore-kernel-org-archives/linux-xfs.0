Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A560BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 16:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbiF2QRI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 12:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiF2QRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 12:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419E631936
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 09:17:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3D2BB82572
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 16:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD3C34114;
        Wed, 29 Jun 2022 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656519423;
        bh=D95JN1wnA/SqyQpzhxJfeSjosu7wTDvz7M0CHReCN0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NsisMkS/X455+OzeWD5AKvp9y/l0o1J6mrmYj/+KstO/UFreuzYTuPYmMmXp+ua0y
         xgz8iMrOCsm/kxa2M/dz3nEN6pX9dnjzMgfI7iVrk3WKE4awLMcDTdnC/xlulFqM9d
         Z3Fr1VD0TS51N5qKVEhoIy62xfy1w6w8E4nC+oz6SPoCyB+zz2PvnApPdEWWK0ssAB
         3A630Suu4apVUakxHHmzUdb8yKNX8F5msqqZqa1KGPvA4WgeRGPR8pwImC9OBpcoiP
         UlnqOymQ9I3YhJSeJqKS/xBIVw8uB4Mggf+Sd2zeNWXH6PtfWSgpiKyMQFHKj+G7xK
         1PIb2/7wOCt0Q==
Date:   Wed, 29 Jun 2022 09:17:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Ayushman Dutta <ayushman999@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: syzkaller@googlegroups.com
Message-ID: <Yrx6/0UmYyuBPjEr@magnolia>
References: <CA+6OtaVMKW=K2mfbi=3A7fuPw2BmHv-zcx2jVKg9yEEY4wab3g@mail.gmail.com>
 <Yrt7t2Y1tsgAUFAr@magnolia>
 <20220628224453.GL227878@dread.disaster.area>
 <CAOQ4uxiWBMZSy9R9KNFKf5ptqM38naaSS5vLY2hdbYLvT0L5VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiWBMZSy9R9KNFKf5ptqM38naaSS5vLY2hdbYLvT0L5VA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 07:32:43AM +0300, Amir Goldstein wrote:
> On Wed, Jun 29, 2022 at 1:52 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Tue, Jun 28, 2022 at 03:07:51PM -0700, Darrick J. Wong wrote:
> > > [+linux-xfs]
> > >
> > > On Tue, Jun 28, 2022 at 02:27:36PM -0500, Ayushman Dutta wrote:
> > > > Kernel Version: 5.10.122
> > > >
> > > > Kernel revision: 58a0d94cb56fe0982aa1ce9712e8107d3a2257fe
> > > >
> > > > Syzkaller Dashboard report:
> > > >
> > > > ------------[ cut here ]------------
> > > > WARNING: CPU: 1 PID: 8503 at mm/util.c:618 kvmalloc_node+0x15a/0x170
> > > > mm/util.c:618
> > >
> > > No.  Do not DM your syzbot reports to random XFS developers.
> > >
> > > Especially do not send me *three message* with 300K of attachments; even
> > > the regular syzbot runners dump all that stuff into a web portal.
> > >
> > > If you are going to run some scripted tool to randomly
> > > corrupt the filesystem to find failures, then you have an
> > > ethical and moral responsibility to do some of the work to
> > > narrow down and identify the cause of the failure, not just
> > > throw them at someone else to do all the work.
> >
> > /me reads the stack trace, takes 30s to look at the change log,
> > finds commit 29d650f7e3ab ("xfs: reject crazy array sizes being fed
> > to XFS_IOC_GETBMAP*").
> >
> 
> I don't have the syzbot link here, but I assume this is reproducible
> and not reproducing on mainline, so in fact syzbot should be capable
> of finding the fix commit itself.
> 
> If syzbot can hear me, next time you find an xfs bug that is reproducible
> on 5.10.y and not on mainline, you may send it to me.

I suspect this guy is /not/ affiliated with the actual googlers who run
syzbot internally, which is why there's no link to their web app.

> Darrick, if you want to find a creative way to encode that request
> in MAINTAINERS as you suggested, that is fine by me.
> It should be something that makes it easy to teach the few bots that run
> on LTS kernels to find the right recipients and spam us instead of you.
> We could add a P: Subsystem Profile document, which contains stable
> maintainers info but that is less robot friendly.
> I don't have a better idea.

Yeah, I'll email the rest of the xfs lts cabal about that.

> This fix patch is in my xfs-5.10.y queue - it will probably take several
> weeks/month until it gets reviewed. I could expedite it if anyone
> feels that I should.

I don't care, but the people who think that /any/ backtrace in dmesg
might, even though this one in particular logs the warning and returns
ENOMEM.

--D

> Thanks,
> Amir.
