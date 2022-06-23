Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71125CCA481
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 16:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiFWQFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 12:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiFWQFN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 12:05:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348CC44A1C;
        Thu, 23 Jun 2022 09:05:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89C9BCE25BC;
        Thu, 23 Jun 2022 16:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84DEC3411B;
        Thu, 23 Jun 2022 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656000309;
        bh=MOPJ1SFOjh/McCvwfbTS5fOolF3LlkCPdK5POgIXvkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SYNOoB7S6CjvazdbgcfN+vaydj/iZeDrAy4DFUrF/mPQ6mcvBh0RojUc2SCnH5qRb
         WHMXXfd2WXItHttAS6DM0aVNiDKcp2gH3kKBRNS/kxNLjLC5WVvifuCjuwkkz12VmZ
         Ef0eEgp/B0udVlFobeZGW1T/DsPkN5jI+hAGcqWTW7/6p7XKDJ2a+EQ9bgFiywiAW9
         GL7jZCu0DvT2xAed4angR2xTD1lLztnFghDG9NDxxBVUHvrozXVzgu/GnWr/QJpjKz
         zsd5pnPJGQuSJKRifTKgbEap6asQdImOnhlv5RTgUadvTdCkEt16WFyFUjbfkOyVQz
         DFQxwC9eRdo3Q==
Date:   Thu, 23 Jun 2022 09:05:08 -0700
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
Message-ID: <YrSPNFZ+Hium1rhE@magnolia>
References: <20220617100641.1653164-1-amir73il@gmail.com>
 <YrOpmMzn9ArsR9Dy@magnolia>
 <CAOQ4uxhOAaYkWeKXz6M8681ZjFiOSOJQqmewoq+-P1O2oXhsOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhOAaYkWeKXz6M8681ZjFiOSOJQqmewoq+-P1O2oXhsOg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 10:33:47AM +0300, Amir Goldstein wrote:
> On Thu, Jun 23, 2022 at 2:45 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Fri, Jun 17, 2022 at 01:06:30PM +0300, Amir Goldstein wrote:
> > > Hi all,
> > >
> > > Previously posted candidates for 5.10.y followed chronological release
> > > order.
> > >
> > > Parts 1 and 2 of fixes from v5.10..v5.12 have already been applied to
> > > v5.10.121.
> > >
> > > Part 3 (from 5.13) has already been posted for review [3] on June 6,
> > > but following feedback from Dave, I changed my focus to get the same
> > > set of patches tested and reviewed for 5.10.y/5.15.y.
> > >
> > > I do want to ask you guys to also find time to review part 3, because
> > > we have a lot of catching up to do for 5.10.y, so we need to chew at
> > > this debt at a reasonable rate.
> > >
> > > This post has the matching set of patches for 5.10.y that goes with
> > > Leah's first set of candidates for 5.15.y [1].
> > >
> > > Most of the fixes are from v5.15..v5.17 except for patch 11 (v5.18-rc1).
> > > All fix patches have been tagged with Fixes: by the author.
> > >
> > > The patches have been soaking in kdepops since Sunday. They passed more
> > > than 30 auto group runs with several different versions of xfsprogs.
> > >
> > > The differences from Leah's 5.15.y:
> > > - It is 11 patches and not 8 because of dependencies
> > > - Patches 6,7 are non-fixes backported as dependency to patch 8 -
> > >   they have "backported .* for dependency" in their commit message
> > > - Patches 3,4,11 needed changes to apply to 5.10.y - they have a
> > >   "backport" related comment in their commit message to explain what
> > >   changes were needed
> > > - Patch 10 is a fix from v5.12 that is re-posted as a dependency for
> > >   patch 11
> > >
> > > Darrick,
> > >
> > > As the author patches 4,11 and sole reviewer of patch 3 (a.k.a
> > > the non-cleanly applied patches), please take a closer look at those.
> > >
> > > Patch 10 has been dropped from my part 2 candidates following concerns
> > > raised by Dave and is now being re-posted following feedback from
> > > Christian and Christoph [2].
> > >
> > > If there are still concerns about patches 10 or 11, please raise a flag.
> > > I can drop either of these patches before posting to stable if anyone
> > > feels that they need more time to soak in master.
> >
> > At the current moment (keep in mind that I have 2,978 more emails to get
> 
> Oh boy! Thank you for getting to my series so soon.
> 
> > through before I'm caught up), I think it's safe to say that for patches
> > 1-5:
> >
> > Acked-by: Darrick J. Wong <djwong@kernel.org>
> >
> > (patch 9 also, but see the reply I just sent for that one about grabbing
> > the sync_fs fixes too)
> >
> > The log changes are going to take more time to go through, since that
> > stuff is always tricky and /not/ something for me to be messing with at
> > 4:45pm.
> 
> Let's make it easier for you then.
> I already decided to defer patches 9-11.
> 
> Since you already started looking at patches 6-8, if you want to finish
> that review let me know and I will wait, but if you prefer, I can also defer
> the log changes 6-8 and post them along with the other log fixes from 5.14.
> That means that I have a 5 patch series ACKed and ready to go to stable.
> 
> Let me know what you prefer.

I wouldn't hold back on sending 1-5 to stable; yesterday was quick
triage of the list traffic to figure out who I could unblock most
rapidly.

--D

> Thanks,
> Amir.
