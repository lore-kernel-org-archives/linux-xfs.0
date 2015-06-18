Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B49F29DFB
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 07:49:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A7A7AC005
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 05:49:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4tgDsxyGAkdOd5bs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2015 05:49:03 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 1E59C2D1543
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 12:49:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5ICn2Ab022166
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 08:49:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: validate transaction header length on log recovery
Date: Thu, 18 Jun 2015 08:49:01 -0400
Message-Id: <1434631741-50856-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
References: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
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

The code already checks that the length matches the transaction header
in order to add a recovery item to the transaction. Convert this check
to an explicit validation of the length to prevent memcpy() overflow. In
the event of the latter, warn the user and fail the log recovery.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 299fbaf..3c6ad4c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3437,8 +3437,14 @@ xlog_recover_add_to_trans(
 			ASSERT(0);
 			return -EIO;
 		}
-		if (len == sizeof(xfs_trans_header_t))
-			xlog_recover_add_item(&trans->r_itemq);
+		if (len != sizeof(struct xfs_trans_header)) {
+			xfs_warn(log->l_mp, "%s: bad header size (%d)",
+				 __func__, len);
+			ASSERT(0);
+			return -EIO;
+		}
+
+		xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len);
 		return 0;
 	}
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
