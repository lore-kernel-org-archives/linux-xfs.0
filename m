Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D83C7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:04:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15ED6304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 15:04:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GsqFHAsXDilcrBp8 for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 15:04:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wcinv-0002PJ-CE
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wcinv-0000o2-BY
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] shared/051: remove ACL count subtest
Date: Wed, 23 Apr 2014 08:04:30 +1000
Message-Id: <1398204274-2113-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1398204274-2113-1-git-send-email-david@fromorbit.com>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Different versions of XFS support different numbers of ACLs on disk.
Remove that subtest from this shared test to prevent it form causing
spurious failures on filesystems that support more than 25 ACLs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/shared/051     |  45 -----------------
 tests/shared/051.out | 135 ---------------------------------------------------
 2 files changed, 180 deletions(-)

diff --git a/tests/shared/051 b/tests/shared/051
index 39fdad4..2b61f45 100755
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -318,51 +318,6 @@ chacl m:user1:rwx file1
 chacl a::rwx file1
 set +x
 
-# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
-# on old kernel. So we need to filter out the error message in order
-# to make the updated golden output works for both old and new kernels.
-_filter_largeacl()
-{
-	sed -e "s/Invalid argument/Argument list too long/"
-}
-
-#-------------------------------------------------------
-
-echo ""
-echo "=== Test out large ACLs  ==="
-touch largeaclfile
-XFS_ACL_MAX_ENTRIES=25
-num_aces_pre=`expr $XFS_ACL_MAX_ENTRIES - 1`
-num_aces_post=`expr $XFS_ACL_MAX_ENTRIES + 1`
-
-acl1=`_create_n_aces $num_aces_pre`
-acl2=`_create_n_aces $XFS_ACL_MAX_ENTRIES`
-acl3=`_create_n_aces $num_aces_post`
-acl4=`_create_n_aces 16` # Andreas G. libacl size for initial get
-acl5=`_create_n_aces 17` # 1 over A.G. libacl initial size
-
-echo "1 below xfs acl max"
-chacl $acl1 largeaclfile
-getfacl --numeric largeaclfile | _filter_aces
-
-echo "xfs acl max"
-chacl $acl2 largeaclfile
-getfacl --numeric largeaclfile | _filter_aces
-
-echo "1 above xfs acl max"
-chacl $acl3 largeaclfile 2>&1 | _filter_largeacl
-getfacl --numeric largeaclfile | _filter_aces
-
-echo "use 16 aces"
-chacl $acl4 largeaclfile
-getfacl --numeric largeaclfile | _filter_aces
-
-echo "use 17 aces"
-chacl $acl5 largeaclfile
-getfacl --numeric largeaclfile | _filter_aces
-
-#-------------------------------------------------------
-
 # success, all done
 status=0
 exit
diff --git a/tests/shared/051.out b/tests/shared/051.out
index 354ec6a..2b5220f 100644
--- a/tests/shared/051.out
+++ b/tests/shared/051.out
@@ -218,138 +218,3 @@ chacl: m:user1:rwx - Invalid argument
 + chacl a::rwx file1
 chacl: a::rwx - Invalid argument
 + set +x
-
-=== Test out large ACLs  ===
-1 below xfs acl max
-# file: largeaclfile
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-user:14:rwx
-user:15:rwx
-user:16:rwx
-user:17:rwx
-user:18:rwx
-user:19:rwx
-user:20:rwx
-group::rwx
-mask::rwx
-other::rwx
-
-xfs acl max
-# file: largeaclfile
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-user:14:rwx
-user:15:rwx
-user:16:rwx
-user:17:rwx
-user:18:rwx
-user:19:rwx
-user:20:rwx
-user:21:rwx
-group::rwx
-mask::rwx
-other::rwx
-
-1 above xfs acl max
-chacl: cannot set access acl on "largeaclfile": Argument list too long
-# file: largeaclfile
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-user:14:rwx
-user:15:rwx
-user:16:rwx
-user:17:rwx
-user:18:rwx
-user:19:rwx
-user:20:rwx
-user:21:rwx
-group::rwx
-mask::rwx
-other::rwx
-
-use 16 aces
-# file: largeaclfile
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-group::rwx
-mask::rwx
-other::rwx
-
-use 17 aces
-# file: largeaclfile
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-group::rwx
-mask::rwx
-other::rwx
-
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
