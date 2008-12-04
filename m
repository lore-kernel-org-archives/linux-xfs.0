Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB47IF1h000961 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 01:18:16 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id EC518304081
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 23:18:12 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id SAA21577 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 18:18:05 +1100
Message-ID: <49378444.9040108@sgi.com>
Date: Thu, 04 Dec 2008 18:18:28 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [Fwd: [PATCH] Fix speculative allocation beyond eof]
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

ping.

Anyone have any objections to this?

-------- Original Message --------
Subject: [PATCH] Fix speculative allocation beyond eof
Date: Tue, 23 Sep 2008 13:14:44 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Speculative allocation beyond eof doesn't work properly.  It was broken some
time ago after a code cleanup that moved what is now xfs_iomap_eof_align_last_fsb()
and xfs_iomap_eof_want_preallocate() out of xfs_iomap_write_delay() into
separate functions.  The code used to use the current file size in various checks
but got changed to be max(file_size, i_new_size).  Since i_new_size is the result
of 'offset + count' then in xfs_iomap_eof_want_preallocate() the check for
'(offset + count) <= isize' will always be true.

ie if 'offset + count' is > ip->i_size then isize will be i_new_size and equal to
'offset + count'.

This change fixes all the places that used to use the current file size.

--- a/fs/xfs/xfs_iomap.c	2008-09-23 12:52:12.000000000 +1000
+++ b/fs/xfs/xfs_iomap.c	2008-09-23 12:51:29.000000000 +1000
@@ -290,7 +290,6 @@ STATIC int
xfs_iomap_eof_align_last_fsb(
	xfs_mount_t	*mp,
	xfs_inode_t	*ip,
-	xfs_fsize_t	isize,
	xfs_extlen_t	extsize,
	xfs_fileoff_t	*last_fsb)
{
@@ -306,14 +305,14 @@ xfs_iomap_eof_align_last_fsb(
	 * stripe width and we are allocating past the allocation eof.
	 */
	else if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC) &&
-	        (isize >= XFS_FSB_TO_B(mp, mp->m_swidth)))
+	        (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_swidth)))
		new_last_fsb = roundup_64(*last_fsb, mp->m_swidth);
	/*
	 * Roundup the allocation request to a stripe unit (m_dalign) boundary
	 * if the file size is >= stripe unit size, and we are allocating past
	 * the allocation eof.
	 */
-	else if (mp->m_dalign && (isize >= XFS_FSB_TO_B(mp, mp->m_dalign)))
+	else if (mp->m_dalign && (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_dalign)))
		new_last_fsb = roundup_64(*last_fsb, mp->m_dalign);

	/*
@@ -403,7 +402,6 @@ xfs_iomap_write_direct(
	xfs_filblks_t	count_fsb, resaligned;
	xfs_fsblock_t	firstfsb;
	xfs_extlen_t	extsz, temp;
-	xfs_fsize_t	isize;
	int		nimaps;
	int		bmapi_flag;
	int		quota_flag;
@@ -426,15 +424,10 @@ xfs_iomap_write_direct(
	rt = XFS_IS_REALTIME_INODE(ip);
	extsz = xfs_get_extsz_hint(ip);

-	isize = ip->i_size;
-	if (ip->i_new_size > isize)
-		isize = ip->i_new_size;
-
	offset_fsb = XFS_B_TO_FSBT(mp, offset);
	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
-	if ((offset + count) > isize) {
-		error = xfs_iomap_eof_align_last_fsb(mp, ip, isize, extsz,
-							&last_fsb);
+	if ((offset + count) > ip->i_size) {
+		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
		if (error)
			goto error_out;
	} else {
@@ -559,7 +552,6 @@ STATIC int
xfs_iomap_eof_want_preallocate(
	xfs_mount_t	*mp,
	xfs_inode_t	*ip,
-	xfs_fsize_t	isize,
	xfs_off_t	offset,
	size_t		count,
	int		ioflag,
@@ -573,7 +565,7 @@ xfs_iomap_eof_want_preallocate(
	int		n, error, imaps;

	*prealloc = 0;
-	if ((ioflag & BMAPI_SYNC) || (offset + count) <= isize)
+	if ((ioflag & BMAPI_SYNC) || (offset + count) <= ip->i_size)
		return 0;

	/*
@@ -617,7 +609,6 @@ xfs_iomap_write_delay(
	xfs_fileoff_t	ioalign;
	xfs_fsblock_t	firstblock;
	xfs_extlen_t	extsz;
-	xfs_fsize_t	isize;
	int		nimaps;
	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
	int		prealloc, fsynced = 0;
@@ -637,11 +628,7 @@ xfs_iomap_write_delay(
	offset_fsb = XFS_B_TO_FSBT(mp, offset);

retry:
-	isize = ip->i_size;
-	if (ip->i_new_size > isize)
-		isize = ip->i_new_size;
-
-	error = xfs_iomap_eof_want_preallocate(mp, ip, isize, offset, count,
+	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
	if (error)
		return error;
@@ -655,8 +642,7 @@ retry:
	}

	if (prealloc || extsz) {
-		error = xfs_iomap_eof_align_last_fsb(mp, ip, isize, extsz,
-							&last_fsb);
+		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
		if (error)
			return error;
	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
