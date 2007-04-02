Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Apr 2007 11:24:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l32IO2kH008050
	for <xfs@oss.sgi.com>; Mon, 2 Apr 2007 11:24:04 -0700
Date: Mon, 02 Apr 2007 16:31:52 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: review: remove unused ilen var from xfs_vnodeops.c
Message-ID: <B2C0ED44991A4A556F5258C3@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@oss.sgi.com

simple cleanup patch


===========================================================================
Index: fs/xfs/xfs_vnodeops.c
===========================================================================

--- a/fs/xfs/xfs_vnodeops.c	2007-04-02 15:56:30.000000000 +1000
+++ b/fs/xfs/xfs_vnodeops.c	2007-04-02 15:19:42.926081759 +1000
@@ -4289,7 +4289,6 @@ xfs_free_file_space(
 	int			error;
 	xfs_fsblock_t		firstfsb;
 	xfs_bmap_free_t		free_list;
-	xfs_off_t		ilen;
 	xfs_bmbt_irec_t		imap;
 	xfs_off_t		ioffset;
 	xfs_extlen_t		mod=0;
@@ -4338,10 +4337,7 @@ xfs_free_file_space(
 	}

 	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, NBPP);
-	ilen = len + (offset & (rounding - 1));
 	ioffset = offset & ~(rounding - 1);
-	if (ilen & (rounding - 1))
-		ilen = (ilen + rounding) & ~(rounding - 1);

 	if (VN_CACHED(vp) != 0) {
 		xfs_inval_cached_trace(&ip->i_iocore, ioffset, -1,

=============================================================================




I think ilen was removed a while back when we changed a call interface...
  revision 1.534
  date: 2002/07/08 22:09:30;  author: lord;  state: Exp;  lines: +1 -2
  modid: 2.4.x-xfs:slinx:122666a
  changes xfs_inval_cached_pages interface
===========================================================================
Index: fs/xfs/xfs_vnodeops.c
===========================================================================

--- a/fs/xfs/xfs_vnodeops.c     2007-04-02 15:38:34.000000000 +1000
+++ b/fs/xfs/xfs_vnodeops.c     2007-04-02 15:38:34.000000000 +1000
@@ -5459,8 +5459,7 @@ xfs_free_file_space(
        ioffset = offset & ~(rounding - 1);
        if (ilen & (rounding - 1))
                ilen = (ilen + rounding) & ~(rounding - 1);
-       xfs_inval_cached_pages(XFS_ITOV(ip), &(ip->i_iocore),
-                               ioffset, ilen, NULL, 0);
+       xfs_inval_cached_pages(XFS_ITOV(ip), &(ip->i_iocore), ioffset, 0, 0);
        /*
         * Need to zero the stuff we're not freeing, on disk.
         * If its specrt (realtime & can't use unwritten extents) then

--Tim
