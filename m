Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 860157F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 15:12:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B2DB304084
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 13:12:35 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XSbHkJYmW76pFUIr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 13:12:30 -0700 (PDT)
Date: Thu, 24 Oct 2013 16:11:55 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH] xfstests: generic/318 use symbolic namespaced ids
Message-ID: <20131024161155.080eabad@oracle.com>
In-Reply-To: <20131024154414.GB19055@infradead.org>
References: <20131024154414.GB19055@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph, I think the following should fix 318 for you.

--

- use namespace ids that correspond to the initial acl ids
  and match them symbolically in the output

- also ensure that all uids have a mapping in the namespace
  so we don't get the unmapped uid (65534) in the output

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 tests/generic/318     |   21 +++++++++++++++++++--
 tests/generic/318.out |   20 ++++++++++----------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/tests/generic/318 b/tests/generic/318
index d3bce51..810cff4 100755
--- a/tests/generic/318
+++ b/tests/generic/318
@@ -63,6 +63,23 @@ _require_scratch
 _need_to_be_root
 _acl_setup_ids
 _require_acls
+ns_acl1=0
+ns_acl2=`expr $acl2 - $acl1`
+ns_acl3=`expr $acl3 - $acl1`
+
+_getfacl_filter_nsid()
+{
+    sed \
+       -e "s/user:$ns_acl1/user:nsid1/" \
+       -e "s/user:$ns_acl2/user:nsid2/" \
+       -e "s/user:$ns_acl3/user:nsid3/" \
+       -e "s/group:$ns_acl1/group:nsid1/" \
+       -e "s/group:$ns_acl2/group:nsid2/" \
+       -e "s/group:$ns_acl3/group:nsid3/" \
+       -e "s/: $ns_acl1/: nsid1/" \
+       -e "s/: $ns_acl2/: nsid2/" \
+       -e "s/: $ns_acl3/: nsid3/"
+}
 
 _print_getfacls()
 {
@@ -70,7 +87,7 @@ _print_getfacls()
     getfacl --absolute-names -n $file 2>/dev/null | _filter_scratch | _getfacl_filter_id
 
     echo "From user_ns"
-    $nsexec -U -M "0 $acl1 1000" -G "0 $acl2 1000" getfacl --absolute-names -n $file  2>/dev/null | _filter_scratch | _getfacl_filter_id
+    $nsexec -U -M "0 $acl1 1000" -G "0 $acl1 1000" getfacl --absolute-names -n $file 2>/dev/null | _filter_scratch | _getfacl_filter_nsid
 }
 
 umount $SCRATCH_DEV >/dev/null 2>&1
@@ -85,7 +102,7 @@ chown $acl1.$acl1 $file
 # set acls from init_user_ns, to be checked from inside the userns
 setfacl -n -m u:$acl2:rw,g:$acl2:r $file
 # set acls from inside userns, to be checked from init_user_ns
-$nsexec -s -U -M "0 $acl1 1000" -G "0 $acl2 1000" setfacl -n -m u:root:rx,g:root:x $file
+$nsexec -s -U -M "0 $acl1 1000" -G "0 $acl1 1000" setfacl -n -m u:root:rx,g:$ns_acl2:x $file
 
 _print_getfacls
 
diff --git a/tests/generic/318.out b/tests/generic/318.out
index e2b42a4..6ff2bf8 100644
--- a/tests/generic/318.out
+++ b/tests/generic/318.out
@@ -13,13 +13,13 @@ other::r--
 
 From user_ns
 # file: SCRATCH_MNT/file1
-# owner: 0
-# group: 65534
+# owner: nsid1
+# group: nsid1
 user::rw-
-user:0:r-x	#effective:r--
-user:1:rw-	#effective:r--
+user:nsid1:r-x	#effective:r--
+user:nsid2:rw-	#effective:r--
 group::r--
-group:0:--x	#effective:---
+group:nsid2:--x	#effective:---
 mask::r--
 other::r--
 
@@ -39,13 +39,13 @@ other::r--
 
 From user_ns
 # file: SCRATCH_MNT/file1
-# owner: 0
-# group: 65534
+# owner: nsid1
+# group: nsid1
 user::rw-
-user:0:r-x	#effective:r--
-user:1:rw-	#effective:r--
+user:nsid1:r-x	#effective:r--
+user:nsid2:rw-	#effective:r--
 group::r--
-group:0:--x	#effective:---
+group:nsid2:--x	#effective:---
 mask::r--
 other::r--
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
