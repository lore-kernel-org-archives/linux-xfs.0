Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeJCA0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 20:26:38 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g7OgS-0007dH-AF
        for linux-xfs@vger.kernel.org; Tue, 02 Oct 2018 17:42:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: delalloc and reflink fixes & tweaks V3
Date: Tue,  2 Oct 2018 10:41:59 -0700
Message-Id: <20181002174207.25275-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series contains the basic reflink and delalloc fixups intended
for 4.20.  All the bits that need more work are left out for now.

Changes since v2:
  - add a new comment
  - drop the patch to use unwritten extents for delalloc by default,
    it didn't actually do what it was intended to do, because there
    was no test to check for that, and actually changing that caused
    a few regressions that need more time looking into
  - add two new unwritten extent related cleanup patches

Changes since v1:
  - drop various patches
  - print the inode number for dangling delalloc extents
