Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HGZ8Fe090819 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 11:35:08 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1231304071
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 09:35:05 -0700 (PDT)
Received: from [134.15.68.103] (cf-vpn-sw-corp-68-103.corp.sgi.com
	[134.15.68.103])
	by estes.americas.sgi.com (Postfix) with ESMTP id EA3AF70017FE
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 11:35:04 -0500 (CDT)
Message-ID: <50059437.6070705@sgi.com>
Date: Tue, 17 Jul 2012 18:35:03 +0200
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: prevent xfs_bmap_extsize_align() to exceed maximum
	extent size.
References: <20120712154554.377970666@sgi.com> <4FFFF3D8.7060001@sgi.com>
In-Reply-To: <4FFFF3D8.7060001@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7418406648652585606=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============7418406648652585606==
Content-Type: multipart/alternative;
 boundary="------------030801010301020603010209"

This is a multi-part message in MIME format.
--------------030801010301020603010209
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Here is a second revision. Needed to remove an ASSERT and added a new one.

xfs: prevent xfs_bmap_extsize_align() to exceed maximum extent size.

When trying to do preallocation that exceed the the maximum size of
an extent, the extsize alignment can exceed this value.

We are already trying to solve this issue for delay allocation but we
have the same with prealloc. So I think the simple solution is to limit
the size in xfs_bmap_extsize_align() and remove the code specific to
delay allocation.

We do have a simple test case to confirm that the problem exist.

# cd/xfs_dir/
# xfs_io -c 'extsize 4m' .
# xfs_io -f -c 'resvsp 0 8g' test_file
XFS_IOC_RESVSP64: No space left on device

Signed-off-by: Alain Renaud<arenaud@sgi.com>

---
  fs/xfs/xfs_bmap.c |   14 ++++++--------
  1 file changed, 6 insertions(+), 8 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1912,6 +1912,11 @@ xfs_bmap_extsize_align(
  		align_alen += extsz - temp;
  	}
  	/*
+	 * Make sure we do not exceed the maximum len of an extent.
+	 */
+	align_alen = XFS_FILBLKS_MIN(align_alen,
+				     MAXEXTLEN - (MAXEXTLEN % extsz));
+	/*
  	 * If the previous block overlaps with this proposed allocation
  	 * then move the start forward without adjusting the length.
  	 */
@@ -1999,7 +2004,6 @@ xfs_bmap_extsize_align(
  			return XFS_ERROR(EINVAL);
  	} else {
  		ASSERT(orig_off >= align_off);
-		ASSERT(orig_end <= align_off + align_alen);
  	}
  
  #ifdef DEBUG
@@ -2009,6 +2013,7 @@ xfs_bmap_extsize_align(
  		ASSERT(align_off >= prevp->br_startoff + prevp->br_blockcount);
  #endif
  
+	ASSERT(align_alen <= MAXEXTLEN);
  	*lenp = align_alen;
  	*offp = align_off;
  	return 0;
@@ -4450,13 +4455,6 @@ xfs_bmapi_reserve_delalloc(
  	/* Figure out the extent size, adjust alen */
  	extsz = xfs_get_extsz_hint(ip);
  	if (extsz) {
-		/*
-		 * Make sure we don't exceed a single extent length when we
-		 * align the extent by reducing length we are going to
-		 * allocate by the maximum amount extent size aligment may
-		 * require.
-		 */
-		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));
  		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
  					       1, 0, &aoff, &alen);
  		ASSERT(!error);


-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================




--------------030801010301020603010209
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <tt>Here is a second revision. Needed to remove an ASSERT and added
      a new one.<br>
      <br>
      xfs: prevent xfs_bmap_extsize_align() to exceed maximum extent
      size.<br>
    </tt>
    <pre wrap="">When trying to do preallocation that exceed the the maximum size of
an extent, the extsize alignment can exceed this value. 

We are already trying to solve this issue for delay allocation but we
have the same with prealloc. So I think the simple solution is to limit
the size in xfs_bmap_extsize_align() and remove the code specific to
delay allocation.

We do have a simple test case to confirm that the problem exist.

# cd <i class="moz-txt-slash"><span class="moz-txt-tag">/</span>xfs_dir<span class="moz-txt-tag">/</span></i>
# xfs_io -c 'extsize 4m' .
# xfs_io -f -c 'resvsp 0 8g' test_file
XFS_IOC_RESVSP64: No space left on device

Signed-off-by: Alain Renaud <a class="moz-txt-link-rfc2396E" href="mailto:arenaud@sgi.com">&lt;arenaud@sgi.com&gt;</a>

---
 fs/xfs/xfs_bmap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1912,6 +1912,11 @@ xfs_bmap_extsize_align(
 		align_alen += extsz - temp;
 	}
 	/*
+	 * Make sure we do not exceed the maximum len of an extent.
+	 */
+	align_alen = XFS_FILBLKS_MIN(align_alen,
+				     MAXEXTLEN - (MAXEXTLEN % extsz));
+	/*
 	 * If the previous block overlaps with this proposed allocation
 	 * then move the start forward without adjusting the length.
 	 */
@@ -1999,7 +2004,6 @@ xfs_bmap_extsize_align(
 			return XFS_ERROR(EINVAL);
 	} else {
 		ASSERT(orig_off &gt;= align_off);
-		ASSERT(orig_end &lt;= align_off + align_alen);
 	}
 
 #ifdef DEBUG
@@ -2009,6 +2013,7 @@ xfs_bmap_extsize_align(
 		ASSERT(align_off &gt;= prevp-&gt;br_startoff + prevp-&gt;br_blockcount);
 #endif
 
+	ASSERT(align_alen &lt;= MAXEXTLEN);
 	*lenp = align_alen;
 	*offp = align_off;
 	return 0;
@@ -4450,13 +4455,6 @@ xfs_bmapi_reserve_delalloc(
 	/* Figure out the extent size, adjust alen */
 	extsz = xfs_get_extsz_hint(ip);
 	if (extsz) {
-		/*
-		 * Make sure we don't exceed a single extent length when we
-		 * align the extent by reducing length we are going to
-		 * allocate by the maximum amount extent size aligment may
-		 * require.
-		 */
-		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));
 		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
 					       1, 0, &amp;aoff, &amp;alen);
 		ASSERT(!error);
</pre>
    <br>
    <pre class="moz-signature" cols="75">-- 
===============================================
Alain Renaud     - Cluster File System Engineer 
<a class="moz-txt-link-abbreviated" href="mailto:arenaud@sgi.com">arenaud@sgi.com</a>  - SGI
===============================================
</pre>
    <br>
    <br>
  </body>
</html>

--------------030801010301020603010209--


--===============7418406648652585606==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7418406648652585606==--
