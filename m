Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C23BA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980128; cv=none; b=EwRhE5DWLd60EFqYR1+v+BuRgw9m8r352fhdC7jrFRZ7fmMUk8xEgciYzepWLXvwLWytF5INGyWZNUNIe2QLIZ1g8KY/hdeB1Xo47KBN9kKhhrgHSDcFqF1FZS5SkeV2ko0yBV5g9uUbGw3RVBf/43Cjmu4WN4eDp4GlUtlYt/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980128; c=relaxed/simple;
	bh=XMg9YcOXMk/i5Yhx/Shlh9vf2rKVDaVAeudA6SrRqJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HJX/Z5t5rHQitgjzwBX+ckeTxqr7UaqSksP8Ul+KfzokDEzd79pLUr2GfLDsAyBuMdkj/hW5uCd/PA+f2M7nocXWDFnDWA+2VDG+Lru+gw7AQzq9xKlhmLM/JBYhLHWNStSMTKQKe7osaui2ABd/WQhY6X/g8BgxBB0mNQQtNyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fw6CARLH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fw6CARLH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=v7leKuyK5/wTpd1Y+6V6vLdyU4AAmVLdHmSJPir1RRo=; b=fw6CARLHzrMME6xtHBuJZ7h23X
	rBdbEv4j578gpIEcLWKpfIi8Bxt/0Mg8xsQ6Ya8cYw1I1GBdiSbbeB4dVx0yl98dKXrjuupmPesYj
	8aPWgCPtCp+MT+pLclT5zlEiWG2Ir8LuceMgEhB0rsCT5lmVJGZP9ENnU1JarKUDuBBllEMAwv34O
	3r07Fjri4t4fs007tJDeZ/FOiiT+CvhfVCZs/l/TllyI87gfTdwIQajL7P3jxOGAMrn00GUsT7vPB
	j8Iqv2Yw/ISCs3sCCWAfLg0GvLXUr6+MM9oiqCdgJkis4EgLF7lL/lU1ktFDlX5TUZBEb1JJZ65gi
	FRSbIGbw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVeY-0000000F9Oc-0aKh;
	Thu, 15 Feb 2024 06:55:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 22/26] configure: don't check for the f_flags field in statfs
Date: Thu, 15 Feb 2024 07:54:20 +0100
Message-Id: <20240215065424.2193735-23-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The f_flags field has been supported since Linux 2.6.36.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  4 ----
 io/stat.c             |  2 --
 m4/package_libcdev.m4 | 14 --------------
 5 files changed, 22 deletions(-)

diff --git a/configure.ac b/configure.ac
index 09ffe52c8..a967322cf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -168,7 +168,6 @@ AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
 AC_HAVE_GETFSMAP
-AC_HAVE_STATFS_FLAGS
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
diff --git a/include/builddefs.in b/include/builddefs.in
index b84369ea7..c359cde45 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -96,7 +96,6 @@ NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
 HAVE_GETFSMAP = @have_getfsmap@
-HAVE_STATFS_FLAGS = @have_statfs_flags@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
diff --git a/io/Makefile b/io/Makefile
index 35b3ebd52..17d499de9 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -47,10 +47,6 @@ ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += fsmap.c
 endif
 
-ifeq ($(HAVE_STATFS_FLAGS),yes)
-LCFLAGS += -DHAVE_STATFS_FLAGS
-endif
-
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/stat.c b/io/stat.c
index b57f9eefe..7f9f633bb 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -238,10 +238,8 @@ statfs_f(
 					(long long) st.f_files);
 			printf(_("statfs.f_ffree = %lld\n"),
 					(long long) st.f_ffree);
-#ifdef HAVE_STATFS_FLAGS
 			printf(_("statfs.f_flags = 0x%llx\n"),
 					(long long) st.f_flags);
-#endif
 		}
 	}
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index ff0e83752..320809a62 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -120,20 +120,6 @@ struct fsmap_head fh;
     AC_SUBST(have_getfsmap)
   ])
 
-AC_DEFUN([AC_HAVE_STATFS_FLAGS],
-  [
-    AC_CHECK_TYPE(struct statfs,
-      [
-        AC_CHECK_MEMBER(struct statfs.f_flags,
-          have_statfs_flags=yes,,
-          [#include <sys/vfs.h>]
-        )
-      ],,
-      [#include <sys/vfs.h>]
-    )
-    AC_SUBST(have_statfs_flags)
-  ])
-
 #
 # Check if we have MAP_SYNC defines (Linux)
 #
-- 
2.39.2

