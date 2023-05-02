Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AFEC77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 20:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjEBUIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 16:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjEBUIu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92461BC1;
        Tue,  2 May 2023 13:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FB3F60ACD;
        Tue,  2 May 2023 20:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D05C433EF;
        Tue,  2 May 2023 20:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058120;
        bh=Ewcx81n3II88DZyyYEa/0YN50pn3fUFZrWWgSuQlWnE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XoDWQ7JeTGfms8y4eZUiIcqa55F2QynZbYXx98XUwuJgbDCtmoyque01na0Upz7/P
         D/sHGQKOiZtTCPO3Bs3bu81JE85Om6yYssv+p14m+xkCLpQ3O9mot7RC6IGkbKS1X+
         0XViLsXI9Xl+bz/aqa8qLR+09acjJGISqrayWwmWuof9Y1oTLS2wcD1KOjKFqiMLpp
         eafgn3eDKznf4z+VJey2d01DSLC+POi1CwTzFvTsEaV4RJGG95nRyvA7tq/0ZD9HO7
         6v70BQO8rH9ngp9veXxVJylynOz1QDZzUQtUIjvBPVCO4ryBQoNMfkwl669Zp0xlz0
         MsSWCT/F0IBwA==
Subject: [PATCH 6/7] fiemap: FIEMAP_EXTENT_LAST denotes the last record in the
 recordset
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:40 -0700
Message-ID: <168305812033.331137.5860693859612500212.stgit@frogsfrogsfrogs>
In-Reply-To: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
References: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove this check because FIEMAP_EXTENT_LAST denotes the last space
mapping record in the recordset of space mappings attached to the file.
That last mapping might actually map space beyond EOF, in the case of
(a) speculative post-eof preallocations, (b) stripe-aligned allocations
on XFS, or (c) realtime files in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/fiemap-tester.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)


diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
index 7e9f9fe8c1..fa085a25f1 100644
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -236,7 +236,7 @@ check_flags(struct fiemap *fiemap, int blocksize)
 
 static int
 check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
-	   int last, int prealloc)
+	   int prealloc)
 {
 	struct fiemap_extent *extent;
 	__u64 orig_offset = logical_offset;
@@ -280,11 +280,6 @@ check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
 	if (!found) {
 		printf("ERROR: couldn't find extent at %llu\n",
 		       (unsigned long long)(orig_offset / blocksize));
-	} else if (last &&
-		   !(fiemap->fm_extents[c].fe_flags & FIEMAP_EXTENT_LAST)) {
-		printf("ERROR: last extent not marked as last: %llu\n",
-		       (unsigned long long)(orig_offset / blocksize));
-		found = 0;
 	}
 
 	return (!found) ? -1 : 0;
@@ -418,7 +413,7 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 {
 	struct fiemap *fiemap;
 	char *fiebuf;
-	int blocks_to_map, ret, cur_extent = 0, last_data = 0;
+	int blocks_to_map, ret, cur_extent = 0;
 	__u64 map_start, map_length;
 	int i, c;
 
@@ -437,11 +432,6 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 	map_start = 0;
 	map_length = blocks_to_map * blocksize;
 
-	for (i = 0; i < blocks; i++) {
-		if (map[i] != 'H')
-			last_data = i;
-	}
-
 	fiemap->fm_flags = syncfile ? FIEMAP_FLAG_SYNC : 0;
 	fiemap->fm_extent_count = blocks_to_map;
 	fiemap->fm_mapped_extents = 0;
@@ -471,7 +461,7 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 			switch (map[i]) {
 			case 'D':
 				if (check_data(fiemap, logical_offset,
-					       blocksize, last_data == i, 0))
+					       blocksize, 0))
 					goto error;
 				break;
 			case 'H':
@@ -481,7 +471,7 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize, int syncfil
 				break;
 			case 'P':
 				if (check_data(fiemap, logical_offset,
-					       blocksize, last_data == i, 1))
+					       blocksize, 1))
 					goto error;
 				break;
 			default:

