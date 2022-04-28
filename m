Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6D0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 19:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbiD1TNw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 15:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbiD1TNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 15:13:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBF06D957
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 12:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99C0D61D8F
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 19:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC53C385A0;
        Thu, 28 Apr 2022 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651173034;
        bh=hZjGHiJo9cqpaAUv3RnNEVfi80M2544iMlDw/p6+hxY=;
        h=Date:From:To:Cc:Subject:From;
        b=iUL2Uz/VBI7Q6+SDmpavFN23cRcu8o6EYg3mM6oFrcuQAZbwQBvCw3WpMAQ/zNEC9
         3Mdl1WjtOF9jls+2iKb6qF5kenSTZPSwS8OYhd/8413oW+dOAfDZAHPc14AQCOX0vv
         Mc9MB47tcdStiEbp62xkx8odyrGdhwxagcMlC3mgQunMA6aFdLSjkBdQjgCOdEMwBN
         LFJZ+uXOWNCKNnn8wZ1Rz+uYe1BFTBRjVE7KxkwgnI9f3QNggYAnZeyhPGOmRO/Sm1
         LxiR+kNPfFav438wkhs4PZHERJcJjgdAlkokiuXdBV5pBVswTJzzpe65F+UcZ/cyg7
         gxsQo3tpas4MA==
Date:   Thu, 28 Apr 2022 12:10:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: fix rmap inefficiencies
Message-ID: <20220428191033.GO17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes since commit a44a027a8b2a20fec30e0e9c99b0eb41c03e7420:

  Merge tag 'large-extent-counters-v9' of https://github.com/chandanr/linux into xfs-5.19-for-next (2022-04-21 16:46:17 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/rmap-speedups-5.19_2022-04-28

for you to fetch changes up to 1edf8056131aca6fe7f98873da8297e6fa279d8c:

  xfs: speed up write operations by using non-overlapped lookups when possible (2022-04-28 10:24:38 -0700)

----------------------------------------------------------------
xfs: fix rmap inefficiencies

Reduce the performance impact of the reverse mapping btree when reflink
is enabled by using the much faster non-overlapped btree lookup
functions when we're searching the rmap index with a fully specified
key.  If we find the exact record we're looking for, great!  We don't
have to perform the full overlapped scan.  For filesystems with high
sharing factors this reduces the xfs_scrub runtime by a good 15%%.

This has been shown to reduce the fstests runtime for realtime rmap
configurations by 30%%, since the lack of AGs severely limits
scalability.

v2: simplify the non-overlapped lookup code per dave comments

----------------------------------------------------------------
Darrick J. Wong (4):
      xfs: capture buffer ops in the xfs_buf tracepoints
      xfs: simplify xfs_rmap_lookup_le call sites
      xfs: speed up rmap lookups by using non-overlapped lookups when possible
      xfs: speed up write operations by using non-overlapped lookups when possible

 fs/xfs/libxfs/xfs_rmap.c | 161 ++++++++++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rmap.h |   7 +--
 fs/xfs/scrub/bmap.c      |  24 ++-----
 fs/xfs/xfs_trace.h       |   5 +-
 4 files changed, 106 insertions(+), 91 deletions(-)
