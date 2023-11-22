Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95EFC27C40
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbjKVXHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbjKVXHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E489199
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBDC433C8;
        Wed, 22 Nov 2023 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694460;
        bh=opPw3xe+heHZkZZt9ty/PHeu/jcTOfYDGE0iMeC+CR0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hx/Rwo1zH3YMRtCVVE8ltKG/1EW+EKfRCjMUxUrlVZ6+w+uc8HjwwRfWwToru9gpc
         XaUtAgeoIXiuTi596QbCFpGTJd2T7oLiTsHcZz+kMwd16XDXPMyaCY5frituNmJqr2
         izrqpasKcy3aVrHm4eRkSeY0xb6eB6mHPCmtqy3TSkmVO1n1m3F9JJRH913bZzGi3H
         Q0vQHzaUlMREfqcai9iu2VWWh/aDGs0zeUU44QXPbUOe+ZUl+m/h5R/kJwlwgs8Rs8
         kpgI8WiH3idRkFpWIpD0uLsCsl1iZi6TIokmD+QVU28ftD0w11Pk71NcauUcd+Ahmu
         peVCUUPs+I5rQ==
Subject: [PATCH 9/9] xfs_mdrestore: fix missed progress reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:39 -0800
Message-ID: <170069445938.1865809.2272471874760042809.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
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

Fix the v2 code to emit one final status message in case the last
extent restored is more than a megabyte.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 3f761e8fe8d..ab9a44d2118 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -7,6 +7,7 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
+#include "libfrog/div64.h"
 
 union mdrestore_headers {
 	__be32				magic;
@@ -160,6 +161,7 @@ restore_v1(
 	int			mb_count;
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
+	int64_t			mb_read = 0;
 
 	block_size = 1 << h->v1.mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
@@ -208,9 +210,14 @@ restore_v1(
 	bytes_read = 0;
 
 	for (;;) {
-		if (mdrestore.show_progress &&
-		    (bytes_read & ((1 << 20) - 1)) == 0)
-			print_progress("%lld MB read", bytes_read >> 20);
+		if (mdrestore.show_progress) {
+			int64_t		mb_now = bytes_read >> 20;
+
+			if (mb_now != mb_read) {
+				print_progress("%lld MB read", mb_now);
+				mb_read = mb_now;
+			}
+		}
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(ddev_fd, &block_buffer[cur_index <<
@@ -240,6 +247,9 @@ restore_v1(
 		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
 	}
 
+	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
+		print_progress("%lld MB read", howmany_64(bytes_read, 1U << 20));
+
 	if (mdrestore.progress_since_warning)
 		putchar('\n');
 
@@ -340,6 +350,7 @@ restore_v2(
 	struct xfs_sb		sb;
 	struct xfs_meta_extent	xme;
 	char			*block_buffer;
+	int64_t			mb_read = 0;
 	int64_t			bytes_read;
 	uint64_t		offset;
 	int			len;
@@ -416,16 +427,18 @@ restore_v2(
 		bytes_read += len;
 
 		if (mdrestore.show_progress) {
-			static int64_t mb_read;
-			int64_t mb_now = bytes_read >> 20;
+			int64_t	mb_now = bytes_read >> 20;
 
 			if (mb_now != mb_read) {
-				print_progress("%lld MB read", mb_now);
+				print_progress("%lld mb read", mb_now);
 				mb_read = mb_now;
 			}
 		}
 	} while (1);
 
+	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
+		print_progress("%lld mb read", howmany_64(bytes_read, 1U << 20));
+
 	if (mdrestore.progress_since_warning)
 		putchar('\n');
 

