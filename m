Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C62C7F53
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 17:45:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 695698F8050
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 15:45:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6nDvDQkZYmKc4bLG for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 15:45:34 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C4A3963C5B52
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 17:45:33 -0600 (CST)
Subject: [PATCH 3/3] xfs: test for valid remount options, error if not
References: <56BBC982.50804@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BBCB9D.6080404@sandeen.net>
Date: Wed, 10 Feb 2016 17:45:33 -0600
MIME-Version: 1.0
In-Reply-To: <56BBC982.50804@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch attempts to check for a valid set of remount
options.  As far as I can tell, it's tricky; as the old
comment says, on remount we may get a long string of
options from /proc/mounts and/or /etc/mtab, as well
as options specified on the commandline.  Later options
may negate previous options, etc.

At the most basic level, we may be handed a mount option
which we do not handle on remount, but which may not actually
be a change from the current mount option set.

Unfortunately our mount option state is somewhat far flung;
a combinations of m_flags, and values in various other
mount structure members; see the showargs function for
a taste of that.

So this extends xfs_test_remount_options() to do a full set
of mount processing of the options remount sees, to arrive
at a final state, then compares that state to the current
state, and determines if we can proceed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This is lightly tested; mostly just a sanity check to see
if this approach is a "wtf?" or a "yeah, seems ok."

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 986290c..3d4187c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -455,7 +455,7 @@ xfs_set_maxicount(xfs_mount_t *mp)
  * We use smaller I/O sizes when the file system
  * is being used for NFS service (wsync mount option).
  */
-STATIC void
+void
 xfs_set_rw_sizes(xfs_mount_t *mp)
 {
 	xfs_sb_t	*sbp = &(mp->m_sb);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a4e03ab..bee9284 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -335,6 +335,7 @@ extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
+extern void	xfs_set_rw_sizes(xfs_mount_t *);
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
 int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d1cd4fa..50e15d8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -65,6 +65,8 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
 
+STATIC int xfs_finish_flags(struct xfs_mount *mp);
+
 /*
  * Table driven mount option parser.
  */
@@ -1167,24 +1169,87 @@ xfs_quiesce_attr(
 	xfs_log_quiesce(mp);
 }
 
+#define XFS_BAD_REMOUNT_GOTO(mp, option, l)	\
+	{ \
+		xfs_warn(mp, \
+		  option " options may not be changed via remount");	\
+		goto l;	\
+	}
+/*
+ * Remount can only handle a few options today.
+ * First, check for completely bogus options by looking for errors
+ * from xfs_parseargs.
+ * But if that passes, look at the result to make sure we're not changin
+ * anything that is not, in fact, remountable.  Do this by parsing all
+ * options into a dummy mount structure, and compare the final result
+ * to the current one so we can see what actually changed.
+ */
 STATIC int
 xfs_test_remount_options(
 	struct super_block	*sb,
 	struct xfs_mount	*mp,
 	char			*options)
 {
-	int			error = 0;
-	struct xfs_mount	*tmp;
+	int			error;
+	struct xfs_mount	*tmp_mp;
+
+	__uint64_t		ok_flags, changed_flags;
 
-	tmp = kmem_zalloc(sizeof(*tmp), KM_MAYFAIL);
-	if (!tmp)
+	tmp_mp = kmem_zalloc(sizeof(*tmp_mp), KM_MAYFAIL);
+	if (!tmp_mp)
 		return -ENOMEM;
 
-	tmp->m_super = sb;
-	error = xfs_parseargs(tmp, options);
-	xfs_free_fsname(tmp);
-	kfree(tmp);
+	tmp_mp->m_super = sb;
+	/* structure copy */
+	tmp_mp->m_sb = mp->m_sb;
+
+	/* Emulate mount parsing & flag setting on tmp_mp */
+	error = xfs_parseargs(tmp_mp, options);
+	if (error)
+		goto out;
+
+	error = xfs_finish_flags(tmp_mp);
+	if (error)
+		goto out;
+
+	xfs_set_rw_sizes(tmp_mp);
 
+	/* The only flags we can change on remount */
+	ok_flags = XFS_MOUNT_BARRIER | XFS_MOUNT_RDONLY |
+		   XFS_MOUNT_SMALL_INUMS | XFS_MOUNT_32BITINODES; 
+	/* This is only used internally, so OK as well */
+	ok_flags |= XFS_MOUNT_WAS_CLEAN;
+
+	/* The flags that *did* change */
+	changed_flags = (tmp_mp->m_flags ^ mp->m_flags);
+
+	error = -EINVAL;
+
+	if (tmp_mp->m_qflags != mp->m_qflags)
+		XFS_BAD_REMOUNT_GOTO(mp, "quota", out);
+
+	if (tmp_mp->m_logbufs != mp->m_logbufs ||
+	    tmp_mp->m_logbsize != mp->m_logbsize)
+		XFS_BAD_REMOUNT_GOTO(mp, "logbufs/logbsize", out);
+
+	if (tmp_mp->m_readio_log != mp->m_readio_log ||
+	    tmp_mp->m_writeio_log != mp->m_writeio_log)
+		XFS_BAD_REMOUNT_GOTO(mp, "allocsize/biosize", out);
+
+	if ((tmp_mp->m_logname && mp->m_logname &&
+	     strcmp(tmp_mp->m_logname, mp->m_logname)) ||
+	    (tmp_mp->m_rtname &&  mp->m_rtname &&
+	     strcmp(tmp_mp->m_rtname, mp->m_rtname)))
+		XFS_BAD_REMOUNT_GOTO(mp, "logdev/rtdev", out);
+
+	/* Catch-all for anything else */
+	if (changed_flags & ~ok_flags)
+		XFS_BAD_REMOUNT_GOTO(mp, "specified", out);
+
+	error = 0;
+out:
+	xfs_free_fsname(tmp_mp);
+	kfree(tmp_mp);
 	return error;
 }
 
@@ -1200,7 +1265,12 @@ xfs_fs_remount(
 	char			*p;
 	int			error;
 
-	/* First, check for complete junk; i.e. invalid options */
+	/*
+	 * Remounting is tricky; we get various combinations
+	 * of options, both pre-existing and changed, here.
+	 * This function tries to ensure that what we got
+	 * is a sane set for remounting, and errors if not.
+	 */
 	error = xfs_test_remount_options(sb, mp, options);
 	if (error)
 		return error;
@@ -1228,28 +1298,13 @@ xfs_fs_remount(
 			break;
 		default:
 			/*
-			 * Logically we would return an error here to prevent
-			 * users from believing they might have changed
-			 * mount options using remount which can't be changed.
-			 *
-			 * But unfortunately mount(8) adds all options from
-			 * mtab and fstab to the mount arguments in some cases
-			 * so we can't blindly reject options, but have to
-			 * check for each specified option if it actually
-			 * differs from the currently set option and only
-			 * reject it if that's the case.
-			 *
-			 * Until that is implemented we return success for
-			 * every remount request, and silently ignore all
-			 * options that we can't actually change.
+			 * xfs_test_remount_options really should have errored
+			 * out on any non-remountable options; anything that got 
+			 * here should be a no-op; a re-statement of existing
+			 * options. If something slipped through: too bad!
+			 * We'll just ignore it.
 			 */
-#if 0
-			xfs_info(mp,
-		"mount option \"%s\" not supported for remount", p);
-			return -EINVAL;
-#else
 			break;
-#endif
 		}
 	}
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
