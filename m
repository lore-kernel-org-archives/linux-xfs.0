Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeKJVf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 16:35:58 -0500
Received: from 089144211136.atnat0020.highway.a1.net ([89.144.211.136] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gLRnD-0000Vj-RJ
        for linux-xfs@vger.kernel.org; Sat, 10 Nov 2018 11:51:12 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: COW improvements and always_cow support
Date: Sat, 10 Nov 2018 12:51:01 +0100
Message-Id: <20181110115104.30293-1-hch@lst.de>
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
