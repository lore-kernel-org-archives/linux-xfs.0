Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56355 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756718AbdGLLoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2017 07:44:34 -0400
Date: Wed, 12 Jul 2017 04:44:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: xfstests failures with current kernel/xfsprogs/xfstests
Message-ID: <20170712114433.GA2231@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net

I see a few failures with a (hopefully) uptodate setup.  I'm pretty
sure some of them have been around for a while, but I'd like to
figure out how to get to a clean slate.

This is a 4k fs on x86-64, with reflink enabled for the test and
scratch dev.

generic/204 seems to run out of space:

  @@ -1,2 +1,780 @@
  QA output created by 204
+./tests/generic/204: line 85: /mnt/scratch/20862: No space left on device
+./tests/generic/204: line 86: /mnt/scratch/20862: No space left on device

maybe we need to key this off the device size better?  I can look into
this.

generic/417 seems to fail to recover things on a r/o to r/w mount.

I thoght Eric had a fix for this, but it seems like it didn't get merge.

xfs/010 seems to have an unhappy extent state:

     Phase 4 - check for duplicate blocks...
             - setting up duplicate extent list...
    +unknown block state, ag 0, block 119
             - check for inodes claiming duplicate blocks...
     Phase 5 - rebuild AG headers and trees...

Might this be userspace not catching up to the various reflink
and co updates?

xfs/170  seems to not get the filestreams behavior it wants.

xfs/293 complains about undcoumented xfs_io commandsa:

    +cowextsize not documented in the xfs_io manpage
    +dedupe not documented in the xfs_io manpage
    +finsert not documented in the xfs_io manpage
    +fsmap not documented in the xfs_io manpage
    +funshare not documented in the xfs_io manpage

