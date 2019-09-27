Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37F6C4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 17:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1A0420872
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 17:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfI0RSD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 13:18:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfI0RSD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Sep 2019 13:18:03 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE351155E0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 17:18:02 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97F20196B2
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 17:18:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 00/11] xfs: rework near mode extent allocation
Date:   Fri, 27 Sep 2019 13:17:51 -0400
Message-Id: <20190927171802.45582-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 27 Sep 2019 17:18:02 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's v5 of the near mode block allocation rework. This mostly consists
of various minor cleanups from v4. The only functional change is to
deactivate the cntbt cursor on finding a perfect extent in patch 8.
Thoughts, reviews, flames appreciated.

Brian

v5:
- Fix up active logic in patch 1.
- Fix busy_gen type.
- Change ->diff initialization value in proper patch.
- Deactivate cntbt cursor on location of perfect extent.
- Various aesthetic cleanups. 
v4: https://lore.kernel.org/linux-xfs/20190916121635.43148-1-bfoster@redhat.com/
- Fix up cursor active tracking type usage.
- Fix up cntbt lookup function signature.
- Added high level comment on optimized allocation algorithm.
- Split up series into smaller patches to separate refactoring from
  functional changes.
v3: https://lore.kernel.org/linux-xfs/20190815125538.49570-1-bfoster@redhat.com/
- Drop by-size and exact allocation rework bits.
- Add near mode last block scan.
- Add debug mode patch to randomly toggle near mode algos.
- Refactor cursor setup/lookup logic.
- Refactor minlen reverse scan to be common between near mode algos.
- Fix up logic to consistently prioritize extent size over locality.
- Add more useful tracepoints.
- Miscellaneous bug fixes and code/comment cleanups.
v2: https://marc.info/?l=linux-xfs&m=155854834815400&w=2
- Lift small mode refactoring into separate patch (retained review
  tag(s).
- Various logic cleanups and refactors.
- Push active flag down into btree cursor private area; eliminate cursor
  container struct.
- Refactor final allocation code. Fold xfs_alloc_ag_vextent_type() into
  caller and factor out accounting.                                                                                                                     
- Fix up tracepoints.
v1: https://marc.info/?l=linux-xfs&m=155742169729590&w=2
- Continued development (various fixes, refinements) on generic bits and
  near mode implementation.
- Added patches 4-6 to refactor exact, by-size and small allocation
  modes.
rfcv2: https://marc.info/?l=linux-xfs&m=155197946630582&w=2
- Dropped spurious initial refactoring.
- Added minlen functionality.
- Properly tied into near alloc path.
- General refactoring and cleanups.
rfcv1: https://marc.info/?l=linux-xfs&m=154479089914351&w=2

Brian Foster (11):
  xfs: track active state of allocation btree cursors
  xfs: introduce allocation cursor data structure
  xfs: track allocation busy state in allocation cursor
  xfs: track best extent from cntbt lastblock scan in alloc cursor
  xfs: refactor cntbt lastblock scan best extent logic into helper
  xfs: reuse best extent tracking logic for bnobt scan
  xfs: refactor allocation tree fixup code
  xfs: refactor and reuse best extent scanning logic
  xfs: refactor near mode alloc bnobt scan into separate function
  xfs: factor out tree fixup logic into helper
  xfs: optimize near mode bnobt scans with concurrent cntbt lookups

 fs/xfs/libxfs/xfs_alloc.c       | 897 ++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_alloc_btree.c |   1 +
 fs/xfs/libxfs/xfs_btree.h       |   3 +
 fs/xfs/xfs_trace.h              |  33 +-
 4 files changed, 547 insertions(+), 387 deletions(-)

-- 
2.20.1

