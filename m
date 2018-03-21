Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbeCUDlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:41:11 -0400
Subject: [PATCH 14/14] xfs_scrub_all: use system encoding for lsblk output
 decoding
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:41:07 -0700
Message-ID: <152160366773.8288.6721882677866606943.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't hardcode utf-8 as the decoding scheme for lsblk output, since the
system could set it to anything else.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub_all.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 83c4e21..d374f92 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -48,7 +48,7 @@ def find_mounts():
 	result.wait()
 	if result.returncode != 0:
 		return fs
-	sarray = [x.decode('utf-8') for x in result.stdout.readlines()]
+	sarray = [x.decode(sys.stdout.encoding) for x in result.stdout.readlines()]
 	output = ' '.join(sarray)
 	bdevdata = json.loads(output)
 	# The lsblk output had better be in disks-then-partitions order

