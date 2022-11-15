Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C43DC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 23:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiKOXSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKOXSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 18:18:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1414864E8
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 15:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CB83B818C7
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 23:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACCDC433D6;
        Tue, 15 Nov 2022 23:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668554307;
        bh=veiwJcOFFCOlUHD8yCj3kw7TI1S18lVCabc1+TOtGag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WArfAkgCtIjSANk6TrOmVyIVCnN0uozc35tShKqTP2GF2TwIdWK8LpxhO0n2XH1yk
         89nu/5G+QOVL04VdscG8IsHhYV5Cwg5v/0IUIoMRDNQDITBWeP9YiNpQ4mgLSTItAB
         11o1AqPeaayoUY2m3S0Fs4E1guRh8yXNgHw4pYSIhqSTL8cNrMtq+gbUiB0NeNvTUB
         4qp8Jg9O++Pi4GScJ69hU9DWU7xSwrCVmonLMW4a9a9cX2Z/LeXJlKe/j9Ei7L6C3E
         3/ErX21V0h0JilsNSiQOIrQdgZiFv1sF/0n0FEsvS1Aq9NjIyio64hAsYWIgfScv94
         b3YFSqQeBiOAQ==
Date:   Tue, 15 Nov 2022 15:18:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs-6.0.0 released
Message-ID: <Y3QeQ0Qjbi+zZ+Da@magnolia>
References: <20221114113639.mxgewf2zjgokr6cb@andromeda>
 <MFdMcJkXExDqRlJ-aVz2XJ-M8bIadOqGWhtqEhPtyqrZekwtIe4ct1QDWmiwdlBWm34jZVsT-fASD8ubtjrWNQ==@protonmail.internalid>
 <Y3KUCsPH0rSv2Tzb@magnolia>
 <20221115153541.xcabtoftrvmwoty4@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115153541.xcabtoftrvmwoty4@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 04:35:41PM +0100, Carlos Maiolino wrote:
> On Mon, Nov 14, 2022 at 11:16:26AM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 14, 2022 at 12:36:39PM +0100, Carlos Maiolino wrote:
> > > Hi folks,
> > >
> > > The xfsprogs repository at:
> > >
> > >         git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > >
> > > has just been updated and tagged for a v6.0.0 release. The condensed changelog
> > > since v6.0.0-rc0 is below.
> > >
> > > Tarballs are available at:
> > >
> > > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.gz
> > > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.xz
> > > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.sign
> > >
> > > Patches often get missed, so please check if your outstanding
> > > patches were in this update. If they have not been in this update,
> > > please resubmit them to linux-xfs@vger.kernel.org so they can be
> > > picked up in the next update.
> > 
> > That means I should requeue this pile of bugfixes
> > https://lore.kernel.org/linux-xfs/166795950005.3761353.14062544433865007925.stgit@magnolia/T/#t
> > 
> > for 6.1, right?
> 
> No need for re-sending it, I'll make sure to queue these patches.

Ok.  You might also want to push for-next ahead to match master, like
Eric used to.

--D

> > 
> > --D
> > 
> > > The new head of the master branch is commit:
> > >
> > > 3498b6802 xfsprogs: Release v6.0.0
> > >
> > > New Commits:
> > >
> > > Andrey Albershteyn (5):
> > >       [f103166a9] xfs_quota: separate quota info acquisition into get_dquot()
> > >       [2c1e7aefd] xfs_quota: separate get_dquot() and dump_file()
> > >       [79e651743] xfs_quota: separate get_dquot() and report_mount()
> > >       [6c007276a] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
> > >       [f2fde322d] xfs_quota: apply -L/-U range limits in uid/gid/pid loops
> > >
> > > Carlos Maiolino (1):
> > >       [3498b6802] xfsprogs: Release v6.0.0
> > >
> > > Jakub Bogusz (1):
> > >       [f034a3215] Polish translation update for xfsprogs 5.19.0.
> > >
> > > Xiaole He (1):
> > >       [d878935dd] xfs_db: use preferable macro to seek offset for local dir3 entry fields
> > >
> > >  VERSION          |     2 +-
> > >  configure.ac     |     2 +-
> > >  db/dir2sf.c      |     6 +-
> > >  debian/changelog |     6 +
> > >  doc/CHANGES      |     5 +
> > >  po/pl.po         | 21351 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------
> > >  quota/report.c   |   343 ++-
> > >  7 files changed, 11248 insertions(+), 10467 deletions(-)
> > >
> > >
> > > I needed to do a forced update to the tree, to fix a patch authoring mistake,
> > > since both push and forced push were done only a few minutes apart, I hope it
> > > didn't cause any trouble for anyone, otherwise, please accept my apologies.
> > >
> > > --
> > > Carlos Maiolino
> 
> -- 
> Carlos Maiolino
