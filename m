Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbeK3N4J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Nov 2018 08:56:09 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95F77659AC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Nov 2018 02:48:26 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 64A7F604CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Nov 2018 02:48:26 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: fix inverted return from xfs_btree_sblock_verify_crc
Message-ID: <28345031-dfa2-1d73-a36c-400e3c2333d1@redhat.com>
Date: Thu, 29 Nov 2018 20:48:25 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

xfs_btree_sblock_verify_crc is a bool so should not be returning
a failaddr_t; worse, if xfs_log_check_lsn fails it returns
__this_address which looks like a boolean true (i.e. success)
to the caller.

(interestingly xfs_btree_lblock_verify_crc doesn't have the issue)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 34c6d7bd4d18..bbdae2b4559f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -330,7 +330,7 @@ xfs_btree_sblock_verify_crc(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
-			return __this_address;
+			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
 	}
 
