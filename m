Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbeLMWZn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 17:25:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/3] iomap: 1 cleanup, 1 fix, 1 optimization
Date: Thu, 13 Dec 2018 16:25:26 -0600
Message-Id: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Christoph@sandeen.net, Hellwig@sandeen.net, hch@lst.de

Patch 1 is trivial, to use the SECTOR_SIZE macro instead of open-coding.
Patch 2 is the one that matters: iomap_is_partially_uptodate was doing invalid memory accesses past the end of the iomap_page->uptodate bitmap.
Patch3 is a small optimization (?) based on what the non-iomap code does, i.e. don't bother checking each block if the "partial" range covers the whole page

These survived an xfstests -g auto run on 4k and 1k block size filesystems
on x86_64.  Careful review for off by ones is appreciated in any case. ;)

Thanks,
-Eric
