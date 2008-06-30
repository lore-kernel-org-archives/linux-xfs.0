Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jun 2008 09:17:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5UGHfrl016032
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 09:17:42 -0700
Date: Mon, 30 Jun 2008 12:18:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix mount option parsing in remount
Message-ID: <20080630161841.GA22137@infradead.org>
References: <20080518153539.GA5218@lst.de> <48687B79.6050101@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48687B79.6050101@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jun 30, 2008 at 04:21:45PM +1000, Timothy Shimmin wrote:
> typo: s/support/supported/
> 
> Looking at ext3 and other XFS out of curiosity:
> "XFS: unknown mount option [%s].", this_char
> "EXT3-fs: Unrecognized mount option \"%s\" "
> ./smbfs/getopt.c:	printk("%s: Unrecognized mount option %s\n", caller, token);
> Though I see for remount it is more a question of support
> versus recognising it or not. Ok.

I've fixed the typo.  The recognized vs supported thing will get a
little better once we switch to the parser table for mount, at which
point we can make the message more fine-grained and report either
unrecognized or unsupported.  But until we need the full blown parser
table I'd rather keep it simple.  But once this one and my patch series
to kill struct xfs_mount_args is in the full-blown switch to the table
driven parser is quite easy.

> I'm a little confused why we call xfs_mountfs_check_barriers(mp) in 2 places.
> Oh okay,
> so you want it tested if we have barrier option and
> currently not-readonly or after we transition to not-readonly.
> And you have it around the parsing code because you don't care about
> what it might transition to in the current not-readonly case.

Yes, if the filesystem is currently read-write we want to test the
barriers immediately, if it's read-only we can't test it just yet but
have to wait until the filesystems is remounted r/w.

> I think we ideally should have a qa test for this.
> We have 017 but it doesn't do any barrier or illegal options.

Makes sense.  I'll look into doing a QA test.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-06-29 14:03:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-06-30 14:42:02.000000000 +0200
@@ -66,6 +66,7 @@
 #include <linux/writeback.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/parser.h>
 
 static struct quotactl_ops xfs_quotactl_operations;
 static struct super_operations xfs_super_operations;
@@ -147,6 +148,23 @@ xfs_args_allocate(
 #define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
 
+/*
+ * Table driven mount option parser.
+ *
+ * Currently only used for remount, but it will be used for mount
+ * in the future, too.
+ */
+enum {
+	Opt_barrier, Opt_nobarrier, Opt_err
+};
+
+static match_table_t tokens = {
+	{Opt_barrier, "barrier"},
+	{Opt_nobarrier, "nobarrier"},
+	{Opt_err, NULL}
+};
+
+
 STATIC unsigned long
 suffix_strtoul(char *s, char **endp, unsigned int base)
 {
@@ -1261,36 +1279,54 @@ xfs_fs_remount(
 	char			*options)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
-	struct xfs_mount_args	*args;
-	int			error;
+	substring_t		args[MAX_OPT_ARGS];
+	char			*p;
 
-	args = xfs_args_allocate(sb, 0);
-	if (!args)
-		return -ENOMEM;
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
 
-	error = xfs_parseargs(mp, options, args, 1);
-	if (error)
-		goto out_free_args;
+		if (!*p)
+			continue;
 
-	if (!(*flags & MS_RDONLY)) {			/* rw/ro -> rw */
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
-		mp->m_flags &= ~XFS_MOUNT_RDONLY;
-		if (args->flags & XFSMNT_BARRIER) {
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_barrier:
 			mp->m_flags |= XFS_MOUNT_BARRIER;
-			xfs_mountfs_check_barriers(mp);
-		} else {
+
+			/*
+			 * Test if barriers are actually working if we can,
+			 * else delay this check until the filesystem is
+			 * marked writeable.
+			 */
+			if (!(mp->m_flags & XFS_MOUNT_RDONLY))
+				xfs_mountfs_check_barriers(mp);
+			break;
+		case Opt_nobarrier:
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
+			break;
+		default:
+			printk(KERN_INFO
+	"XFS: mount option \"%s\" not supported for remount\n", p);
+			return -EINVAL;
 		}
-	} else if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {	/* rw -> ro */
+	}
+
+	/* rw/ro -> rw */
+	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
+		mp->m_flags &= ~XFS_MOUNT_RDONLY;
+		if (mp->m_flags & XFS_MOUNT_BARRIER)
+			xfs_mountfs_check_barriers(mp);
+	}
+
+	/* rw -> ro */
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
 		xfs_filestream_flush(mp);
 		xfs_sync(mp, SYNC_DATA_QUIESCE);
 		xfs_attr_quiesce(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
 
- out_free_args:
-	kfree(args);
-	return -error;
+	return 0;
 }
 
 /*
