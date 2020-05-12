Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AD7C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 14:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EC56206D3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 14:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgELORH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 10:17:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:39018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbgELORF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 May 2020 10:17:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 22327AA7C;
        Tue, 12 May 2020 14:17:07 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_db: fix crc invalidation segfault
Date:   Tue, 12 May 2020 16:16:48 +0200
Message-Id: <20200512141648.3569-1-ailiop@suse.com>
X-Mailer: git-send-email 2.26.2
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

Fixes: b64af2c48220c8 ("xfs_db: add crc manipulation commands")
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 db/crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/crc.c b/db/crc.c
index 95161c6dfe6a55..b23417a11a1e66 100644
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
2.26.2

