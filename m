Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3A4YF3U045628 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 23:34:16 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id V0Sb2pQavMLaaeBB for
	<xfs@oss.sgi.com>; Mon, 09 Apr 2012 21:34:14 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3A4YEVU014965
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 00:34:14 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q3A4YD3S000454
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 00:34:13 -0400
Message-ID: <4F83B844.3060508@redhat.com>
Date: Mon, 09 Apr 2012 23:34:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] metadump: obfuscate symlinks by path component
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

xfs_metadump currently obfuscates entire symlinks without regard
to path components; this can lead to a corrupt image when restoring
a metadump containing extremely long symlinks:

Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
component of symlink in inode 145 too long
problem with symbolic link in inode 145
cleared inode 145
... <more trail of woe>

Fix this by consolidating symlink obfuscation into a new
function which obfuscates one path component at a time.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Yes, I need to do an xfstest for this.  metadumping a filesystem
after fsstressing it works well.

diff --git a/db/metadump.c b/db/metadump.c
index c5ffddb..9f15d9e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -956,6 +956,40 @@ obfuscate_sf_dir(
 }
 
 static void
+obfuscate_path_components(
+	char			*buf,
+	__uint64_t		len)
+{
+	uchar_t			*comp;
+	xfs_dahash_t		hash;
+
+	comp = (uchar_t *)buf;
+	while (comp < (uchar_t *)buf + len) {
+		char	*slash;
+		int	namelen;
+
+		/* find slash at end of this component */
+		slash = strchr((char *)comp, '/');
+		if (!slash) {
+			/* last (or single) component */
+			namelen = strlen((char *)comp);
+			hash = libxfs_da_hashname(comp, namelen);
+			obfuscate_name(hash, namelen, comp);
+			break;
+		}
+		namelen = slash - (char *)comp;
+		/* handle leading or consecutive slashes */
+		if (!namelen) {
+			comp++;
+			continue;
+		}
+		hash = libxfs_da_hashname(comp, namelen);
+		obfuscate_name(hash, namelen, comp);
+		comp += namelen + 1;
+	}
+}
+
+static void
 obfuscate_sf_symlink(
 	xfs_dinode_t		*dip)
 {
@@ -971,8 +1005,7 @@ obfuscate_sf_symlink(
 	}
 
 	buf = (char *)XFS_DFORK_DPTR(dip);
-	while (len > 0)
-		buf[--len] = random() % 127 + 1;
+	obfuscate_path_components(buf, len);
 }
 
 static void
@@ -1176,11 +1209,8 @@ obfuscate_symlink_blocks(
 	char			*block,
 	xfs_dfilblks_t		count)
 {
-	int 			i;
-
 	count <<= mp->m_sb.sb_blocklog;
-	for (i = 0; i < count; i++)
-		block[i] = random() % 127 + 1;
+	obfuscate_path_components(block, count);
 }
 
 #define MAX_REMOTE_VALS		4095

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
