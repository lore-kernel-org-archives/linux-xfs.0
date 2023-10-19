Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA50CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjJSQVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbjJSQVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:21:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD32115
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:21:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31F4C433C7;
        Thu, 19 Oct 2023 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732476;
        bh=jdf/Yx7i9SsUG2xfzXMPDz1tw5a8EaN4Z7ppwUT+5oY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=khtfuuFLX66K8SR7wSqjZIMURvAUryvfsuZxjTlf4l0eDig1rIFS7Swaqc4mRuw0X
         rAqLTiG/MuE3Youe2szeYabd/RI6Lw0bBOmUZz0H2UlOR9as25ExrtT5YkblA8z+sL
         Xm3qvUdfbVoGoBtQiDvUCmuadkDqCYs2XeAPZishOHa4e+Jy4sIO3xuYrtxOTywS0h
         3scEs5ITTHur1MJ9ApQ6NyTXsScZQBkYdf55Pb6M6IP5vMBz2jElcQPoNFapOwBxGU
         i4rs743jQFdBGI+l0NNKdKfMe5cUmwm7dwOgnfYvq2Ag/rz3HkaKziRbnrsTsvfF/4
         H1cRqIw5my9+w==
Date:   Thu, 19 Oct 2023 09:21:16 -0700
Subject: [PATCHSET v2.3 0/9] xfs: CPU usage optimizations for realtime
 allocator
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        osandov@osandov.com, osandov@fb.com, hch@lst.de
Message-ID: <169773211712.225862.9408784830071081083.stgit@frogsfrogsfrogs>
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

This is version 2 of [Omar's] XFS realtime allocator opimization patch
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
v2.3: move struct definition around for lolz

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

