Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E70CDB483
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjJQPq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbjJQPqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:46:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3C813A
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:46:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD90C433C9;
        Tue, 17 Oct 2023 15:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557608;
        bh=wB74DDD2ST5HotJurgrEIki/PTH4+X3+7En2oc/+QFk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cV67gzQuq2rp6uVKYnqXHXI2BOPSZ7qyRizH2Rwy9U/LrYlIE/v/cl1ejsGlll64x
         O+HkNiNOl4FB12phfe5mIjMDgjlsSRsJ5QCWn81yDHoYY+RP0h5W6HpMp9x1Dxh3Rj
         Bw7i0ICFCJiH9KSbLmsJvMhOkK07F82qYxVWTTKPHI6xyzqX6uUiibbSKLVdr/Oc46
         LH8R8e2KSyKQzlhO8QLWSSsc5DVeFi+p3oWkBnRglxOPhtbNLr1ca+QbM3aNTVdG1Y
         xL/XPdrKvQCUoRS+faHX4YYFzRHdxOVy03kGdcNCTfEfGKSs+qFFhSWhbBjSm66zde
         QXdnqOMmXDMTw==
Date:   Tue, 17 Oct 2023 08:46:47 -0700
Subject: [PATCHSET RFC 2.1 0/7] xfs: CPU usage optimizations for realtime
 allocator
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>,
        Dave Chinner <dchinner@redhat.com>, osandov@fb.com,
        osandov@osandov.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
In-Reply-To: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
References: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Hello,

This is version 2 of my XFS realtime allocator opimization patch series.

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

v2.1: djwong rebased everything atop his own clenaups, added dave's rtalloc_args

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtalloc-speedups-6.7
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  441 ++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   53 +++--
 fs/xfs/scrub/rtsummary.c     |   10 +
 fs/xfs/xfs_mount.h           |    6 -
 fs/xfs/xfs_rtalloc.c         |  455 ++++++++++++++++++++----------------------
 5 files changed, 476 insertions(+), 489 deletions(-)

