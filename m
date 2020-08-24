Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B5EC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A27206BE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgHXUhw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:37:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:42374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHXUhw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:37:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5B8E6AC8B;
        Mon, 24 Aug 2020 20:38:20 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] libfrog: add dax capability detection in topology probing
Date:   Mon, 24 Aug 2020 22:37:19 +0200
Message-Id: <20200824203724.13477-2-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824203724.13477-1-ailiop@suse.com>
References: <20200824203724.13477-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Detect support for blkid_topology_get_dax in libblkid which was
introduced in util-linux v2.36, and use it to obtain if the underlying
block device is dax-capable. This can be used to issue warnings for
incompatible configurations during mkfs.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 include/builddefs.in |  1 +
 libfrog/Makefile     |  4 ++++
 libfrog/topology.c   | 11 +++++++++--
 libfrog/topology.h   |  1 +
 m4/package_blkid.m4  |  5 +++++
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 30b2727a8db4..88ecf24a74a7 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -140,6 +140,7 @@ PCFLAGS+= -DHAVE_FSETXATTR
 endif
 ifeq ($(ENABLE_BLKID),yes)
 PCFLAGS+= -DENABLE_BLKID
+HAVE_BLKID_DAX = @have_blkid_dax@
 endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 395ce30804b7..bb680b6822ed 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -56,6 +56,10 @@ ifeq ($(HAVE_GETMNTENT),yes)
 LCFLAGS += -DHAVE_GETMNTENT
 endif
 
+ifeq ($(HAVE_BLKID_DAX),yes)
+LCFLAGS += -DHAVE_BLKID_DAX
+endif
+
 LDIRT = gen_crc32table crc32table.h crc32selftest
 
 default: crc32selftest ltdepend $(LTLIBRARY)
diff --git a/libfrog/topology.c b/libfrog/topology.c
index b1b470c9b6d3..713358b01b4c 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -180,6 +180,7 @@ static void blkid_get_topology(
 	int		*swidth,
 	int		*lsectorsize,
 	int		*psectorsize,
+	int		*dax,
 	int		force_overwrite)
 {
 
@@ -212,6 +213,10 @@ static void blkid_get_topology(
 	*sunit = val;
 	val = blkid_topology_get_optimal_io_size(tp);
 	*swidth = val;
+#if defined(HAVE_BLKID_DAX)
+	val = blkid_topology_get_dax(tp);
+	*dax = val;
+#endif
 
 	/*
 	 * If the reported values are the same as the physical sector size
@@ -275,6 +280,7 @@ static void blkid_get_topology(
 	int		*swidth,
 	int		*lsectorsize,
 	int		*psectorsize,
+	int		*dax,
 	int		force_overwrite)
 {
 	/*
@@ -320,13 +326,14 @@ void get_topology(
 	} else {
 		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
 				   &ft->lsectorsize, &ft->psectorsize,
-				   force_overwrite);
+				   &ft->dax, force_overwrite);
 	}
 
 	if (xi->rtname && !xi->risfile) {
 		int sunit, lsectorsize, psectorsize;
 
 		blkid_get_topology(xi->rtname, &sunit, &ft->rtswidth,
-				   &lsectorsize, &psectorsize, force_overwrite);
+				   &lsectorsize, &psectorsize, &ft->dax,
+				   force_overwrite);
 	}
 }
diff --git a/libfrog/topology.h b/libfrog/topology.h
index 6fde868a5923..cde8ff282287 100644
--- a/libfrog/topology.h
+++ b/libfrog/topology.h
@@ -16,6 +16,7 @@ typedef struct fs_topology {
 	int	rtswidth;	/* stripe width - rt subvolume */
 	int	lsectorsize;	/* logical sector size &*/
 	int	psectorsize;	/* physical sector size */
+	int	dax;		/* dax support */
 } fs_topology_t;
 
 extern void
diff --git a/m4/package_blkid.m4 b/m4/package_blkid.m4
index 9510dced59c1..db7595237120 100644
--- a/m4/package_blkid.m4
+++ b/m4/package_blkid.m4
@@ -14,5 +14,10 @@ AC_DEFUN([AC_HAVE_BLKID_TOPO],
     echo 'Install the Block device ID development package.'
     exit 1
   fi
+  AC_CHECK_FUNCS(blkid_topology_get_dax)
+  if test $ac_cv_func_blkid_topology_get_dax = yes; then
+	have_blkid_dax=yes
+	AC_SUBST(have_blkid_dax)
+  fi
   AC_SUBST(libblkid)
 ])
-- 
2.28.0

