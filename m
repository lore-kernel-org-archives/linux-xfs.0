Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8FBF7F69
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:16:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6BBB304039
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:16:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OmWy2YA5iPsXEG2X (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:16:07 -0700 (PDT)
Received: from p5de57ec4.dip0.t-ipconnect.de ([93.229.126.196] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat
	Linux)) id 1ZJOas-0000OF-Iu
	for xfs@oss.sgi.com; Sun, 26 Jul 2015 16:16:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10] xfsprogs: don't install internal header files
Date: Sun, 26 Jul 2015 18:13:20 +0200
Message-Id: <1437927209-31354-2-git-send-email-hch@lst.de>
In-Reply-To: <1437927209-31354-1-git-send-email-hch@lst.de>
References: <1437927209-31354-1-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com

All the headers in $(HFILES) are internal to xfsprogs and should not be
installed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 98e0e28..c85f1ed 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -139,7 +139,7 @@ install-headers: $(addsuffix -hdrs, $(PKGHFILES) $(QAHFILES))
 	$(Q)$(LN_S) -f $(PWD)/libxfs/$* $(TOPDIR)/include/xfs/$*
 
 install-dev: install
-	$(INSTALL) -m 644 $(PKGHFILES) $(HFILES) $(PKG_INC_DIR)
+	$(INSTALL) -m 644 $(PKGHFILES) $(PKG_INC_DIR)
 
 install-qa: install-dev
 	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
