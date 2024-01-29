Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FFF4F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513597; cv=none; b=V5oKf3Sqt/bYO0MoDWZJtvIBqbc9iabhIG4sCpy/NA1s2AZ9lfsmBP1V9AJcfl4aSFx7cTaKI/oVH/HgzCRiCJZCkS0Y1pcasqWyC4BOqfRFdyyTjQBdxFLpLuUyyEilzT1hPN9zvMbyqpW6Osj2pVm01N8NOMXcM7NhSAK11HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513597; c=relaxed/simple;
	bh=3i46HRLBgFF3IRC226WudWgjm5lkgiqqMwAd+UDCb6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EcooWVftjWWDZMgI8X1ZizYwI/YI9kM8wqclEWjnli/V5mWSLZFlNmAjZH0W/ceTZ+BJ588FXY0g1GJRqVJNGYLhA/R0iF7i571Qn1V+QAvlex2nAK57z4tCitIbyxaxsqUAKBF0rx2MBozRqZUH/bKmcrsS5c2NLfpS3v8Ocms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RMF7dHJB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RMF7dHJB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YDnvvYeVjViPzb7ZORlIr97W7eXIhb6njpBbgnqlrtc=; b=RMF7dHJBXQyHWkQOP/NV0/ikQ0
	Rtj/0j5Pu1+pZg1QPou9iaIBr7sj+yg9DfVp6mF8sAC+pJlj72YOw8mCev+iZAWOOLaM0s+m/+o8b
	u0Y+u/rixg6YPeKbXmflEPq08tlxmNHqBaHpBytG+2hVQ1ffskD4mOOwf/dLjvoZVp81TU1AkfFdS
	/8EpS2z7Si16KGTaEmjW8BSD4NBNwEB4zvHRJejocwF5vkzVfa4DBz+6a/aoGe4szvHJJdjTaPPuF
	qnAnKuntHmR+i/ZyXFwzGct/FD2zaY+AoGC9vI+gkzfix6uI7R+jLE03GHfXEhMxVXTH4ctlOvnei
	FJsKDfNw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM8p-0000000BcmH-2sc3;
	Mon, 29 Jan 2024 07:33:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 22/27] configure: don't check for the f_flags field in statfs
Date: Mon, 29 Jan 2024 08:32:10 +0100
Message-Id: <20240129073215.108519-23-hch@lst.de>
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

The f_flags field has been supported since Linux 2.6.36.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure.ac          |  1 -
 include/builddefs.in  |  1 -
 io/Makefile           |  4 ----
 io/stat.c             |  2 --
 m4/package_libcdev.m4 | 14 --------------
 5 files changed, 22 deletions(-)

diff --git a/configure.ac b/configure.ac
index ce9a8a935..32efad760 100644
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

