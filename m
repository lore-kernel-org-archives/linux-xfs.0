Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37846 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966438AbcKLQcs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Nov 2016 11:32:48 -0500
Date: Sat, 12 Nov 2016 08:32:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: new xfs/103 failure
Message-ID: <20161112163248.GA24737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

After recently upgrading the xfs and xfsprogs trees I get reproducible
xfs/103 failures because the n flags is not reported.  Does anyone else
see this?

root@testvm:~/xfstests# diff -u tests/xfs/103.out
/root/xfstests/results//xfs/103
--- tests/xfs/103.outs# 2016-03-29 13:59:30.451720622
+0000stests/results//xfs/10
+++ /root/xfstests/results//xfs/103.out.bad	2016-11-12
16:30:37.032780388 +0000
@@ -3,7 +3,7 @@
 *** mount
 *** testing nosymlinks directories
 *** setting nosymlinks bit
---n-- SCRATCH_MNT/nosymlink
+----- SCRATCH_MNT/nosymlink
 ln: creating symbolic link 'SCRATCH_MNT/nosymlink/target': Operation not permitted
 *** 1st listing...
 SCRATCH_MNT

