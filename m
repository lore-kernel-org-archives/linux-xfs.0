Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7446CC77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 16:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbjD0QE4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243466AbjD0QEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 12:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FC92D72
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 09:04:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 462F8631EE
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 16:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0853C433D2;
        Thu, 27 Apr 2023 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682611493;
        bh=wIIZKx+nOkuGNK9uYCSueGnMo3sop4xNVz2+SIeSkIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GWcFNaDiIomEMtUzkZe4+yE9l55ziT77Jbv2wcHc07CnuoQpsbLY/V6YKrCA4MBpH
         rkaDuj/lhEgcAzpxQnzWq9JCjkonmvlJK1tWzBE2AlBW/1Abmzz5fKTtIxHN/epPLR
         TqpQqZZ7OMns1MCMwfFp9fUT38LQl/GiRfEN8FwybPWcVO7JBCrOtY/Ccw6oNZBX8d
         +0g4dO5n7C/6l1xyghjoACe558Lvh0aV/HPl48hm+zZ0kWuv6Pz1Y/93LAzk+J5dJw
         8xWEGsyXywVN7nLyv8mQEbcxEq5+LbMiCm9gBwPr26492ktFOku11FbeUXjyYPsY8u
         u+ug2HB9DGHxQ==
Date:   Thu, 27 Apr 2023 09:04:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsdump: for-next updated to c3a72aa
Message-ID: <20230427160453.GE59245@frogsfrogsfrogs>
References: <20230424104756.naou6t6uig4wt6wj@andromeda>
 <iLkUAgB70UCuDQDDlb8K9vvMYLTjrlCBUoZavlAXibYVpIAUAmdCxQ5DTVNcxqVIs9veP-RT4gVpyuULhohb-Q==@protonmail.internalid>
 <20230424174531.GP360889@frogsfrogsfrogs>
 <20230427154810.2lqqlpnxsgh6gv6q@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427154810.2lqqlpnxsgh6gv6q@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 05:48:10PM +0200, Carlos Maiolino wrote:
> On Mon, Apr 24, 2023 at 10:45:31AM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 24, 2023 at 12:47:56PM +0200, Carlos Maiolino wrote:
> > > Hello.
> > >
> > > The xfsdump for-next branch, located at:
> > >
> > > https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/?h=for-next
> > >
> > > Has just been updated.
> > >
> > > Patches often get missed, so if your outstanding patches are properly reviewed on
> > > the list and not included in this update, please let me know.
> > 
> > Why does for-next diverge from master?
> > 
> > $ git log --oneline master | head -n15
> > acb8083 xfsdump: Release 3.1.12
> > aaaa57f xfsrestore: untangle inventory unpacking logic
> > 7b843fd xfsdump: fix on-media inventory stream packing
> > 6503407 xfsrestore: fix on-media inventory stream unpacking
> > 06dd184 xfsrestore: fix on-media inventory media unpacking
> > 8b6bbcf xfsdump: Release 3.1.11
> > 
> > $ git log --oneline for-next | head -n15
> > c3a72aa xfsrestore: fix rootdir due to xfsdump bulkstat misuse
> > aaaa57f xfsrestore: untangle inventory unpacking logic
> > 7b843fd xfsdump: fix on-media inventory stream packing
> > 6503407 xfsrestore: fix on-media inventory stream unpacking
> > 06dd184 xfsrestore: fix on-media inventory media unpacking
> > 8b6bbcf xfsdump: Release 3.1.11
> > 
> > aaaa57f -> c3a72aa (for-next)
> >    \-----> acb8083 (master)
> 
> D'oh :(
> 
> When I release 3.1.12, likely I didn't update for-next as I started to do on
> xfsprogs.
> 
> I'm going to fix it tomorrow. Will require a rebase on the for-next though :(
> Thanks a lot for spotting it, at least the issue won't be pushed to master.

Ah, ok.  No worries, I wanted to make sure that 3.1.12 was still a legit
release. :)

--D

> 
> > 
> > --D
> > 
> > >
> > > The new head of the for-next branch is commit:
> > >
> > > c3a72aabb22bb3a79ed0f09762e6d81c0cbdadd6
> > >
> > > 1 new commits:
> > >
> > > Gao Xiang (1):
> > >       [c3a72aa] xfsrestore: fix rootdir due to xfsdump bulkstat misuse
> > >
> > > Code Diffstat:
> > >
> > >  common/main.c         |  1 +
> > >  man/man8/xfsrestore.8 | 14 ++++++++++
> > >  restore/content.c     |  7 +++++
> > >  restore/getopt.h      |  4 +--
> > >  restore/tree.c        | 72 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > >  restore/tree.h        |  2 ++
> > >  6 files changed, 94 insertions(+), 6 deletions(-)
> > >
> > > --
> > > Carlos Maiolino
> 
> -- 
> Carlos Maiolino
