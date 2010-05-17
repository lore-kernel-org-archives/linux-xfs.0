Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HNMUkI014417 for <xfs@oss.sgi.com>; Mon, 17 May 2010 18:22:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D96439C4D48
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:25:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	yDq5G1lXWsWbY0a6 for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 16:25:45 -0700 (PDT)
Received: from dastard (unverified [121.44.136.97])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	24466475-1927428
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 08:54:45 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OE9fl-00059S-SH
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:33 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OE9fg-0000RW-W6
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/12] xfs: allow log ticket allocation to take allocation
	flags
Date: Tue, 18 May 2010 09:24:18 +1000
Message-Id: <1274138668-1662-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1274138668-1662-1-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
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

Delayed logging currently requires ticket allocation to succeed, so
we need to be able to sleep on allocation. It also should not allow
memory allocation to recurse into the filesystem. hence we need to
pass allocation flags directing the type of allocation the caller
requires.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 687b220..83be6a6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -88,11 +88,9 @@ STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 
 
 /* local ticket functions */
-STATIC xlog_ticket_t	*xlog_ticket_alloc(xlog_t *log,
-					 int	unit_bytes,
-					 int	count,
-					 char	clientid,
-					 uint	flags);
+STATIC xlog_ticket_t *xlog_ticket_alloc(xlog_t *log, int unit_bytes, int count,
+					char clientid, uint flags,
+					int alloc_flags);
 
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
@@ -376,7 +374,8 @@ xfs_log_reserve(
 	} else {
 		/* may sleep if need to allocate more tickets */
 		internal_ticket = xlog_ticket_alloc(log, unit_bytes, cnt,
-						  client, flags);
+						  client, flags,
+						  KM_SLEEP|KM_MAYFAIL);
 		if (!internal_ticket)
 			return XFS_ERROR(ENOMEM);
 		internal_ticket->t_trans_type = t_type;
@@ -3331,13 +3330,14 @@ xlog_ticket_alloc(
 	int		unit_bytes,
 	int		cnt,
 	char		client,
-	uint		xflags)
+	uint		xflags,
+	int		alloc_flags)
 {
 	struct xlog_ticket *tic;
 	uint		num_headers;
 	int		iclog_space;
 
-	tic = kmem_zone_zalloc(xfs_log_ticket_zone, KM_SLEEP|KM_MAYFAIL);
+	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
 	if (!tic)
 		return NULL;
 
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
