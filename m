Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7NGpotJ026349 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 11:51:50 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F7E2304067
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 09:52:37 -0700 (PDT)
Received: from [134.15.95.102] (cf-vpn-hw-arenaud-5.corp.sgi.com
	[134.15.95.102])
	by estes.americas.sgi.com (Postfix) with ESMTP id AE0E87001AB1
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 11:52:36 -0500 (CDT)
Message-ID: <50365FD1.7000304@sgi.com>
Date: Thu, 23 Aug 2012 12:52:33 -0400
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH V3] xfs: prevent xfs_bmapi_write() to exceed maximum extent
	size.
References: <20120712154554.377970666@sgi.com> <4FFFF3D8.7060001@sgi.com>
	<50059437.6070705@sgi.com> <20120719033027.GD23387@dastard>
	<5007C33B.5010603@sgi.com> <20120720014454.GI23387@dastard>
	<5009112D.4090106@sgi.com>
In-Reply-To: <5009112D.4090106@sgi.com>
Content-Type: multipart/mixed; boundary="------------070107000404040908060209"
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
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070107000404040908060209
Content-Type: multipart/alternative;
 boundary="------------020008050105080902090308"


--------------020008050105080902090308
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

xfs: prevent xfs_bmapi_write() to exceed maximum extent size.


When trying to do preallocation that exceed the the maximum size of
an extent, the extsize alignment can exceed the MAXEXTLEN.

We are already solving this issue for delay allocation but we
have the same with prealloc. So the Solution is to limit the bma.length
we send to xfs_bmapi_allocate() in xfs_bmapi_write().

We do have a simple test case to confirm that the problem exist.

# mkfs.xfs -f -b size=512 -d agcount=1,size=4294967296  /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=1, agsize=8388608 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=512    blocks=8388608, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=512    blocks=20480, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/sdb1 /xfs_dir
# cd/xfs_dir/
# xfs_io -c 'extsize 4m' .
# xfs_io -f -c 'resvsp 0 1g' test_file
XFS_IOC_RESVSP64: No space left on device

Signed-off-by: Alain Renaud<arenaud@sgi.com>

---
    This is the 3rd version of the patch. In the previous version we were
making the change in xfs_bmap_extsize_align() but like Dave mention
we were breaking the function definition.

    Limiting the length in xfs_bmapi_write() seem more logical and should
avoid any unexpected side effect.

  fs/xfs/xfs_bmap.c |   27 ++++++++++++++++-----------
  1 file changed, 16 insertions(+), 11 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4915,22 +4915,27 @@ xfs_bmapi_write(
  		 * that we found, if any.
  		 */
  		if (inhole || wasdelay) {
+			xfs_extlen_t	extsz;
  			bma.eof = eof;
  			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
  			bma.wasdel = wasdelay;
  			bma.offset = bno;
  
-			/*
-			 * There's a 32/64 bit type mismatch between the
-			 * allocation length request (which can be 64 bits in
-			 * length) and the bma length request, which is
-			 * xfs_extlen_t and therefore 32 bits. Hence we have to
-			 * check for 32-bit overflows and handle them here.
-			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
-			else
-				bma.length = len;
+			/* Figure out the extent size, set bma.length */
+			extsz = xfs_get_extsz_hint(ip);
+			if (extsz) {
+				/*
+				 * Make sure we don't exceed the maximum extent
+				 * length when we align the extent.  Reduce the
+				 * length we are going to allocate by the
+				 * maximum adjustment extent size aligment may
+				 * require.
+				 */
+				bma.length = XFS_FILBLKS_MIN(len,
+					     MAXEXTLEN - (2 * extsz - 1));
+			} else {
+				bma.length = XFS_FILBLKS_MIN(len, MAXEXTLEN);
+			}
  
  			ASSERT(len > 0);
  			ASSERT(bma.length > 0);


Alain Renaud


--------------020008050105080902090308
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-text-plain" wrap="true" graphical-quote="true"
      style="font-family: -moz-fixed; font-size: 12px;" lang="x-unicode">
      <pre wrap="">xfs: prevent xfs_bmapi_write() to exceed maximum extent size.


When trying to do preallocation that exceed the the maximum size of
an extent, the extsize alignment can exceed the MAXEXTLEN. 

We are already solving this issue for delay allocation but we
have the same with prealloc. So the Solution is to limit the bma.length
we send to xfs_bmapi_allocate() in xfs_bmapi_write().

We do have a simple test case to confirm that the problem exist.

# mkfs.xfs -f -b size=512 -d agcount=1,size=4294967296  /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=1, agsize=8388608 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=512    blocks=8388608, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=512    blocks=20480, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/sdb1 /xfs_dir
# cd <i class="moz-txt-slash"><span class="moz-txt-tag">/</span>xfs_dir<span class="moz-txt-tag">/</span></i>
# xfs_io -c 'extsize 4m' .
# xfs_io -f -c 'resvsp 0 1g' test_file
XFS_IOC_RESVSP64: No space left on device

Signed-off-by: Alain Renaud <a class="moz-txt-link-rfc2396E" href="mailto:arenaud@sgi.com">&lt;arenaud@sgi.com&gt;</a>

---
   This is the 3rd version of the patch. In the previous version we were
making the change in xfs_bmap_extsize_align() but like Dave mention
we were breaking the function definition.

   Limiting the length in xfs_bmapi_write() seem more logical and should
avoid any unexpected side effect.

 fs/xfs/xfs_bmap.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4915,22 +4915,27 @@ xfs_bmapi_write(
 		 * that we found, if any.
 		 */
 		if (inhole || wasdelay) {
+			xfs_extlen_t	extsz;
 			bma.eof = eof;
 			bma.conv = !!(flags &amp; XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
 			bma.offset = bno;
 
-			/*
-			 * There's a 32/64 bit type mismatch between the
-			 * allocation length request (which can be 64 bits in
-			 * length) and the bma length request, which is
-			 * xfs_extlen_t and therefore 32 bits. Hence we have to
-			 * check for 32-bit overflows and handle them here.
-			 */
-			if (len &gt; (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
-			else
-				bma.length = len;
+			/* Figure out the extent size, set bma.length */
+			extsz = xfs_get_extsz_hint(ip);
+			if (extsz) {
+				/*
+				 * Make sure we don't exceed the maximum extent
+				 * length when we align the extent.  Reduce the
+				 * length we are going to allocate by the
+				 * maximum adjustment extent size aligment may
+				 * require.
+				 */
+				bma.length = XFS_FILBLKS_MIN(len,
+					     MAXEXTLEN - (2 * extsz - 1));
+			} else {
+				bma.length = XFS_FILBLKS_MIN(len, MAXEXTLEN);
+			}
 
 			ASSERT(len &gt; 0);
 			ASSERT(bma.length &gt; 0);


Alain Renaud 
</pre>
    </div>
  </body>
</html>

--------------020008050105080902090308--

--------------070107000404040908060209
Content-Type: text/x-patch;
 name="xfs:avoid_bmap_len_overflow_xfs_bmap_extsize_align.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs:avoid_bmap_len_overflow_xfs_bmap_extsize_align.patch"

When trying to do preallocation that exceed the the maximum size of
an extent, the extsize alignment can exceed the MAXEXTLEN. 

We are already solving this issue for delay allocation but we
have the same with prealloc. So the Solution is to limit the bma.length
we send to xfs_bmapi_allocate() in xfs_bmapi_write().

We do have a simple test case to confirm that the problem exist.

# mkfs.xfs -f -b size=512 -d agcount=1,size=4294967296  /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=1, agsize=8388608 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=512    blocks=8388608, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=512    blocks=20480, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/sdb1 /xfs_dir
# cd /xfs_dir/
# xfs_io -c 'extsize 4m' .
# xfs_io -f -c 'resvsp 0 1g' test_file
XFS_IOC_RESVSP64: No space left on device

Signed-off-by: Alain Renaud <arenaud@sgi.com>

---
   This is the 3rd version of the patch. In the previous version we were
making the change in xfs_bmap_extsize_align() but like Dave mention
we were breaking the function definition.

   Limiting the length in xfs_bmapi_write() seem more logical and should
avoid any unexpected side effect.

 fs/xfs/xfs_bmap.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4915,22 +4915,27 @@ xfs_bmapi_write(
 		 * that we found, if any.
 		 */
 		if (inhole || wasdelay) {
+			xfs_extlen_t	extsz;
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
 			bma.offset = bno;
 
-			/*
-			 * There's a 32/64 bit type mismatch between the
-			 * allocation length request (which can be 64 bits in
-			 * length) and the bma length request, which is
-			 * xfs_extlen_t and therefore 32 bits. Hence we have to
-			 * check for 32-bit overflows and handle them here.
-			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
-			else
-				bma.length = len;
+			/* Figure out the extent size, set bma.length */
+			extsz = xfs_get_extsz_hint(ip);
+			if (extsz) {
+				/*
+				 * Make sure we don't exceed the maximum extent
+				 * length when we align the extent.  Reduce the
+				 * length we are going to allocate by the
+				 * maximum adjustment extent size aligment may
+				 * require.
+				 */
+				bma.length = XFS_FILBLKS_MIN(len,
+					     MAXEXTLEN - (2 * extsz - 1));
+			} else {
+				bma.length = XFS_FILBLKS_MIN(len, MAXEXTLEN);
+			}
 
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);

--------------070107000404040908060209
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070107000404040908060209--
