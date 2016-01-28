Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 433BA7CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:14:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40E5F8F8040
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:04 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 350cquR4Hw2K0NGo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:02 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] xfstests: require dedup ioctl support in 182
Date: Thu, 28 Jan 2016 18:13:54 +0100
Message-Id: <1454001236-2600-3-git-send-email-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/182 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/182 b/tests/generic/182
index bf5cd38..eb80b43 100755
--- a/tests/generic/182
+++ b/tests/generic/182
@@ -46,6 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_test_reflink
+_require_test_dedupe
 _require_cp_reflink
 
 rm -f "$seqres.full"
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
