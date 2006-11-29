Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 01:54:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAT9sgaG010400
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 01:54:44 -0800
Date: Wed, 29 Nov 2006 20:56:28 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] attr2 patch for data btrees & attr 2  was: (and bad attr2 bug) - pack xfs_sb_t
 for 64-bit arches
Message-ID: <199451295660174A6ADE13B3@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <456ADF08.4080002@sgi.com>
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>	
 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net>	
 <1164157336.19915.43.camel@xenon.msp.redhat.com>	
 <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>	 <45647042.2040604@sandeen.net>
 <1164212695.19915.65.camel@xenon.msp.redhat.com> <45647CF8.8020104@sandeen.net>
 <26F2AE58A7D40E5170649BC2@timothy-shimmins-power-mac-g5.local> <4565DC6A.9080602@thebarn.com>
 <456ADF08.4080002@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi,

FYI
I've done more testing and still have more testing to do.
Found a bug in my previous patch.
Below is my latest one.

--Tim

--- .pc/attr2_tes/fs/xfs/xfs_attr.c	2006-10-26 17:45:01.000000000 +1000
+++ fs/xfs/xfs_attr.c	2006-11-28 14:45:09.191482676 +1100
@@ -199,18 +199,14 @@ xfs_attr_set_int(xfs_inode_t *dp, const
 		return (error);

 	/*
-	 * Determine space new attribute will use, and if it would be
-	 * "local" or "remote" (note: local != inline).
-	 */
-	size = xfs_attr_leaf_newentsize(namelen, valuelen,
-					mp->m_sb.sb_blocksize, &local);
-
-	/*
 	 * If the inode doesn't have an attribute fork, add one.
 	 * (inode must not be locked when we call this routine)
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
-		if ((error = xfs_bmap_add_attrfork(dp, size, rsvd)))
+		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
+			      XFS_ATTR_SF_ENTSIZE_BYNAME(namelen, valuelen);
+
+		if ((error = xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
 			return(error);
 	}

@@ -231,6 +227,13 @@ xfs_attr_set_int(xfs_inode_t *dp, const
 	args.addname = 1;
 	args.oknoent = 1;

+	/*
+	 * Determine space new attribute will use, and if it would be
+	 * "local" or "remote" (note: local != inline).
+	 */
+	size = xfs_attr_leaf_newentsize(namelen, valuelen,
+					mp->m_sb.sb_blocksize, &local);
+
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	if (local) {
 		if (size > (mp->m_sb.sb_blocksize >> 1)) {
--- .pc/attr2_tes/fs/xfs/xfs_attr_leaf.c	2006-10-26 17:45:01.000000000 +1000
+++ fs/xfs/xfs_attr_leaf.c	2006-11-29 20:25:17.273599367 +1100
@@ -170,18 +170,33 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
 	}

 	/* data fork btree root can have at least this many key/ptr pairs */
-	minforkoff = MAX(dp->i_df.if_bytes, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
+	minforkoff = MAX(xfs_ifork_dsize_used(dp), XFS_BMDR_SPACE_CALC(MINDBTPTRS));
 	minforkoff = roundup(minforkoff, 8) >> 3;

 	/* attr fork btree root can have at least this many key/ptr pairs */
 	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */

-	if (offset >= minforkoff && offset < maxforkoff)
-		return offset;
+	/* we can't fit inline */
+	if (offset < minforkoff)
+		return 0;
+
+	/*
+	 * If have data btree then keep forkoff if we have one,
+	 * otherwise we are adding a new attr, so then we set forkoff to where
+	 * the btree root can finish so we have plenty of room for attrs
+	 */
+	if (dp->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+		if (dp->i_d.di_forkoff)
+			return dp->i_d.di_forkoff;
+		else
+			return minforkoff;
+	}
+
 	if (offset >= maxforkoff)
 		return maxforkoff;
-	return 0;
+	else
+		return offset;
 }

 /*
--- .pc/attr2_tes/fs/xfs/xfs_bmap.c	2006-11-17 14:35:46.000000000 +1100
+++ fs/xfs/xfs_bmap.c	2006-11-27 15:54:33.166590715 +1100
@@ -3543,6 +3543,7 @@ xfs_bmap_forkoff_reset(
 	if (whichfork == XFS_ATTR_FORK &&
 	    (ip->i_d.di_format != XFS_DINODE_FMT_DEV) &&
 	    (ip->i_d.di_format != XFS_DINODE_FMT_UUID) &&
+	    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
 	    ((mp->m_attroffset >> 3) > ip->i_d.di_forkoff)) {
 		ip->i_d.di_forkoff = mp->m_attroffset >> 3;
 		ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) /
--- .pc/attr2_tes/fs/xfs/xfs_inode.c	2006-11-27 23:20:19.000000000 +1100
+++ fs/xfs/xfs_inode.c	2006-11-29 20:29:16.994035217 +1100
@@ -4747,3 +4747,34 @@ xfs_iext_irec_update_extoffs(
 		ifp->if_u1.if_ext_irec[i].er_extoff += ext_diff;
 	}
 }
+
+/*
+ * return how much space is used by the inode's data fork
+ */
+int
+xfs_ifork_dsize_used(xfs_inode_t *ip)
+{
+	switch (ip->i_d.di_format) {
+	case XFS_DINODE_FMT_DEV:
+		return sizeof(xfs_dev_t);
+	case XFS_DINODE_FMT_UUID:
+		return sizeof(uuid_t);
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
+		return ip->i_df.if_bytes;
+	case XFS_DINODE_FMT_BTREE:
+		if (ip->i_d.di_forkoff)
+			return ip->i_d.di_forkoff << 3;
+		else
+			/*
+			 * For new attr fork, data btree takes all the space,
+			 * so no room for any attrs with the current layout
+			 * but we can know how much space it really needs
+			 * i.e. the ptrs are half way along but we could compress to
+			 * preserve the num of records.
+			 */
+			return XFS_BMDR_SPACE_CALC(XFS_BMAP_BROOT_NUMRECS(ip->i_df.if_broot));
+	default:
+		return 0;
+	}
+}
--- .pc/attr2_tes/fs/xfs/xfs_inode.h	2006-11-17 14:35:46.000000000 +1100
+++ fs/xfs/xfs_inode.h	2006-11-27 23:24:09.376554289 +1100
@@ -535,6 +535,7 @@ void		xfs_iext_irec_compact(xfs_ifork_t
 void		xfs_iext_irec_compact_pages(xfs_ifork_t *);
 void		xfs_iext_irec_compact_full(xfs_ifork_t *);
 void		xfs_iext_irec_update_extoffs(xfs_ifork_t *, int, int);
+int		xfs_ifork_dsize_used(xfs_inode_t *);

 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
