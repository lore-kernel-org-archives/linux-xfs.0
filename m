Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAC1CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 00:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjJSAAw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjJSAAw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 20:00:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3166113
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 17:00:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62840C433C7;
        Thu, 19 Oct 2023 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697673650;
        bh=hAQrBBv0TmE6mb0frVNInHAN4MCrTwRWM/XcW9Cos78=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VjtJjnihIoZEjwG7HdzfmfDHk40QLHLMhMLxlj1eP+LsFl19UIx9ywjVr9x6YJZwX
         lUbXI0MmDnYXqcdQcJgIvP4vX+xp8OSKuBH6pws7yOm/abMFEkVY7niO0zRMch36xI
         ICZRX4nYvehlCqYeaVBWdbxvhl63gQvxEZ0l7rnFhCUvmZabhMMN4t/roadQbeVnyf
         /pGHxsJfEsVHlmR2cFhUbgrLoEFkCxKfk7uEtfV51hwxACdW6MUynbYBk1879RhsNA
         zN74XBWD3b34/nBArtL0zG/qwa3au7DvSI8yxZshbXUaNtO8iu/T3qHISztb6U4fcQ
         nBIUt6gz4+kHg==
Subject: [PATCHSET v2.2 0/9] xfs: CPU usage optimizations for realtime
 allocator
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, osandov@fb.com,
        linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Date:   Wed, 18 Oct 2023 17:00:49 -0700
Message-ID: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is [Omar']s version 2 of his XFS realtime allocator opimization patch
series.

Changes since v1 [1]:

- Fixed potential overflow in patch 4.
- Changed deprecated typedefs to normal struct names
- Fixed broken indentation
- Used xfs_fileoff_t instead of xfs_fsblock_t where appropriate.
- Added calls to xfs_rtbuf_cache_relse anywhere that the cache is used
  instead of relying on the buffers being dirtied and thus attached to
  the transaction.
- Clarified comments and commit messages in a few places.
- Added Darrick's Reviewed-bys.

Cover letter from v1:

Our distributed storage system uses XFS's realtime device support as a
way to split an XFS filesystem between an SSD and an HDD -- we configure
the HDD as the realtime device so that metadata goes on the SSD and data
goes on the HDD.

We've been running this in production for a few years now, so we have
some fairly fragmented filesystems. This has exposed various CPU
inefficiencies in the realtime allocator. These became even worse when
we experimented with using XFS_XFLAG_EXTSIZE to force files to be
allocated contiguously.

This series adds several optimizations that don't change the realtime
allocator's decisions, but make them happen more efficiently, mainly by
avoiding redundant work. We've tested these in production and measured
~10% lower CPU utilization. Furthermore, it made it possible to use
XFS_XFLAG_EXTSIZE to force contiguous allocations -- without these
patches, our most fragmented systems would become unresponsive due to
high CPU usage in the realtime allocator, but with them, CPU utilization
is actually ~4-6% lower than before, and disk I/O utilization is 15-20%
lower.

Patches 2 and 3 are preparations for later optimizations; the remaining
patches are the optimizations themselves.

1: https://lore.kernel.org/linux-xfs/cover.1687296675.git.osandov@osandov.com/

v2.1: djwong rebased everything atop his own cleanups, added dave's rtalloc_args
v2.2: rebase with new apis and clean them up too

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtalloc-speedups-6.7
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  525 +++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   97 +++++---
 fs/xfs/scrub/rtsummary.c     |   13 +
 fs/xfs/xfs_mount.h           |    6 
 fs/xfs/xfs_rtalloc.c         |  471 ++++++++++++++++++--------------------
 5 files changed, 554 insertions(+), 558 deletions(-)

