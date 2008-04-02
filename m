Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:26:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QYRN006090
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:39 -0700
Message-Id: <20080402062709.577869936@chook.melbourne.sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:15 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 7/7] XFS: NLS config option
Content-Disposition: inline; filename=config_nls.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

This optional patch implements the NLS support as a CONFIG option.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/Kconfig       |   10 ++++++++++
 fs/xfs/xfs_unicode.c |    4 ++++
 fs/xfs/xfs_unicode.h |   17 ++++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

Index: kern_ci/fs/xfs/Kconfig
===================================================================
--- kern_ci.orig/fs/xfs/Kconfig
+++ kern_ci/fs/xfs/Kconfig
@@ -87,6 +87,16 @@ config XFS_UNICODE
 
 	  If you don't require UTF-8 enforcement, say N.
 
+config XFS_UNICODE_NLS
+	bool "XFS NLS Unicode support
+	depends on XFS_UNICODE
+	help
+	  NLS (Native Language Support) allows non-UTF8 locales to
+	  interact with XFS Unicode support. To specify the character
+	  set being used, use the "-n nls=<charset>" mount option.
+
+	  If you don't require NLS conversion in XFS, say N.
+
 config XFS_RT
 	bool "XFS Realtime subvolume support"
 	depends on XFS_FS
Index: kern_ci/fs/xfs/xfs_unicode.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_unicode.c
+++ kern_ci/fs/xfs/xfs_unicode.c
@@ -498,6 +498,8 @@ xfs_unicode_uninit(void)
 	mutex_destroy(&cft_lock);
 }
 
+#ifdef CONFIG_XFS_UNICODE_NLS
+
 /*
  * Convert UTF-8 (Unicode) string into the specified character set in "nls".
  * If no NLS conversion is required (mp->m_nls = NULL), the pointers are
@@ -634,3 +636,5 @@ xfs_unicode_nls_free(
 	if (src_name != conv_name)
 		xfs_da_name_free((uchar_t *)conv_name);
 }
+
+#endif /* CONFIG_XFS_UNICODE_NLS */
Index: kern_ci/fs/xfs/xfs_unicode.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_unicode.h
+++ kern_ci/fs/xfs/xfs_unicode.h
@@ -65,6 +65,8 @@ int xfs_unicode_validate(const uchar_t *
 int xfs_unicode_read_cft(struct xfs_mount *mp);
 void xfs_unicode_free_cft(const xfs_cft_t *cft);
 
+#ifdef CONFIG_XFS_UNICODE_NLS
+
 #define xfs_is_using_nls(mp)	((mp)->m_nls != NULL)
 
 int xfs_unicode_to_nls(struct xfs_mount *mp, const uchar_t *uni_name,
@@ -73,7 +75,20 @@ int xfs_nls_to_unicode(struct xfs_mount 
 		int nls_namelen, const uchar_t **uni_name, int *uni_namelen);
 void xfs_unicode_nls_free(const uchar_t *src_name, const uchar_t *conv_name);
 
-#else
+#else /* CONFIG_XFS_UNICODE_NLS */
+
+#define xfs_is_using_nls(mp)		0
+
+#define xfs_unicode_to_nls(mp, uname, ulen, pnname, pnlen) \
+		((*(pnname)) = (uname), (*(pnlen)) = (ulen), 0)
+#define xfs_nls_to_unicode(mp, nname, nlen, puname, pulen) \
+		((*(puname)) = (nname), (*(pulen)) = (nlen), \
+		 xfs_unicode_validate(nname, nlen))
+#define xfs_unicode_nls_free(sname, cname)
+
+#endif /* CONFIG_XFS_UNICODE_NLS */
+
+#else /* CONFIG_XFS_UNICODE */
 
 #define xfs_unicode_nameops		xfs_default_nameops
 #define xfs_unicode_ci_nameops		xfs_default_nameops

-- 
