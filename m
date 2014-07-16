Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6AE637FCB
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 15:45:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 53ADD8F806F
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 13:45:30 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FWfcyubmYHudOa0P (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 13:45:28 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH v2] logprint: Fix printing of AGF and AGI buffers
Date: Wed, 16 Jul 2014 22:45:21 +0200
Message-Id: <1405543521-21978-1-git-send-email-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, dchinner@redhat.com

Currently xfs_logprint doesn't show detailed data about AGF and AGI
buffers and instead always shows "Out of space". This is because
xfs_agf_t has additional fields and padding which we never read from
disk and thus buffer length is always smaller than the size of
xfs_agf_t or xfs_agi_t respectively.

Fix the problem by only making sure we have enough data in the buffer
to contain all the information we want to print.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 logprint/log_misc.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index d482cf3fba57..c9286c67b913 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -325,7 +325,15 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr, int len, int *i, int num_ops)
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
 		agi = (xfs_agi_t *)(*ptr);
 		printf(_("AGI Buffer: XAGI  "));
-		if (be32_to_cpu(head->oh_len) < sizeof(xfs_agi_t) -
+		/*
+		 * v4 filesystems only contain the fields before the uuid.
+		 * Even v5 filesystems don't log any field beneath it. That
+		 * means that the size that is logged is almost always going to
+		 * be smaller than the structure itself. Hence we need to make
+		 * sure that the buffer contains all the data we want to print
+		 * rather than just check against the structure size.
+		 */
+		if (be32_to_cpu(head->oh_len) < offsetof(xfs_agi_t, agi_uuid) -
 				XFS_AGI_UNLINKED_BUCKETS*sizeof(xfs_agino_t)) {
 			printf(_("out of space\n"));
 		} else {
@@ -367,7 +375,15 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr, int len, int *i, int num_ops)
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGF_MAGIC) {
 		agf = (xfs_agf_t *)(*ptr);
 		printf(_("AGF Buffer: XAGF  "));
-		if (be32_to_cpu(head->oh_len) < sizeof(xfs_agf_t)) {
+		/*
+		 * v4 filesystems only contain the fields before the uuid.
+		 * Even v5 filesystems don't log any field beneath it. That
+		 * means that the size that is logged is almost always going to
+		 * be smaller than the structure itself. Hence we need to make
+		 * sure that the buffer contains all the data we want to print
+		 * rather than just check against the structure size.
+		 */
+		if (be32_to_cpu(head->oh_len) < offsetof(xfs_agf_t, agf_uuid)) {
 			printf(_("Out of space\n"));
 		} else {
 			printf("\n");
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
