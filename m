Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C317FA372A
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 17:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7D621925
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 17:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r4kYb7Ir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437794AbfJQR4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 13:56:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47228 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437730AbfJQR4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 13:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A/CR7PHPpcU/5/5I+dFoTTHqvSCjwPyHdxbff3qIeNU=; b=r4kYb7IrDCx/or/1brPaGMPC3W
        17qLswbrjI6klyzXg3WPoiUaXTM7ugMuCmFUkWxsEb2T15jrsJacCFph67T/nRsC7SclGex3Eer1Z
        hgUwXzVau2A2wacsglBNNAbLdqqlBjoo5iK3mQEbvGJSKnwM1qn5hMCsGZ7rp25Q2JzW3KZsHbiOZ
        Ko/Xx0+/dbdIrvDx/naBRzPjog1l0GRvNkixaW1FkM7zXXc7hox7cRUqlmsL6DPJ5vbP0pzVTVu/y
        Io1nCdcMNJD+Adb0QPD6fB6Gfs11xyTFO7k8OW5Zn3c2Lm4YpP3qbIw9IeFd3uR/nkSniaIdXclWB
        sRl4iIpw==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLA0o-0000mM-Sh; Thu, 17 Oct 2019 17:56:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 03/14] xfs: set IOMAP_F_NEW more carefully
Date:   Thu, 17 Oct 2019 19:56:13 +0200
Message-Id: <20191017175624.30305-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017175624.30305-1-hch@lst.de>
References: <20191017175624.30305-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Don't set IOMAP_F_NEW if we COW over an existing allocated range, as
these aren't strictly new allocations.  This is required to be able to
use IOMAP_F_NEW to zero newly allocated blocks, which is required for
the iomap code to fully support file systems that don't do delayed
allocations or use unwritten extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 699bbb81b8a8..f7b8b1329ddd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -707,9 +707,12 @@ xfs_file_iomap_begin_delay(
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
 	 */
-	iomap_flags |= IOMAP_F_NEW;
-	trace_xfs_iomap_alloc(ip, offset, count, whichfork,
-			whichfork == XFS_DATA_FORK ? &imap : &cmap);
+	if (whichfork == XFS_DATA_FORK) {
+		iomap_flags |= IOMAP_F_NEW;
+		trace_xfs_iomap_alloc(ip, offset, count, whichfork, &imap);
+	} else {
+		trace_xfs_iomap_alloc(ip, offset, count, whichfork, &cmap);
+	}
 done:
 	if (whichfork == XFS_COW_FORK) {
 		if (imap.br_startoff > offset_fsb) {
-- 
2.20.1

