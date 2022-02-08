Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458B4C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 16:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352314AbiBHQqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 11:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383520AbiBHQqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Feb 2022 11:46:10 -0500
X-Greylist: delayed 84899 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 08:46:09 PST
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B42C061576
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 08:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8167ECE1AFC
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 16:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF16C340EC;
        Tue,  8 Feb 2022 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644338765;
        bh=5j2nI3fVvLE4ZnU5PwRtM9KOmviZZwXCs74HLBhPffo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VmxUKwiRDyC1kR5/nKc4Yhrxk1WfnEaxP7pCM96tjdLPZP5VvXri+Zruieg5AjWQk
         u7LxgdSL9n3T6rgFHrNKazo1TpckJeJWrIQ4tf/EAauYeQfKTIXYRDOAecbEK4PfJp
         4Nu1+9JheRewvwxYvZhHpkQNN/iPv3vRgedNWymqpNzPtjDsvOW+J9cbJS/EwIHM14
         1/uWT9yD8WVbG+jij53F6rlyVO7QgB7uVPCkQDuYeSWZD100Se+/MtwTYWNX2AQ7HE
         QicMGE5Xz5xMyP5IdnJGzu63WDvi6BN0+C49p8XGi3fZzrCYXDap+Ep0M7S9LDHOwn
         9maR7k8prSkgQ==
Date:   Tue, 8 Feb 2022 08:46:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH v1.1 04/17] libfrog: always use the kernel GETFSMAP
 definitions
Message-ID: <20220208164605.GC8313@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811682.863810.12064586264139896800.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164263811682.863810.12064586264139896800.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The GETFSMAP ioctl has been a part of the kernel since 4.12.  We have no
business shipping a stale copy of kernel header contents in the xfslibs
package, so get rid of it.  This means that xfs_scrub now has a hard
dependency on the build system having new kernel headers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/linux.h   |  105 -----------------------------------------------------
 io/Makefile       |    5 +--
 io/fsmap.c        |    1 +
 scrub/Makefile    |    7 +---
 scrub/phase6.c    |    1 +
 scrub/phase7.c    |    1 +
 scrub/spacemap.c  |    1 +
 spaceman/Makefile |    5 +--
 spaceman/freesp.c |    1 +
 9 files changed, 11 insertions(+), 116 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index de8a7122..3d9f4e3d 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -251,111 +251,6 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
-#ifdef HAVE_GETFSMAP
-# include <linux/fsmap.h>
-#else
-/*
- *	Structure for FS_IOC_GETFSMAP.
- *
- *	The memory layout for this call are the scalar values defined in
- *	struct fsmap_head, followed by two struct fsmap that describe
- *	the lower and upper bound of mappings to return, followed by an
- *	array of struct fsmap mappings.
- *
- *	fmh_iflags control the output of the call, whereas fmh_oflags report
- *	on the overall record output.  fmh_count should be set to the
- *	length of the fmh_recs array, and fmh_entries will be set to the
- *	number of entries filled out during each call.  If fmh_count is
- *	zero, the number of reverse mappings will be returned in
- *	fmh_entries, though no mappings will be returned.  fmh_reserved
- *	must be set to zero.
- *
- *	The two elements in the fmh_keys array are used to constrain the
- *	output.  The first element in the array should represent the
- *	lowest disk mapping ("low key") that the user wants to learn
- *	about.  If this value is all zeroes, the filesystem will return
- *	the first entry it knows about.  For a subsequent call, the
- *	contents of fsmap_head.fmh_recs[fsmap_head.fmh_count - 1] should be
- *	copied into fmh_keys[0] to have the kernel start where it left off.
- *
- *	The second element in the fmh_keys array should represent the
- *	highest disk mapping ("high key") that the user wants to learn
- *	about.  If this value is all ones, the filesystem will not stop
- *	until it runs out of mapping to return or runs out of space in
- *	fmh_recs.
- *
- *	fmr_device can be either a 32-bit cookie representing a device, or
- *	a 32-bit dev_t if the FMH_OF_DEV_T flag is set.  fmr_physical,
- *	fmr_offset, and fmr_length are expressed in units of bytes.
- *	fmr_owner is either an inode number, or a special value if
- *	FMR_OF_SPECIAL_OWNER is set in fmr_flags.
- */
-struct fsmap {
-	__u32		fmr_device;	/* device id */
-	__u32		fmr_flags;	/* mapping flags */
-	__u64		fmr_physical;	/* device offset of segment */
-	__u64		fmr_owner;	/* owner id */
-	__u64		fmr_offset;	/* file offset of segment */
-	__u64		fmr_length;	/* length of segment */
-	__u64		fmr_reserved[3];	/* must be zero */
-};
-
-struct fsmap_head {
-	__u32		fmh_iflags;	/* control flags */
-	__u32		fmh_oflags;	/* output flags */
-	__u32		fmh_count;	/* # of entries in array incl. input */
-	__u32		fmh_entries;	/* # of entries filled in (output). */
-	__u64		fmh_reserved[6];	/* must be zero */
-
-	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
-	struct fsmap	fmh_recs[];	/* returned records */
-};
-
-/* Size of an fsmap_head with room for nr records. */
-static inline size_t
-fsmap_sizeof(
-	unsigned int	nr)
-{
-	return sizeof(struct fsmap_head) + nr * sizeof(struct fsmap);
-}
-
-/* Start the next fsmap query at the end of the current query results. */
-static inline void
-fsmap_advance(
-	struct fsmap_head	*head)
-{
-	head->fmh_keys[0] = head->fmh_recs[head->fmh_entries - 1];
-}
-
-/*	fmh_iflags values - set by XFS_IOC_GETFSMAP caller in the header. */
-/* no flags defined yet */
-#define FMH_IF_VALID		0
-
-/*	fmh_oflags values - returned in the header segment only. */
-#define FMH_OF_DEV_T		0x1	/* fmr_device values will be dev_t */
-
-/*	fmr_flags values - returned for each non-header segment */
-#define FMR_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
-#define FMR_OF_ATTR_FORK	0x2	/* segment = attribute fork */
-#define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
-#define FMR_OF_SHARED		0x8	/* segment = shared with another file */
-#define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
-#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
-
-/* Each FS gets to define its own special owner codes. */
-#define FMR_OWNER(type, code)	(((__u64)type << 32) | \
-				 ((__u64)code & 0xFFFFFFFFULL))
-#define FMR_OWNER_TYPE(owner)	((__u32)((__u64)owner >> 32))
-#define FMR_OWNER_CODE(owner)	((__u32)(((__u64)owner & 0xFFFFFFFFULL)))
-#define FMR_OWN_FREE		FMR_OWNER(0, 1) /* free space */
-#define FMR_OWN_UNKNOWN		FMR_OWNER(0, 2) /* unknown owner */
-#define FMR_OWN_METADATA	FMR_OWNER(0, 3) /* metadata */
-
-#define FS_IOC_GETFSMAP		_IOWR('X', 59, struct fsmap_head)
-
-#define HAVE_GETFSMAP
-#endif /* HAVE_GETFSMAP */
-
 #ifndef HAVE_MAP_SYNC
 #define MAP_SYNC 0
 #define MAP_SHARED_VALIDATE 0
diff --git a/io/Makefile b/io/Makefile
index 71741926..498174cf 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -104,10 +104,9 @@ LLDLIBS += $(LIBDEVMAPPER)
 LCFLAGS += -DHAVE_DEVMAPPER
 endif
 
-# On linux we get fsmap from the system or define it ourselves
-# so include this unconditionally.  If this reverts to only
-# the autoconf check w/o local definition, test HAVE_GETFSMAP
+ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += fsmap.c
+endif
 
 ifeq ($(HAVE_STATFS_FLAGS),yes)
 LCFLAGS += -DHAVE_STATFS_FLAGS
diff --git a/io/fsmap.c b/io/fsmap.c
index f540a7c0..9dd19cc0 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -4,6 +4,7 @@
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
 #include "platform_defs.h"
+#include <linux/fsmap.h>
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
diff --git a/scrub/Makefile b/scrub/Makefile
index fd6bb679..335e1e8d 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -6,12 +6,9 @@ TOPDIR = ..
 builddefs=$(TOPDIR)/include/builddefs
 include $(builddefs)
 
-# On linux we get fsmap from the system or define it ourselves
-# so include this based on platform type.  If this reverts to only
-# the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
-SCRUB_PREREQS=$(HAVE_OPENAT)$(HAVE_FSTATAT)
+SCRUB_PREREQS=$(HAVE_OPENAT)$(HAVE_FSTATAT)$(HAVE_GETFSMAP)
 
-ifeq ($(SCRUB_PREREQS),yesyes)
+ifeq ($(SCRUB_PREREQS),yesyesyes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 87828b60..afdb16b6 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -7,6 +7,7 @@
 #include <stdint.h>
 #include <dirent.h>
 #include <sys/statvfs.h>
+#include <linux/fsmap.h>
 #include "handle.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
diff --git a/scrub/phase7.c b/scrub/phase7.c
index bc652ab6..84546b1c 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -7,6 +7,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
+#include <linux/fsmap.h>
 #include "libfrog/paths.h"
 #include "libfrog/ptvar.h"
 #include "list.h"
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index a5508d56..03440d3a 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -8,6 +8,7 @@
 #include <string.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
+#include <linux/fsmap.h>
 #include "libfrog/workqueue.h"
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 2a366918..1f048d54 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -18,10 +18,9 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
-# On linux we get fsmap from the system or define it ourselves
-# so include this unconditionally.  If this reverts to only
-# the autoconf check w/o local definition, test HAVE_GETFSMAP
+ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += freesp.c
+endif
 
 default: depend $(LTCOMMAND)
 
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index de301c19..423568a4 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -8,6 +8,7 @@
 
 #include "libxfs.h"
 #include <linux/fiemap.h>
+#include <linux/fsmap.h>
 #include "libfrog/fsgeom.h"
 #include "command.h"
 #include "init.h"
