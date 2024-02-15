Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D46BA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980092; cv=none; b=c9XNeDSkVD0vISx4IszYCplWtV58JCr+nf25svECA5wRegC0wyIQDiehdHDOeoqX9b6aXaUsDQHeiSzhfsMHOFidAkeRKGUbPMOdUxRI/74niIpakyXjfR7ovbt0fnUpvkKbYjQOollC0M3+KzWHT2pUwml3L//3+qXju/Cwu2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980092; c=relaxed/simple;
	bh=H9wI/3F0TV3LIgjA4o74SbKUTUG8YRhWCOmmcMFYXBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iZTTGAkUSjM3z6NwDFrtKQjHQpKRWlCq3djZ/aqOEkR4UXMBKqFFP4elGB4poXKItnIz8dRrF/aZRU+woii5tR/MG0xshDE9t28qnx+6VhBxsSALEATI11THfjMCrZ/7/H2/mXDKQoVk3vjqK4cKkL0FzpUUEAt8MOg4zEORXWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y5C/AX9Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y5C/AX9Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L+geLSiJt+YtagP7/0sI/FsRC4U3RZFqBe7EiMiLFaY=; b=Y5C/AX9ZRVFoPUYxmxbu+IEoyz
	QnqCJbFno1sTxB2vmLPKyy5ighmMjyVABfPbgwKhe0ZNZhwkXstGqHeu199EoKh9O4IHeiLjap6SY
	PjIBvJ53pTXSBJvxS4WH4UTk73OHSJP8iJRVcOi126/PbtOs3qsqswrwD6+AawQoIAICo/b0abIAh
	WnqaOSMCQo6C2QR3TDYkNKxZnYZIyBC+NIoWUYyZm6CIr2FqH5cLmW4KuSnIcCESuunuMSDPHDTWO
	CUktxvxOcHpwXdJauug7mlZvDEHxo4JJAOp/IyKpLIVBc62wIxxHswxGyCce01bLLhdsRaaZlvc3c
	nfanGt+A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdy-0000000F9EQ-24fl;
	Thu, 15 Feb 2024 06:54:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 08/26] configure: require libblkid
Date: Thu, 15 Feb 2024 07:54:06 +0100
Message-Id: <20240215065424.2193735-9-hch@lst.de>
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

We can't support block device access (which is the reason for xfsprogs
to exist) without blkid.  Make it a hard requirement and remove the
stubs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac         |  8 --------
 include/builddefs.in |  4 ----
 libxfs/topology.c    | 37 +------------------------------------
 3 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/configure.ac b/configure.ac
index 228e89a50..012508b8e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -36,11 +36,6 @@ AC_ARG_ENABLE(gettext,
 	enable_gettext=yes)
 AC_SUBST(enable_gettext)
 
-AC_ARG_ENABLE(blkid,
-[  --enable-blkid=[yes/no]   Enable use of block device id library [default=yes]],,
-	enable_blkid=yes)
-AC_SUBST(enable_blkid)
-
 AC_ARG_ENABLE(editline,
 [  --enable-editline=[yes/no] Enable editline command editing [default=no]],
 	test $enable_editline = yes && libeditline="-ledit",
@@ -208,10 +203,7 @@ AC_HAVE_HDIO_GETGEO
 AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
 AC_CONFIG_CROND_DIR
 AC_CONFIG_UDEV_RULE_DIR
-
-if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
-fi
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/include/builddefs.in b/include/builddefs.in
index b5bfbb1f2..a00283da1 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -86,7 +86,6 @@ RPM_VERSION	= @rpm_version@
 ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
-ENABLE_BLKID	= @enable_blkid@
 ENABLE_SCRUB	= @enable_scrub@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
@@ -144,9 +143,6 @@ endif
 ifeq ($(HAVE_FSETXATTR),yes)
 PCFLAGS+= -DHAVE_FSETXATTR
 endif
-ifeq ($(ENABLE_BLKID),yes)
-PCFLAGS+= -DENABLE_BLKID
-endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
diff --git a/libxfs/topology.c b/libxfs/topology.c
index 06013d429..4515d238d 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -6,9 +6,7 @@
 
 #include "libxfs_priv.h"
 #include "libxcmd.h"
-#ifdef ENABLE_BLKID
-#  include <blkid/blkid.h>
-#endif /* ENABLE_BLKID */
+#include <blkid/blkid.h>
 #include "xfs_multidisk.h"
 #include "libfrog/platform.h"
 
@@ -96,7 +94,6 @@ done:
  *	 0 for nothing found
  *	-1 for internal error
  */
-#ifdef ENABLE_BLKID
 int
 check_overwrite(
 	const char	*device)
@@ -253,38 +250,6 @@ out_free_probe:
 		_("warning: unable to probe device topology for device %s\n"),
 		device);
 }
-#else /* ifdef ENABLE_BLKID */
-/*
- * Without blkid, we can't do a good check for signatures.
- * So instead of some messy attempts, just disable any checks
- * and always return 'nothing found'.
- */
-#  warning BLKID is disabled, so signature detection and block device\
- access are not working!
-int
-check_overwrite(
-	const char	*device)
-{
-	return 1;
-}
-
-static void blkid_get_topology(
-	const char	*device,
-	int		*sunit,
-	int		*swidth,
-	int		*lsectorsize,
-	int		*psectorsize,
-	int		force_overwrite)
-{
-	/*
-	 * Shouldn't make any difference (no blkid = no block device access),
-	 * but make sure this dummy replacement returns with at least some
-	 * sanity.
-	 */
-	*lsectorsize = *psectorsize = 512;
-}
-
-#endif /* ENABLE_BLKID */
 
 void
 get_topology(
-- 
2.39.2

