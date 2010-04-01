Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o31Ce6hW120219 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 07:40:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B47441532CE0
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 05:41:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	Pn5kThy0VFny0w4o for <xfs@oss.sgi.com>;
	Thu, 01 Apr 2010 05:41:52 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	19168965-1927428
	for <xfs@oss.sgi.com>; Thu, 01 Apr 2010 23:11:48 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NxJiU-0002Hu-JY
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:46 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NxJiK-0001nZ-64
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 23:41:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfs: make the log ticket transaction id random
Date: Thu,  1 Apr 2010 23:41:26 +1100
Message-Id: <1270125691-29266-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1270125691-29266-1-git-send-email-david@fromorbit.com>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The transaction ID that is written to the log for a transaction is
currently set by taking the lower 32 bits of the memory address of
the ticket structure.  This is not guaranteed to be unique as
tickets comes from a slab and slots can be reallocated immediately
after being freed. As a result, there is no guarantee of uniqueness
in the ticket ID value.

Fix this by assigning a random number to the ticket ID field so that
it is extremely unlikely that duplicates will occur and remove the
possibility of transactions being mixed up during recovery due to
duplicate IDs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9edbd67..77593c2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3417,7 +3417,7 @@ xlog_ticket_alloc(
 	tic->t_curr_res		= unit_bytes;
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
-	tic->t_tid		= (xlog_tid_t)((__psint_t)tic & 0xffffffff);
+	tic->t_tid		= random32();
 	tic->t_clientid		= client;
 	tic->t_flags		= XLOG_TIC_INITED;
 	tic->t_trans_type	= 0;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
