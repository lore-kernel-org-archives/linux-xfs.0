Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64B747F88
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:52:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5751E304032
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 12:52:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GfrzXq6C3lnkdYEX for <xfs@oss.sgi.com>;
	Fri, 09 Oct 2015 12:52:17 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 08C7163C77A5
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:52:17 -0500 (CDT)
Subject: [PATCH 3/5] xfs_logprint: fix some unaligned accesses
References: <56181A17.9080503@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56181AF0.7090904@sandeen.net>
Date: Fri, 9 Oct 2015 14:52:16 -0500
MIME-Version: 1.0
In-Reply-To: <56181A17.9080503@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This routine had a fair bit of gyration to avoid unaligned
accesses, but didn't fix them all.
Fix some more spotted at runtime by libubsan.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Change variable scope, remove extraneous hunk

 logprint/log_misc.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index d76145c..4cdcbec 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -243,9 +243,6 @@ int
 xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 {
     xfs_buf_log_format_t *f;
-    xfs_agi_t		 *agi;
-    xfs_agf_t		 *agf;
-    xfs_disk_dquot_t	 *dq;
     xlog_op_header_t	 *head = NULL;
     int			 num, skip;
     int			 super_block = 0;
@@ -325,7 +322,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
-		agi = (xfs_agi_t *)(*ptr);
+  	  	struct xfs_agi	*agi, agi_s;
+
+		/* memmove because *ptr may not be 8-byte aligned */
+		agi = &agi_s;
+		memmove(agi, *ptr, sizeof(struct xfs_agi));
 		printf(_("AGI Buffer: XAGI  "));
 		/*
 		 * v4 filesystems only contain the fields before the uuid.
@@ -375,7 +376,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 			}
 		}
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGF_MAGIC) {
-		agf = (xfs_agf_t *)(*ptr);
+    		struct xfs_agf	*agf, agf_s;
+
+		/* memmove because *ptr may not be 8-byte aligned */
+		agf = &agf_s;
+		memmove(agf, *ptr, sizeof(struct xfs_agf));
 		printf(_("AGF Buffer: XAGF  "));
 		/*
 		 * v4 filesystems only contain the fields before the uuid.
@@ -408,7 +413,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 				be32_to_cpu(agf->agf_longest));
 		}
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_DQUOT_MAGIC) {
-		dq = (xfs_disk_dquot_t *)(*ptr);
+		struct xfs_disk_dquot *dq, dq_s;
+
+		/* memmove because *ptr may not be 8-byte aligned */
+		dq = &dq_s;
+		memmove(dq, *ptr, sizeof(struct xfs_disk_dquot));
 		printf(_("DQUOT Buffer: DQ  "));
 		if (be32_to_cpu(head->oh_len) <
 				sizeof(xfs_disk_dquot_t)) {
-- 
2.6.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
