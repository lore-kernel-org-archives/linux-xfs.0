Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PLcuB6074994 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 15:38:57 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id yR4CO18O8O5huxPk for <xfs@oss.sgi.com>;
	Wed, 25 Jan 2012 13:38:54 -0800 (PST)
Message-ID: <4F20766E.9040902@sandeen.net>
Date: Wed, 25 Jan 2012 15:38:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: Sort recursive getfattr output in 062
References: <4EC10664.1080501@tuxadero.com>
	<CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
	<20111115142246.GA7516@thunk.org>
	<246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
	<4ECA4282.5020908@whamcloud.com>
	<401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
	<4ECB2ADE.3010007@redhat.com> <4ECD28D1.1080800@redhat.com>
In-Reply-To: <4ECD28D1.1080800@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andreas Dilger <adilger@whamcloud.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@MIT.EDU>, Yu Jian <yujian@whamcloud.com>, xfs-oss <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Test 062 was made "generic" a while back, but it fails on any filesystem
which returns getfattr -R results (aka readdir results) in something
other than inode-order.

With a little awk-fu we can sort the records from getfattr -R so that
the output is the same for xfs as well as ext4, etc.

Also filter out lost+found which extN creates at mkfs time, but
some other filesystems do not.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
- ---

V2: move sorting function into common.attr

diff --git a/062 b/062
index f666e1b..9800e33 100755
- --- a/062
+++ b/062
@@ -67,7 +67,7 @@ _create_test_bed()
 	mknod $SCRATCH_MNT/dev/c c 0 0
 	mknod $SCRATCH_MNT/dev/p p
 	# sanity check
- -	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch
+	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch | grep -v "lost+found"
 }
 
 # real QA test starts here
@@ -160,18 +160,18 @@ _extend_test_bed()
 	# whack a symlink in the middle, just to be difficult
 	ln -s $SCRATCH_MNT/here/up $SCRATCH_MNT/descend/and
 	# dump out our new starting point
- -	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch
+	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch | grep -v "lost+found"
 }
 
 _extend_test_bed
 
 echo
 echo "*** directory descent with us following symlinks"
- -getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT
+getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT | _sort_getfattr_output
 
 echo
 echo "*** directory descent without following symlinks"
- -getfattr -h -P -R -m '.' -e hex $SCRATCH_MNT
+getfattr -h -P -R -m '.' -e hex $SCRATCH_MNT | _sort_getfattr_output
 
 
 # 
diff --git a/062.out b/062.out
index 699254a..8cc3c65 100644
- --- a/062.out
+++ b/062.out
@@ -508,21 +508,21 @@ SCRATCH_MNT/lnk
 SCRATCH_MNT/reg
 
 *** directory descent with us following symlinks
- -# file: SCRATCH_MNT/reg
- -trusted.name=0xbabe
- -trusted.name3=0xdeface
- -user.name=0xbabe
- -user.name3=0xdeface
+# file: SCRATCH_MNT/descend
+user.1=0x3233
+user.x=0x797a
 
- -# file: SCRATCH_MNT/dir
- -trusted.name=0xbabe
- -trusted.name3=0xdeface
- -user.name=0xbabe
- -user.name3=0xdeface
+# file: SCRATCH_MNT/descend/and/ascend
+trusted.9=0x3837
+trusted.a=0x6263
 
- -# file: SCRATCH_MNT/lnk
- -trusted.name=0xbabe
- -trusted.name3=0xdeface
+# file: SCRATCH_MNT/descend/down
+user.1=0x3233
+user.x=0x797a
+
+# file: SCRATCH_MNT/descend/down/here
+user.1=0x3233
+user.x=0x797a
 
 # file: SCRATCH_MNT/dev/b
 trusted.name=0xbabe
@@ -536,6 +536,12 @@ trusted.name3=0xdeface
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
+# file: SCRATCH_MNT/dir
+trusted.name=0xbabe
+trusted.name3=0xdeface
+user.name=0xbabe
+user.name3=0xdeface
+
 # file: SCRATCH_MNT/here
 trusted.9=0x3837
 trusted.a=0x6263
@@ -548,6 +554,18 @@ trusted.a=0x6263
 trusted.9=0x3837
 trusted.a=0x6263
 
+# file: SCRATCH_MNT/lnk
+trusted.name=0xbabe
+trusted.name3=0xdeface
+
+# file: SCRATCH_MNT/reg
+trusted.name=0xbabe
+trusted.name3=0xdeface
+user.name=0xbabe
+user.name3=0xdeface
+
+
+*** directory descent without following symlinks
 # file: SCRATCH_MNT/descend
 user.1=0x3233
 user.x=0x797a
@@ -560,28 +578,6 @@ user.x=0x797a
 user.1=0x3233
 user.x=0x797a
 
- -# file: SCRATCH_MNT/descend/and/ascend
- -trusted.9=0x3837
- -trusted.a=0x6263
- -
- -
- -*** directory descent without following symlinks
- -# file: SCRATCH_MNT/reg
- -trusted.name=0xbabe
- -trusted.name3=0xdeface
- -user.name=0xbabe
- -user.name3=0xdeface
- -
- -# file: SCRATCH_MNT/dir
- -trusted.name=0xbabe
- -trusted.name3=0xdeface
- -user.name=0xbabe
- -user.name3=0xdeface
- -
- -# file: SCRATCH_MNT/lnk
- -trusted.name=0xbabe
- -trusted.name3=0xdeface
- -
 # file: SCRATCH_MNT/dev/b
 trusted.name=0xbabe
 trusted.name3=0xdeface
@@ -594,6 +590,12 @@ trusted.name3=0xdeface
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
+# file: SCRATCH_MNT/dir
+trusted.name=0xbabe
+trusted.name3=0xdeface
+user.name=0xbabe
+user.name3=0xdeface
+
 # file: SCRATCH_MNT/here
 trusted.9=0x3837
 trusted.a=0x6263
@@ -606,17 +608,15 @@ trusted.a=0x6263
 trusted.9=0x3837
 trusted.a=0x6263
 
- -# file: SCRATCH_MNT/descend
- -user.1=0x3233
- -user.x=0x797a
- -
- -# file: SCRATCH_MNT/descend/down
- -user.1=0x3233
- -user.x=0x797a
+# file: SCRATCH_MNT/lnk
+trusted.name=0xbabe
+trusted.name3=0xdeface
 
- -# file: SCRATCH_MNT/descend/down/here
- -user.1=0x3233
- -user.x=0x797a
+# file: SCRATCH_MNT/reg
+trusted.name=0xbabe
+trusted.name3=0xdeface
+user.name=0xbabe
+user.name3=0xdeface
 
 
 
diff --git a/common.attr b/common.attr
index 3e2ba85..b49d990 100644
- --- a/common.attr
+++ b/common.attr
@@ -176,6 +176,13 @@ _require_attrs()
     rm -f $TEST_DIR/syscalltest.out
 }
 
+# getfattr -R returns info in readdir order which varies from fs to fs.
+# This sorts the output by filename
+_sort_getfattr_output()
+{
+	awk '{a[FNR]=$0}END{n = asort(a); for(i=1; i <= n; i++) print a[i]"\n"}' RS=''
+}
+
 # set maximum total attr space based on fs type
 if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
 	MAX_ATTRS=1000


-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPIHZtAAoJECCuFpLhPd7g2yMP/1VU2RhD8gdfpJIQKGvZjurP
XGmv2tLY/3eDWTwbpm3E5m3EmXIAZpq+ahUYT9C+I8afw0oLv4zggAQ3M6P20JlM
dM/M7imNHYfafIMr7wIw0+Iv0pt/tpDv3cm2kxJDJq+yW88Y+tRG/ifU8uSjREyX
WBSqKjo3mJ0CJ03Chh9xWDK7AV4reYW3cxlCNMMzUrRPho7hWIrZN58GhDO4esqa
x11eFp4qk6I5ApExfpa5PJIGTT7xepCsQsDSaf2HNKzSEg3c5fzV43nHUFl+qRNH
FQ0CPx10VMhxtr3RZI7laN01yHk5qWjMFB9ufldot6Xv/CFwU++zBVH21IwKAgvR
D/tihuxUf8Sllpa0+DuMTuobg2cZuvlyshkWeU4YGAbyFfxirPNVjqEcnfnIMnoA
+C3Sc/8DTd70C8WG9M5ON9sMmGtJr/s93OAZMwiLHGvBC1GZf51BvAI+l7ln3Ug3
jws77r4x1P01da6ciUsESNibCrilCiw3Q2XcYJU/VfbxpFZ0ro0ib3wA4O654vqN
V38zh7BOipn7ukWIn8KRc09d9X/PqsqeFNVaLJA+tMsxH021J8uluG4nTmn3a+jM
t79YFK0JccMk8t0ShCTUjhnhHXwdrVVs8MCCghc9QoYg2/HEQrcDPKft69hM9UTL
OrK3+QKMf3JATAYdgXSg
=w2HJ
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
