Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 357797F6B
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:37:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6E91AC004
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 16:37:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Bi6chVioV6tXUK63 for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 16:37:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XWw81-0004yF-KO
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XWw81-00056o-JR
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: xfs_qm_dquot_isolate needs locking annotations for
	sparse
Date: Thu, 25 Sep 2014 09:37:41 +1000
Message-Id: <1411601863-19594-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1411601863-19594-1-git-send-email-david@fromorbit.com>
References: <1411601863-19594-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

To remove noise from the build.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 1023210..d68f230 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -434,6 +434,7 @@ xfs_qm_dquot_isolate(
 	struct list_head	*item,
 	spinlock_t		*lru_lock,
 	void			*arg)
+		__releases(lru_lock) __acquires(lru_lock)
 {
 	struct xfs_dquot	*dqp = container_of(item,
 						struct xfs_dquot, q_lru);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
