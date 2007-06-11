Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 00:09:28 -0700 (PDT)
Received: from stitch.e-626.net (60.153.216.81.static.spa.siw.siwnet.net [81.216.153.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5B79LWt027819
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 00:09:23 -0700
Received: from [130.100.71.110] (hidden-user@146.175.241.83.in-addr.dgcsystems.net [83.241.175.146])
	(authenticated bits=0)
	by stitch.e-626.net (8.14.0/8.13.7) with ESMTP id l5B6pXVU022993
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 08:51:54 +0200
Subject: xfs_fsr allocation group optimization
From: Johan Andersson <johan@e-626.net>
Content-Type: multipart/mixed; boundary="=-wsRKX+nWyxHC7f7kq87l"
Date: Mon, 11 Jun 2007 08:51:32 +0200
Message-Id: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-wsRKX+nWyxHC7f7kq87l
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi!

Last week I discovered that one of our volumes had 87%(!) file
fragmentation. Number of extents per file was in the range of thousands!
Nothing you are used to when it comes to XFS...
The filesystem is 68% full, but was up to 99% full for a short period a
couple of weeks earlier.

The xfs_fsr utility is made for this kind of problem, but after reading
more about xfs_fsr, in particular this:
http://oss.sgi.com/archives/xfs/2003-02/msg00141.html
I was more sceptical.

So I run some tests. And as Chris pointed out, when running xfs_fsr on a
badly fragmented filesystem, it completely destroys the locality of
files.

Then I decided to try to fix this, so I wrote a dirty little proof of
concept hack to xfs_fsr.c (diff against cvs attached) that finds one
name for the inode it defrags, and places the temporary file it's parent
directory. This way, it will restore the broken locality.

This works fine, after running it on the badly fragmented filesystem,
both fragmentation and locality was better than ever!

However, this fix is as I said "dirty". It uses find -inum to find a
filename for an inode. This makes it quite slow. Not much of a problem
for a one-time problem like this, but it's not very nice to put this
into a cron-job. There must be a better way to find the filename. But
I'm not familiar with the internals of XFS, so I thought I ask on this
list:
Does anyone know of a good way to find one filename that points o a
certain inode? I can't use xfs_db ncheck, as the filesystem is mounted.
Or is there a way to tell XFS to place extents in a newly created file
in a certain AG?

/Johan Andersson


--=-wsRKX+nWyxHC7f7kq87l
Content-Disposition: attachment; filename=xfs_fsr-agfix.diff
Content-Type: text/x-patch; name=xfs_fsr-agfix.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: xfs_fsr.c
===================================================================
RCS file: /cvs/xfs-cmds/xfsdump/fsr/xfs_fsr.c,v
retrieving revision 1.28
diff -u -r1.28 xfs_fsr.c
--- xfs_fsr.c	24 May 2007 03:59:42 -0000	1.28
+++ xfs_fsr.c	11 Jun 2007 06:42:29 -0000
@@ -655,10 +655,12 @@
 	int	ret;
 	__s32	buflenout;
 	xfs_bstat_t buf[GRABSZ];
-	char	fname[64];
+	char	fname[PATH_MAX+1];
 	char	*tname;
+	char    cmd[64];
 	jdm_fshandle_t	*fshandlep;
 	xfs_ino_t	lastino = startino;
+	FILE    *pfname;
 
 	fsrprintf(_("%s start inode=%llu\n"), mntdir,
 		(unsigned long long)startino);
@@ -714,11 +716,20 @@
 				continue;
 			}
 
-			/* Don't know the pathname, so make up something */
-			sprintf(fname, "ino=%lld", (long long)p->bs_ino);
-
-			/* Get a tmp file name */
-			tname = tmp_next(mntdir);
+			/* Find (one) filename that this inode belongs to. */
+			snprintf(cmd, sizeof(cmd), "find %s -xdev -inum %lld -print0", mntdir, (long long)p->bs_ino);
+			pfname = popen(cmd, "r");
+			fgets(fname, sizeof(fname), pfname);
+			pclose(pfname);
+			
+			if (strlen(fname)) {
+			  tname = gettmpname(fname);
+			} else {
+			  /* Don't know the pathname, so make up something */
+			  snprintf(fname, sizeof(fname), "ino=%lld", (long long)p->bs_ino);
+			  /* Get a tmp file name */
+			  tname = tmp_next(mntdir);
+			} 
 
 			ret = fsrfile_common(fname, tname, mntdir, fd, p);
 
@@ -1297,6 +1308,8 @@
 
 	strcat(buf, sbuf);
 
+	fsrprintf(_("gettmpname: fname=%s, buf=%s\n"), fname, buf);
+
 	return(buf);
 }
 

--=-wsRKX+nWyxHC7f7kq87l--
