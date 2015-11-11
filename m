Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5FB427FBF
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 15:53:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 285BB8F8033
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:53:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9ELWKwXzqVuPTqWC for <xfs@oss.sgi.com>;
	Wed, 11 Nov 2015 13:52:56 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 75E9761F88CD
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 15:52:56 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs_fsr: more selinux fixes
Message-ID: <5643B8B7.9030708@sandeen.net>
Date: Wed, 11 Nov 2015 15:52:55 -0600
MIME-Version: 1.0
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

Commit:

1adfe5c xfs_fsr: fix SWAPEXT failures under selinux

attempted to fix up the fork offset under selinux, where
the temp file is created with a local attribute, but the
target file has remote attributes; this can lead to a smaller
data area in the temp inode, without enough room to swap extents
from the target inode.  I remedied this by pushing the temp
file attribute to remote, but *only* if the target file's attr
was also remote.

However, I have a case from the field where the parent dir
and the target file both have a context of:

system_u:object_r:samba_share_t:s0

but new files created in the dir have a context of

unconfined_u:object_r:samba_share_t:s0

This means the temp file has a smaller forkoff, and less space
in the inode for data, so we fail to swap the extents between
the two, because they don't fit.

The following patch fixes this by allowing xfs_fsr to
kick the tempfile's attr out of local format even if the target
file's attr is local, if this will move the forkoff in the right
direction.  This does pass all our fsr xfstests, though I'm not
sure we have any real coverage of fsr under selinux...

The only functional change is the test at the very end of the
patch; the rest is comments, ascii art, and removing the
now-extraneous XFS_IOC_FSGETXATTRA ioctl.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index c8ef18f..68b9819 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1104,14 +1104,12 @@ fsr_setup_attr_fork(
 			}
 			continue;
 		} else if (i == 0) {
-			struct fsxattr	fsx;
 			/*
 			 * First pass, and temp file already has an inline
 			 * xattr, probably due to selinux.
 			 *
 			 * It's *possible* that the temp file attr area
-			 * is larger than the target file's, if the 
-			 * target file's attrs are not inline:
+			 * is larger than the target file's:
 			 *
 			 *  Target		 Temp
 			 * +-------+ 0		+-------+ 0
@@ -1121,28 +1119,18 @@ fsr_setup_attr_fork(
 			 * |	   |		v-------v forkoff
 			 * |	   |		|       |
 			 * v-------v forkoff	| Attr  | local
-			 * | Attr  | ext/btree	|       |
+			 * | Attr  | 		|       |
 			 * +-------+		+-------+
-			 *
-			 * FSGETXATTRA will tell us nr of attr extents in
-			 * target, if any.  If none, it's local:
 			 */
 
-			memset(&fsx, 0, sizeof(fsx));
-			if (ioctl(fd, XFS_IOC_FSGETXATTRA, &fsx)) {
-				fsrprintf(_("FSGETXATTRA failed on target\n"));
-				return -1;
-			}
-
 			/*
-			 * If target attr area is less than the temp's (diff < 0)
-			 * and the target is not local, write a big attr to
-			 * the temp file to knock the attr out of local format,
-			 * to match the target.  (This should actually *increase*
-			 * the temp file's forkoffset when the attr moves out
-			 * of the inode)
+			 * If target attr area is less than the temp's
+			 * (diff < 0), write a big attr to the temp file to knock
+			 * the attr out of local format.
+			 * (This should actually *increase* the temp file's
+			 * forkoffset when the attr moves out of the inode)
 			 */
- 			if (diff < 0 && fsx.fsx_nextents > 0) {
+ 			if (diff < 0) {
 				char val[2048];
 				memset(val, 'X', 2048);
 				if (fsetxattr(tfd, name, val, 2048, 0)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
