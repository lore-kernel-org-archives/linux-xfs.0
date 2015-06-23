Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FE277F54
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 09:25:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EEA17AC001
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 07:25:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7ACICozDPS8lO1WX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jun 2015 07:25:16 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 9382A3CA14D
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 14:25:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5NEPFlv028122
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 10:25:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: validate transaction header length on log recovery
Date: Tue, 23 Jun 2015 10:25:14 -0400
Message-Id: <1435069514-13675-1-git-send-email-bfoster@redhat.com>
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

When log recovery hits a new transaction, it copies the transaction
header from the expected location in the log to the in-core structure
using the length from the op record header. This length is validated to
ensure it doesn't exceed the length of the record, but not against the
expected size of a transaction header (and thus the size of the in-core
structure). If the on-disk length is corrupted, the associated memcpy()
can overflow, write to unrelated memory and lead to crashes. This has
been reproduced via filesystem fuzzing.

The code currently handles the possibility that the transaction header
is split across two op records. Neither instance accounts for corruption
where the op record length might be larger than the in-core transaction
header. Update both sites to detect such corruption, warn and return an
error from log recovery. Also add some comments and assert that if the
record is split, the copy of the second portion is less than a full
header. Otherwise, this suggests the copy of the second portion could
have overwritten bits from the first and thus that something could be
wrong.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Updated to account for the fact that the transaction header can be
  split across op records.
- Detect potential overflow at both sites where the transaction header
  is copied.
v1: http://oss.sgi.com/pipermail/xfs/2015-June/042128.html

 fs/xfs/xfs_log_recover.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 01dd228..493a8ef 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3380,14 +3380,24 @@ xlog_recover_add_to_cont_trans(
 	char			*ptr, *old_ptr;
 	int			old_len;
 
+	/*
+	 * If the transaction is empty, the header was split across this and the
+	 * previous record. Copy the rest of the header.
+	 */
 	if (list_empty(&trans->r_itemq)) {
-		/* finish copying rest of trans header */
+		ASSERT(len < sizeof(struct xfs_trans_header));
+		if (len > sizeof(struct xfs_trans_header)) {
+			xfs_warn(log->l_mp, "%s: bad header length", __func__);
+			return -EIO;
+		}
+
 		xlog_recover_add_item(&trans->r_itemq);
 		ptr = (char *)&trans->r_theader +
-				sizeof(xfs_trans_header_t) - len;
+				sizeof(struct xfs_trans_header) - len;
 		memcpy(ptr, dp, len);
 		return 0;
 	}
+
 	/* take the tail entry */
 	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
 
@@ -3436,7 +3446,19 @@ xlog_recover_add_to_trans(
 			ASSERT(0);
 			return -EIO;
 		}
-		if (len == sizeof(xfs_trans_header_t))
+
+		if (len > sizeof(struct xfs_trans_header)) {
+			xfs_warn(log->l_mp, "%s: bad header length", __func__);
+			ASSERT(0);
+			return -EIO;
+		}
+
+		/*
+		 * The transaction header can be arbitrarily split across op
+		 * records. If we don't have the whole thing here, copy what we
+		 * do have and handle the rest in the next record.
+		 */
+		if (len == sizeof(struct xfs_trans_header))
 			xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len);
 		return 0;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
