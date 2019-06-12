Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56276 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437271AbfFLPkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 11:40:04 -0400
Date: Wed, 12 Jun 2019 08:40:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: claim maintainership of loose files
Message-ID: <20190612154001.GC3773859@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Claim maintainership over the miscellaneous files outside of fs/xfs/
that came from xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 57f496cff999..f0edb53b9dd3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17357,7 +17357,13 @@ W:	http://xfs.org/
 T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 S:	Supported
 F:	Documentation/filesystems/xfs.txt
+F:	Documentation/ABI/testing/sysfs-fs-xfs
+F:	Documentation/filesystems/xfs.txt
+F:	Documentation/filesystems/xfs-delayed-logging-design.txt
+F:	Documentation/filesystems/xfs-self-describing-metadata.txt
 F:	fs/xfs/
+F:	include/uapi/linux/dqblk_xfs.h
+F:	include/uapi/linux/fsmap.h
 
 XILINX AXI ETHERNET DRIVER
 M:	Anirudha Sarangi <anirudh@xilinx.com>
