Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3406C282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 14:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26462077B
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 14:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbgAIOPT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 09:15:19 -0500
Received: from foss.arm.com ([217.140.110.172]:59960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731559AbgAIOPS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Jan 2020 09:15:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3546D1FB;
        Thu,  9 Jan 2020 06:15:18 -0800 (PST)
Received: from e119884-lin.cambridge.arm.com (e119884-lin.cambridge.arm.com [10.1.196.72])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8639F3F534;
        Thu,  9 Jan 2020 06:15:17 -0800 (PST)
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
To:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vincenzo.frascino@arm.com
Subject: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
Date:   Thu,  9 Jan 2020 14:14:59 +0000
Message-Id: <20200109141459.21808-1-vincenzo.frascino@arm.com>
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

xfs_dir2_sf_entry_t size is set erroneously to 3 which breaks the
compilation with the assertion below:

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

Restore the correct behavior defining the correct size.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
---
 fs/xfs/xfs_ondisk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index b6701b4f59a9..ee487ddc60c7 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -104,7 +104,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		4);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
-- 
2.24.1

