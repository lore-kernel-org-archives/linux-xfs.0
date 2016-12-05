Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbcLEVFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 16:05:30 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: reflink COW improvements
Date: Mon,  5 Dec 2016 22:05:21 +0100
Message-Id: <1480971924-4864-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

Hi all,

this series adds a few improvements to the direct I/O COW path.

Note that patch 2 at this point causes a regression in xfs/214:

@ -11,7 +11,7 @@
 CoW one of the files
 root      --       0       0       0              4     0     0       
 nobody    --       0       0       0              1     0     0       
-fsgqa     --    3520       0       0              4     0     0       
+fsgqa     --    3072       0       0              4     0     0       
 Remount the FS to see if accounting changes
 root      --       0       0       0              4     0     0       
 nobody    --       0       0       0              1     0     0 

But I think the test golden output actually is wrong - the test
claims it tests that we don't get blocks charged during the COW,
but the 3520 here means 512 bytes were charged, and later in the
golden output we actually see that going away after a remount.
