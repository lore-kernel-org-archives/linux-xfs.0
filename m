Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5HUPVK000758 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 11:30:25 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67D0A16BDA82
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 09:30:23 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id QUVEhN99S3D3byAe for <xfs@oss.sgi.com>;
	Fri, 05 Dec 2008 09:30:23 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mB5HUMhJ025553
	for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 12:30:23 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5HUKag003809
	for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 12:30:22 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mB5HUGJL002446
	for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 12:30:19 -0500
Message-ID: <49396528.1090700@sandeen.net>
Date: Fri, 05 Dec 2008 11:30:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix up xfs-cmds build after the parallel-fest
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

My big parallel build patch lost the "make configure" target.
This broke Makepkgs...

Now, IMHO, running configure from make is a little bass-ackwards;
I'd probably prefer to have Makepkgs explicitly run:

 autoconf; configure --myoptions; make

but for now, this adds back in a workable "make configure" target.

Also fixed "make install-lib" for acl, which was failing
in the man subdir.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-cmds/acl/Makefile
===================================================================
--- xfs-cmds.orig/acl/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/acl/Makefile	2008-12-05 10:46:04.977513746 -0600
@@ -38,7 +38,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/acl/man/Makefile
===================================================================
--- xfs-cmds.orig/acl/man/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/acl/man/Makefile	2008-12-05 10:48:20.842513303 -0600
@@ -13,10 +13,15 @@ install : $(addsuffix -install,$(SUBDIRS
 
 install-dev : $(addsuffix -install-dev,$(SUBDIRS))
 
+install-lib: $(addsuffix -install-lib,$(SUBDIRS))
+
 %-install:
 	$(MAKE) -C $* install
 
 %-install-dev:
 	$(MAKE) -C $* install-dev
 
+%-install-lib:
+	$(MAKE) -C $* install-lib
+
 include $(BUILDRULES)
Index: xfs-cmds/dmapi/Makefile
===================================================================
--- xfs-cmds.orig/dmapi/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/dmapi/Makefile	2008-12-05 11:07:59.130513205 -0600
@@ -36,7 +36,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfsprogs/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/Makefile	2008-12-05 11:08:55.000000000 -0600
+++ xfs-cmds/xfsprogs/Makefile	2008-12-05 11:09:03.698512814 -0600
@@ -44,7 +44,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfsdump/Makefile
===================================================================
--- xfs-cmds.orig/xfsdump/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/xfsdump/Makefile	2008-12-05 11:12:26.074512652 -0600
@@ -37,7 +37,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/nfs4acl/Makefile
===================================================================
--- xfs-cmds.orig/nfs4acl/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/nfs4acl/Makefile	2008-12-05 11:27:54.454512630 -0600
@@ -39,7 +39,7 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoconf
 	./configure \
 		--prefix=/ \
Index: xfs-cmds/xfstests/Makefile
===================================================================
--- xfs-cmds.orig/xfstests/Makefile	2008-12-05 10:42:40.000000000 -0600
+++ xfs-cmds/xfstests/Makefile	2008-12-05 11:27:59.947513229 -0600
@@ -42,7 +42,7 @@ else
 clean:  # if configure hasn't run, nothing to clean
 endif
 
-include/builddefs:
+configure include/builddefs:
 	autoheader
 	autoconf
 	./configure \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
