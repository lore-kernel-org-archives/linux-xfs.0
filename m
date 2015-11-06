Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E91177F76
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 10:55:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CACD68F8049
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 08:55:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FLglxDufyxiEJ1VA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Nov 2015 08:55:13 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 61892E7076
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 16:55:13 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-67.bos.redhat.com [10.18.41.67])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tA6GtDZ3023088
	for <xfs@oss.sgi.com>; Fri, 6 Nov 2015 11:55:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix log recovery op header validation assert
Date: Fri,  6 Nov 2015 11:55:11 -0500
Message-Id: <1446828911-11314-1-git-send-email-bfoster@redhat.com>
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

Commit 89cebc84 ("xfs: validate transaction header length on log
recovery") added additional validation of the on-disk op header length
to protect from buffer overflow during log recovery. It accounts for the
fact that the transaction header can be split across multiple op
headers. It added an assert for when this occurs that verifies the
length of the second part of a split transaction header is less than a
full transaction header. In other words, it expects that the first op
header of a split transaction header includes at least some portion of
the transaction header.

This expectation is not always valid as a zero-length op header can
exist for the first op header of a split transaction header (see
xlog_recover_add_to_trans() for details). This means that the second op
header can have a valid, full length transaction header and thus the
full header is copied in xlog_recover_add_to_cont_trans(). Fix the
assert in xlog_recover_add_to_cont_trans() to handle this case correctly
and require that the op header length is less than or equal to a full
transaction header.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f8f1363..c5ecaac 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3431,7 +3431,7 @@ xlog_recover_add_to_cont_trans(
 	 * previous record. Copy the rest of the header.
 	 */
 	if (list_empty(&trans->r_itemq)) {
-		ASSERT(len < sizeof(struct xfs_trans_header));
+		ASSERT(len <= sizeof(struct xfs_trans_header));
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
 			return -EIO;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
