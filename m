Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbfCRNSj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Mar 2019 09:18:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1647E3082E68
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 13:18:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7A1E60C4C
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 13:18:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs_io: allow combination of sync_file_range() flags
Date: Mon, 18 Mar 2019 09:18:38 -0400
Message-Id: <20190318131838.19019-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The sync_file_range() functionality supports a flags argument that
allows the caller to specify any combination of initiating writeback
or waiting for write completion before and/or after the write. The
xfs_io handler supports the ability to specify combinations of flags
on the command line, but fails to OR the flags together and thus
only performs one action per invocation.

This is inconsistent with the syscall and command interpretation.
Update the sync_file_range() handler to populate the flags mask as
specified by the user.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 io/sync_file_range.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 30bbc93d..8b5345c5 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -37,13 +37,13 @@ sync_range_f(
 	while ((c = getopt(argc, argv, "abw")) != EOF) {
 		switch (c) {
 		case 'a':
-			sync_mode = SYNC_FILE_RANGE_WAIT_AFTER;
+			sync_mode |= SYNC_FILE_RANGE_WAIT_AFTER;
 			break;
 		case 'b':
-			sync_mode = SYNC_FILE_RANGE_WAIT_BEFORE;
+			sync_mode |= SYNC_FILE_RANGE_WAIT_BEFORE;
 			break;
 		case 'w':
-			sync_mode = SYNC_FILE_RANGE_WRITE;
+			sync_mode |= SYNC_FILE_RANGE_WRITE;
 			break;
 		default:
 			return command_usage(&sync_range_cmd);
-- 
2.17.2
