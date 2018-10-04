Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51504 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeJEAxn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 20:53:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id 143-v6so9835863wmf.1
        for <linux-xfs@vger.kernel.org>; Thu, 04 Oct 2018 10:59:21 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only one stripe
Date: Thu,  4 Oct 2018 19:58:39 +0200
Message-Id: <20181004175839.18736-1-idryomov@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>

rbd devices report the following geometry:

  $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
  512
  512
  4194304
  4194304

(4M is unnecessarily high and will probably be made configurable and
changed to 64K in the future.  By default, the new bluestore backend
does double-write for I/Os smaller than 64K.)

If pbsz != iomin, mkfs.xfs goes into multidisk mode and, under the
assumption that larger multidisk filesystems will have more devices,
chooses a higher agcount.  Though rbd devices are indeed backed by
multiple OSD devices, it appears that high agcount actually degrades
the performance with multiple rbd devices on the same host.

Commit 9a106b5fbb88 ("mkfs.xfs: Don't stagger AG for a single disk")
has set a precedent for treating sunit == swidth specially.  Take it
one step further.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 mkfs/xfs_mkfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e53c1e83b6a..c3efa30005a2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2650,8 +2650,8 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
 				(cfg->dblocks % cfg->agcount != 0);
 	} else {
 		calc_default_ag_geometry(cfg->blocklog, cfg->dblocks,
-					 cfg->dsunit, &cfg->agsize,
-					 &cfg->agcount);
+					 cfg->dsunit != cfg->dswidth,
+					 &cfg->agsize, &cfg->agcount);
 	}
 }
 
-- 
2.14.4
