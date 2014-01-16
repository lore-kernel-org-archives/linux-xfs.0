Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 389937F4E
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:07:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D3EC8F8059
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 09:07:20 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QpM51NbNIhiDiTp1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 09:07:19 -0800 (PST)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 21D97AC56
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 17:07:18 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/5] xfstests: fix minor build warning
Date: Thu, 16 Jan 2014 18:07:11 +0100
Message-Id: <46203afc2c2423b9df110a38be39c632dd83d5c7.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

Make in the toplevel directory tries to process the 'group' file that
existed in the previous file layout

$ make
 sed: can't read group: No such file or directory
 sed: can't read group: No such file or directory
 ...

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a7f6f9d374ca..30d8747d1f79 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,6 @@ endif
 
 SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
 
-TESTS = $(shell sed -n -e '/^[0-9][0-9][0-9]*/s/ .*//p' group)
 CONFIGURE = configure include/builddefs include/config.h
 LSRCFILES = configure configure.ac aclocal.m4 README VERSION
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
@@ -60,7 +59,7 @@ endif
 export TESTS_DIR = tests
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
 
-default: include/builddefs $(DMAPI_MAKEFILE) $(TESTS)
+default: include/builddefs $(DMAPI_MAKEFILE)
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) $@
 else
-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
