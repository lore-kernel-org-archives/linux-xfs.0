Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0CBC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjDLDrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDLDrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:47:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EAD30E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCFD062CAC
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33795C433D2;
        Wed, 12 Apr 2023 03:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271260;
        bh=TS6b2HixXPNkpr+JNBX9+RPj9tj8UxDgLVwThxPE9XM=;
        h=Date:Subject:From:To:Cc:From;
        b=pEM8wiWlxfdClHdlYdMdcmtaXkfTg1vl9VsjU4tpCYMyKy553Sy28atv2e8rasZLS
         cah3qnSXImHz9e6zi5jUrvry9lOYSHcx321uO2BPer5Ht2pH7tg7PweG8aXnvMsVmt
         p5WHGICI9G+P/RD1/kH/63stLCUx54jGmWAlyDw1mmBbYD4dSheTsGWlCpexnmhZHW
         n2k5Fz1p3L2Qy7mm5EK/5H/UXN8DpnvJnxRlMr3bg36HPRsHWYdQb8Fi0w7iShNTiw
         xfzISVsKvFxduUvtbO6vSMZBHSSjzy1BJfQI3MklGUehVW1TmWlzBKURNelMZtjpIu
         Kfo6UyXBlZTtA==
Date:   Tue, 11 Apr 2023 20:47:39 -0700
Subject: [GIT PULL 11/22] xfs: detect incorrect gaps in inode btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094761.417736.17953865523353006184.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 7ac14fa2bd22e99a06ae16382b394f697cfe2b8a:

xfs: ensure that all metadata and data blocks are not cow staging extents (2023-04-11 19:00:12 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-detect-inobt-gaps-6.4_2023-04-11

for you to fetch changes up to efc0845f5d3e253f7f46a60b66a94c3164d76ee3:

xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results (2023-04-11 19:00:15 -0700)

----------------------------------------------------------------
xfs: detect incorrect gaps in inode btree [v24.5]

This series continues the corrections for a couple of problems I found
in the inode btree scrubber.  The first problem is that we don't
directly check the inobt records have a direct correspondence with the
finobt records, and vice versa.  The second problem occurs on
filesystems with sparse inode chunks -- the cross-referencing we do
detects sparseness, but it doesn't actually check the consistency
between the inobt hole records and the rmap data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: remove pointless shadow variable from xfs_difree_inobt
xfs: clean up broken eearly-exit code in the inode btree scrubber
xfs: directly cross-reference the inode btrees with each other
xfs: convert xfs_ialloc_has_inodes_at_extent to return keyfill scan results

fs/xfs/libxfs/xfs_ialloc.c |  84 ++++++++------
fs/xfs/libxfs/xfs_ialloc.h |   5 +-
fs/xfs/scrub/ialloc.c      | 268 ++++++++++++++++++++++++++++++++++++---------
3 files changed, 269 insertions(+), 88 deletions(-)

