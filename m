Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58635C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiLaCaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaCaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:30:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB931CB17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A38E61CFE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFF0C433EF;
        Sat, 31 Dec 2022 02:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453802;
        bh=adiCzSPihOW6N6ACa8PfPRYlmQgnxd3/zAXfe1mQV2o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PCE3YjYbYcLK9NDYewdY7ORA8m8VSRbF3oyiUWaD1r4K9gZ0qW0OZxn2Bf5BLf2bE
         kngoiqWU+E3LpxSZxkHrRdBnXycIgP/pkXII+oSHsy8gx9l1VBxkjBZdpbDpzis1vY
         XHRxTl/2dOYzVgqmzEqq1wYBEt5BINM4qu9hN+zQSaxzbDC+GcQq3EMBbhDwiLw35a
         PWCeB8O7F9K9ewzdeFLHgu5qZfbKvPJmWFueYq6cq34dkj4KX7WFzy1C+s/MSGSmWd
         BMx2EEL06RhVsxMgg3QNUVRZXqyqgbc6V4hSh8qmEOivhqF6wbZi8KWs5YPvj2S6nE
         +LDMMYfpdZuBQ==
Subject: [PATCH 5/5] xfs_mdrestore: fix missed progress reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878049.730695.4353400122351023727.stgit@magnolia>
In-Reply-To: <167243877981.730695.7761889719607533776.stgit@magnolia>
References: <167243877981.730695.7761889719607533776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the progress reporting only triggers when the number of bytes
read is exactly a multiple of a megabyte.  This isn't always guaranteed,
since AG headers can be 512 bytes in size.  Fix the algorithm by
recording the number of megabytes we've reported as being read, and emit
a new report any time the bytes_read count, once converted to megabytes,
doesn't match.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 4318fac9008..672010bcc6e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -126,6 +126,7 @@ perform_restore(
 	int			mb_count;
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
+	int64_t			mb_read = 0;
 	int			log_fd = -1;
 	bool			is_mdx;
 
@@ -205,8 +206,14 @@ perform_restore(
 			fatal("rtdev not supported\n");
 		}
 
-		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
-			print_progress("%lld MB read", bytes_read >> 20);
+		if (show_progress) {
+			int64_t		mb_now = bytes_read >> 20;
+
+			if (mb_now != mb_read) {
+				print_progress("%lld MB read", mb_now);
+				mb_read = mb_now;
+			}
+		}
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(write_fd, &block_buffer[cur_index <<
@@ -245,6 +252,9 @@ perform_restore(
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
 	}
 
+	if (show_progress && bytes_read > (mb_read << 20))
+		print_progress("%lld MB read", mb_read + 1);
+
 	if (progress_since_warning)
 		putchar('\n');
 

