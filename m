Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7DKERo3160999 for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 15:14:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7FBB18C685E
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 13:14:22 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tqza9dKeNwi3VQJi for <xfs@oss.sgi.com>;
	Sat, 13 Aug 2011 13:14:22 -0700 (PDT)
Date: Sat, 13 Aug 2011 16:14:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests #62 broken on ext4
Message-ID: <20110813201419.GA6442@infradead.org>
References: <E1QsFMR-0001iq-Vt@tytso-glaptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <E1QsFMR-0001iq-Vt@tytso-glaptop>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 13, 2011 at 10:38:51AM -0400, Theodore Ts'o wrote:
> 
> Xfstests #62 was recently enabled by commit b2b36d0a4.
> 
> However, this test is failing for ext4 because ext4 doesn't support
> extended attributes on anything other than regular files and
> directories.  This is behavior is documented in the attr(5) man page:

As explained to you before that is not the reason why it fails.  The
reason is that Andreas Gruenbacher changed return values for certain
xattr operations in commit 55b23bde19c08f14127a27d461a4e079942c7258.


> It looks like XFS is not conformant to documented behaviour and the file
> system generic code.

Care to explain that conclusion?  A simple test and/or a look at the
code will reveal that this is not true.

Below is the patch from Andreas that makes the test work properly again
on Linux 3.0+ on XFS, although other filesystem still have some issues
with it.  For ext4 that mostly seems the presence of the lost+found
directory, and a different ordering from readdir than expected.

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.diff"

diff --git a/062 b/062
index 5cb6f92..df29e7a 100755
--- a/062
+++ b/062
@@ -84,6 +84,12 @@ _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 _scratch_mount || _fail "mount failed"
 _create_test_bed
 
+# In kernels before 3.0.0, getxattr() returns -EPERM for an attribute which
+# cannot exist.  Later kernels return -ENODATA.
+invalid_attribute_filter() {
+	sed -e "s:\(No such attribute\|Operation not permitted\):No such attribute or operation not permitted:"
+}
+
 if [ "$USE_ATTR_SECURE" = yes ]; then
     ATTR_MODES="user security trusted"
 else
@@ -119,15 +125,15 @@ for nsp in $ATTR_MODES; do
 		
 		echo "*** set an empty value for second attribute"
 		setfattr -h -n $nsp.name2 $SCRATCH_MNT/$inode
-		getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode
+		getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
 
 		echo "*** overwrite empty value"
 		setfattr -h -n $nsp.name2 -v 0xcafe $SCRATCH_MNT/$inode
-		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode
+		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
 
 		echo "*** remove attribute"
 		setfattr -h -x $nsp.name2 $SCRATCH_MNT/$inode
-		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode
+		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
 
 		echo "*** final list (strings, type=$inode, nsp=$nsp)"
 		getfattr -m '.' -e hex $SCRATCH_MNT/$inode
diff --git a/062.out b/062.out
index 73fd628..5e3f5d9 100644
--- a/062.out
+++ b/062.out
@@ -55,7 +55,7 @@ user.name2
 user.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/reg: user.name2: No such attribute
+SCRATCH_MNT/reg: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=reg, nsp=user)
 # file: SCRATCH_MNT/reg
 user.name=0xbabe
@@ -102,7 +102,7 @@ user.name2
 user.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dir: user.name2: No such attribute
+SCRATCH_MNT/dir: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dir, nsp=user)
 # file: SCRATCH_MNT/dir
 user.name=0xbabe
@@ -125,13 +125,13 @@ setfattr: SCRATCH_MNT/lnk: Operation not permitted
 setfattr: SCRATCH_MNT/lnk: Operation not permitted
 *** set an empty value for second attribute
 setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: Operation not permitted
+SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
 setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: Operation not permitted
+SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
 *** remove attribute
 setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: Operation not permitted
+SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=lnk, nsp=user)
 
 === TYPE dev/b; NAMESPACE user
@@ -150,13 +150,13 @@ setfattr: SCRATCH_MNT/dev/b: Operation not permitted
 setfattr: SCRATCH_MNT/dev/b: Operation not permitted
 *** set an empty value for second attribute
 setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: Operation not permitted
+SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
 setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: Operation not permitted
+SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
 *** remove attribute
 setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: Operation not permitted
+SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/b, nsp=user)
 
 === TYPE dev/c; NAMESPACE user
@@ -175,13 +175,13 @@ setfattr: SCRATCH_MNT/dev/c: Operation not permitted
 setfattr: SCRATCH_MNT/dev/c: Operation not permitted
 *** set an empty value for second attribute
 setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: Operation not permitted
+SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
 setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: Operation not permitted
+SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
 *** remove attribute
 setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: Operation not permitted
+SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/c, nsp=user)
 
 === TYPE dev/p; NAMESPACE user
@@ -200,13 +200,13 @@ setfattr: SCRATCH_MNT/dev/p: Operation not permitted
 setfattr: SCRATCH_MNT/dev/p: Operation not permitted
 *** set an empty value for second attribute
 setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: Operation not permitted
+SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
 setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: Operation not permitted
+SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
 *** remove attribute
 setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: Operation not permitted
+SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/p, nsp=user)
 
 === TYPE reg; NAMESPACE trusted
@@ -249,7 +249,7 @@ trusted.name2
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/reg: trusted.name2: No such attribute
+SCRATCH_MNT/reg: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=reg, nsp=trusted)
 # file: SCRATCH_MNT/reg
 trusted.name=0xbabe
@@ -298,7 +298,7 @@ trusted.name2
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dir: trusted.name2: No such attribute
+SCRATCH_MNT/dir: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dir, nsp=trusted)
 # file: SCRATCH_MNT/dir
 trusted.name=0xbabe
@@ -347,7 +347,7 @@ trusted.name2
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/lnk: trusted.name2: No such attribute
+SCRATCH_MNT/lnk: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=lnk, nsp=trusted)
 # file: SCRATCH_MNT/lnk
 trusted.name=0xbabe
@@ -394,7 +394,7 @@ trusted.name2
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dev/b: trusted.name2: No such attribute
+SCRATCH_MNT/dev/b: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/b, nsp=trusted)
 # file: SCRATCH_MNT/dev/b
 trusted.name=0xbabe
@@ -441,7 +441,7 @@ trusted.name2
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dev/c: trusted.name2: No such attribute
+SCRATCH_MNT/dev/c: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/c, nsp=trusted)
 # file: SCRATCH_MNT/dev/c
 trusted.name=0xbabe
@@ -488,7 +488,7 @@ trusted.name2
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dev/p: trusted.name2: No such attribute
+SCRATCH_MNT/dev/p: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/p, nsp=trusted)
 # file: SCRATCH_MNT/dev/p
 trusted.name=0xbabe

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--CdrF4e02JqNVZeln--
