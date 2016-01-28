Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D96B67CA6
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:14:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62231AC004
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:04 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id uTGp0ggtxsPLHiA6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:03 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] xfstests: also treat EINVAL as reflink/dedup not supported
Date: Thu, 28 Jan 2016 18:13:55 +0100
Message-Id: <1454001236-2600-4-git-send-email-hch@lst.de>
In-Reply-To: <1454001236-2600-1-git-send-email-hch@lst.de>
References: <1454001236-2600-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com, xfs@oss.sgi.com

This can be returned by various implementations of the ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/reflink | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/reflink b/common/reflink
index de8e56d..8638aba 100644
--- a/common/reflink
+++ b/common/reflink
@@ -92,6 +92,8 @@ _require_test_dedupe()
 		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
 	echo $testio | grep -q "Inappropriate ioctl for device" && \
 		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
+	echo $testio | grep -q "Invalid argument" && \
+		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
 	rm -rf "$TEST_DIR/file1" "$TEST_DIR/file2"
 }
 
@@ -110,6 +112,8 @@ _require_scratch_dedupe()
 		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
 	echo $testio | grep -q "Inappropriate ioctl for device" && \
 		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
+	echo $testio | grep -q "Invalid argument" && \
+		_notrun "Dedupe not supported by test filesystem type: $FSTYP"
 	_scratch_unmount
 }
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
