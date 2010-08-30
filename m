Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7U2jKNo239268 for <xfs@oss.sgi.com>; Sun, 29 Aug 2010 21:45:20 -0500
From: Tao Ma <tao.ma@oracle.com>
Subject: [PATCH v4] xfs: Make fiemap works with sparse file.
Date: Mon, 30 Aug 2010 10:44:03 +0800
Message-Id: <1283136243-2411-1-git-send-email-tao.ma@oracle.com>
In-Reply-To: <1282938415.2450.109.camel@doink>
References: <1282938415.2450.109.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Tao Ma <tao.ma@oracle.com>, xfs@oss.sgi.com

On 08/28/2010 03:46 AM, Alex Elder wrote:
> On Thu, 2010-06-17 at 16:53 +0800, Tao Ma wrote:
>> >  Hi Dave,
>> >  On 06/14/2010 08:29 PM, Dave Chinner wrote:
>>> >  >  I just had a thought - if you want to avoid holes being reported to
>>> >  >  fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
>>> >  >  holes in the mappin gloop when this flag is set. That will make
>>> >  >  fiemap fill in the full number of extents without hacking the
>>> >  >  extent count...
>> >  Here is the updated one. I have used BVM_IF_NO_HOLES in xfs_getbmap
>> >  to skip increasing index 'cur_ext'. It is a bit ugly, see my commit
>> >  log. I guess maybe we can add another flag in xfs_bmapi so that it
>> >  don't even give us the holes?
> Dave said he would commit this but it hasn't been done
> yet, so there's still time to comment!
yeah, it is never late. ;)
> 
> . . .
> 
>> >  diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
>> >  index 99587de..d49107d 100644
>> >  --- a/fs/xfs/xfs_bmap.c
>> >  +++ b/fs/xfs/xfs_bmap.c
>> >  @@ -5744,12 +5744,24 @@ xfs_getbmap(
>> >    					map[i].br_startblock))
>> >    				goto out_free_map;
>> >  
>> >  -			nexleft--;
>> >    			bmv->bmv_offset =
>> >    				out[cur_ext].bmv_offset +
>> >    				out[cur_ext].bmv_length;
>> >    			bmv->bmv_length =
>> >    				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
>> >  +
>> >  +			/*
>> >  +			 * In case we don't want to return the hole,
>> >  +			 * don't increase cur_ext so that we can reuse
>> >  +			 * it in the next loop.
>> >  +			 */
>> >  +			if ((iflags&  BMV_IF_NO_HOLES)&&
>> >  +			    out[cur_ext].bmv_block == -1LL) {
> I personally would prefer this to use:
> 		if ((iflags&  BMV_IF_NO_HOLES)&&
> 			map[i].br_startblock == HOLESTARTBLOCK) {
> 
> I think this is more obvious that this "extent" represents
> a hole (as opposed to bmv_block == -1, which is how
> xfs_getbmapx_fix_eof_hole() encodes this).
> 
> Otherwise looks good.
OK, I have updated the patch and attached it. So could you please send
it to Linus?

Regards,
Tao


>From 09a3cbaa456b35ed071cdd08a8b3c4c129baf451 Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 30 Aug 2010 10:04:51 +0800
Subject: [PATCH v4] xfs: Make fiemap works with sparse file.

In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
to return fi_extent_max extents, but actually it won't work for
a sparse file. The reason is that in xfs_getbmap we will
calculate holes and set it in 'out', while out is malloced by
bmv_count(fi_extent_max+1) which didn't consider holes. So in the
worst case, if 'out' vector looks like
[hole, extent, hole, extent, hole, ... hole, extent, hole],
we will only return half of fi_extent_max extents.

This patch add a new parameter BMV_IF_NO_HOLES for bvm_iflags.
So with this flags, we don't use our 'out' in xfs_getbmap for
a hole. The solution is a bit ugly by just don't increasing
index of 'out' vector. I felt that it is not easy to skip it
at the very beginning since we have the complicated check and
some function like xfs_getbmapx_fix_eof_hole to adjust 'out'.

Cc: Dave Chinner <david@fromorbit.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 fs/xfs/xfs_bmap.c           |   14 +++++++++++++-
 fs/xfs/xfs_fs.h             |    4 +++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 68be25d..b1fc2a6 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -664,7 +664,7 @@ xfs_vn_fiemap(
 					fieinfo->fi_extents_max + 1;
 	bm.bmv_count = min_t(__s32, bm.bmv_count,
 			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
-	bm.bmv_iflags = BMV_IF_PREALLOC;
+	bm.bmv_iflags = BMV_IF_PREALLOC | BMV_IF_NO_HOLES;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;
 	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 23f14e5..f90dadd 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5533,12 +5533,24 @@ xfs_getbmap(
 					map[i].br_startblock))
 				goto out_free_map;
 
-			nexleft--;
 			bmv->bmv_offset =
 				out[cur_ext].bmv_offset +
 				out[cur_ext].bmv_length;
 			bmv->bmv_length =
 				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
+
+			/*
+			 * In case we don't want to return the hole,
+			 * don't increase cur_ext so that we can reuse
+			 * it in the next loop.
+			 */
+			if ((iflags & BMV_IF_NO_HOLES) &&
+			    map[i].br_startblock == HOLESTARTBLOCK) {
+				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
+				continue;
+			}
+
+			nexleft--;
 			bmv->bmv_entries++;
 			cur_ext++;
 		}
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 7cf7220..87c2e9d 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -114,8 +114,10 @@ struct getbmapx {
 #define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
 #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
+#define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
 #define BMV_IF_VALID	\
-	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|BMV_IF_DELALLOC)
+	(BMV_IF_ATTRFORK|BMV_IF_NO_DMAPI_READ|BMV_IF_PREALLOC|	\
+	 BMV_IF_DELALLOC|BMV_IF_NO_HOLES)
 
 /*	bmv_oflags values - returned for each non-header segment */
 #define BMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
-- 
1.7.1.571.gba4d01

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
