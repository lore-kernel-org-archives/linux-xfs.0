Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72841ECAAD4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 15:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiHaPIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Aug 2022 11:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiHaPIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Aug 2022 11:08:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D435300E
        for <linux-xfs@vger.kernel.org>; Wed, 31 Aug 2022 08:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17313B817AC
        for <linux-xfs@vger.kernel.org>; Wed, 31 Aug 2022 15:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE50C433D6;
        Wed, 31 Aug 2022 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661958491;
        bh=ilS5kqDYJORYjrCCHFFVHK/BNKw6bb72i2ntLiPDljY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUhqeC9LyzAEKl+QiMPlLQtPcK98/ndv8L8QXMWS9OJHI0dUKEKUkfKeyqtxOjHRL
         a83RINUMSf+EfeSGM8Da6DvNNvTl58IZ5ObD6uSqCHEBHfSZRwukAJJDZAqzFL2GwA
         o2rT9nBCvuE+EPg6AW1dr6MSfiUEN6gP5IxbZ2/JlsD6VfoEySy85Vhm0SNkGGVVpv
         g/O7SMRaebD7t5W4Bwjz4TDTRNYZNRcAhhhbiVunIy08rWptNH4FbA0Y3iYdFODj2a
         jP0T9Osg6ZGFkUe6ouV1UnA4ZwUSePg1F6mF2ehlXFAJ4QrBiFYXnPBqL5YWlmnSxq
         0n222G1Fr1XcQ==
Date:   Wed, 31 Aug 2022 08:08:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs for-next updated
Message-ID: <Yw95W6ZAvBqQe7qf@magnolia>
References: <20220830115220.5s2nlztp56fbf4xa@andromeda>
 <rlkM2eJNcyQy7rV6YFRttkV5Yq3MmPS6qjlDjTNpzPw-H5ShdMRTb6j_nnN1KmJ4nObvtiv45xwd1cm7No9Nyg==@protonmail.internalid>
 <Yw4o0fBFRqrCHQsY@magnolia>
 <20220831094325.5dwjygbcd5mcibok@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831094325.5dwjygbcd5mcibok@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 31, 2022 at 11:43:25AM +0200, Carlos Maiolino wrote:
> On Tue, Aug 30, 2022 at 08:12:17AM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 30, 2022 at 01:52:20PM +0200, Carlos Maiolino wrote:
> > > Hi folks,
> > >
> > > The for-next branch of the xfsprogs repository at:
> > >
> > >         git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > >
> > > has just been updated.
> > >
> > > This update contains the initial libxfs sync to Linux 6.0 and should be turned
> > > into -rc0 once it (hopefully) gets some testing (and no complains) for more people.
> > 
> > Wooo, welcome, new maintainer! :)
> 
> \o/
> 
> > 
> > > Please, if any questions, let me know.
> > 
> > For the repair deadlock fix[1], do you want me to pin the primary
> > superblock buffer to the xfs_mount like Dave suggested in [2]?
> 
> I'd rather have it pinned to the xfs_mount as it's often accessed, do you think
> it is doable (you mentioned you've ran into many problems with that)?

Oh, the usual problems of adding a new interface...

1. Who is responsible for setting m_sb_bp?

Should libxfs_mount attach m_sb_bp?  Should individual programs decide
to do that if they require the functionality?  Should we instead have a
xfs_getsb function that returns m_sb_bp if set, or libxfs_getbufr's a
new buffer and tries to cmpxchg it with the pointer?

What about mkfs, which needs to libxfs_mount before it's even written
anything to disk?

2. Should it be a cached buffer so that any other program (e.g. xfs_db)
doing open-coded accesses of the superblock will get the same cached
buffer, or should it be uncached like the kernel?

If we decide on uncached, this will necessitate a full audit of xfsprogs
to catch open-coded calls to libxfs_getbuf for the primary super, or
else coherency problems will result.

If we decide on using a cached buffer and setting it in libxfs_mount,
then the part of xfs_repair that tears down the buffer cache and
reinitializes it with a different hash size will also have to learn to
brelse m_sb_bp before destroying the cache and re-assign it afterwards.
Alternately, I suppose it could learn to rehash itself.

This is a /lot/ to think about to solve one problem in one program.

> I didn't have time to try to reproduce those deadlocks yet though.

If you modify cache_node_get like this to make reclaim more aggressive:

diff --git a/libxfs/cache.c b/libxfs/cache.c
index 139c7c1b..b5e1bcf8 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -448,10 +448,10 @@ cache_node_get(
 		/*
 		 * not found, allocate a new entry
 		 */
+		priority = cache_shake(cache, priority, false);
 		node = cache_node_allocate(cache, key);
 		if (node)
 			break;
-		priority = cache_shake(cache, priority, false);
 		/*
 		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
 		 * back the same priority, if not we get back priority+1.

It's trivially reproducible with xfs_repair (do not specify -n).

--D

> > 
> > [1] https://lore.kernel.org/linux-xfs/166007921743.3294543.7334567013352169774.stgit@magnolia/
> > [2] https://lore.kernel.org/linux-xfs/20220811221541.GQ3600936@dread.disaster.area/
> 
> -- 
> Carlos Maiolino
