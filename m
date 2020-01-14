Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE22C33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 12:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1900924679
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 12:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgANMEQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 07:04:16 -0500
Received: from foss.arm.com ([217.140.110.172]:51452 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgANMEQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Jan 2020 07:04:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E99BA1435;
        Tue, 14 Jan 2020 04:04:15 -0800 (PST)
Received: from e119884-lin.cambridge.arm.com (e119884-lin.cambridge.arm.com [10.1.196.72])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25E313F6C4;
        Tue, 14 Jan 2020 04:04:15 -0800 (PST)
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
To:     hch@lst.de, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject: [PATCH] xfs: Add __packed to xfs_dir2_sf_entry_t definition
Date:   Tue, 14 Jan 2020 12:03:52 +0000
Message-Id: <20200114120352.53111-1-vincenzo.frascino@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_check_ondisk_structs() verifies that the sizes of the data types
used by xfs are correct via the XFS_CHECK_STRUCT_SIZE() macro.

Since the structures padding can vary depending on the ABI (e.g. on
ARM OABI structures are padded to multiple of 32 bits), it may happen
that xfs_dir2_sf_entry_t size check breaks the compilation with the
assertion below:

In file included from linux/include/linux/string.h:6,
                 from linux/include/linux/uuid.h:12,
                 from linux/fs/xfs/xfs_linux.h:10,
                 from linux/fs/xfs/xfs.h:22,
                 from linux/fs/xfs/xfs_super.c:7:
In function ‘xfs_check_ondisk_structs’,
    inlined from ‘init_xfs_fs’ at linux/fs/xfs/xfs_super.c:2025:2:
linux/include/linux/compiler.h:350:38:
    error: call to ‘__compiletime_assert_107’ declared with attribute
    error: XFS: sizeof(xfs_dir2_sf_entry_t) is wrong, expected 3
    _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

Restore the correct behavior adding __packed to the structure definition.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dee33043e09..60db25f30430 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -217,7 +217,7 @@ typedef struct xfs_dir2_sf_entry {
 	 * A 64-bit or 32-bit inode number follows here, at a variable offset
 	 * after the name.
 	 */
-} xfs_dir2_sf_entry_t;
+} __packed xfs_dir2_sf_entry_t;
 
 static inline int xfs_dir2_sf_hdr_size(int i8count)
 {
-- 
2.24.1

