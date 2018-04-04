Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751442AbeDDTAY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 15:00:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CC8021BAD
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 19:00:24 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E17B07D64B
        for <linux-xfs@vger.kernel.org>; Wed,  4 Apr 2018 19:00:23 +0000 (UTC)
Subject: [PATCH 3/6] xfs: validate UUID and type in xfs_dquot_verify
From: Eric Sandeen <sandeen@redhat.com>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Message-ID: <59cde702-21d5-3465-12b0-29dad978186d@redhat.com>
Date: Wed, 4 Apr 2018 14:00:22 -0500
MIME-Version: 1.0
In-Reply-To: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Today the xfs_dqblk UUID is only checked in
xfs_dquot_buf_verify_crc, which is a bit odd in itself; normally
a CRC is checked on its own, separate from other metadata.

And by not checking the UUID in xfs_dquot_verify, this means
that future read/write verifiers will continue to choke on
mismatched UUID errors which are never seen or repaired when
quotacheck calls xfs_dquot_verify to validate a disk dquot.

Move the uuid check from xfs_dquot_buf_verify_crc to
xfs_dquot_verify so that this piece of metadata is more consistently
checked.  If we have a type sent in as well, validate that too -
it was unused until now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index f94e8c2..9f8b2c5 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -66,11 +66,20 @@
 	 * This is all fine; things are still consistent, and we haven't lost
 	 * any quota information. Just don't complain about bad dquot blks.
 	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
+
+		if (!uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
+			return __this_address;
+	}
+
 	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC))
 		return __this_address;
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
+	if (type && ddq->d_flags != type)
+		return __this_address;
 	if (ddq->d_flags != XFS_DQ_USER &&
 	    ddq->d_flags != XFS_DQ_PROJ &&
 	    ddq->d_flags != XFS_DQ_GROUP)
@@ -156,8 +165,6 @@
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF))
 			return false;
-		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
 	}
 	return true;
 }
-- 
1.8.3.1


