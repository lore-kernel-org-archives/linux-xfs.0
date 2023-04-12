Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B8AC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjDLDt0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDLDtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7024C2C
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:49:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A65D62D90
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E37C433EF;
        Wed, 12 Apr 2023 03:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271354;
        bh=Uv+TZMzDGXZPHuHxIbJ1NvfvAk0l5MaI6q+K9knhyus=;
        h=Date:Subject:From:To:Cc:From;
        b=hM2COnbJEYs/G4rNoqBfbI3k8bLb/wD8SFztSIb5RHiNTk4YRPXpRhwh8N2ldKSac
         XskmbMksm3QDHdarRO9t1Ai5ZGguMFtsWdz0lbVmIywnYmLZw7U+XWaY5Qaq1af6ZD
         IhMMb2jpAV3zhn1CmSLCPaBlJCa6BJ6xcxNvjAxqBjl+ux9HDvAKBxTk3+iEU0GYpc
         AyRiYa3boJPs4ufqpnq6U39YQBKU408383k9cXGHi21MLsji6sOF5DBgdbwLC3m0Ck
         /jWj+EPbZk/KDvVhfxqvhXwmObMDhRGCoDPMqjMeF4XA4XI2eEsvaEiE2R78UWs12F
         tq+3NhvTJvp0g==
Date:   Tue, 11 Apr 2023 20:49:13 -0700
Subject: [GIT PULL 17/22] xfs: detect mergeable and overlapping btree records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127095343.417736.18039725981807061339.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 1e59fdb7d6157ff685a250e0873a015a2b16a4f2:

xfs: don't call xchk_bmap_check_rmaps for btree-format file forks (2023-04-11 19:00:26 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-detect-mergeable-records-6.4_2023-04-11

for you to fetch changes up to 1c1646afc96783702f92356846d6e47e0bbd6b11:

xfs: check for reverse mapping records that could be merged (2023-04-11 19:00:28 -0700)

----------------------------------------------------------------
xfs: detect mergeable and overlapping btree records [v24.5]

While I was doing differential fuzz analysis between xfs_scrub and
xfs_repair, I noticed that xfs_repair was only partially effective at
detecting btree records that can be merged, and xfs_scrub totally didn't
notice at all.

For every interval btree type except for the bmbt, there should never
exist two adjacent records with adjacent keyspaces because the
blockcount field is always large enough to span the entire keyspace of
the domain.  This is because the free space, rmap, and refcount btrees
have a blockcount field large enough to store the maximum AG length, and
there can never be an allocation larger than an AG.

The bmbt is a different story due to its ondisk encoding where the
blockcount is only 21 bits wide.  Because AGs can span up to 2^31 blocks
and the RT volume can span up to 2^52 blocks, a preallocation of 2^22
blocks will be expressed as two records of 2^21 length.  We don't
opportunistically combine records when doing bmbt operations, which is
why the fsck tools have never complained about this scenario.

Offline repair is partially effective at detecting mergeable records
because I taught it to do that for the rmap and refcount btrees.  This
series enhances the free space, rmap, and refcount scrubbers to detect
mergeable records.  For the bmbt, it will flag the file as being
eligible for an optimization to shrink the size of the data structure.

The last patch in this set also enhances the rmap scrubber to detect
records that overlap incorrectly.  This check is done automatically for
non-overlapping btree types, but we have to do it separately for the
rmapbt because there are constraints on which allocation types are
allowed to overlap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: flag free space btree records that could be merged
xfs: flag refcount btree records that could be merged
xfs: check overlapping rmap btree records
xfs: check for reverse mapping records that could be merged

fs/xfs/scrub/alloc.c    |  29 ++++++++++-
fs/xfs/scrub/refcount.c |  44 +++++++++++++++++
fs/xfs/scrub/rmap.c     | 126 +++++++++++++++++++++++++++++++++++++++++++++++-
3 files changed, 196 insertions(+), 3 deletions(-)

