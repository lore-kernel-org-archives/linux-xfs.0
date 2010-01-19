Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0exRK142602 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:40:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0918A11F8BD8
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:41:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	PJ3Yics9GkrUkSJr for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:41:57 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11561630-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:11:56 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX2AN-0003G0-Lu
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:41:55 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX2AN-0003ct-1l
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:41:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: rearrange xfs_mod_sb() to avoid array subscript
	warning
Date: Tue, 19 Jan 2010 11:41:51 +1100
Message-Id: <1263861711-13900-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861711-13900-1-git-send-email-david@fromorbit.com>
References: <1263861711-13900-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

gcc warns of an array subscript out of bounds in xfs_mod_sb().
The code is written in such a way that if the array subscript is
out of bounds, then it will assert fail. Rearrange the code to
avoid the bounds check warning.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_mount.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0df5045..d95bd18 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1631,15 +1631,14 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
 
 	/* find modified range */
+	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
+	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
+	last = xfs_sb_info[f + 1].offset - 1;
 
 	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	first = xfs_sb_info[f].offset;
 
-	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
-	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
-	last = xfs_sb_info[f + 1].offset - 1;
-
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
