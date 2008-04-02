Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:27:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QYsn006089
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:36 -0700
Message-Id: <20080402062709.286398420@chook.melbourne.sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:14 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 6/7] XFS: Native Language Support for Unicode in XFS
Content-Disposition: inline; filename=nls_support.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Implement the "-o nls=<charset>" mount option and required conversion 
of older style charater sets to/from UTF-8 to support non-UTF8 locales. 
This option is compatible with other Linux filesystems supporting
the "nls" mount option.

NLS conversion is performed on filename operations including readdir and
also user domain extended attribute names. The name zone defined in
the "return name" patch is used for temporarily holding the converted
name.

If Unicode is not configed Y, then the NLS support is virtually a no-op.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/linux-2.6/xfs_linux.h |    5 +
 fs/xfs/linux-2.6/xfs_super.c |   21 ++++++
 fs/xfs/xfs_attr.c            |   78 +++++++++++++++---------
 fs/xfs/xfs_attr.h            |    6 -
 fs/xfs/xfs_attr_leaf.c       |   74 ++++++++++++++++-------
 fs/xfs/xfs_clnt.h            |    1 
 fs/xfs/xfs_dir2_block.c      |   14 +++-
 fs/xfs/xfs_dir2_leaf.c       |   15 ++++
 fs/xfs/xfs_dir2_sf.c         |   12 +++
 fs/xfs/xfs_mount.h           |    2 
 fs/xfs/xfs_rename.c          |   12 +++
 fs/xfs/xfs_unicode.c         |  137 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_unicode.h         |   16 +++++
 fs/xfs/xfs_vfsops.c          |   21 ++++++
 fs/xfs/xfs_vnodeops.c        |  117 +++++++++++++++++++++++++-----------
 15 files changed, 429 insertions(+), 102 deletions(-)

Index: kern_ci/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_linux.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_linux.h
@@ -181,6 +181,11 @@
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
 /*
+ * NLS UTF-8 (unicode) character set
+ */
+#define XFS_NLS_UTF8	"utf8"
+
+/*
  * Various platform dependent calls that don't fit anywhere else
  */
 #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
Index: kern_ci/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
@@ -126,6 +126,7 @@ xfs_args_allocate(
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
 #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
 #define MNTOPT_CILOOKUP	"ci"		/* case-insensitive dir lookup */
+#define MNTOPT_NLS	"nls"		/* NLS code page to use */
 #define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
 #define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
 #define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
@@ -320,9 +321,20 @@ xfs_parseargs(
 			args->flags &= ~XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			args->flags2 |= XFSMNT2_FILESTREAMS;
+#ifdef CONFIG_XFS_UNICODE
 		} else if (!strcmp(this_char, MNTOPT_CILOOKUP)) {
 			args->flags2 |= XFSMNT2_CILOOKUP;
-#ifndef CONFIG_XFS_UNICODE
+		} else if (!strcmp(this_char, MNTOPT_NLS)) {
+			if (!value || !*value) {
+				cmn_err(CE_WARN,
+					"XFS: %s option requires an argument",
+					this_char);
+				return EINVAL;
+			}
+			strncpy(args->nls, value, MAXNAMELEN);
+#else
+		} else if (!strcmp(this_char, MNTOPT_CILOOKUP) ||
+			   !strcmp(this_char, MNTOPT_NLS)) {
 			cmn_err(CE_WARN,
 				"XFS: %s option requires Unicode support",
 				this_char);
@@ -530,6 +542,13 @@ xfs_showargs(
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, "," MNTOPT_NOQUOTA);
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (mp->m_nls)
+			seq_printf(m, "," MNTOPT_NLS "=%s", mp->m_nls->charset);
+		else
+			seq_puts(m, "," MNTOPT_NLS "=" XFS_NLS_UTF8);
+	}
+
 	return 0;
 }
 __uint64_t
Index: kern_ci/fs/xfs/xfs_attr.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_attr.c
+++ kern_ci/fs/xfs/xfs_attr.c
@@ -108,7 +108,7 @@ ktrace_t *xfs_attr_trace_buf;
  *========================================================================*/
 
 int
-xfs_attr_fetch(xfs_inode_t *ip, const char *name, int namelen,
+xfs_attr_fetch(xfs_inode_t *ip, const uchar_t *name, int namelen,
 	       char *value, int *valuelenp, int flags, struct cred *cred)
 {
 	xfs_da_args_t   args;
@@ -167,6 +167,7 @@ xfs_attr_get(
 	cred_t		*cred)
 {
 	int		error, namelen;
+	const uchar_t	*uni_name;
 
 	XFS_STATS_INC(xs_attr_get);
 
@@ -176,24 +177,29 @@ xfs_attr_get(
 	if (namelen >= MAXNAMELEN)
 		return(EFAULT);		/* match IRIX behaviour */
 
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return(EIO);
+
 	/* Enforce UTF-8 only for user attr names */
 	if (xfs_sb_version_hasunicode(&ip->i_mount->m_sb) &&
 			(flags & (ATTR_ROOT | ATTR_SECURE)) == 0) {
-		error = xfs_unicode_validate(name, namelen);
+		error = xfs_nls_to_unicode(ip->i_mount, name, namelen,
+				&uni_name, &namelen);
 		if (error)
 			return error;
-	}
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return(EIO);
+	} else
+		uni_name = name;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_attr_fetch(ip, name, namelen, value, valuelenp, flags, cred);
+	error = xfs_attr_fetch(ip, uni_name, namelen, value, valuelenp,
+				flags, cred);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_unicode_nls_free(name, uni_name);
 	return(error);
 }
 
 int
-xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
+xfs_attr_set_int(xfs_inode_t *dp, const uchar_t *name, int namelen,
 		 char *value, int valuelen, int flags)
 {
 	xfs_da_args_t	args;
@@ -437,26 +443,31 @@ xfs_attr_set(
 	int		valuelen,
 	int		flags)
 {
-	int             namelen;
+	int             error, namelen;
+	const uchar_t	*uni_name;
 
 	namelen = strlen(name);
 	if (namelen >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
 
+	XFS_STATS_INC(xs_attr_set);
+
+	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+		return (EIO);
+
 	/* Enforce UTF-8 only for user attr names */
 	if (xfs_sb_version_hasunicode(&dp->i_mount->m_sb) &&
 			(flags & (ATTR_ROOT | ATTR_SECURE)) == 0) {
-		int error = xfs_unicode_validate(name, namelen);
+		error = xfs_nls_to_unicode(dp->i_mount, name, namelen,
+				&uni_name, &namelen);
 		if (error)
 			return error;
-	}
-
-	XFS_STATS_INC(xs_attr_set);
-
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+	} else
+		uni_name = name;
 
-	return xfs_attr_set_int(dp, name, namelen, value, valuelen, flags);
+	error = xfs_attr_set_int(dp, uni_name, namelen, value, valuelen, flags);
+	xfs_unicode_nls_free(name, uni_name);
+	return error;
 }
 
 /*
@@ -464,7 +475,8 @@ xfs_attr_set(
  * Transitions attribute list from Btree to shortform as necessary.
  */
 int
-xfs_attr_remove_int(xfs_inode_t *dp, const char *name, int namelen, int flags)
+xfs_attr_remove_int(xfs_inode_t *dp, const uchar_t *name, int namelen,
+		    int flags)
 {
 	xfs_da_args_t	args;
 	xfs_fsblock_t	firstblock;
@@ -591,35 +603,41 @@ xfs_attr_remove(
 	const char	*name,
 	int		flags)
 {
-	int		namelen;
+	int		error, namelen;
+	const uchar_t	*uni_name;
 
 	namelen = strlen(name);
 	if (namelen >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
 
+	XFS_STATS_INC(xs_attr_remove);
+
+	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+		return (EIO);
+
 	/* Enforce UTF-8 only for user attr names */
 	if (xfs_sb_version_hasunicode(&dp->i_mount->m_sb) &&
 			(flags & (ATTR_ROOT | ATTR_SECURE)) == 0) {
-		int error = xfs_unicode_validate(name, namelen);
+		error = xfs_nls_to_unicode(dp->i_mount, name, namelen,
+				&uni_name, &namelen);
 		if (error)
 			return error;
-	}
-
-	XFS_STATS_INC(xs_attr_remove);
-
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+	} else
+		uni_name = name;
 
 	xfs_ilock(dp, XFS_ILOCK_SHARED);
 	if (XFS_IFORK_Q(dp) == 0 ||
 		   (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
 		    dp->i_d.di_anextents == 0)) {
 		xfs_iunlock(dp, XFS_ILOCK_SHARED);
+		xfs_unicode_nls_free(name, uni_name);
 		return(XFS_ERROR(ENOATTR));
 	}
 	xfs_iunlock(dp, XFS_ILOCK_SHARED);
 
-	return xfs_attr_remove_int(dp, name, namelen, flags);
+	error = xfs_attr_remove_int(dp, uni_name, namelen, flags);
+	xfs_unicode_nls_free(name, uni_name);
+	return error;
 }
 
 int								/* error */
@@ -658,9 +676,9 @@ xfs_attr_list_int(xfs_attr_list_context_
  */
 /*ARGSUSED*/
 STATIC int
-xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *namesp,
-		     char *name, int namelen,
-		     int valuelen, char *value)
+xfs_attr_user_list(xfs_attr_list_context_t *context, attrnames_t *namesp,
+		   char *name, int namelen,
+		   int valuelen, char *value)
 {
 	attrlist_ent_t *aep;
 	int arraytop;
@@ -789,7 +807,7 @@ xfs_attr_list(
 		context.alist->al_count = 0;
 		context.alist->al_more = 0;
 		context.alist->al_offset[0] = context.bufsize;
-		context.put_listent = xfs_attr_put_listent;
+		context.put_listent = xfs_attr_user_list;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
Index: kern_ci/fs/xfs/xfs_attr.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_attr.h
+++ kern_ci/fs/xfs/xfs_attr.h
@@ -158,13 +158,13 @@ struct xfs_da_args;
 /*
  * Overall external interface routines.
  */
-int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int, int);
-int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
+int xfs_attr_set_int(struct xfs_inode *, const uchar_t *, int, char *, int, int);
+int xfs_attr_remove_int(struct xfs_inode *, const uchar_t *, int, int);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_attr_inactive(struct xfs_inode *dp);
 
 int xfs_attr_shortform_getvalue(struct xfs_da_args *);
-int xfs_attr_fetch(struct xfs_inode *, const char *, int,
+int xfs_attr_fetch(struct xfs_inode *, const uchar_t *, int,
 			char *, int *, int, struct cred *);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 
Index: kern_ci/fs/xfs/xfs_attr_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_attr_leaf.c
+++ kern_ci/fs/xfs/xfs_attr_leaf.c
@@ -42,6 +42,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 
 /*
  * xfs_attr_leaf.c
@@ -89,6 +90,9 @@ STATIC void xfs_attr_leaf_moveents(xfs_a
 					 int dst_start, int move_count,
 					 xfs_mount_t *mp);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
+STATIC int xfs_attr_put_listent(xfs_attr_list_context_t *context,
+				attrnames_t *namesp, char *name, int namelen,
+				int valuelen, char *value);
 
 /*========================================================================
  * Namespace helper routines
@@ -150,7 +154,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	int offset;
 	int minforkoff;	/* lower limit on valid forkoff locations */
 	int maxforkoff;	/* upper limit on valid forkoff locations */
-	int dsize;	
+	int dsize;
 	xfs_mount_t *mp = dp->i_mount;
 
 	offset = (XFS_LITINO(mp) - bytes) >> 3; /* rounded down */
@@ -171,39 +175,39 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	}
 
 	dsize = dp->i_df.if_bytes;
-	
+
 	switch (dp->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		/* 
-		 * If there is no attr fork and the data fork is extents, 
-		 * determine if creating the default attr fork will result 
-		 * in the extents form migrating to btree. If so, the 
-		 * minimum offset only needs to be the space required for 
+		/*
+		 * If there is no attr fork and the data fork is extents,
+		 * determine if creating the default attr fork will result
+		 * in the extents form migrating to btree. If so, the
+		 * minimum offset only needs to be the space required for
 		 * the btree root.
-		 */ 
+		 */
 		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes > mp->m_attroffset)
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
-		
+
 	case XFS_DINODE_FMT_BTREE:
 		/*
 		 * If have data btree then keep forkoff if we have one,
-		 * otherwise we are adding a new attr, so then we set 
-		 * minforkoff to where the btree root can finish so we have 
+		 * otherwise we are adding a new attr, so then we set
+		 * minforkoff to where the btree root can finish so we have
 		 * plenty of room for attrs
 		 */
 		if (dp->i_d.di_forkoff) {
-			if (offset < dp->i_d.di_forkoff) 
+			if (offset < dp->i_d.di_forkoff)
 				return 0;
-			else 
+			else
 				return dp->i_d.di_forkoff;
 		} else
 			dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
 		break;
 	}
-	
-	/* 
-	 * A data fork btree root must have space for at least 
+
+	/*
+	 * A data fork btree root must have space for at least
 	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
 	 */
 	minforkoff = MAX(dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
@@ -370,7 +374,7 @@ xfs_attr_shortform_remove(xfs_da_args_t 
 	 */
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && !args->addname &&
-	    (mp->m_flags & XFS_MOUNT_ATTR2) && 
+	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
 	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE)) {
 		/*
 		 * Last attribute now removed, revert to original
@@ -631,7 +635,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
 				continue;
 			}
 			namesp = xfs_attr_flags_namesp(sfe->flags);
-			error = context->put_listent(context,
+			error = xfs_attr_put_listent(context,
 					   namesp,
 					   (char *)sfe->nameval,
 					   (int)sfe->namelen,
@@ -734,7 +738,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
 			cursor->hashval = sbp->hash;
 			cursor->offset = 0;
 		}
-		error = context->put_listent(context,
+		error = á(context,
 					namesp,
 					sbp->name,
 					sbp->namelen,
@@ -2418,7 +2422,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 			xfs_attr_leaf_name_local_t *name_loc =
 				XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
 
-			retval = context->put_listent(context,
+			retval = xfs_attr_put_listent(context,
 						namesp,
 						(char *)name_loc->nameval,
 						(int)name_loc->namelen,
@@ -2445,7 +2449,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 				retval = xfs_attr_rmtval_get(&args);
 				if (retval)
 					return retval;
-				retval = context->put_listent(context,
+				retval = xfs_attr_put_listent(context,
 						namesp,
 						(char *)name_rmt->name,
 						(int)name_rmt->namelen,
@@ -2454,7 +2458,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 				kmem_free(args.value, valuelen);
 			}
 			else {
-				retval = context->put_listent(context,
+				retval = xfs_attr_put_listent(context,
 						namesp,
 						(char *)name_rmt->name,
 						(int)name_rmt->namelen,
@@ -2472,6 +2476,32 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 	return(retval);
 }
 
+/*
+ * Do NLS name conversion if required for user attribute names and call
+ * context's put_listent routine
+ */
+
+STATIC int
+xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *namesp,
+	char *name, int namelen, int valuelen, char *value)
+{
+	char *nls_name;
+	int nls_namelen;
+	int error;
+
+	if (xfs_is_using_nls(context->dp->i_mount) && namesp == attr_user) {
+		error = xfs_unicode_to_nls(context->dp->i_mount, name, namelen,
+				&nls_name, &nls_namelen);
+		if (error)
+			return error;
+		error = context->put_listent(context, namesp, nls_name,
+				nls_namelen, valuelen, value);
+		xfs_unicode_nls_free(name, nls_name);
+		return error;
+	} else
+		return context->put_listent(context, namesp, name, namelen,
+				valuelen, value);
+}
 
 /*========================================================================
  * Manage the INCOMPLETE flag in a leaf entry
Index: kern_ci/fs/xfs/xfs_clnt.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_clnt.h
+++ kern_ci/fs/xfs/xfs_clnt.h
@@ -48,6 +48,7 @@ struct xfs_mount_args {
 	char	rtname[MAXNAMELEN+1];	/* realtime device filename */
 	char	logname[MAXNAMELEN+1];	/* journal device filename */
 	char	mtpt[MAXNAMELEN+1];	/* filesystem mount point */
+	char	nls[MAXNAMELEN+1];	/* NLS character set to use */
 	int	sunit;		/* stripe unit (BBs) */
 	int	swidth;		/* stripe width (BBs), multiple of sunit */
 	uchar_t iosizelog;	/* log2 of the preferred I/O size */
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -38,6 +38,7 @@
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 
 /*
  * Local function prototypes.
@@ -450,6 +451,8 @@ xfs_dir2_block_getdents(
 	int			wantoff;	/* starting block offset */
 	xfs_ino_t		ino;
 	xfs_off_t		cook;
+	const uchar_t		*nls_name;
+	int			nls_namelen;
 
 	mp = dp->i_mount;
 	/*
@@ -513,16 +516,21 @@ xfs_dir2_block_getdents(
 #if XFS_BIG_INUMS
 		ino += mp->m_inoadd;
 #endif
-
+		error = xfs_unicode_to_nls(mp, dep->name, dep->namelen,
+				&nls_name, &nls_namelen);
+		if (error)
+			break;
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
-		if (filldir(dirent, dep->name, dep->namelen, cook,
+		if (filldir(dirent, nls_name, nls_namelen, cook,
 			    ino, DT_UNKNOWN)) {
 			*offset = cook;
+			xfs_unicode_nls_free(dep->name, nls_name);
 			xfs_da_brelse(NULL, bp);
 			return 0;
 		}
+		xfs_unicode_nls_free(dep->name, nls_name);
 	}
 
 	/*
@@ -531,7 +539,7 @@ xfs_dir2_block_getdents(
 	 */
 	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
 	xfs_da_brelse(NULL, bp);
-	return 0;
+	return error;
 }
 
 /*
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -40,6 +40,7 @@
 #include "xfs_dir2_node.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_unicode.h"
 
 /*
  * Local function declarations.
@@ -780,6 +781,8 @@ xfs_dir2_leaf_getdents(
 	int			ra_offset;	/* map entry offset for ra */
 	int			ra_want;	/* readahead count wanted */
 	xfs_ino_t		ino;
+	const uchar_t		*nls_name;	/* NLS name buffer */
+	int			nls_namelen;
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -1087,13 +1090,21 @@ xfs_dir2_leaf_getdents(
 		ino += mp->m_inoadd;
 #endif
 
+		error = xfs_unicode_to_nls(mp, dep->name, dep->namelen,
+				&nls_name, &nls_namelen);
+		if (error)
+			break;
+
 		/*
 		 * Won't fit.  Return to caller.
 		 */
-		if (filldir(dirent, dep->name, dep->namelen,
+		if (filldir(dirent, nls_name, nls_namelen,
 			    xfs_dir2_byte_to_dataptr(mp, curoff),
-			    ino, DT_UNKNOWN))
+			    ino, DT_UNKNOWN)) {
+			xfs_unicode_nls_free(dep->name, nls_name);
 			break;
+		}
+		xfs_unicode_nls_free(dep->name, nls_name);
 
 		/*
 		 * Advance to next entry in the block.
Index: kern_ci/fs/xfs/xfs_dir2_sf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_sf.c
+++ kern_ci/fs/xfs/xfs_dir2_sf.c
@@ -38,6 +38,7 @@
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"
 #include "xfs_dir2_trace.h"
+#include "xfs_unicode.h"
 
 /*
  * Prototypes for internal functions.
@@ -700,6 +701,7 @@ xfs_dir2_sf_getdents(
 	xfs_off_t		*offset,
 	filldir_t		filldir)
 {
+	int			error;
 	int			i;		/* shortform entry number */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
@@ -708,6 +710,8 @@ xfs_dir2_sf_getdents(
 	xfs_dir2_dataptr_t	dot_offset;
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
+	const uchar_t		*nls_name;	/* NLS name buffer */
+	int			nls_namelen;
 
 	mp = dp->i_mount;
 
@@ -789,12 +793,18 @@ xfs_dir2_sf_getdents(
 #if XFS_BIG_INUMS
 		ino += mp->m_inoadd;
 #endif
+		error = xfs_unicode_to_nls(mp, sfep->name, sfep->namelen,
+				&nls_name, &nls_namelen);
+		if (error)
+			return error;
 
-		if (filldir(dirent, sfep->name, sfep->namelen,
+		if (filldir(dirent, nls_name, nls_namelen,
 					    off, ino, DT_UNKNOWN)) {
 			*offset = off;
+			xfs_unicode_nls_free(sfep->name, nls_name);
 			return 0;
 		}
+		xfs_unicode_nls_free(sfep->name, nls_name);
 		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 
Index: kern_ci/fs/xfs/xfs_mount.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_mount.h
+++ kern_ci/fs/xfs/xfs_mount.h
@@ -54,6 +54,7 @@ typedef struct xfs_trans_reservations {
 #else
 struct cred;
 struct log;
+struct nls_table;
 struct xfs_mount_args;
 struct xfs_inode;
 struct xfs_bmbt_irec;
@@ -316,6 +317,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	struct xfs_nameops	*m_dirnameops;	/* vector of dir name ops */
 	struct xfs_cft		*m_cft;		/* unicode case fold table */
+	struct nls_table	*m_nls;		/* active NLS table */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
Index: kern_ci/fs/xfs/xfs_rename.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_rename.c
+++ kern_ci/fs/xfs/xfs_rename.c
@@ -250,10 +250,14 @@ xfs_rename(
 	xfs_itrace_entry(target_dp);
 
 	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
-		error = xfs_unicode_validate(src_name, src_namelen);
+		error = xfs_nls_to_unicode(mp,
+				VNAME(src_vname), VNAMELEN(src_vname),
+				(const uchar_t **)&src_name, &src_namelen);
 		if (error)
 			return error;
-		error = xfs_unicode_validate(target_name, target_namelen);
+		error = xfs_nls_to_unicode(mp,
+				VNAME(target_vname), VNAMELEN(target_vname),
+				(const uchar_t **)&target_name, &target_namelen);
 		if (error)
 			return error;
 	}
@@ -265,6 +269,8 @@ xfs_rename(
 					src_name, target_name,
 					0, 0, 0);
 		if (error) {
+			xfs_unicode_nls_free(VNAME(src_vname), src_name);
+			xfs_unicode_nls_free(VNAME(target_vname), target_name);
 			return error;
 		}
 	}
@@ -598,6 +604,8 @@ std_return:
 					src_name, target_name,
 					0, error, 0);
 	}
+	xfs_unicode_nls_free(VNAME(src_vname), src_name);
+	xfs_unicode_nls_free(VNAME(target_vname), target_name);
 	return error;
 
  abort_return:
Index: kern_ci/fs/xfs/xfs_unicode.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_unicode.c
+++ kern_ci/fs/xfs/xfs_unicode.c
@@ -497,3 +497,140 @@ xfs_unicode_uninit(void)
 	mutex_unlock(&cft_lock);
 	mutex_destroy(&cft_lock);
 }
+
+/*
+ * Convert UTF-8 (Unicode) string into the specified character set in "nls".
+ * If no NLS conversion is required (mp->m_nls = NULL), the pointers are
+ * return as is. Otherwise, a new buffer is allocated and returned.
+ * xfs_unicode_nls_free() must be called with the source uni_name and returned
+ * nls_name so it can free the buffer if required.
+ */
+int
+xfs_unicode_to_nls(
+	xfs_mount_t	*mp,
+	const uchar_t	*uni_name,
+	int		uni_namelen,
+	const uchar_t	**nls_name,
+	int		*nls_namelen)
+{
+	char		*n;
+	int		i, o;
+	wchar_t		uc;
+	int		nlen;
+	int		u8len;
+	int		error;
+
+	if (!xfs_is_using_nls(mp)) {
+		*nls_name = uni_name;
+		*nls_namelen = uni_namelen;
+		return 0;
+	}
+
+	n = xfs_da_name_alloc();
+	if (!n)
+		return ENOMEM;
+
+	error = 0;
+	for (i = 0, o = 0; i < uni_namelen && o < MAXNAMELEN;
+			i += u8len, o += nlen) {
+		u8len = utf8_mbtowc(&uc, uni_name + i, uni_namelen - i);
+		if (u8len < 0) {
+			error = EINVAL;
+			goto err_out;
+		}
+		nlen = mp->m_nls->uni2char(uc, n + o, MAXNAMELEN - o);
+		if (nlen == -EINVAL) {
+			n[o] = '?';
+			nlen = 1;
+		} else if (nlen < 0) {
+			error = -nlen;
+			goto err_out;
+		}
+	}
+	if (i == uni_namelen) {
+		*nls_name = n;
+		*nls_namelen = o;
+		return 0;
+	}
+	error = ENAMETOOLONG;
+err_out:
+	xfs_da_name_free(n);
+	return error;
+}
+
+/*
+ * Convert the "nls" specified charset string into UTF-8 (Unicode).
+ * If no NLS conversion is required (mp->m_nls = NULL), the pointers are
+ * return as is. Otherwise, a new buffer is allocated and returned.
+ * xfs_unicode_nls_free() must be called with the source uni_name and returned
+ * nls_name so it can free the buffer if required.
+ *
+ * As this is used for all strings coming in from outside XFS, if NLS
+ * conversion is not used, validate the string as properly formed UTF-8.
+ */
+int
+xfs_nls_to_unicode(
+	xfs_mount_t	*mp,
+	const uchar_t	*nls_name,
+	int		nls_namelen,
+	const uchar_t	**uni_name,
+	int		*uni_namelen)
+{
+	char		*n;
+	int		i, o;
+	wchar_t		uc;
+	int		nlen;
+	int		u8len;
+	int		error;
+
+	if (!xfs_is_using_nls(mp)) {
+		error = xfs_unicode_validate(nls_name, nls_namelen);
+		if (error)
+			return error;
+		*uni_name = nls_name;
+		*uni_namelen = nls_namelen;
+		return 0;
+	}
+
+	n = xfs_da_name_alloc();
+	if (!n)
+		return ENOMEM;
+
+	error = 0;
+	for (i = 0, o = 0; i < nls_namelen; i += nlen, o += u8len) {
+		nlen = mp->m_nls->char2uni(nls_name + i, nls_namelen - i, &uc);
+		if (nlen < 0) {
+			error = -nlen;
+			goto err_out;
+		}
+		if (uc >= 0xfffe || (uc >= 0xd800 && uc <= 0xdfff)) {
+			error = EINVAL;	/* don't support chars outside BMP */
+			goto err_out;
+		}
+		u8len = utf8_wctomb(n + o, uc, MAXNAMELEN - o);
+		if (u8len <= 0) {
+			error = (MAXNAMELEN - o < 3) ? ENAMETOOLONG : EINVAL;
+			goto err_out;
+		}
+	}
+	*uni_name = n;
+	*uni_namelen = o;
+	return 0;
+err_out:
+	xfs_da_name_free(n);
+	return error;
+
+}
+
+/*
+ * free the buffer that MAY have been allocated by xfs_unicode_to_nls()
+ * or xfs_nls_to_unicode().
+ */
+void
+xfs_unicode_nls_free(
+	const uchar_t		*src_name,
+	const uchar_t		*conv_name)
+{
+	if (src_name != conv_name)
+		xfs_da_name_free((uchar_t *)conv_name);
+}
Index: kern_ci/fs/xfs/xfs_unicode.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_unicode.h
+++ kern_ci/fs/xfs/xfs_unicode.h
@@ -65,6 +65,14 @@ int xfs_unicode_validate(const uchar_t *
 int xfs_unicode_read_cft(struct xfs_mount *mp);
 void xfs_unicode_free_cft(const xfs_cft_t *cft);
 
+#define xfs_is_using_nls(mp)	((mp)->m_nls != NULL)
+
+int xfs_unicode_to_nls(struct xfs_mount *mp, const uchar_t *uni_name,
+		int uni_namelen, const uchar_t **nls_name, int *nls_namelen);
+int xfs_nls_to_unicode(struct xfs_mount *mp, const uchar_t *nls_name,
+		int nls_namelen, const uchar_t **uni_name, int *uni_namelen);
+void xfs_unicode_nls_free(const uchar_t *src_name, const uchar_t *conv_name);
+
 #else
 
 #define xfs_unicode_nameops		xfs_default_nameops
@@ -76,6 +84,14 @@ void xfs_unicode_free_cft(const xfs_cft_
 #define xfs_unicode_read_cft(mp)	(EOPNOTSUPP)
 #define xfs_unicode_free_cft(cft)
 
+#define xfs_is_using_nls(mp)		0
+
+#define xfs_unicode_to_nls(mp, uname, ulen, pnname, pnlen) \
+		((*(pnname)) = (uname), (*(pnlen)) = (ulen), 0)
+#define xfs_nls_to_unicode(mp, nname, nlen, puname, pulen) \
+		((*(puname)) = (nname), (*(pulen)) = (nlen), 0)
+#define xfs_unicode_nls_free(sname, cname)
+
 #endif	/* CONFIG_XFS_UNICODE */
 
 #endif /* __XFS_UNICODE_H__ */
Index: kern_ci/fs/xfs/xfs_vfsops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vfsops.c
+++ kern_ci/fs/xfs/xfs_vfsops.c
@@ -405,13 +405,30 @@ xfs_finish_flags(
 	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
 		if (ap->flags2 & XFSMNT2_CILOOKUP)
 			mp->m_flags |= XFS_MOUNT_CILOOKUP;
+
+		mp->m_nls = ap->nls[0] ? load_nls(ap->nls) : load_nls_default();
+		if (!mp->m_nls) {
+			cmn_err(CE_WARN,
+	"XFS: unable to load nls mapping \"%s\"\n", ap->nls);
+			return XFS_ERROR(EINVAL);
+		}
+		if (strcmp(mp->m_nls->charset, XFS_NLS_UTF8) == 0) {
+			/* special case utf8 - no translation required */
+			unload_nls(mp->m_nls);
+			mp->m_nls = NULL;
+		}
 	} else {
 		/*
 		 * Check for mount options which require a Unicode FS
 		 */
 		if (ap->flags2 & XFSMNT2_CILOOKUP) {
 			cmn_err(CE_WARN,
-	"XFS: can't do case-insensitive mount on non-utf8 filesystem");
+	"XFS: can't do case-insensitive mount on non-Unicode filesystem");
+			return XFS_ERROR(EINVAL);
+		}
+		if (ap->nls[0]) {
+			cmn_err(CE_WARN,
+	"XFS: can't use nls mount option on non-Unicode filesystem");
 			return XFS_ERROR(EINVAL);
 		}
 	}
@@ -647,6 +664,8 @@ out:
 		xfs_unmountfs(mp, credp);
 		xfs_qmops_put(mp);
 		xfs_dmops_put(mp);
+		if (xfs_is_using_nls(mp))
+			unload_nls(mp->m_nls);
 		kmem_free(mp, sizeof(xfs_mount_t));
 	}
 
Index: kern_ci/fs/xfs/xfs_vnodeops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vnodeops.c
+++ kern_ci/fs/xfs/xfs_vnodeops.c
@@ -1779,13 +1779,14 @@ xfs_lookup(
 		return XFS_ERROR(EIO);
 
 	if (xfs_sb_version_hasunicode(&dp->i_mount->m_sb)) {
-		error = xfs_unicode_validate(d_name->name, d_name->len);
+		error = xfs_nls_to_unicode(dp->i_mount, d_name->name,
+				d_name->len, &name.name, &name.len);
 		if (error)
 			return error;
+	} else {
+		name.name = d_name->name;
+		name.len = d_name->len;
 	}
-
-	name.name = (uchar_t *)d_name->name;
-	name.len = d_name->len;
 	rname.name = NULL;
 	lock_mode = xfs_ilock_map_shared(dp);
 	error = xfs_dir_lookup_int(dp, lock_mode, &name, &e_inum, &ip, &rname);
@@ -1793,11 +1794,15 @@ xfs_lookup(
 		*ipp = ip;
 		xfs_itrace_ref(ip);
 		if (rname.name) {
-			ci_name->name = rname.name;
-			ci_name->len = rname.len;
+			error = xfs_unicode_to_nls(dp->i_mount,
+					rname.name, rname.len,
+					&ci_name->name, &ci_name->len);
+			/* free rname.name if conversion occurred or error */
+			xfs_unicode_nls_free(ci_name->name, rname.name);
 		}
 	}
 	xfs_iunlock_map_shared(dp, lock_mode);
+	xfs_unicode_nls_free(d_name->name, name.name);
 	return error;
 }
 
@@ -1810,7 +1815,7 @@ xfs_create(
 	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
-	char			*name = VNAME(dentry);
+	char			*name;
 	xfs_mount_t	        *mp = dp->i_mount;
 	xfs_inode_t		*ip;
 	xfs_trans_t		*tp;
@@ -1832,12 +1837,14 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	namelen = VNAMELEN(dentry);
-
 	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
-		error = xfs_unicode_validate(name, namelen);
+		error = xfs_nls_to_unicode(mp, VNAME(dentry), VNAMELEN(dentry),
+				(const uchar_t **)&name, &namelen);
 		if (error)
 			return error;
+	} else {
+		name = VNAME(dentry);
+		namelen = VNAMELEN(dentry);
 	}
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
@@ -1846,8 +1853,10 @@ xfs_create(
 				DM_RIGHT_NULL, name, NULL,
 				mode, 0, 0);
 
-		if (error)
+		if (error) {
+			xfs_unicode_nls_free(VNAME(dentry), name);
 			return error;
+		}
 		dm_event_sent = 1;
 	}
 
@@ -1999,6 +2008,7 @@ std_return:
 			DM_RIGHT_NULL, name, NULL,
 			mode, error, 0);
 	}
+	xfs_unicode_nls_free(VNAME(dentry), name);
 	return error;
 
  abort_return:
@@ -2290,10 +2300,10 @@ xfs_remove(
 	xfs_inode_t             *dp,
 	bhv_vname_t		*dentry)
 {
-	char			*name = VNAME(dentry);
+	char			*name;
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_inode_t             *ip = VNAME_TO_INODE(dentry);
-	int			namelen = VNAMELEN(dentry);
+	int			namelen;
 	xfs_trans_t             *tp = NULL;
 	int                     error;
 	xfs_bmap_free_t         free_list;
@@ -2309,17 +2319,23 @@ xfs_remove(
 		return XFS_ERROR(EIO);
 
 	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
-		error = xfs_unicode_validate(name, namelen);
+		error = xfs_nls_to_unicode(mp, VNAME(dentry), VNAMELEN(dentry),
+				(const uchar_t **)&name, &namelen);
 		if (error)
 			return error;
+	} else {
+		name = VNAME(dentry);
+		namelen = VNAMELEN(dentry);
 	}
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
 					name, NULL, ip->i_d.di_mode, 0, 0);
-		if (error)
+		if (error) {
+			xfs_unicode_nls_free(VNAME(dentry), name);
 			return error;
+		}
 	}
 
 	/*
@@ -2472,6 +2488,7 @@ xfs_remove(
 				NULL, DM_RIGHT_NULL,
 				name, NULL, ip->i_d.di_mode, error, 0);
 	}
+	xfs_unicode_nls_free(VNAME(dentry), name);
 	return error;
 
  error1:
@@ -2511,22 +2528,26 @@ xfs_link(
 	int			cancel_flags;
 	int			committed;
 	int			resblks;
-	char			*target_name = VNAME(dentry);
+	char			*target_name;
 	int			target_namelen;
 
 	xfs_itrace_entry(tdp);
 	xfs_itrace_entry(sip);
 
-	target_namelen = VNAMELEN(dentry);
 	ASSERT(!S_ISDIR(sip->i_d.di_mode));
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
 	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
-		error = xfs_unicode_validate(target_name, target_namelen);
+		error = xfs_nls_to_unicode(mp, VNAME(dentry), VNAMELEN(dentry),
+					(const uchar_t **)&target_name,
+					&target_namelen);
 		if (error)
 			return error;
+	} else {
+		target_name = VNAME(dentry);
+		target_namelen = VNAMELEN(dentry);
 	}
 
 	if (DM_EVENT_ENABLED(tdp, DM_EVENT_LINK)) {
@@ -2534,8 +2555,10 @@ xfs_link(
 					tdp, DM_RIGHT_NULL,
 					sip, DM_RIGHT_NULL,
 					target_name, NULL, 0, 0, 0);
-		if (error)
+		if (error) {
+			xfs_unicode_nls_free(VNAME(dentry), target_name);
 			return error;
+		}
 	}
 
 	/* Return through std_return after this point. */
@@ -2646,6 +2669,7 @@ std_return:
 				sip, DM_RIGHT_NULL,
 				target_name, NULL, 0, error, 0);
 	}
+	xfs_unicode_nls_free(VNAME(dentry), target_name);
 	return error;
 
  abort_return:
@@ -2666,8 +2690,8 @@ xfs_mkdir(
 	xfs_inode_t		**ipp,
 	cred_t			*credp)
 {
-	char			*dir_name = VNAME(dentry);
-	int			dir_namelen = VNAMELEN(dentry);
+	char			*dir_name;
+	int			dir_namelen;
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_inode_t		*cdp;	/* inode of created dir */
 	xfs_trans_t		*tp;
@@ -2687,9 +2711,13 @@ xfs_mkdir(
 		return XFS_ERROR(EIO);
 
 	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
-		error = xfs_unicode_validate(dir_name, dir_namelen);
+		error = xfs_nls_to_unicode(mp, VNAME(dentry), VNAMELEN(dentry),
+				(const uchar_t **)&dir_name, &dir_namelen);
 		if (error)
 			return error;
+	} else {
+		dir_name = VNAME(dentry);
+		dir_namelen = VNAMELEN(dentry);
 	}
 
 	tp = NULL;
@@ -2699,8 +2727,10 @@ xfs_mkdir(
 					dp, DM_RIGHT_NULL, NULL,
 					DM_RIGHT_NULL, dir_name, NULL,
 					mode, 0, 0);
-		if (error)
+		if (error) {
+			xfs_unicode_nls_free(VNAME(dentry), dir_name);
 			return error;
+		}
 		dm_event_sent = 1;
 	}
 
@@ -2858,6 +2888,7 @@ std_return:
 					dir_name, NULL,
 					mode, error, 0);
 	}
+	xfs_unicode_nls_free(VNAME(dentry), dir_name);
 	return error;
 
  error2:
@@ -2882,8 +2913,8 @@ xfs_rmdir(
 	bhv_vname_t		*dentry)
 {
 	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
-	char			*name = VNAME(dentry);
-	int			namelen = VNAMELEN(dentry);
+	char			*name;
+	int			namelen;
 	xfs_mount_t		*mp = dp->i_mount;
   	xfs_inode_t             *cdp = VNAME_TO_INODE(dentry);
 	xfs_trans_t             *tp;
@@ -2901,9 +2932,13 @@ xfs_rmdir(
 		return XFS_ERROR(EIO);
 
 	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
-		error = xfs_unicode_validate(name, namelen);
+		error = xfs_nls_to_unicode(mp, VNAME(dentry), VNAMELEN(dentry),
+				(const uchar_t **)&name, &namelen);
 		if (error)
 			return error;
+	} else {
+		name = VNAME(dentry);
+		namelen = VNAMELEN(dentry);
 	}
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
@@ -2911,8 +2946,10 @@ xfs_rmdir(
 					dp, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL,
 					name, NULL, cdp->i_d.di_mode, 0, 0);
-		if (error)
+		if (error) {
+			xfs_unicode_nls_free(VNAME(dentry), name);
 			return XFS_ERROR(error);
+		}
 	}
 
 	/*
@@ -3087,6 +3124,7 @@ xfs_rmdir(
 					name, NULL, cdp->i_d.di_mode,
 					error, 0);
 	}
+	xfs_unicode_nls_free(VNAME(dentry), name);
 	return error;
 
  error1:
@@ -3130,7 +3168,7 @@ xfs_symlink(
 	xfs_prid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
-	char			*link_name = VNAME(dentry);
+	char			*link_name;
 	int			link_namelen;
 
 	*ipp = NULL;
@@ -3142,14 +3180,6 @@ xfs_symlink(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	link_namelen = VNAMELEN(dentry);
-
-	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
-		error = xfs_unicode_validate(link_name, link_namelen);
-		if (error)
-			return error;
-	}
-
 	/*
 	 * Check component lengths of the target path name.
 	 */
@@ -3182,12 +3212,24 @@ xfs_symlink(
 		}
 	}
 
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		error = xfs_nls_to_unicode(mp, VNAME(dentry), VNAMELEN(dentry),
+				(const uchar_t **)&link_name, &link_namelen);
+		if (error)
+			return error;
+	} else {
+		link_name = VNAME(dentry);
+		link_namelen = VNAMELEN(dentry);
+	}
+
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
 					link_name, target_path, 0, 0, 0);
-		if (error)
+		if (error) {
+			xfs_unicode_nls_free(VNAME(dentry), link_name);
 			return error;
+		}
 	}
 
 	/* Return through std_return after this point. */
@@ -3395,6 +3437,7 @@ std_return:
 
 	if (!error)
 		*ipp = ip;
+	xfs_unicode_nls_free(VNAME(dentry), link_name);
 	return error;
 
  error2:

-- 
