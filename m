Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Feb 2007 21:16:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1J5Ggm7021880
	for <xfs@oss.sgi.com>; Sun, 18 Feb 2007 21:16:44 -0800
Message-Id: <200702190516.QAA10507@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] Cleanup some build cruft in xfs-cmds GNUmakefile
Date: Mon, 19 Feb 2007 16:18:26 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0073_01C75441.965EA160"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@corp.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_0073_01C75441.965EA160
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Clean up some old SGI specific stuff in the root xfs-cmds GNUmakefile, and
be able to set final location for the RPM packages from the environment.

------=_NextPart_000_0073_01C75441.965EA160
Content-Type: application/octet-stream;
	name="makefile_clean.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="makefile_clean.patch"

--- a/GNUmakefile	2007-02-19 16:13:09.000000000 +1100
+++ b/GNUmakefile	2007-02-19 16:08:42.302255319 +1100
@@ -1,16 +1,16 @@
 #
-# Copyright (c) 2002 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2002-2007 Silicon Graphics, Inc.  All Rights Reserved.
 #
-# Top-level makefile for all of xfs-cmds (with specific bits for LBS)
+# Top-level makefile for all of xfs-cmds
 #
=20
 XFS_CMDS_DIR :=3D $(shell pwd)
=20
-# This is true for both LBS and 2.4.x-xfs builds... for now...
-TOP=3D..
-
 ARCH :=3D $(shell uname -m | sed -e s/i.86/i386/)
=20
+RPM_OUT_DIR ?=3D $(XFS_CMDS_DIR)/RPMS/$(ARCH)
+SRPM_OUT_DIR ?=3D $(XFS_CMDS_DIR)/SRPMS
+
 COMMANDS =3D attr acl xfsprogs dmapi xfsdump
=20
 # We'd like to be able to satisfy dependencies from within the
@@ -50,37 +50,22 @@
 		( cd $(XFS_CMDS_DIR)/$$d && ./Makepkgs ) || exit 1; \
 	done
 	for d in $(COMMANDS); do \
-		( cd $(XFS_CMDS_DIR) && /bin/cp $$d/build/rpm/*.src.rpm SRPMS ) \
+		( cd $(XFS_CMDS_DIR) && /bin/cp $$d/build/rpm/*.src.rpm $(SRPM_OUT_DIR) =
) \
 	done
 	for d in $(COMMANDS); do \
-		( cd $(XFS_CMDS_DIR) && /bin/cp $$d/build/rpm/*.$(ARCH).rpm RPMS/$(ARCH)=
 ) \
+		( cd $(XFS_CMDS_DIR) && /bin/cp $$d/build/rpm/*.$(ARCH).rpm $(RPM_OUT_DI=
R) ) \
 	done
=20
-	# If this is an LBS build ($(TOP)/sgi-install/SGI/RPMS exists)
-	# then copy the RPMs over to sgi-install after they're built
-	([ -d $(TOP)/sgi-install/SGI/RPMS ] && \
-		( /bin/cp $(XFS_CMDS_DIR)/RPMS/$(ARCH)/*.rpm $(TOP)/sgi-install/SGI/RPMS=
 )) || \
-		echo
-
-	([ -d $(TOP)/sgi-install/SGI/SRPMS ] && \
-		( /bin/cp $(XFS_CMDS_DIR)/SRPMS/*.src.rpm $(TOP)/sgi-install/SGI/SRPMS )=
) || \
-		echo
-
 builddirs:
 	echo "cmd builddirs"
-	([ -d $(XFS_CMDS_DIR)/BUILD ] || mkdir $(XFS_CMDS_DIR)/BUILD)
-	([ -d $(XFS_CMDS_DIR)/SRPMS ] || mkdir $(XFS_CMDS_DIR)/SRPMS)
-	([ -d $(XFS_CMDS_DIR)/RPMS/$(ARCH) ] || mkdir -p $(XFS_CMDS_DIR)/RPMS/$(A=
RCH))
+	([ -d $(SRPM_OUT_DIR) ] || mkdir -p $(SRPM_OUT_DIR))
+	([ -d $(RPM_OUT_DIR) ] || mkdir -p $(RPM_OUT_DIR))
=20
 clean:
-	rm -rf RPMS SRPMS BUILD SOURCES
+	rm -rf $(SRPM_OUT_DIR) $(RPM_OUT_DIR)
 	for d in $(COMMANDS); do \
 		( cd $(XFS_CMDS_DIR)/$$d && make -i clean ) \
 	done
=20
 realclean: clean
 	for d in $(COMMANDS); do ( cd $(XFS_CMDS_DIR)/$$d && make realclean ) done
-
-clean-lbs:    realclean
-
-build-lbs:    cmds-install

------=_NextPart_000_0073_01C75441.965EA160--
