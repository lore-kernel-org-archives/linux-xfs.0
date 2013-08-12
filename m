Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 840297F5E
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 22:17:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21EB7AC002
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:17:57 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id kmX3hhalOYGWmpbY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 20:17:56 -0700 (PDT)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Sun, 11 Aug 2013 21:17:55 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 6932E1FF001B
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:12:26 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7C3HpAj179202 for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:17:51 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r7C3Hp3w030888
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:17:51 -0600
From: zwu.kernel@gmail.com
Subject: [PATCH 12/12] xfs: fix the comment of xfs_mountfs()
Date: Mon, 12 Aug 2013 11:15:03 +0800
Message-Id: <1376277303-29455-13-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
References: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_mount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1981be9..d202238 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1400,7 +1400,7 @@ xfs_mountfs(
 	xfs_set_inoalignment(mp);
 
 	/*
-	 * Check that the data (and log if separate) are an ok size.
+	 * Check that the data (and log if separate) is an ok size.
 	 */
 	error = xfs_check_sizes(mp);
 	if (error)
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
