Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08J82Tl023105 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 13:08:02 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD9C17181F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 11:08:01 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 3xSSdI415noyULEG for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 11:08:01 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n08J81Bp012926
	for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 14:08:01 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n08J81pB012794
	for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 14:08:01 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n08J80GV001948
	for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 14:08:01 -0500
Message-ID: <49664F0F.1030702@sandeen.net>
Date: Thu, 08 Jan 2009 13:07:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] dmapi: fix include/ symlink creation (again)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

We need the "default" target first, otherwise a simple "make -C include"
only ran the xfs target, missing disk, and failures ensued.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/include/Makefile b/include/Makefile
index 8e092d2..b8d75c7 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -9,11 +9,11 @@ HFILES = dmapi.h
 LSRCFILES = builddefs.in buildmacros buildrules dmapi_kern.h
 LDIRT = xfs
 
+default install: xfs
+
 xfs:
 	$(LN_S) . $@
 
-default install: xfs
-
 include $(BUILDRULES)
 
 install-dev: default

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
