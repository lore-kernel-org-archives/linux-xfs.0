Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8CFC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 15:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbiKOPfz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 10:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiKOPfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 10:35:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5F7A1B0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 07:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 124FAB81999
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 15:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF68BC433D6;
        Tue, 15 Nov 2022 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668526546;
        bh=41w+sR+2rH9mpCJOCBqslUdffeBzGMzNgm4vxxyg8TQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kUdzq4LuFhglKx4aOXPCyNWWs4VRVDArEh1ZU+858KrNIKj34oWyhtD7QqWD3PZVw
         mN0xLLTima5CcgvYtLy6lZVD9X6Bgrm0Jv4Y4S/f5fFp2tmdP8wKH3XwwsMjDVr3N/
         ID/zd+6nFikmSEnjZdWeKqZpqMZaV1GGza57byoK9y3OuWG7aG/cCp1m+8mUt5OmRY
         kLoLjfxgb0z2OHlSnqBM6/zlpgfjxNMMu5B3PjtxkFDjs6MASz3rHar8KbBdeZ8KCh
         yDo1lxkOl538O/HGD+LixQeVLGmAqKaT1SYUKrtxQT4HfAegc991OmSynk32EiHiYf
         9wXFkts+4GPVA==
Date:   Tue, 15 Nov 2022 16:35:41 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs-6.0.0 released
Message-ID: <20221115153541.xcabtoftrvmwoty4@andromeda>
References: <20221114113639.mxgewf2zjgokr6cb@andromeda>
 <MFdMcJkXExDqRlJ-aVz2XJ-M8bIadOqGWhtqEhPtyqrZekwtIe4ct1QDWmiwdlBWm34jZVsT-fASD8ubtjrWNQ==@protonmail.internalid>
 <Y3KUCsPH0rSv2Tzb@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3KUCsPH0rSv2Tzb@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2022 at 11:16:26AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 14, 2022 at 12:36:39PM +0100, Carlos Maiolino wrote:
> > Hi folks,
> >
> > The xfsprogs repository at:
> >
> >         git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> >
> > has just been updated and tagged for a v6.0.0 release. The condensed changelog
> > since v6.0.0-rc0 is below.
> >
> > Tarballs are available at:
> >
> > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.gz
> > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.xz
> > https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.sign
> >
> > Patches often get missed, so please check if your outstanding
> > patches were in this update. If they have not been in this update,
> > please resubmit them to linux-xfs@vger.kernel.org so they can be
> > picked up in the next update.
> 
> That means I should requeue this pile of bugfixes
> https://lore.kernel.org/linux-xfs/166795950005.3761353.14062544433865007925.stgit@magnolia/T/#t
> 
> for 6.1, right?

No need for re-sending it, I'll make sure to queue these patches.

> 
> --D
> 
> > The new head of the master branch is commit:
> >
> > 3498b6802 xfsprogs: Release v6.0.0
> >
> > New Commits:
> >
> > Andrey Albershteyn (5):
> >       [f103166a9] xfs_quota: separate quota info acquisition into get_dquot()
> >       [2c1e7aefd] xfs_quota: separate get_dquot() and dump_file()
> >       [79e651743] xfs_quota: separate get_dquot() and report_mount()
> >       [6c007276a] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
> >       [f2fde322d] xfs_quota: apply -L/-U range limits in uid/gid/pid loops
> >
> > Carlos Maiolino (1):
> >       [3498b6802] xfsprogs: Release v6.0.0
> >
> > Jakub Bogusz (1):
> >       [f034a3215] Polish translation update for xfsprogs 5.19.0.
> >
> > Xiaole He (1):
> >       [d878935dd] xfs_db: use preferable macro to seek offset for local dir3 entry fields
> >
> >  VERSION          |     2 +-
> >  configure.ac     |     2 +-
> >  db/dir2sf.c      |     6 +-
> >  debian/changelog |     6 +
> >  doc/CHANGES      |     5 +
> >  po/pl.po         | 21351 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------
> >  quota/report.c   |   343 ++-
> >  7 files changed, 11248 insertions(+), 10467 deletions(-)
> >
> >
> > I needed to do a forced update to the tree, to fix a patch authoring mistake,
> > since both push and forced push were done only a few minutes apart, I hope it
> > didn't cause any trouble for anyone, otherwise, please accept my apologies.
> >
> > --
> > Carlos Maiolino

-- 
Carlos Maiolino
