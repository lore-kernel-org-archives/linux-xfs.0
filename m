Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C71A7F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 06:57:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A6B38F8039
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 04:57:48 -0800 (PST)
Received: from www.osadl.org (www.osadl.org [62.245.132.105]) by cuda.sgi.com
	with ESMTP id rM0lUJiXM22vAJU9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 04:57:45 -0800 (PST)
From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] xfs: fix implicit bool to int conversion
Date: Thu,  8 Jan 2015 13:49:51 +0100
Message-Id: <1420721391-22717-1-git-send-email-der.herr@hofr.at>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

try_wait_for_completion returns bool so the wrapper function
xfs_dqflock_nowait should probably also return bool and not int. 

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

patch was only compile tested x86_64_defconfig + CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y

patch is against linux-next 3.19.0-rc3 -next-20150107

 fs/xfs/xfs_dquot.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index c24c67e..2f536f3 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -86,7 +86,7 @@ static inline void xfs_dqflock(xfs_dquot_t *dqp)
 	wait_for_completion(&dqp->q_flush);
 }
 
-static inline int xfs_dqflock_nowait(xfs_dquot_t *dqp)
+static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
 {
 	return try_wait_for_completion(&dqp->q_flush);
 }
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
