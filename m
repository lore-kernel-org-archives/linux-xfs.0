Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789CAC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Dec 2022 16:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiLIQbc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Dec 2022 11:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiLIQbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2022 11:31:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614DB85D08
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 08:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23080B82894
        for <linux-xfs@vger.kernel.org>; Fri,  9 Dec 2022 16:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF646C433F0;
        Fri,  9 Dec 2022 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670603488;
        bh=NOB+N9POaciT0D4+azzAyDAg0me8yz1kzaljP4ixy0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a356opoaeXTxiE9KrQ75dVp2DxkFmGpOqsG/9JSyfVvVnsf3PLb4SN57W7WM/cQ7o
         WQJV/jHwYRWIZdM8BlkZCOX8gS2pDuIEFviDBouuxVPBjIi9c+O4jBoj1TdYM76pF/
         vASwPQZbTWpKaYihjzZQQ4Ma+Ri1XamdQZc+WBU1/0JtU6vCgwCZ5jhTrLbC0ExwkX
         x1AMlVWWjJFG6anm4qQJz37Q9O9h6AcxYQlOFHPJOfE8ybo+N52LZco9yRqUwcf9uk
         jCRdI1CoPzdlxXRLkC4awkz/JecbyzyJ+AKgAyxsC1uca7TpXvPrcEqH37OrqqER5d
         3VLqT/BujDS/Q==
Date:   Fri, 9 Dec 2022 08:31:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/9] xfsprogs: random fixes for 6.1
Message-ID: <Y5Ni4PJ+fZLo8lIp@magnolia>
References: <-I-A6mYlvGXZxmIaxIGm-2ZMrd2rhOOQruX8Y9AicksvGaoRMIwwd1VbgylGm0sx8N7VdVJNSuOmeXyLbGBIDw==@protonmail.internalid>
 <166922333463.1572664.2330601679911464739.stgit@magnolia>
 <20221209085932.iclu56hrslflcdnq@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209085932.iclu56hrslflcdnq@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 09, 2022 at 09:59:32AM +0100, Carlos Maiolino wrote:
> On Wed, Nov 23, 2022 at 09:08:54AM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is a rollup of all the random fixes I've collected for xfsprogs
> > 6.1.  At this point it's just an assorted collection, no particular
> > theme.  Many of them are verbatim repostings from the 6.0 series.
> > There's also a mkfs config file for the 6.1 LTS.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> 
> I've reviewed these patches before, except the last 2, which seems fine too. So,
> for the whole series:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cool, thank you!

--D


> > 
> > --D
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.1
> > ---
> >  db/btblock.c             |    2 +
> >  db/check.c               |    4 +-
> >  db/namei.c               |    2 +
> >  db/write.c               |    4 +-
> >  io/pread.c               |    2 +
> >  libfrog/linux.c          |    1 +
> >  libxfs/libxfs_api_defs.h |    2 +
> >  libxfs/libxfs_io.h       |    1 +
> >  libxfs/libxfs_priv.h     |    2 +
> >  libxfs/rdwr.c            |    8 +++++
> >  libxfs/util.c            |    1 +
> >  mkfs/Makefile            |    3 +-
> >  mkfs/lts_6.1.conf        |   14 ++++++++
> >  mkfs/xfs_mkfs.c          |    2 +
> >  repair/phase2.c          |    8 +++++
> >  repair/phase6.c          |    9 +++++
> >  repair/protos.h          |    1 +
> >  repair/scan.c            |   22 ++++++++++---
> >  repair/xfs_repair.c      |   77 ++++++++++++++++++++++++++++++++++++++++------
> >  scrub/inodes.c           |    2 +
> >  20 files changed, 139 insertions(+), 28 deletions(-)
> >  create mode 100644 mkfs/lts_6.1.conf
> > 
> 
> -- 
> Carlos Maiolino
