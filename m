Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08J73Lg022995 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 13:07:03 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 356396E38F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 11:07:02 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id sbgM15945WShJjr5 for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 11:07:02 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n08J71kr012836
	for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 14:07:01 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n08J72kk012574
	for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 14:07:02 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n08J71Ea001849
	for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 14:07:01 -0500
Message-ID: <49664ED4.2070206@sandeen.net>
Date: Thu, 08 Jan 2009 13:07:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] acl: fix include/ symlink creation (again)
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
only ran the sys target, missing disk, and failures ensued.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/include/Makefile b/include/Makefile
index e923bc0..f9f5552 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -9,11 +9,11 @@ HFILES = acl.h libacl.h acl_ea.h misc.h walk_tree.h
 LSRCFILES = builddefs.in buildmacros buildrules config.h.in
 LDIRT = sys acl
 
+default: sys acl
+
 sys acl:
 	$(LN_S) . $@
 
-default: sys acl
-
 include $(BUILDRULES)
 
 install-dev: default


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
