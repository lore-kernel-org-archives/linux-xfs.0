Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfA1PUg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jan 2019 10:20:36 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB5B681DE9
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 15:20:35 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 607D419E34
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 15:20:35 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC v2 0/3] xfs: fix [f]inobt magic value verification
Date: Mon, 28 Jan 2019 10:20:31 -0500
Message-Id: <20190128152034.21080-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's another RFC of the [f]inobt magic value verifier fixups. This is
a bit more polished so I figured I'd send another to solicit any
feedback on the helpers and whatnot. I also put together a mitigation
patch to change over verifier and btree block verification errors into a
warning. I suppose it's debatable whether we want the latter but FWIW
the commit log description describes the reasoning for each mitigation.

Patch 1 is a straightforward creation of a finobt verifier, patch 2
implements the magic value verification and patch 3 implements the
aforementioned error mitigation. This has been tested, but note that
Darrick's recent scrub verifier patch[1] is required for patch 2. I had
a patch to address that in this series but dropped it since it's already
been posted. Thoughts, reviews, flames appreciated.

Brian

[1] https://marc.info/?l=linux-xfs&m=154861208322420&w=2

rfcv2:
- Split off finobt verifier into separate patch, assign it
  appropriately.
- Created helpers for xfs_buf_ops magic value verification.
- Added error mitigation patch for problematic finobt blocks.
rfcv1: https://marc.info/?l=linux-xfs&m=154834528212262&w=2

Brian Foster (3):
  xfs: create a separate finobt verifier
  xfs: distinguish between inobt and finobt magic values
  xfs: detect and warn about finobt blocks with an inobt magic value

 fs/xfs/libxfs/xfs_ag.c           |  2 +-
 fs/xfs/libxfs/xfs_btree.c        | 12 +++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c | 43 ++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_shared.h       |  1 +
 fs/xfs/scrub/agheader_repair.c   |  2 +-
 fs/xfs/xfs_buf.h                 | 19 ++++++++++++++
 fs/xfs/xfs_log_recover.c         |  6 +++--
 7 files changed, 69 insertions(+), 16 deletions(-)

-- 
2.17.2
