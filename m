Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6A9C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 23:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiGTX2E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 19:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiGTX2D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 19:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B8A2D1FA
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 16:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29BA761DF7
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 23:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0E9C3411E;
        Wed, 20 Jul 2022 23:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658359680;
        bh=RSE4wLGXzzyDMt+QS0zrwGfQEybg3lA6YkxIYpr3LiU=;
        h=Date:From:To:Cc:Subject:From;
        b=MRWOEoCgqjOa3uei4nB4Huzm7bp8zvvu1YApEUWbivlMDjNX9q+truWed0MPEZGm4
         vaHtm3KHWpHNdjzA2agDiEB8X8xmRi+S8j10Zq1VDu78bx3a6QYocmLQKVZa+dWCEr
         /omWNsAnvNE+yj8p84zjY0eFGFF4bOGYhkq/5+VK1ElQkcEvJf3t5jym2A+292U2FB
         dPRlZUeDscDMCFUdpE3KzSv16ZGE+l19+a6h81VEi3HixcNxQygOvTTQCdx3csNhOm
         2wifgxOKWs8clSm+fxnwkjJ0u6SQisPizpjbmkpKnkM6RDsm/xSAaRjZ6vqzHkIikn
         tkhMdGqr8BwVw==
Date:   Wed, 20 Jul 2022 16:28:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     info@mobile-stream.com,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC PATCH] libxfs: stop overriding MAP_SYNC in publicly exported
 header files
Message-ID: <YtiPgDT3imEyU2aF@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Can one of you please apply this patch and see if it'll build in musl on
mips, please?  Sorry it's taken so long to address this. :/

--D

---
From: Darrick J. Wong <djwong@kernel.org>

Florian Fainelli most recently reported that xfsprogs doesn't build with
musl on mips:

"MIPS platforms building with recent kernel headers and the musl-libc
toolchain will expose the following build failure:

mmap.c: In function 'mmap_f':
mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
  196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
      |            ^~~~~~~~
      |            MS_SYNC
mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [../include/buildrules:81: mmap.o] Error 1"

At first glance, the build failure here is caused by the fact that:

1. The configure script doesn't detect MAP_SYNC support
2. The build system doesn't set HAVE_MAP_SYNC
2. io/mmap.c includes input.h -> projects.h -> xfs.h and later sys/mman.h
3. include/linux.h #define's MAP_SYNC to 0 if HAVE_MAP_SYNC is not set
4. musl's sys/mman.h #undef MAP_SYNC on platforms that don't support it
5. io/mmap.c tries to use MAP_SYNC, not realizing that libc undefined it

Normally, xfs_io only exports functionality that is defined by the libc
and/or kernel headers on the build system.  We often make exceptions for
new functionality so that we have a way to test them before the header
file packages catch up, hence this '#ifndef HAVE_FOO #define FOO'
paradigm.

MAP_SYNC is a gross and horribly broken example of this.  These support
crutches are supposed to be *private* to xfsprogs for benefit of early
testing, but they were instead added to include/linux.h, which we
provide to user programs in the xfslibs-dev package.  IOWs, we've been
#defining MAP_SYNC to zero for unsuspecting programs.

Worst yet, gcc 11.3 doesn't even warn about overriding a #define to 0:

#include <stdio.h>
#include <sys/mman.h>
#ifdef STUPID
# include <xfs/xfs.h>
#endif

int main(int argc, char *argv[]) {
	printf("MAP_SYNC 0x%x\n", MAP_SYNC);
}

$ gcc -o a a.c -Wall
$ ./a
MAP_SYNC 0x80000
$ gcc -DSTUPID -o a a.c -Wall
$ ./a
MAP_SYNC 0x0

Four years have gone by since the introduction of MAP_SYNC, so let's get
rid of the override code entirely -- any platform that supports MAP_SYNC
has had plenty of chances to ensure their header files have the right
bits.  While we're at it, fix AC_HAVE_MAP_SYNC to look for MAP_SYNC in
the same header file that the one user (io/mmap.c) uses -- sys/mman.h.

Annoyingly, I had to test this by hand because the sole fstest that
exercises MAP_SYNC (generic/470) requires dm-logwrites and dm-thinp,
neither of which support fsdax on current kernels.

Reported-by: info@mobile-stream.com
Reported-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/linux.h       |    8 --------
 io/io.h               |    2 +-
 io/mmap.c             |   25 +++++++++++++------------
 m4/package_libcdev.m4 |    3 +--
 4 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 3d9f4e3d..eddc4ad9 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -251,14 +251,6 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
-#ifndef HAVE_MAP_SYNC
-#define MAP_SYNC 0
-#define MAP_SHARED_VALIDATE 0
-#else
-#include <asm-generic/mman.h>
-#include <asm-generic/mman-common.h>
-#endif /* HAVE_MAP_SYNC */
-
 /*
  * Reminder: anything added to this file will be compiled into downstream
  * userspace projects!
diff --git a/io/io.h b/io/io.h
index ada0a149..de4ef607 100644
--- a/io/io.h
+++ b/io/io.h
@@ -58,7 +58,7 @@ typedef struct mmap_region {
 	size_t		length;		/* length of mapping */
 	off64_t		offset;		/* start offset into backing file */
 	int		prot;		/* protection mode of the mapping */
-	bool		map_sync;	/* is this a MAP_SYNC mapping? */
+	int		flags;		/* MAP_* flags passed to mmap() */
 	char		*name;		/* name of backing file */
 } mmap_region_t;
 
diff --git a/io/mmap.c b/io/mmap.c
index 8c048a0a..425957d4 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -46,8 +46,11 @@ print_mapping(
 	for (i = 0, p = pflags; p->prot != PROT_NONE; i++, p++)
 		buffer[i] = (map->prot & p->prot) ? p->mode : '-';
 
-	if (map->map_sync)
+#ifdef HAVE_MAP_SYNC
+	if ((map->flags & (MAP_SYNC | MAP_SHARED_VALIDATE)) ==
+			  (MAP_SYNC | MAP_SHARED_VALIDATE))
 		sprintf(&buffer[i], " S");
+#endif
 
 	printf("%c%03d%c 0x%lx - 0x%lx %s  %14s (%lld : %ld)\n",
 		braces? '[' : ' ', index, braces? ']' : ' ',
@@ -139,7 +142,9 @@ mmap_help(void)
 " -r -- map with PROT_READ protection\n"
 " -w -- map with PROT_WRITE protection\n"
 " -x -- map with PROT_EXEC protection\n"
+#ifdef HAVE_MAP_SYNC
 " -S -- map with MAP_SYNC and MAP_SHARED_VALIDATE flags\n"
+#endif
 " -s <size> -- first do mmap(size)/munmap(size), try to reserve some free space\n"
 " If no protection mode is specified, all are used by default.\n"
 "\n"));
@@ -193,18 +198,14 @@ mmap_f(
 			prot |= PROT_EXEC;
 			break;
 		case 'S':
+#ifdef HAVE_MAP_SYNC
 			flags = MAP_SYNC | MAP_SHARED_VALIDATE;
-
-			/*
-			 * If MAP_SYNC and MAP_SHARED_VALIDATE aren't defined
-			 * in the system headers we will have defined them
-			 * both as 0.
-			 */
-			if (!flags) {
-				printf("MAP_SYNC not supported\n");
-				return 0;
-			}
 			break;
+#else
+			printf("MAP_SYNC not supported\n");
+			exitcode = 1;
+			return command_usage(&mmap_cmd);
+#endif
 		case 's':
 			length2 = cvtnum(blocksize, sectsize, optarg);
 			break;
@@ -281,7 +282,7 @@ mmap_f(
 	mapping->offset = offset;
 	mapping->name = filename;
 	mapping->prot = prot;
-	mapping->map_sync = (flags == (MAP_SYNC | MAP_SHARED_VALIDATE));
+	mapping->flags = flags;
 	return 0;
 }
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index df44174d..5293dd1a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -387,8 +387,7 @@ AC_DEFUN([AC_HAVE_MAP_SYNC],
   [ AC_MSG_CHECKING([for MAP_SYNC])
     AC_COMPILE_IFELSE(
     [	AC_LANG_PROGRAM([[
-#include <asm-generic/mman.h>
-#include <asm-generic/mman-common.h>
+#include <sys/mman.h>
 	]], [[
 int flags = MAP_SYNC | MAP_SHARED_VALIDATE;
 	]])
