Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB10C7FA5
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 09:45:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A38A2304043
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 07:45:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id XvXIRc13SR8Bs5cP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 07:45:30 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 987A5ACA2
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 14:45:28 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] logprint: Fix printing of AGF buffers
Date: Mon, 14 Jul 2014 16:45:00 +0200
Message-Id: <1405349100-19734-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

Currently xfs_logprint doesn't show detailed data about AGF buffers and
instead always shows "Out of space". This is because xfs_agf_t has
additional fields and padding which we never read from disk and thus
buffer length is always smaller than the size of xfs_agf_t.

Fix the problem by only making sure we have enough data in the buffer
to contain all the information we want to print.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 logprint/log_misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index d482cf3fba57..e7306c08789a 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -367,7 +367,8 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr, int len, int *i, int num_ops)
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGF_MAGIC) {
 		agf = (xfs_agf_t *)(*ptr);
 		printf(_("AGF Buffer: XAGF  "));
-		if (be32_to_cpu(head->oh_len) < sizeof(xfs_agf_t)) {
+		/* Make sure buffer contains all the data we want to print */
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
