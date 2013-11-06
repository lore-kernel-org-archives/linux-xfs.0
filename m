Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C62F29E1C
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 04:25:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55084304048
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 02:25:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IASPT5t6kWy6P1kU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 02:25:39 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Ve0It-0002Sz-5i
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 10:25:39 +0000
Date: Wed, 6 Nov 2013 02:25:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add generated crc files to .gitignore
Message-ID: <20131106102539.GA9481@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/.gitignore b/.gitignore
index 446d84e..913b371 100644
--- a/.gitignore
+++ b/.gitignore
@@ -67,3 +67,8 @@ cscope.*
 /quota/xfs_quota
 /repair/xfs_repair
 /rtcp/xfs_rtcp
+
+# generated crc files
+/libxfs/crc32selftest
+/libxfs/crc32table.h
+/libxfs/gen_crc32table

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
