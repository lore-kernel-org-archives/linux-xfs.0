Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28760C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjDLDpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLDpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CFA40CA
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:45:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9430D62B68
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C14C433D2;
        Wed, 12 Apr 2023 03:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271151;
        bh=+icNcZKOhk8CPbPYm7ED0zOfkpvhR/bdV8kPsGCvIM4=;
        h=Date:Subject:From:To:Cc:From;
        b=XgdKH9enEeP+AcJxFIVNe/17mSX2EAw1xG4bHtK4bybdCvU+YzIPMaKqPJ2L9QcWF
         fUN/lHQClXxxTEVtKhFihf99krjJD0yocepYVgnr/Ci9LLSSAmZETpL1m1an8w/iHa
         1+pBYZVg/ZwuJaRLgeuzV1BeEkK2DCjkPd7dYQarwrMwmmkiRIOJne1KiwAQln413B
         4gIfzXRj0bjwQCsRdslhrBxPZfw1woFsyAU0eZb7dyAF0+6V3O5TrTe0RSGNafKBcL
         r+xLzaZQ+RQi2QYg4lvLFM9iAu1VHf5j4isSGAU4q1IuErCTjEh1ehvBkm0r13IcT3
         T9e34vDx2E62Q==
Date:   Tue, 11 Apr 2023 20:45:50 -0700
Subject: [GIT PULL 4/22] xfs_scrub: fix licensing and copyright notices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094049.417736.4769433461213675106.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 9b2e5a234c89f097ec36f922763dfa1465dc06f8:

xfs: create traced helper to get extra perag references (2023-04-11 18:59:55 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-fix-legalese-6.4_2023-04-11

for you to fetch changes up to ecc73f8a58c7844b04186726f8699ba97cec2ef9:

xfs: update copyright years for scrub/ files (2023-04-11 18:59:57 -0700)

----------------------------------------------------------------
xfs_scrub: fix licensing and copyright notices [v24.5]

Fix various attribution problems in the xfs_scrub source code, such as
the author's contact information, out of date SPDX tags, and a rough
estimate of when the feature was under heavy development.  The most
egregious parts are the files that are missing license information
completely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: fix author and spdx headers on scrub/ files
xfs: update copyright years for scrub/ files

fs/xfs/scrub/agheader.c        | 6 +++---
fs/xfs/scrub/agheader_repair.c | 6 +++---
fs/xfs/scrub/alloc.c           | 6 +++---
fs/xfs/scrub/attr.c            | 6 +++---
fs/xfs/scrub/attr.h            | 4 ++--
fs/xfs/scrub/bitmap.c          | 6 +++---
fs/xfs/scrub/bitmap.h          | 6 +++---
fs/xfs/scrub/bmap.c            | 6 +++---
fs/xfs/scrub/btree.c           | 6 +++---
fs/xfs/scrub/btree.h           | 6 +++---
fs/xfs/scrub/common.c          | 6 +++---
fs/xfs/scrub/common.h          | 6 +++---
fs/xfs/scrub/dabtree.c         | 6 +++---
fs/xfs/scrub/dabtree.h         | 6 +++---
fs/xfs/scrub/dir.c             | 6 +++---
fs/xfs/scrub/fscounters.c      | 4 ++--
fs/xfs/scrub/health.c          | 6 +++---
fs/xfs/scrub/health.h          | 6 +++---
fs/xfs/scrub/ialloc.c          | 6 +++---
fs/xfs/scrub/inode.c           | 6 +++---
fs/xfs/scrub/parent.c          | 6 +++---
fs/xfs/scrub/quota.c           | 6 +++---
fs/xfs/scrub/refcount.c        | 6 +++---
fs/xfs/scrub/repair.c          | 6 +++---
fs/xfs/scrub/repair.h          | 6 +++---
fs/xfs/scrub/rmap.c            | 6 +++---
fs/xfs/scrub/rtbitmap.c        | 6 +++---
fs/xfs/scrub/scrub.c           | 6 +++---
fs/xfs/scrub/scrub.h           | 6 +++---
fs/xfs/scrub/symlink.c         | 6 +++---
fs/xfs/scrub/trace.c           | 6 +++---
fs/xfs/scrub/trace.h           | 6 +++---
fs/xfs/scrub/xfs_scrub.h       | 6 +++---
33 files changed, 97 insertions(+), 97 deletions(-)

