Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D82C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 19:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 667C620857
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 19:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgDTTxJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:53:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:60758 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTTxJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Apr 2020 15:53:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CB9DBAC92;
        Mon, 20 Apr 2020 19:53:07 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_db: fix crc invalidation segfault
Date:   Mon, 20 Apr 2020 21:52:35 +0200
Message-Id: <20200420195235.14260-1-ailiop@suse.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The nowrite_ops var is declared within nested block scope but used
outside that scope, causing xfs_db to crash while trying to defererence
the verify_write pointer. Fix it by lifting the declaration to the outer
scope, where it is accessed.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 db/crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/crc.c b/db/crc.c
index 95161c6df..b23417a11 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -53,6 +53,7 @@ crc_f(
 	char		**argv)
 {
 	const struct xfs_buf_ops *stashed_ops = NULL;
+	struct xfs_buf_ops nowrite_ops;
 	extern char	*progname;
 	const field_t	*fields;
 	const ftattr_t	*fa;
@@ -127,7 +128,6 @@ crc_f(
 	}
 
 	if (invalidate) {
-		struct xfs_buf_ops nowrite_ops;
 		flist_t		*sfl;
 		int		bit_length;
 		int		parentoffset;
-- 
2.26.1

