Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB854F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513576; cv=none; b=IKMtP7K4AznmGt7VzevLrx2DKKYTT0FwFUSQZNyiGn3vRdUao6Sr1bgWc9Z1pYr2P77nPReyZUgjxnDVD9fF2IQU7ql/PAN3i8F0K1XLbMY+/FSy0frUfEq8kiD8FFQIp/RexR/+K2TRnYlTQ5GnWcxath7LIrm+lP7U138QhWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513576; c=relaxed/simple;
	bh=XdNzuntUzgqzux2B1SNM4V7SEvhWggRmMPGkx3cAQpg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RFQuu+wd/Pv+y+JAV/kjDzLeMKkcZd7iM9vl1ey7IiEwdxIHxvItNqEfRzqPxUBK3piVXV3HQa0fM4YifDuKx2w99W6JrO7qRcw5S7H2cNNSW0F6qOPQtyrE6vt4r+t0SonXZJ+DkXVYvWrjd6dLnGNn7ymcFSJj+ktlbzbRI/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=REfXZ751; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="REfXZ751"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+82kN9SINfpYaGFk72ZH13ASBlUQtUGFITqkNXOvWOw=; b=REfXZ751ulNxqPUjQqYcPy41DH
	j3vU1zDElbbX+M7jKl3U6k+otJie5fkZ0RNUtMJvtOgW8QlgD76xvP0zg1kPcNxSLWFH4lnFRIBwa
	mG5bI8ycewt7WR04FDia8vfhTrm9y9agYecnmw+4x92hYuII5bv4ELx917uNiR3rW2wrnDbaLDjVu
	oG/pmI0zG+1UwGmqHCL5F/iBzk/6esyFJb51VGzHOG/j8fkdmsKInBbO59/ysTdt7+G6Z2FChV5kc
	gLFrQVxFRk6dOK7U3YqPYh2IlvqAm0dWB3UJ4Dok/lX5bXzRczaFIC/IjTzEc5CR7nLeQ9HLBUkxP
	x5tyOQnw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8U-0000000Bcgy-2xq8;
	Mon, 29 Jan 2024 07:32:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/27] configure: don't check for sync_file_range
Date: Mon, 29 Jan 2024 08:32:02 +0100
Message-Id: <20240129073215.108519-15-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

sync_file_range has been supported since Linux 2.6.17.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  8 ++------
 io/io.h               |  4 ----
 m4/package_libcdev.m4 | 18 ------------------
 5 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/configure.ac b/configure.ac
index 40999b598..7c1248583 100644
--- a/configure.ac
+++ b/configure.ac
@@ -166,7 +166,6 @@ AC_HAVE_FALLOCATE
 AC_HAVE_PWRITEV2
 AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
-AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_SYNCFS
 AC_HAVE_FLS
 AC_HAVE_READDIR
diff --git a/include/builddefs.in b/include/builddefs.in
index a5408014d..247dd9956 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -94,7 +94,6 @@ HAVE_FALLOCATE = @have_fallocate@
 HAVE_PREADV = @have_preadv@
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
-HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_SYNCFS = @have_syncfs@
 HAVE_READDIR = @have_readdir@
 HAVE_FLS = @have_fls@
diff --git a/io/Makefile b/io/Makefile
index 2271389f5..0709f8f21 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -13,7 +13,8 @@ CFILES = init.c \
 	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c fiemap.c
+	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c fiemap.c \
+	sync_file_range.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
@@ -24,11 +25,6 @@ CFILES += copy_file_range.c
 LCFLAGS += -DHAVE_COPY_FILE_RANGE
 endif
 
-ifeq ($(HAVE_SYNC_FILE_RANGE),yes)
-CFILES += sync_file_range.c
-LCFLAGS += -DHAVE_SYNC_FILE_RANGE
-endif
-
 ifeq ($(HAVE_SYNCFS),yes)
 LCFLAGS += -DHAVE_SYNCFS
 endif
diff --git a/io/io.h b/io/io.h
index 982d37c38..ad025c51d 100644
--- a/io/io.h
+++ b/io/io.h
@@ -128,11 +128,7 @@ extern void		copy_range_init(void);
 #define copy_range_init()	do { } while (0)
 #endif
 
-#ifdef HAVE_SYNC_FILE_RANGE
 extern void		sync_range_init(void);
-#else
-#define sync_range_init()	do { } while (0)
-#endif
 
 #ifdef HAVE_READDIR
 extern void		readdir_init(void);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 93daf3640..5a2290de1 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -73,24 +73,6 @@ syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
     AC_SUBST(have_copy_file_range)
   ])
 
-#
-# Check if we have a sync_file_range libc call (Linux)
-#
-AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
-  [ AC_MSG_CHECKING([for sync_file_range])
-    AC_LINK_IFELSE(
-    [	AC_LANG_PROGRAM([[
-#define _GNU_SOURCE
-#include <fcntl.h>
-	]], [[
-sync_file_range(0, 0, 0, 0);
-	]])
-    ], have_sync_file_range=yes
-       AC_MSG_RESULT(yes),
-       AC_MSG_RESULT(no))
-    AC_SUBST(have_sync_file_range)
-  ])
-
 #
 # Check if we have a syncfs libc call (Linux)
 #
-- 
2.39.2

