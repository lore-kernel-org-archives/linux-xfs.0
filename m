Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEoms8166653 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:50:51 -0500
Date: Wed, 29 Apr 2009 10:50:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: a couple getbmap cleanups
Message-ID: <20090429145048.GA15558@infradead.org>
References: <20090224133858.GB15820@infradead.org>
	<9EF64CF3-FDFC-4777-94A5-7295E827ABA4@sgi.com>
	<20090409171135.GA25303@infradead.org>
	<6F8D4AC9-D76A-43FC-AA5C-78C86A12E244@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <6F8D4AC9-D76A-43FC-AA5C-78C86A12E244@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 29, 2009 at 09:40:40AM -0500, Felix Blyakher wrote:
>
> On Apr 9, 2009, at 12:11 PM, Christoph Hellwig wrote:
>
>> On Mon, Apr 06, 2009 at 07:57:48PM -0500, Felix Blyakher wrote:
>>> Shouldn't we set error to ENOMEM here?
>>
>> Yes, good catch.
>
> Christoph, do you want to repost this patch with that change?

Yeah, I added it long ago.  Below is the updated version.  I've been
running xfsqa on it quite a bit.

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-getbmap-cleanups

Subject: xfs: a couple getbmap cleanups  
From: Christoph Hellwig <hch@lst.de>

 - reshuffle various conditionals for data vs attr fork to make the code
   more readable
 - do fine-grainded goto-based error handling
 - exit early from conditionals instead of keeping a long else branch around
 - allow kmem_alloc to fail 

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2009-04-06 18:39:17.952445045 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2009-04-09 19:07:46.764452348 +0200
@@ -5880,7 +5880,7 @@ xfs_getbmap(
 	void			*arg)		/* formatter arg */
 {
 	__int64_t		bmvend;		/* last block requested */
-	int			error;		/* return value */
+	int			error = 0;	/* return value */
 	__int64_t		fixlen;		/* length for -1 case */
 	int			i;		/* extent number */
 	int			lock;		/* lock state */
@@ -5899,30 +5899,8 @@ xfs_getbmap(
 
 	mp = ip->i_mount;
 	iflags = bmv->bmv_iflags;
-
 	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	/*	If the BMV_IF_NO_DMAPI_READ interface bit specified, do not
-	 *	generate a DMAPI read event.  Otherwise, if the DM_EVENT_READ
-	 *	bit is set for the file, generate a read event in order
-	 *	that the DMAPI application may do its thing before we return
-	 *	the extents.  Usually this means restoring user file data to
-	 *	regions of the file that look like holes.
-	 *
-	 *	The "old behavior" (from XFS_IOC_GETBMAP) is to not specify
-	 *	BMV_IF_NO_DMAPI_READ so that read events are generated.
-	 *	If this were not true, callers of ioctl( XFS_IOC_GETBMAP )
-	 *	could misinterpret holes in a DMAPI file as true holes,
-	 *	when in fact they may represent offline user data.
-	 */
-	if ((iflags & BMV_IF_NO_DMAPI_READ) == 0 &&
-	    DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
-	    whichfork == XFS_DATA_FORK) {
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip, 0, 0, 0, NULL);
-		if (error)
-			return XFS_ERROR(error);
-	}
-
 	if (whichfork == XFS_ATTR_FORK) {
 		if (XFS_IFORK_Q(ip)) {
 			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
@@ -5936,11 +5914,37 @@ xfs_getbmap(
 					 ip->i_mount);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
-	} else if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
-		   ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
-		   ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
-		return XFS_ERROR(EINVAL);
-	if (whichfork == XFS_DATA_FORK) {
+
+		prealloced = 0;
+		fixlen = 1LL << 32;
+	} else {
+		/*
+		 * If the BMV_IF_NO_DMAPI_READ interface bit specified, do
+		 * not generate a DMAPI read event.  Otherwise, if the
+		 * DM_EVENT_READ bit is set for the file, generate a read
+		 * event in order that the DMAPI application may do its thing
+		 * before we return the extents.  Usually this means restoring
+		 * user file data to regions of the file that look like holes.
+		 *
+		 * The "old behavior" (from XFS_IOC_GETBMAP) is to not specify
+		 * BMV_IF_NO_DMAPI_READ so that read events are generated.
+		 * If this were not true, callers of ioctl(XFS_IOC_GETBMAP)
+		 * could misinterpret holes in a DMAPI file as true holes,
+		 * when in fact they may represent offline user data.
+		 */
+		if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
+		    !(iflags & BMV_IF_NO_DMAPI_READ)) {
+			error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip,
+					      0, 0, 0, NULL);
+			if (error)
+				return XFS_ERROR(error);
+		}
+
+		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
+		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
+		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+			return XFS_ERROR(EINVAL);
+
 		if (xfs_get_extsz_hint(ip) ||
 		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
 			prealloced = 1;
@@ -5949,42 +5953,34 @@ xfs_getbmap(
 			prealloced = 0;
 			fixlen = ip->i_size;
 		}
-	} else {
-		prealloced = 0;
-		fixlen = 1LL << 32;
 	}
 
 	if (bmv->bmv_length == -1) {
 		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, fixlen));
-		bmv->bmv_length = MAX( (__int64_t)(fixlen - bmv->bmv_offset),
-					(__int64_t)0);
-	} else if (bmv->bmv_length < 0)
-		return XFS_ERROR(EINVAL);
-	if (bmv->bmv_length == 0) {
+		bmv->bmv_length =
+			max_t(__int64_t, fixlen - bmv->bmv_offset, 0);
+	} else if (bmv->bmv_length == 0) {
 		bmv->bmv_entries = 0;
 		return 0;
+	} else if (bmv->bmv_length < 0) {
+		return XFS_ERROR(EINVAL);
 	}
+
 	nex = bmv->bmv_count - 1;
 	if (nex <= 0)
 		return XFS_ERROR(EINVAL);
 	bmvend = bmv->bmv_offset + bmv->bmv_length;
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-
-	if (((iflags & BMV_IF_DELALLOC) == 0) &&
-	    (whichfork == XFS_DATA_FORK) &&
-	    (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
-		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
-		error = xfs_flush_pages(ip, (xfs_off_t)0,
-					       -1, 0, FI_REMAPF);
-		if (error) {
-			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-		return error;
+	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
+		if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
+			error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
+			if (error)
+				goto out_unlock_iolock;
 		}
-	}
 
-	ASSERT(whichfork == XFS_ATTR_FORK || (iflags & BMV_IF_DELALLOC) ||
-	       ip->i_delayed_blks == 0);
+		ASSERT(ip->i_delayed_blks == 0);
+	}
 
 	lock = xfs_ilock_map_shared(ip);
 
@@ -5995,23 +5991,25 @@ xfs_getbmap(
 	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
 		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
 
-	bmapi_flags = xfs_bmapi_aflag(whichfork) |
-			((iflags & BMV_IF_PREALLOC) ? 0 : XFS_BMAPI_IGSTATE);
+	bmapi_flags = xfs_bmapi_aflag(whichfork);
+	if (!(iflags & BMV_IF_PREALLOC))
+		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
 	/*
 	 * Allocate enough space to handle "subnex" maps at a time.
 	 */
+	error = ENOMEM;
 	subnex = 16;
-	map = kmem_alloc(subnex * sizeof(*map), KM_SLEEP);
+	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL);
+	if (!map)
+		goto out_unlock_ilock;
 
 	bmv->bmv_entries = 0;
 
-	if ((XFS_IFORK_NEXTENTS(ip, whichfork) == 0)) {
-		if (((iflags & BMV_IF_DELALLOC) == 0) ||
-		    whichfork == XFS_ATTR_FORK) {
-			error = 0;
-			goto unlock_and_return;
-		}
+	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0 &&
+	    (whichfork == XFS_ATTR_FORK || !(iflags & BMV_IF_DELALLOC))) {
+		error = 0;
+		goto out_free_map;
 	}
 
 	nexleft = nex;
@@ -6023,10 +6021,12 @@ xfs_getbmap(
 				  bmapi_flags, NULL, 0, map, &nmap,
 				  NULL, NULL);
 		if (error)
-			goto unlock_and_return;
+			goto out_free_map;
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
+			int full = 0;	/* user array is full */
+
 			out.bmv_oflags = 0;
 			if (map[i].br_state == XFS_EXT_UNWRITTEN)
 				out.bmv_oflags |= BMV_OF_PREALLOC;
@@ -6041,36 +6041,32 @@ xfs_getbmap(
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */
 				out.bmv_oflags |= BMV_OF_LAST;
-				goto unlock_and_return;
-			} else {
-				int full = 0;	/* user array is full */
-
-				if (!xfs_getbmapx_fix_eof_hole(ip, &out,
-							prealloced, bmvend,
-							map[i].br_startblock)) {
-					goto unlock_and_return;
-				}
-
-				/* format results & advance arg */
-				error = formatter(&arg, &out, &full);
-				if (error || full)
-					goto unlock_and_return;
-				nexleft--;
-				bmv->bmv_offset =
-					out.bmv_offset + out.bmv_length;
-				bmv->bmv_length = MAX((__int64_t)0,
-					(__int64_t)(bmvend - bmv->bmv_offset));
-				bmv->bmv_entries++;
+				goto out_free_map;
 			}
+
+			if (!xfs_getbmapx_fix_eof_hole(ip, &out, prealloced,
+					bmvend, map[i].br_startblock))
+				goto out_free_map;
+
+			/* format results & advance arg */
+			error = formatter(&arg, &out, &full);
+			if (error || full)
+				goto out_free_map;
+			nexleft--;
+			bmv->bmv_offset =
+				out.bmv_offset + out.bmv_length;
+			bmv->bmv_length =
+				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
+			bmv->bmv_entries++;
 		}
 	} while (nmap && nexleft && bmv->bmv_length);
 
-unlock_and_return:
+ out_free_map:
+	kmem_free(map);
+ out_unlock_ilock:
 	xfs_iunlock_map_shared(ip, lock);
+ out_unlock_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	kmem_free(map);
-
 	return error;
 }
 

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--oyUTqETQ0mS9luUI--
