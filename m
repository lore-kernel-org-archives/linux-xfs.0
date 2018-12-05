Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbeLEVDM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:03:12 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A98CC2F3D
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:03:12 +0000 (UTC)
Subject: [PATCH 02/10] xfs: make checksum verifiers consistently return bools
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <fb3cd029-89d0-4e4a-0795-6c109254546b@redhat.com>
Date: Wed, 5 Dec 2018 15:03:05 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

xfs_verify_cksum returns the result of a comparison, so make it
a bool. xfs_buf_verify_cksum calls it, so make it a bool as well.
Other callers up the callchain from here are already bools.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_cksum.h | 2 +-
 fs/xfs/xfs_buf.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
index 999a290cfd72..1e3802a99867 100644
--- a/fs/xfs/libxfs/xfs_cksum.h
+++ b/fs/xfs/libxfs/xfs_cksum.h
@@ -71,7 +71,7 @@ xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 /*
  * Helper to verify the checksum for a buffer.
  */
-static inline int
+static inline bool
 xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 {
 	uint32_t crc = xfs_start_cksum_safe(buffer, length, cksum_offset);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9f5511ea998..5015255b5ede 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -359,7 +359,7 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 	xfs_buf_rele(bp);
 }
 
-static inline int
+static inline bool
 xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 {
 	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-- 
2.17.0
