Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E04457F37
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 11:24:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6BB8EAC008
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 09:24:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p4QtM7IFg2zFQyxi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 09:24:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id D20A08E3DC
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 16:24:04 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4FGO3xW032720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 12:24:04 -0400
Message-ID: <55561DA3.3070607@redhat.com>
Date: Fri, 15 May 2015 11:24:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: install PKGHFILES in install-dev
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
To: xfs-oss <xfs@oss.sgi.com>

Without this, we'll be missing xfs_fs.h and xfs_types.h
when we "make install-dev" (and xfs.h includes them).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(for the libxfs-4* branch)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 981cb0b..a3c9ab5 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -131,7 +131,7 @@ include $(BUILDRULES)
 install: default
 
 install-dev: install
-	$(INSTALL) -m 644 $(HFILES) $(PKG_INC_DIR)
+	$(INSTALL) -m 644 $(PKGHFILES) $(HFILES) $(PKG_INC_DIR)
 
 install-qa: install-dev
 	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
