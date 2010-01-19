Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0f95l142649 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:41:10 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A980111F8BDA
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:42:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	vbMpGtxKM9mHZnFw for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:42:08 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11404573-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:12:07 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX2AN-0003Fz-KK
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:41:55 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX2AM-0003cr-V7
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:41:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: suppress spurious uninitialised var warning in
	xfs_bmapi()
Date: Tue, 19 Jan 2010 11:41:50 +1100
Message-Id: <1263861711-13900-2-git-send-email-david@fromorbit.com>
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

Initialise the xfs_bmalloca_t structure to zero to avoid uninitialised
variable warnings. This is done by zeroing the arg structure rather than
using the uninitialised_var() trick so we know for certain that the
structure is correctly initialised as xfs_bmapi is a very complex
function and it is difficult to prove warnings are spurious.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_bmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 7c6d9ac..1869fb9 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4471,7 +4471,7 @@ xfs_bmapi(
 	xfs_fsblock_t	abno;		/* allocated block number */
 	xfs_extlen_t	alen;		/* allocated extent length */
 	xfs_fileoff_t	aoff;		/* allocated file offset */
-	xfs_bmalloca_t	bma;		/* args for xfs_bmap_alloc */
+	xfs_bmalloca_t	bma = { 0 };	/* args for xfs_bmap_alloc */
 	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
 	xfs_fileoff_t	end;		/* end of mapped file region */
 	int		eof;		/* we've hit the end of extents */
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
