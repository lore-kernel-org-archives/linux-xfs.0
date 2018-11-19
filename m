Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbeKTAKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Nov 2018 19:10:03 -0500
Received: from 089144201193.atnat0010.highway.a1.net ([89.144.201.193] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gOjsc-0004sa-Hw
        for linux-xfs@vger.kernel.org; Mon, 19 Nov 2018 13:46:22 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: COW improvements and always_cow support V2
Date: Mon, 19 Nov 2018 14:46:10 +0100
Message-Id: <20181119134619.16812-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series adds the always_cow mode support after improving our COW
write support a little bit first.

The always_cow mode stresses the COW path a lot, but with a few xfstests
fixups it generall looks good, except for:

 - a few tests that complain about fragmentation, which is rather inherent
   in this mode
 - generic/208 crashing a lot (and generic/095 with 1k block similarly)
   because a COW fork extent has changed under writeback.  As far as I can
   tell this is because nothing prevents another thread from moving a COW
   fork extent to the data fork while we are under writeback.  I'm currently
   fully root causing this and looking into a potential fix
 - xfs/017 crashes occasionally in log recovery because we can't find
   a refcount tree record that we try to free.
   I haven't really fully understood this one yet.

Changes since v1:
 - make delalloc and unwritten extent conversions simpler and more robust
 - add a few additional cleanups
 - support all fallocate modes but actual preallocation
 - rebase on top of a fix from Brian (which is included as first patch
   to make the patch set more usable)
