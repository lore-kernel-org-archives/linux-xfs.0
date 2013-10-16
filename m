Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 512557F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 09:05:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 332438F806F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 07:05:14 -0700 (PDT)
Received: from mail-we0-f175.google.com (mail-we0-f175.google.com
	[74.125.82.175]) by cuda.sgi.com with ESMTP id rphcmYgkM6hymoIU
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Oct 2013 07:05:12 -0700 (PDT)
Received: by mail-we0-f175.google.com with SMTP id t61so747722wes.20
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 07:05:11 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: add specific test for default ACL inheritance
Date: Wed, 16 Oct 2013 15:04:56 +0100
Message-Id: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: dsterba@suse.cz, jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>

This test is motivated by an issue found by a btrfs user, addressed
and described by the following GNU/Linux kernel patch:

https://patchwork.kernel.org/patch/3046931/

The steps to reproduce the issue on btrfs are the following:

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt
$ mkdir /mnt/acl
$ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
$ getfacl /mnt/acl
user::rwx
group::rwx
other::r-x
default:user::rwx
default:group::rwx
default:other::---

$ mkdir /mnt/acl/dir1
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---

After unmounting and mounting again the filesystem, getfacl returned the
expected default ACL for the subdirectory:

$ umount /mnt/acl
$ mount /dev/loop0 /mnt
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---
default:user::rwx
default:group::rwx
default:other::---

This means that the underlying ACL xattr was persisted correctly but
the in memory representation of the inode had (incorrectly) a NULL ACL.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/shared/051     |   18 ++++++++++++++++--
 tests/shared/051.out |   21 +++++++++++++++++++++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/tests/shared/051 b/tests/shared/051
index 07399cc..56a4c10 100755
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -69,7 +69,7 @@ _cleanup()
 #
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs xfs udf btrfs
 _supported_os Linux
 
 [ -x $runas ] || _notrun "$runas executable not found"
@@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
 getfacl --numeric largeaclfile | _filter_aces
 
 echo "1 above xfs acl max"
-chacl $acl3 largeaclfile
+if [ "$FSTYP" != "btrfs" ]; then
+	chacl $acl3 largeaclfile
+else
+	echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
+fi
+
 getfacl --numeric largeaclfile | _filter_aces
 
 echo "use 16 aces"
@@ -356,6 +361,15 @@ echo "use 17 aces"
 chacl $acl5 largeaclfile
 getfacl --numeric largeaclfile | _filter_aces
 
+echo "=== Test child directory inheritance of its parent's default ACL ==="
+
+mkdir $SCRATCH_MNT/testdir
+setfacl -d --set u::rwx,g::rwx,o::- $SCRATCH_MNT/testdir
+getfacl --absolute-names $SCRATCH_MNT/testdir | _filter_scratch
+
+mkdir $SCRATCH_MNT/testdir/testsubdir
+getfacl --absolute-names $SCRATCH_MNT/testdir/testsubdir | _filter_scratch
+
 #-------------------------------------------------------
 
 # success, all done
diff --git a/tests/shared/051.out b/tests/shared/051.out
index a871082..5f0b620 100644
--- a/tests/shared/051.out
+++ b/tests/shared/051.out
@@ -353,3 +353,24 @@ group::rwx
 mask::rwx
 other::rwx
 
+=== Test child directory inheritance of its parent's default ACL ===
+# file: SCRATCH_MNT/testdir
+# owner: root
+# group: root
+user::rwx
+group::r-x
+other::r-x
+default:user::rwx
+default:group::rwx
+default:other::---
+
+# file: SCRATCH_MNT/testdir/testsubdir
+# owner: root
+# group: root
+user::rwx
+group::rwx
+other::---
+default:user::rwx
+default:group::rwx
+default:other::---
+
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
