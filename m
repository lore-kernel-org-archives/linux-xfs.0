Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BCD77F5E
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 22:17:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E0DB48F8040
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:17:22 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id SXyiWxZrm8ujCDf4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 20:17:21 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Sun, 11 Aug 2013 23:17:21 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id A528CC9003E
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:16 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7C3HIUV38207696
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:18 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r7C3HH28018981 for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:18 -0400
From: zwu.kernel@gmail.com
Subject: [PATCH 02/12] xfs: fix the comment of xfs_bmap_validate_ret()
Date: Mon, 12 Aug 2013 11:14:53 +0800
Message-Id: <1376277303-29455-3-git-send-email-zwu.kernel@gmail.com>
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
 fs/xfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 75bb841..b8a0537 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -724,8 +724,8 @@ xfs_bmap_trace_exlist(
 
 /*
  * Validate that the bmbt_irecs being returned from bmapi are valid
- * given the callers original parameters.  Specifically check the
- * ranges of the returned irecs to ensure that they only extent beyond
+ * given the caller's original parameters.  Specifically check the
+ * ranges of the returned irecs to ensure that they only extend beyond
  * the given parameters if the XFS_BMAPI_ENTIRE flag was set.
  */
 STATIC void
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
