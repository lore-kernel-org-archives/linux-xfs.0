Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F76AC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDLDuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDLDuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:50:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D499A40D7
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69709629DF
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7163C433D2;
        Wed, 12 Apr 2023 03:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271400;
        bh=eg2PzQ/bAS9Le06OYNQPLcSWbbhtonLngp4I16kgIBQ=;
        h=Date:Subject:From:To:Cc:From;
        b=QBPII7zQMf73m8AMqbNACvPhkKBXUmhFn1fjgV/FvZmRu+0Cvc8+IjRCdNJc8jBPE
         j/3AGZYwd4Zx03FfbUH80Or3kY+HIJSaw1fgPYi+sh6qyr9N9bhhfBeeYuvLZR/z4o
         IOE+JswVsYePKWS1jxDSxzKQjkAtjzgISKdTl4jQoGru4TKcIdBCs9y4Wjln4SAZlt
         xj0Ds4xkflctE3AI35PVfIivCR234wc/UhhyWuYHIdDfftm990fTCM17U8oVDufXFw
         ERtRiKZowhOJJfsptrMXBGyz9FNs5Vra1WqUyqwyKwSD8IxkSY6O7V1DnhDbFwCCko
         S3P0JX6twUOBQ==
Date:   Tue, 11 Apr 2023 20:50:00 -0700
Subject: [GIT PULL 20/22] xfs: strengthen rmapbt scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127095646.417736.15195904792324204986.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 6772fcc8890ae34595253fcfb8196c1aea65e111:

xfs: convert xbitmap to interval tree (2023-04-11 19:00:36 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-strengthen-rmap-checking-6.4_2023-04-11

for you to fetch changes up to 4f5e304248ab4939e9aef58244041c194f01f0b5:

xfs: cross-reference rmap records with refcount btrees (2023-04-11 19:00:39 -0700)

----------------------------------------------------------------
xfs: strengthen rmapbt scrubbing [v24.5]

This series strengthens space allocation record cross referencing by
using AG block bitmaps to compute the difference between space used
according to the rmap records and the primary metadata, and reports
cross-referencing errors for any discrepancies.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: introduce bitmap type for AG blocks
xfs: cross-reference rmap records with ag btrees
xfs: cross-reference rmap records with free space btrees
xfs: cross-reference rmap records with inode btrees
xfs: cross-reference rmap records with refcount btrees

fs/xfs/Makefile       |   2 +-
fs/xfs/scrub/bitmap.c |  55 ++++++++++
fs/xfs/scrub/bitmap.h |  72 +++++++++++++
fs/xfs/scrub/repair.h |   1 +
fs/xfs/scrub/rmap.c   | 283 +++++++++++++++++++++++++++++++++++++++++++++++++-
5 files changed, 411 insertions(+), 2 deletions(-)

