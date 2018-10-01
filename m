Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54260 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729227AbeJATPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 15:15:20 -0400
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g6xSJ-0004J5-TL
        for linux-xfs@vger.kernel.org; Mon, 01 Oct 2018 12:37:43 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: delalloc and reflink fixes & tweaks V2
Date: Mon,  1 Oct 2018 05:37:34 -0700
Message-Id: <20181001123741.32005-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series contains the basic reflink and delalloc fixups intended
for 4.20.  All the bits that need more work are left out for now.

Changes since v1:
  - drop various patches
  - print the inode number for dangling delalloc extents
