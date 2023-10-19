Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4B8CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjJSQUQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbjJSQUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:20:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E812A
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:20:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4BAC433C8;
        Thu, 19 Oct 2023 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732413;
        bh=W1CacFGXGGD4vzTfX1CswgvWcKEZPkWdgbwzXPAAs48=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GHEpuFXkN5g8NtZvbfkS36UEIByxnLZfbaMXcBcUf72KmJC2VA6WPlH9wmzk9wXM1
         VzDF3fKeD8zKcGXXs6inSU6s5yBZgu2VAhYzxrtedIaWiv3zdNwtsulRvQmIp9wFHE
         TcQOL4C8o31liqBuXonFlBvKT2u+RygVw0Xl4ZVo5BOepgscUWxacrdLQZSWvW2F0w
         u69Fu9iK4zSWQwQm7gf7ns26dDJfKz8POBBPEjNps3usH01skwQpXNpxpWqcywNp6T
         SEREFT5xC6YghIjNxDdYv8tKiO7kxi6nbJZTpL9S5ii13EoK2D5liInO1PeZhMpprb
         jnYnbmjO7bBag==
Date:   Thu, 19 Oct 2023 09:20:13 -0700
Subject: [PATCHSET v1.1 0/8] xfs: clean up realtime type usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
In-Reply-To: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
References: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The realtime code uses xfs_rtblock_t and xfs_fsblock_t in a lot of
places, and it's very confusing.  Clean up all the type usage so that an
xfs_rtblock_t is always a block within the realtime volume, an
xfs_fileoff_t is always a file offset within a realtime metadata file,
and an xfs_rtxnumber_t is always a rt extent within the realtime volume.

v1.1: various cleanups suggested by hch

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=clean-up-realtime-units-6.7
---
 fs/xfs/libxfs/xfs_bmap.c     |    8 +
 fs/xfs/libxfs/xfs_format.h   |    2 
 fs/xfs/libxfs/xfs_rtbitmap.c |  121 ++++++++++----------
 fs/xfs/libxfs/xfs_rtbitmap.h |   79 +++++++++++++
 fs/xfs/libxfs/xfs_types.c    |    4 -
 fs/xfs/libxfs/xfs_types.h    |    8 +
 fs/xfs/scrub/bmap.c          |    2 
 fs/xfs/scrub/fscounters.c    |    2 
 fs/xfs/scrub/rtbitmap.c      |   12 +-
 fs/xfs/scrub/rtsummary.c     |    4 -
 fs/xfs/scrub/trace.h         |    7 +
 fs/xfs/xfs_bmap_util.c       |   18 +--
 fs/xfs/xfs_fsmap.c           |    2 
 fs/xfs/xfs_rtalloc.c         |  248 +++++++++++++++++++++++-------------------
 fs/xfs/xfs_rtalloc.h         |   89 +--------------
 15 files changed, 319 insertions(+), 287 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h

