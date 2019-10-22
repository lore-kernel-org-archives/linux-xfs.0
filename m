Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F369ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 15:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C206C2084B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 15:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfJVPcy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:32:54 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:32871 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730305AbfJVPcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 11:32:54 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iMw9R-0006aB-1U; Tue, 22 Oct 2019 16:32:49 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iMw9Q-0002gg-B6; Tue, 22 Oct 2019 16:32:48 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: add mising include of xfs_pnfs.h for missing declarations
Date:   Tue, 22 Oct 2019 16:32:47 +0100
Message-Id: <20191022153247.10286-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_pnfs.c file is missing an include of xfs_pnfs.h to
add the prototypes of the functions it exports. Include this
file to fix the following sparse warnings:

fs/xfs/xfs_pnfs.c:27:1: warning: symbol 'xfs_break_leased_layouts' was not declared. Should it be static?
fs/xfs/xfs_pnfs.c:52:1: warning: symbol 'xfs_fs_get_uuid' was not declared. Should it be static?
fs/xfs/xfs_pnfs.c:77:1: warning: symbol 'xfs_fs_map_blocks' was not declared. Should it be static?
fs/xfs/xfs_pnfs.c:226:1: warning: symbol 'xfs_fs_commit_blocks' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/xfs/xfs_pnfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a339bd5fa260..b2f6f1e3d9c4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -12,6 +12,7 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_iomap.h"
+#include "xfs_pnfs.h"
 
 /*
  * Ensure that we do not have any outstanding pNFS layouts that can be used by
-- 
2.23.0

