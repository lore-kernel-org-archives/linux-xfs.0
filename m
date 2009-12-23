Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNESDno241997 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 08:28:13 -0600
Received: from smtp27.orange.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C457E931E0
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 06:28:54 -0800 (PST)
Received: from smtp27.orange.fr (smtp27.orange.fr [80.12.242.94]) by
	cuda.sgi.com with ESMTP id o6YOXkuoFhrY14WY for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2009 06:28:54 -0800 (PST)
Message-ID: <4B322924.1030406@wanadoo.fr>
Date: Wed, 23 Dec 2009 15:28:52 +0100
From: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
MIME-Version: 1.0
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp>
	<4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp>
	<4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp>
	<4B30B67A.7080703@wanadoo.fr>	<87ljgvi1an.fsf@devron.myhome.or.jp>
	<4B30F0C9.2020702@wanadoo.fr> <87my1aevro.fsf@devron.myhome.or.jp>
In-Reply-To: <87my1aevro.fsf@devron.myhome.or.jp>
Content-Type: multipart/mixed; boundary="------------020808040301050801010500"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Eric Blake <ebb9@byu.net>, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>

This is a multi-part message in MIME format.
--------------020808040301050801010500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

OGAWA Hirofumi wrote:
>> I suggest I port Miklos patch to fuse-lite soon,
>> and delay the low-level case (and microsecond
>> precision) until January. Does that suit your needs ?
>>      
> Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
> bug report on lkml to others. Eric?

As my Christmas present to any real non-bridging
user, here is, ahead of schedule, the patch for the
low level fuse interface of ntfs-3g.

The good news is that for this interface, no update
of fuse is needed. So there is no compilation issue with
unpatched versions of fuse, and the attached patch
is independent of the one for the high-level interface
posted previously, except for the configuration.ac file
for which I duplicate the patch.

Regards

Jean-Pierre




--------------020808040301050801010500
Content-Type: text/plain;
 name="lowutimensat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lowutimensat.patch"

--- ntfs-3g-2009.11.14AC.2/configure.ac	2009-12-16 08:33:26.000000000 +0100
+++ ntfslow/configure.ac	2009-12-23 10:24:29.000000000 +0100
@@ -314,7 +314,7 @@
 	atexit basename daemon dup2 fdatasync ffs getopt_long hasmntopt \
 	mbsinit memmove memset realpath regcomp setlocale setxattr \
 	strcasecmp strchr strdup strerror strnlen strsep strtol strtoul \
-	sysconf utime fork \
+	sysconf utime utimensat fork \
 ])
 AC_SYS_LARGEFILE
 
--- ntfs-3g-2009.11.14AC.2/src/lowntfs-3g.c	2009-12-19 09:58:22.000000000 +0100
+++ ntfslow/src/lowntfs-3g.c	2009-12-23 15:06:14.000000000 +0100
@@ -1527,8 +1527,54 @@
 	return res;
 }
 
+#ifdef HAVE_UTIMENSAT
+
+static int ntfs_fuse_utimens(struct SECURITY_CONTEXT *scx, fuse_ino_t ino,
+		struct stat *stin, struct stat *stbuf, int to_set)
+{
+	ntfs_inode *ni;
+	int res = 0;
+
+	ni = ntfs_inode_open(ctx->vol, INODE(ino));
+	if (!ni)
+		return -errno;
+
+			/* no check or update if both UTIME_OMIT */
+	if (to_set & (FUSE_SET_ATTR_ATIME + FUSE_SET_ATTR_MTIME)) {
+#if !KERNELPERMS | (POSIXACLS & !KERNELACLS)
+		if (ntfs_allowed_access(scx, ni, S_IWRITE)
+		    || ((to_set & FUSE_SET_ATTR_ATIME_NOW)
+			&& (to_set & FUSE_SET_ATTR_MTIME_NOW)
+			&& ntfs_allowed_as_owner(scx, ni))) {
+#endif
+			ntfs_time_update_flags mask = NTFS_UPDATE_CTIME;
+
+			if (to_set & FUSE_SET_ATTR_ATIME_NOW)
+				mask |= NTFS_UPDATE_ATIME;
+			else
+				if (to_set & FUSE_SET_ATTR_ATIME)
+					ni->last_access_time = stin->st_atime;
+			if (to_set & FUSE_SET_ATTR_MTIME_NOW)
+				mask |= NTFS_UPDATE_MTIME;
+			else
+				if (to_set & FUSE_SET_ATTR_MTIME)
+					ni->last_data_change_time = stin->st_mtime;;
+			ntfs_inode_update_times(ni, mask);
+#if !KERNELPERMS | (POSIXACLS & !KERNELACLS)
+		} else
+			res = -errno;
+#endif
+	}
+	res = ntfs_fuse_getstat(scx, ni, stbuf);
+	if (ntfs_inode_close(ni))
+		set_fuse_error(&res);
+	return res;
+}
+
+#else /* HAVE_UTIMENSAT */
+
 static int ntfs_fuse_utime(struct SECURITY_CONTEXT *scx, fuse_ino_t ino,
-		struct stat *stin, struct stat *stbuf)
+		struct stat *stin, struct stat *stbuf, int to_set)
 {
 	ntfs_inode *ni;
 	int res = 0;
@@ -1586,6 +1632,8 @@
 	return res;
 }
 
+#endif /* HAVE_UTIMENSAT */
+
 static void ntfs_fuse_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
 			 int to_set, struct fuse_file_info *fi __attribute__((unused)))
 {
@@ -1594,13 +1642,14 @@
 	int res;
 	struct SECURITY_CONTEXT security;
 
+	res = 0;
 	ntfs_fuse_fill_security_context(req, &security);
-	switch (to_set
+						/* no flags */
+	if (!(to_set
 		    & (FUSE_SET_ATTR_MODE
 			| FUSE_SET_ATTR_UID | FUSE_SET_ATTR_GID
 			| FUSE_SET_ATTR_SIZE
-			| FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) {
-	case 0 :
+			| FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME))) {
 		ni = ntfs_inode_open(ctx->vol, INODE(ino));
 		if (!ni)
 			res = -errno;
@@ -1609,46 +1658,60 @@
 			if (ntfs_inode_close(ni))
 				set_fuse_error(&res);
 		}
-		break;
-	case FUSE_SET_ATTR_MODE :
-		res = ntfs_fuse_chmod(&security, ino, attr->st_mode & 07777,
-					&stbuf);
-		break;
-	case FUSE_SET_ATTR_UID :
-		res = ntfs_fuse_chown(&security, ino, attr->st_uid,
-					(gid_t)-1, &stbuf);
-		break;
-	case FUSE_SET_ATTR_GID :
-		res = ntfs_fuse_chown(&security, ino, (uid_t)-1,
-					attr->st_gid, &stbuf);
-		break;
-	case FUSE_SET_ATTR_UID + FUSE_SET_ATTR_GID :
-		res = ntfs_fuse_chown(&security, ino, attr->st_uid,
-					attr->st_gid, &stbuf);
-		break;
-	case FUSE_SET_ATTR_UID + FUSE_SET_ATTR_MODE:
-		res = ntfs_fuse_chownmod(&security, ino, attr->st_uid,
-					(gid_t)-1,attr->st_mode, &stbuf);
-		break;
-	case FUSE_SET_ATTR_GID + FUSE_SET_ATTR_MODE:
-		res = ntfs_fuse_chownmod(&security, ino, (uid_t)-1,
-					attr->st_gid,attr->st_mode, &stbuf);
-		break;
-	case FUSE_SET_ATTR_UID + FUSE_SET_ATTR_GID + FUSE_SET_ATTR_MODE:
-		res = ntfs_fuse_chownmod(&security, ino, attr->st_uid,
+	}
+						/* some set of uid/gid/mode */
+	if (to_set
+		    & (FUSE_SET_ATTR_MODE
+			| FUSE_SET_ATTR_UID | FUSE_SET_ATTR_GID)) {
+		switch (to_set
+			    & (FUSE_SET_ATTR_MODE
+				| FUSE_SET_ATTR_UID | FUSE_SET_ATTR_GID)) {
+		case FUSE_SET_ATTR_MODE :
+			res = ntfs_fuse_chmod(&security, ino,
+						attr->st_mode & 07777, &stbuf);
+			break;
+		case FUSE_SET_ATTR_UID :
+			res = ntfs_fuse_chown(&security, ino, attr->st_uid,
+						(gid_t)-1, &stbuf);
+			break;
+		case FUSE_SET_ATTR_GID :
+			res = ntfs_fuse_chown(&security, ino, (uid_t)-1,
+						attr->st_gid, &stbuf);
+			break;
+		case FUSE_SET_ATTR_UID + FUSE_SET_ATTR_GID :
+			res = ntfs_fuse_chown(&security, ino, attr->st_uid,
+						attr->st_gid, &stbuf);
+			break;
+		case FUSE_SET_ATTR_UID + FUSE_SET_ATTR_MODE:
+			res = ntfs_fuse_chownmod(&security, ino, attr->st_uid,
+						(gid_t)-1,attr->st_mode,
+						&stbuf);
+			break;
+		case FUSE_SET_ATTR_GID + FUSE_SET_ATTR_MODE:
+			res = ntfs_fuse_chownmod(&security, ino, (uid_t)-1,
+						attr->st_gid,attr->st_mode,
+						&stbuf);
+			break;
+		case FUSE_SET_ATTR_UID + FUSE_SET_ATTR_GID + FUSE_SET_ATTR_MODE:
+			res = ntfs_fuse_chownmod(&security, ino, attr->st_uid,
 					attr->st_gid,attr->st_mode, &stbuf);
-		break;
-	case FUSE_SET_ATTR_SIZE :
+			break;
+		default :
+			break;
+		}
+	}
+						/* size */
+	if (!res && (to_set & FUSE_SET_ATTR_SIZE)) {
 		res = ntfs_fuse_trunc(&security, ino, attr->st_size,
 					!fi, &stbuf);
-		break;
-	case FUSE_SET_ATTR_ATIME + FUSE_SET_ATTR_MTIME :
+	}
+						/* some set of atime/mtime */
+	if (!res && (to_set & (FUSE_SET_ATTR_ATIME + FUSE_SET_ATTR_MTIME))) {
+#ifdef HAVE_UTIMENSAT
+		res = ntfs_fuse_utimens(&security, ino, attr, &stbuf, to_set);
+#else /* HAVE_UTIMENSAT */
 		res = ntfs_fuse_utime(&security, ino, attr, &stbuf);
-		break;
-	default:
-		ntfs_log_error("Unsupported setattr mode 0x%x\n",(int)to_set);
-		res = -EOPNOTSUPP;
-		break;
+#endif /* HAVE_UTIMENSAT */
 	}
 	if (res)
 		fuse_reply_err(req, -res);

--------------020808040301050801010500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------020808040301050801010500--
