Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820BAC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjEZA2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZA2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFAA18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19D0C64B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7095DC433D2;
        Fri, 26 May 2023 00:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685060889;
        bh=D4U+2/rqxt1DFTMiiMh7yKANLYmLkWmvmJeHTMLgWC4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VS0iVyUt7/IW0Sf+97LnE0cT78/ubvUqwY1kY/HGrujzoztJtHpfeED/ON5aH40xX
         LfY5m3dlMxswcTn4/ulcThitnCw4CotIe/s6R3RPqNp3qIA0IWHG1WDg+hr7aDF6SF
         cVfMp5EtEXVBW/kTn/HOT87i9zdEw5RwP21UkCdM6gc9fUhDEpk/ZBJOoCWmURINm6
         vOIhhI7oXgXunDOBaJAmWK93/+K8JXuoF/VnX527HdFqwrGFXUpSSofXkOMY9hv/Nw
         bc+ikSMWX0hMdAAQag6aSLfdR8yzjAVFuiP+ef41wG26NP8D1AvXyAxgI3qaIMUxh4
         NW8Cj9ucfO/Bg==
Date:   Thu, 25 May 2023 17:28:08 -0700
Subject: [PATCHSET 0/7] xfs: fix ranged queries and integer overflows in
 GETFSMAP
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As part of merging the parent pointers patchset into my development
branch, I noticed a few problems with the GETFSMAP implementation for
XFS.  The biggest problem is that ranged queries don't work properly if
the query interval is exactly within a single record.  It turns out that
I didn't implement the record filtering quite right -- for the first
call into the btree code, we want to find any rmap that overlaps with
the range specified, but for subsequent calls, we only want rmaps that
come after the low key of the query.  This can be fixed by tweaking the
filtering logic and pushing the key handling into the individual backend
implementations.

The second problem I noticed is that there are integer overflows in the
rtbitmap and external log handlers.  This is the result of a poor
decision on my part to use the incore rmap records for storing the query
ranges; this only works for the rmap code, which is smart enough to
iterate AGs.  This breaks down spectacularly if someone tries to query
high block offsets in either the rt volume or the log device.  I fixed
that by introducing a second filtering implementation based entirely on
daddrs.

The third problem was minor by comparison -- the rt volume cannot ever
use rtblocks beyond the end of the last rtextent, so it makes no sense
for GETFSMAP to try to query those areas.

Having done that, add a few more patches to clean up some messes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=getfsmap-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=getfsmap-fixes
---
 fs/xfs/libxfs/xfs_alloc.c    |   10 --
 fs/xfs/libxfs/xfs_refcount.c |   13 +-
 fs/xfs/libxfs/xfs_rmap.c     |   10 --
 fs/xfs/xfs_fsmap.c           |  261 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_trace.h           |   25 ++++
 5 files changed, 177 insertions(+), 142 deletions(-)

