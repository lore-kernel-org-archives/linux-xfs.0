Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FD8B7F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:25:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0EDA88F8035
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 17:25:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8ZEJx0QtveUTTbaW for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2015 17:25:52 -0700 (PDT)
Received: from Liberator.local (unknown [205.215.222.148])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 82EB461F8992
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:25:52 -0500 (CDT)
Subject: [PATCH 3/4] xfs_logprint: fix some unaligned accesses
References: <56170906.5090301@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5617098E.9090102@sandeen.net>
Date: Thu, 8 Oct 2015 19:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <56170906.5090301@redhat.com>
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

This routine had a fair bit of gyration to avoid unaligned accesses,
but didn't fix them all.  Fix some more spotted at runtime by libubsan.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 logprint/log_misc.c |   18 +++++++++++++++---
 repair/btree.c      |    1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index d76145c..6cd249a 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -325,7 +325,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
-		agi = (xfs_agi_t *)(*ptr);
+		struct xfs_agi agi_s;
+
+		/* memmove because *ptr may not be 8-byte aligned */
+		memmove(&agi_s, *ptr, sizeof(struct xfs_agi));
+		agi = &agi_s;
 		printf(_("AGI Buffer: XAGI  "));
 		/*
 		 * v4 filesystems only contain the fields before the uuid.
@@ -375,7 +379,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 			}
 		}
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGF_MAGIC) {
-		agf = (xfs_agf_t *)(*ptr);
+		struct xfs_agf agf_s;
+
+		/* memmove because *ptr may not be 8-byte aligned */
+		memmove(&agf_s, *ptr, sizeof(struct xfs_agf));
+		agf = &agf_s;
 		printf(_("AGF Buffer: XAGF  "));
 		/*
 		 * v4 filesystems only contain the fields before the uuid.
@@ -408,7 +416,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 				be32_to_cpu(agf->agf_longest));
 		}
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_DQUOT_MAGIC) {
-		dq = (xfs_disk_dquot_t *)(*ptr);
+		struct xfs_disk_dquot dq_s;
+
+		/* memmove because *ptr may not be 8-byte aligned */
+		memmove(&dq_s, *ptr, sizeof(struct xfs_disk_dquot));
+		dq = &dq_s;
 		printf(_("DQUOT Buffer: DQ  "));
 		if (be32_to_cpu(head->oh_len) <
 				sizeof(xfs_disk_dquot_t)) {
diff --git a/repair/btree.c b/repair/btree.c
index 66fb40b..e31e67a 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -230,6 +230,7 @@ btree_get_next(
 	}
 	if (level == 0) {
 		if (key) {
+		/* XXXX what if index past MAX?  What if no next? */
 			cur->index++;
 			*key = btree_key_of_cursor(cur, root->height);
 			cur->index--;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
