Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06D1C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiF1UYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiF1UYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594E2C39;
        Tue, 28 Jun 2022 13:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E872B8203F;
        Tue, 28 Jun 2022 20:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE1C3411D;
        Tue, 28 Jun 2022 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447683;
        bh=ymJ/MhoVSEN2EqobOvoYw1b3Acb52Dh/mWtxnlb5Pjc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I0Ss/OM3Dn8SWRCNBvdTNEXQOX6ObBsPFUyCy6Klw1O01j6Vw5/rzoMNkEB4tauJ3
         C1RDdqFPOi4SC6NYBQ6mbmlDuF9mi3eegSdcpK/9C6vzzSsbzSmci26cm3d0ivkkfE
         rPYAGuVxx/n+2hdQl3R+baQZ+4+qapATczYzBuQyr9jQMg4N8bBoPEjlzISQ23NqnN
         58+f1QU55zqRq0KI/JYjiJm15i5SGTECseyb8Cd2aK/eW+pRsg6m3yqdsrGMES4c0R
         MTrwn5FfOyz3qVUz8PSqN63/gmZiU1QDC+AnQnrB1XwQIxDcZerEsR/tjSzd+jFIBk
         FXXHtH0aTgD7A==
Subject: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on XFS
 realtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:23 -0700
Message-ID: <165644768327.1045534.10420155448662856970.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The seek sanity test tries to figure out a file space allocation unit by
calling stat and then using an iterative SEEK_DATA method to try to
detect a smaller blocksize based on SEEK_DATA's consultation of the
filesystem's internal block mapping.  This was put in (AFAICT) because
XFS' stat implementation returns max(filesystem blocksize, PAGESIZE) for
most regular files.

Unfortunately, for a realtime file with an extent size larger than a
single filesystem block this doesn't work at all because block mappings
still work at filesystem block granularity, but allocation units do not.
To fix this, detect the specific case where st_blksize != PAGE_SIZE and
trust the fstat results.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/seek_sanity_test.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 76587b7f..1030d0c5 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -45,6 +45,7 @@ static int get_io_sizes(int fd)
 	off_t pos = 0, offset = 1;
 	struct stat buf;
 	int shift, ret;
+	int pagesz = sysconf(_SC_PAGE_SIZE);
 
 	ret = fstat(fd, &buf);
 	if (ret) {
@@ -53,8 +54,16 @@ static int get_io_sizes(int fd)
 		return ret;
 	}
 
-	/* st_blksize is typically also the allocation size */
+	/*
+	 * st_blksize is typically also the allocation size.  However, XFS
+	 * rounds this up to the page size, so if the stat blocksize is exactly
+	 * one page, use this iterative algorithm to see if SEEK_DATA will hint
+	 * at a more precise answer based on the filesystem's (pre)allocation
+	 * decisions.
+	 */
 	alloc_size = buf.st_blksize;
+	if (alloc_size != pagesz)
+		goto done;
 
 	/* try to discover the actual alloc size */
 	while (pos == 0 && offset < alloc_size) {
@@ -80,6 +89,7 @@ static int get_io_sizes(int fd)
 	if (!shift)
 		offset += pos ? 0 : 1;
 	alloc_size = offset;
+done:
 	fprintf(stdout, "Allocation size: %ld\n", alloc_size);
 	return 0;
 

