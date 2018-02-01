Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:60162 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbeBAKXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 05:23:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] xfs: Add missing braces around xfs_scrub_agfl_info initializer
Date: Thu,  1 Feb 2018 11:23:04 +0100
Message-Id: <1517480584-4588-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

With gcc-4.1.2:

    fs/xfs/scrub/agheader.c: In function ‘xfs_scrub_agfl’:
    fs/xfs/scrub/agheader.c:770: warning: missing braces around initializer
    fs/xfs/scrub/agheader.c:770: warning: (near initialization for ‘sai.oinfo’)

The first member of struct xfs_scrub_agfl_info is no longer an integral
type, but a struct.  Add the missing curly braces to fix this.

Fixes: d852657ccfc0e455 ("xfs: cross-reference reverse-mapping btree")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/xfs/scrub/agheader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index fd975524f4603387..9bcfdb0d1da379f5 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -767,7 +767,7 @@ int
 xfs_scrub_agfl(
 	struct xfs_scrub_context	*sc)
 {
-	struct xfs_scrub_agfl_info	sai = { 0 };
+	struct xfs_scrub_agfl_info	sai = { { 0 } };
 	struct xfs_agf			*agf;
 	xfs_agnumber_t			agno;
 	unsigned int			agflcount;
-- 
2.7.4

