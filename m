Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB0A07F3F
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 04:54:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 630FD8F8033
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 02:54:15 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	E9SQfbZajZBeVGve (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Jun 2014 02:54:13 -0700 (PDT)
Received: by mail-wi0-f173.google.com with SMTP id cc10so3843075wib.0
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 02:54:12 -0700 (PDT)
Received: from sucs.org (silver.sucs.swan.ac.uk. [137.44.10.1])
	by mx.google.com with ESMTPSA id i3sm31848376wiz.13.2014.06.23.02.54.10
	for <xfs@oss.sgi.com> (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
	Mon, 23 Jun 2014 02:54:11 -0700 (PDT)
Date: Mon, 23 Jun 2014 10:54:04 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: [PATCH] xfstests: install src/itrash.c
Message-ID: <20140623095404.GA31644@sucs.org>
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

tests/xfs/111 uses itrash.c so ensure it's installed.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 src/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile b/src/Makefile
index 7a7984a..129aafd 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -85,7 +85,7 @@ install: default $(addsuffix -install,$(SUBDIRS))
 	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/src
 	$(LTINSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/src
 	$(LTINSTALL) -m 755 fill2attr fill2fs fill2fs_check scaleread.sh $(PKG_LIB_DIR)/src
-	$(LTINSTALL) -m 644 dumpfile $(PKG_LIB_DIR)/src
+	$(LTINSTALL) -m 644 dumpfile itrash.c $(PKG_LIB_DIR)/src
 
 %-install:
 	$(MAKE) -C $* install
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
