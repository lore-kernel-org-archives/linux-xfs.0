Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06761CDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 02:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjJRCKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 22:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjJRCKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 22:10:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E5CF7
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 19:10:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3698FC433C8;
        Wed, 18 Oct 2023 02:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697595020;
        bh=yXZVy3OmhUxdNsgOfMBuf/UXf8bfzLIOXDHLJZ1Xd3I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gCrFIJsNOGRXBJWKCiz03eumhDIs7WNoBhgyLK5J6hY8vhF+1VbDR2GWiwbYJsG3b
         sKMdFG7pHOzrwlPS9z9UzaAQgtNa38obMSmhL8aOFptFg7D4f1GUgWM/WOFgTsEegN
         Z8x0VMz/1BA7z47mY/y1S/i3CVSAv72MMM0Kp0TON0mYyLWbQPEpMNbuOktAEwxfJ6
         zGGH6NHDfFbOcUJO+un4t6X1waXhB8JhfpJW26n2cKxvPhJMWiMP8sVJQ1KF639P9p
         Zyk2B+6xyM/fGMEYFxhIleWiPaU5p6a4p4+GRt+SXC4eKfkiYwGFwpqr/O29vuGg19
         xCj4B6RtO3S8Q==
Subject: [PATCHSET RFC v1.2 0/4] xfs: refactor rtbitmap/summary accessors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com, hch@lst.de,
        linux-xfs@vger.kernel.org
Date:   Tue, 17 Oct 2023 19:10:19 -0700
Message-ID: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Since the rtbitmap and rtsummary accessor functions have proven more
controversial than the rest of the macro refactoring, split the patchset
into two to make review easier.

v1.1: various cleanups suggested by hch
v1.2: rework the accessor functions to reduce the amount of cursor
      tracking required, and create explicit bitmap/summary logging
      functions

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rtbitmap-accessors-6.7
---
 fs/xfs/libxfs/xfs_format.h   |   16 +++
 fs/xfs/libxfs/xfs_rtbitmap.c |  200 ++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   62 ++++++++++++-
 fs/xfs/scrub/rtsummary.c     |   30 ++++--
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   10 +-
 fs/xfs/xfs_ondisk.h          |    4 +
 fs/xfs/xfs_rtalloc.c         |   17 +---
 8 files changed, 216 insertions(+), 124 deletions(-)

