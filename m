Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1B6154C00
	for <linux-xfs@vger.kernel.org>; Sun, 16 Mar 2025 18:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742150742; cv=none; b=bgcEhwirGVTtQHpa6eDSjda8C+4D/ZSE89VYHX1IeheLyVEFOSL+r62FzSg0JQsNXFx3n3uuP/b/cM+Hah2K35apoAyLuXtaGh5AzHLLEfEDPX1LHnxH9hNHcnYU9eJvqiETch1Rw8wa9J61zw1lhW6voSUPVi4/1gSHd78XLwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742150742; c=relaxed/simple;
	bh=f9xX8a0tZyFrt5yC17B7amlYY83nUepg2X4urVzue6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S7AmveDGxY4B18+FxvZrZJpEfM9qUyKhC9t/yAdy4H4x2drVzf2kSWKQ6F2NBwszFNdOAvV3PnhHk+R4nvxUwiWwk+FYLtswI0jsCujMNZJDTBQ2xiIjw20SO5TTL4iQ5CcoVbzmjrGY/cyBgiE5GhGtrNFNN9kxkyHRuCL+W9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUxiMZ1u; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUxiMZ1u"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22423adf751so56310155ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 16 Mar 2025 11:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742150739; x=1742755539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mBvqhjFmKnNxAwpSs2zBP2YWOeRcVYuEGWWN5UTebH0=;
        b=lUxiMZ1uAOhNd7E/X2/6rl9erIWRAzptoCMv0KYEkV5bPR61JHHH+yWR0qHtRaFFsw
         Ro5OiNg4PC1eSFj2qACeqmFfCJZ08trZYhfoZjtcwMY5Lg3AAb6ON+l2b5juatDpg5o1
         lVaxCYi4zwcR1vvMJMLVkoGNdV7/DrHmd9dV6etQxavTay5LhRbOjLWQRqLYTqn5Bxv/
         vj4+fpec91N84/arVFSryYCeoP+xfDz0qzZQZ42RetsXYVOnXFcCgQ5C15Mxva0sHJxq
         wr6TphmRHn/qcu3402zr1HLdPAH0ipptil/pe65fB9048vCkFqr8VXs2NZV5nhQahmuf
         zamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742150739; x=1742755539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mBvqhjFmKnNxAwpSs2zBP2YWOeRcVYuEGWWN5UTebH0=;
        b=Qgpy8reReYmhka4/YiZzRadhB9JAYcCxg6iZTNmNfEZlqPoBg50MYO6zk/eCr4+2Ns
         pj9caHnzC5uTPYV3VUcrzTxTxxfFqE7HIUOtqDpJRAd1eEE4RpnSoNMBeFzeDTSAMe6z
         gItOnWHAP1imOl1dEzlDqqJT41qVu5IcGBZVM76LUUOXLb+4TpaODqwwEsIeuizvC1Wz
         f+JCVhPbx9+5w5mQzc6nxlKmC/lQy3/+/ttrgDIsnde3I7QNXsv9RzyZoCc2GX5+QPVu
         bdmN/2u7KpwOdhs3dPsPvgaff7vqQaBfewYh/cZcKoZyETVOmXoMfc6GJ/uVJknc7oAP
         n0nw==
X-Gm-Message-State: AOJu0Yxv0/C0lwYMEBVJlEp99584TIRIHqjanNulaGQAnfHf0+GmDbJj
	yj4Urm33jyiqDl3CxcPyquBq7978a+u6VE8X7QL51W23K0H8uPukVvLf2g==
X-Gm-Gg: ASbGncs25Lj6zv7bOHGuwPFG0v+QgQzWjLim+Qfv0uLW8SkoMkcvbYQl/BMeH2Rdrl8
	bU7iCs3+NlrMbRGbXmYSWQ2lPMojnbrVzpQ4B1VTmZQHMoa0ZdGeKN7KVyNMkdxB6eRgJVhORot
	y0Z+VtnQEuimT5F538QqmX2qFuQVy9JKJ+H1izfXScxZ7umK+Bt37YRBJeAIkcXuFJk2j8vv12Y
	E1aTKRxEKaaCdv9NMsUwHDggsH6X1YuD3f9iKySvxphGnmVWQ/YvduSQLCVVNcr+wEzRCyKKSYt
	t4SdFNYZy9m1tXWiKcUWah/zkzpGMHC4bPMvWX3+C4Fh3pg9YSY=
X-Google-Smtp-Source: AGHT+IHjrlNnz8Urszu1ahwTgtdqJCXqKnlv2kzV0hO88ytFU7aFDkJzzU4IM7BsRphjhvBjOuBADw==
X-Received: by 2002:a17:902:e785:b0:220:fce7:d3a6 with SMTP id d9443c01a7336-225e0a75becmr136086555ad.23.1742150739106;
        Sun, 16 Mar 2025 11:45:39 -0700 (PDT)
Received: from dw-tp.ibmuc.com ([171.76.81.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68883d0sm60500325ad.10.2025.03.16.11.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Mar 2025 11:45:38 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC] xfs_io: Add cachestat syscall support
Date: Mon, 17 Mar 2025 00:15:29 +0530
Message-ID: <f93cec1c02eefffff7a5182cf2c0333cec600889.1742150405.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds -c "cachestat off len" command which uses cachestat() syscall
[1]. This can provide following pagecache detail for a file.

- no. of cached pages,
- no. of dirty pages,
- no. of pages marked for writeback,
- no. of evicted pages,
- no. of recently evicted pages

[1]: https://lore.kernel.org/all/20230503013608.2431726-3-nphamcs@gmail.com/T/#u

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 io/Makefile           |  5 +++
 io/cachestat.c        | 77 +++++++++++++++++++++++++++++++++++++++++++
 io/init.c             |  1 +
 io/io.h               |  6 ++++
 m4/package_libcdev.m4 | 19 +++++++++++
 7 files changed, 110 insertions(+)
 create mode 100644 io/cachestat.c

diff --git a/configure.ac b/configure.ac
index 8c76f398..f039bc91 100644
--- a/configure.ac
+++ b/configure.ac
@@ -154,6 +154,7 @@ AC_PACKAGE_NEED_RCU_INIT
 
 AC_HAVE_PWRITEV2
 AC_HAVE_COPY_FILE_RANGE
+AC_HAVE_CACHESTAT
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
diff --git a/include/builddefs.in b/include/builddefs.in
index 82840ec7..fe2a7824 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -95,6 +95,7 @@ HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 
 HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
+HAVE_CACHESTAT = @have_cachestat@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
diff --git a/io/Makefile b/io/Makefile
index 14a3fe20..444e2d6a 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -61,6 +61,11 @@ CFILES += copy_file_range.c
 LCFLAGS += -DHAVE_COPY_FILE_RANGE
 endif
 
+ifeq ($(HAVE_CACHESTAT),yes)
+CFILES += cachestat.c
+LCFLAGS += -DHAVE_CACHESTAT
+endif
+
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
diff --git a/io/cachestat.c b/io/cachestat.c
new file mode 100644
index 00000000..9edf3f9a
--- /dev/null
+++ b/io/cachestat.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
+#include <unistd.h>
+#include <linux/mman.h>
+#include <asm/unistd.h>
+
+static cmdinfo_t cachestat_cmd;
+
+static void print_cachestat(struct cachestat *cs)
+{
+	printf(_("Cached: %llu, Dirty: %llu, Writeback: %llu, Evicted: %llu, Recently Evicted: %llu\n"),
+			cs->nr_cache, cs->nr_dirty, cs->nr_writeback,
+			cs->nr_evicted, cs->nr_recently_evicted);
+}
+
+static int
+cachestat_f(int argc, char **argv)
+{
+	off_t offset = 0, length = 0;
+	size_t blocksize, sectsize;
+	struct cachestat_range cs_range;
+	struct cachestat cs;
+
+	if (argc != 3) {
+		exitcode = 1;
+		return command_usage(&cachestat_cmd);
+	}
+
+	init_cvtnum(&blocksize, &sectsize);
+	offset = cvtnum(blocksize, sectsize, argv[1]);
+	if (offset < 0) {
+		printf(_("invalid offset argument -- %s\n"), argv[1]);
+		exitcode = 1;
+		return 0;
+	}
+
+	length = cvtnum(blocksize, sectsize, argv[2]);
+	if (length < 0) {
+		printf(_("invalid length argument -- %s\n"), argv[2]);
+		exitcode = 1;
+		return 0;
+	}
+
+	cs_range.off = offset;
+	cs_range.len = length;
+
+	if (syscall(__NR_cachestat, file->fd, &cs_range, &cs, 0)) {
+		perror("cachestat");
+		exitcode = 1;
+		return 0;
+	}
+
+	print_cachestat(&cs);
+
+	return 0;
+}
+
+static cmdinfo_t cachestat_cmd = {
+	.name		= "cachestat",
+	.altname	= "cs",
+	.cfunc		= cachestat_f,
+	.argmin		= 2,
+	.argmax		= 2,
+	.flags		= CMD_NOMAP_OK | CMD_FOREIGN_OK,
+	.args		= "[off len]",
+	.oneline	= "find page cache pages for a given file",
+};
+
+void cachestat_init(void)
+{
+	add_command(&cachestat_cmd);
+}
+
diff --git a/io/init.c b/io/init.c
index 4831deae..49e9e7cb 100644
--- a/io/init.c
+++ b/io/init.c
@@ -49,6 +49,7 @@ init_commands(void)
 	bmap_init();
 	bulkstat_init();
 	copy_range_init();
+	cachestat_init();
 	cowextsize_init();
 	encrypt_init();
 	fadvise_init();
diff --git a/io/io.h b/io/io.h
index d9906558..259c0349 100644
--- a/io/io.h
+++ b/io/io.h
@@ -132,6 +132,12 @@ extern void		copy_range_init(void);
 #define copy_range_init()	do { } while (0)
 #endif
 
+#ifdef HAVE_CACHESTAT
+extern void cachestat_init(void);
+#else
+#define cachestat_init() do { } while (0)
+#endif
+
 extern void		sync_range_init(void);
 extern void		readdir_init(void);
 extern void		reflink_init(void);
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 4ef7e8f6..af9da812 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -35,6 +35,25 @@ syscall(__NR_copy_file_range, 0, 0, 0, 0, 0, 0);
     AC_SUBST(have_copy_file_range)
   ])
 
+#
+# Check if we have a cachestat system call (Linux)
+#
+AC_DEFUN([AC_HAVE_CACHESTAT],
+  [ AC_MSG_CHECKING([for cachestat])
+    AC_LINK_IFELSE(
+    [	AC_LANG_PROGRAM([[
+#include <unistd.h>
+#include <linux/mman.h>
+#include <asm/unistd.h>
+	]], [[
+syscall(__NR_cachestat, 0, 0, 0, 0);
+	]])
+    ], have_cachestat=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_cachestat)
+  ])
+
 #
 # Check if we need to override the system struct fsxattr with
 # the internal definition.  This /only/ happens if the system
-- 
2.48.1

