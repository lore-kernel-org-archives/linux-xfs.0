Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANH9grH225025 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:09:43 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82BC91552CC6
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 09:09:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aAH0QncPNyQoIYQG for
	<xfs@oss.sgi.com>; Wed, 23 Nov 2011 09:09:41 -0800 (PST)
Message-ID: <4ECD28D1.1080800@redhat.com>
Date: Wed, 23 Nov 2011 11:09:37 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Sort recursive getfattr output in 062
References: <4EC10664.1080501@tuxadero.com>
	<CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
	<20111115142246.GA7516@thunk.org>
	<246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
	<4ECA4282.5020908@whamcloud.com>
	<401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
	<4ECB2ADE.3010007@redhat.com>
In-Reply-To: <4ECB2ADE.3010007@redhat.com>
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
To: Theodore Tso <tytso@MIT.EDU>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Yu Jian <yujian@whamcloud.com>, Andreas Dilger <adilger@whamcloud.com>, xfs-oss <xfs@oss.sgi.com>

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

diff --git a/062 b/062
index f666e1b..7005c4e 100755
- --- a/062
+++ b/062
@@ -46,6 +46,13 @@ _cleanup()
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
+# getfattr -R returns info in readdir order which varies from fs to fs.
+# This sorts the output by filename
+_sort_getfattr_output()
+{
+	awk '{a[FNR]=$0}END{n = asort(a); for(i=1; i <= n; i++) print a[i],"\n"}' RS=''
+}
+
 getfattr()
 {
     $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch
@@ -67,7 +74,7 @@ _create_test_bed()
 	mknod $SCRATCH_MNT/dev/c c 0 0
 	mknod $SCRATCH_MNT/dev/p p
 	# sanity check
- -	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch
+	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch | grep -v "lost+found"
 }
 
 # real QA test starts here
@@ -160,18 +167,18 @@ _extend_test_bed()
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
index 699254a..7d05c85 100644
- --- a/062.out
+++ b/062.out
@@ -508,115 +508,115 @@ SCRATCH_MNT/lnk
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
- -trusted.name3=0xdeface
+trusted.name3=0xdeface 
 
 # file: SCRATCH_MNT/dev/c
 trusted.name=0xbabe
- -trusted.name3=0xdeface
+trusted.name3=0xdeface 
 
 # file: SCRATCH_MNT/dev/p
 trusted.name=0xbabe
+trusted.name3=0xdeface 
+
+# file: SCRATCH_MNT/dir
+trusted.name=0xbabe
 trusted.name3=0xdeface
+user.name=0xbabe
+user.name3=0xdeface 
 
 # file: SCRATCH_MNT/here
 trusted.9=0x3837
- -trusted.a=0x6263
+trusted.a=0x6263 
 
 # file: SCRATCH_MNT/here/up
 trusted.9=0x3837
- -trusted.a=0x6263
+trusted.a=0x6263 
 
 # file: SCRATCH_MNT/here/up/ascend
 trusted.9=0x3837
- -trusted.a=0x6263
+trusted.a=0x6263 
 
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
- -user.x=0x797a
+user.x=0x797a 
 
 # file: SCRATCH_MNT/descend/down
 user.1=0x3233
- -user.x=0x797a
+user.x=0x797a 
 
 # file: SCRATCH_MNT/descend/down/here
 user.1=0x3233
- -user.x=0x797a
- -
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
+user.x=0x797a 
 
 # file: SCRATCH_MNT/dev/b
 trusted.name=0xbabe
- -trusted.name3=0xdeface
+trusted.name3=0xdeface 
 
 # file: SCRATCH_MNT/dev/c
 trusted.name=0xbabe
- -trusted.name3=0xdeface
+trusted.name3=0xdeface 
 
 # file: SCRATCH_MNT/dev/p
 trusted.name=0xbabe
+trusted.name3=0xdeface 
+
+# file: SCRATCH_MNT/dir
+trusted.name=0xbabe
 trusted.name3=0xdeface
+user.name=0xbabe
+user.name3=0xdeface 
 
 # file: SCRATCH_MNT/here
 trusted.9=0x3837
- -trusted.a=0x6263
+trusted.a=0x6263 
 
 # file: SCRATCH_MNT/here/up
 trusted.9=0x3837
- -trusted.a=0x6263
+trusted.a=0x6263 
 
 # file: SCRATCH_MNT/here/up/ascend
 trusted.9=0x3837
- -trusted.a=0x6263
+trusted.a=0x6263 
 
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
 
 
 


-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzSjQAAoJECCuFpLhPd7gsJIP/j2BKTvft/QjnLxs+gJT/f0S
H7L9r/izHcQ5Z/xk9t4unpOr35EsXOuwMzWN8OrB3fCx0J7gkIj7s7dNFrou8K8w
bkVW6lzy5VUOHPzkqFSNLHSf2YLrrXNfPBLgOQl8A4lkNzY4gjy74uw05bLL4z3y
u+gmjwuOMRTwGe3N9l/q6VR7UybHRyYBE62Ee2SPBa59FFWdicqzQBGVj0OOAdQg
asTekASb8fXv/A4GNMFyNpZtA65ov8puISeGjV/A9Dhrx843qn1IFLA3UfcWEPEf
qF5MDkg0ZuDDzN8YOiZM5S6mY7KAGSiKAHlF9nNZistCMJy4UDWh2lGLCIDEoO8l
oRpbEOQy8tq7v7ppgp4kmh+8aIj0bletjZbgumPiu8KrRNCyXlBpGYGsBIPH+wgn
P0i7EKILkF7gRM6Gs4U7Ek88mLcDSrsRGjI7JWQgOufUoo9noZM4pBlfw+ngx3DC
NlhxisqyWcwDAVV1MBNvoSNGB5iLNCTgb/Ppgb7SdwNJ/heX9EAgKTsTnyENjtYe
ILcuWf0CLYRPG9gun3JIXS/IibJY4Eqi3E9jo+Et5q6eOGTFuD0hjgERULUzH9d2
wwWFq7KPtdJJbWK0mANn2HK0GQH79gskmWsFS8Mxl7JCSMfPOFdbHNSbqdzNKXJS
+OIS7v24/L/pNQNtuqEt
=hW9Q
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
