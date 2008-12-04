Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB45dC44023047 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 23:39:12 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 0A5A530408C
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 21:39:07 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id QAA19948 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 16:39:06 +1100
Message-ID: <49376D11.4010507@sgi.com>
Date: Thu, 04 Dec 2008 16:39:29 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Check return value of xfs_buf_get_noaddr()
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

We check the return value of all other calls to xfs_buf_get_noaddr().
Make sense to do it here too.

--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -3034,6 +3034,8 @@ xfs_zero_remaining_bytes(
  	bp = xfs_buf_get_noaddr(mp->m_sb.sb_blocksize,
  				XFS_IS_REALTIME_INODE(ip) ?
  				mp->m_rtdev_targp : mp->m_ddev_targp);
+	if (!bp)
+		return ENOMEM;

  	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
  		offset_fsb = XFS_B_TO_FSBT(mp, offset);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
