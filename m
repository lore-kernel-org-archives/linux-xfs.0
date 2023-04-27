Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E73C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 15:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbjD0PsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 11:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243950AbjD0PsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 11:48:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C247698
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 08:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E14061726
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9B6C433D2;
        Thu, 27 Apr 2023 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682610494;
        bh=EmeKpevrzrO+ITxPGRBC1Up4PmxBE0MAuC3VImF4IYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=suiy5ojELo9BfFWLtaDC4Cbbe0UZ2TcBknP22J2XxulBZg5VIEKsVGntPWKfVZVBx
         /2zj5qc5k1Z15v8PTbo6nWOUzaakZokfjVRqQUpWvG3wUDuNeMJNKW1rUKwTZ2QFQN
         PGxNDC+7avWXkyupv0hFzPuYR4NWUXa8D1t6BiEEacaWz+wobz7eAKuymNT8DF6L+k
         5UGRMEuwvtx4ZKXoPqCeOoWLydpnhM8/N3bgZld06XEBERH+ISkRdFQJnpX0PkusGt
         s5yHRDDQAEVIr35zutu/xp+BC94DeLDB7B1Fhy31r1bj/EqZOBBURM1lDmYJwU5Q0g
         XxTC4tdijIQFw==
Date:   Thu, 27 Apr 2023 17:48:10 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsdump: for-next updated to c3a72aa
Message-ID: <20230427154810.2lqqlpnxsgh6gv6q@andromeda>
References: <20230424104756.naou6t6uig4wt6wj@andromeda>
 <iLkUAgB70UCuDQDDlb8K9vvMYLTjrlCBUoZavlAXibYVpIAUAmdCxQ5DTVNcxqVIs9veP-RT4gVpyuULhohb-Q==@protonmail.internalid>
 <20230424174531.GP360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424174531.GP360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 24, 2023 at 10:45:31AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 24, 2023 at 12:47:56PM +0200, Carlos Maiolino wrote:
> > Hello.
> >
> > The xfsdump for-next branch, located at:
> >
> > https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/?h=for-next
> >
> > Has just been updated.
> >
> > Patches often get missed, so if your outstanding patches are properly reviewed on
> > the list and not included in this update, please let me know.
> 
> Why does for-next diverge from master?
> 
> $ git log --oneline master | head -n15
> acb8083 xfsdump: Release 3.1.12
> aaaa57f xfsrestore: untangle inventory unpacking logic
> 7b843fd xfsdump: fix on-media inventory stream packing
> 6503407 xfsrestore: fix on-media inventory stream unpacking
> 06dd184 xfsrestore: fix on-media inventory media unpacking
> 8b6bbcf xfsdump: Release 3.1.11
> 
> $ git log --oneline for-next | head -n15
> c3a72aa xfsrestore: fix rootdir due to xfsdump bulkstat misuse
> aaaa57f xfsrestore: untangle inventory unpacking logic
> 7b843fd xfsdump: fix on-media inventory stream packing
> 6503407 xfsrestore: fix on-media inventory stream unpacking
> 06dd184 xfsrestore: fix on-media inventory media unpacking
> 8b6bbcf xfsdump: Release 3.1.11
> 
> aaaa57f -> c3a72aa (for-next)
>    \-----> acb8083 (master)

D'oh :(

When I release 3.1.12, likely I didn't update for-next as I started to do on
xfsprogs.

I'm going to fix it tomorrow. Will require a rebase on the for-next though :(
Thanks a lot for spotting it, at least the issue won't be pushed to master.


> 
> --D
> 
> >
> > The new head of the for-next branch is commit:
> >
> > c3a72aabb22bb3a79ed0f09762e6d81c0cbdadd6
> >
> > 1 new commits:
> >
> > Gao Xiang (1):
> >       [c3a72aa] xfsrestore: fix rootdir due to xfsdump bulkstat misuse
> >
> > Code Diffstat:
> >
> >  common/main.c         |  1 +
> >  man/man8/xfsrestore.8 | 14 ++++++++++
> >  restore/content.c     |  7 +++++
> >  restore/getopt.h      |  4 +--
> >  restore/tree.c        | 72 ++++++++++++++++++++++++++++++++++++++++++++++++---
> >  restore/tree.h        |  2 ++
> >  6 files changed, 94 insertions(+), 6 deletions(-)
> >
> > --
> > Carlos Maiolino

-- 
Carlos Maiolino
