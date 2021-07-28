Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E2DC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF086101C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhG1VQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhG1VQV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017C9600CD;
        Wed, 28 Jul 2021 21:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506979;
        bh=Tqi9VwAcs2fWgYfRetlo9rj5MyjR0oREYJWPk+D1YeU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GhMqdpKYicNJhenl92yRG8NNovk7amnRDWFxTuKSRKD9yhDT9KZevt9Mt3yFqHgNJ
         cfz9x+cDoKrQuOGg0bGzml58MjHkTfegJXC18ggL9sZdEi1qM1+MG2GGgYPKMJqQtJ
         lDwM5OI6JMCG/xSCSELfMyiVTSl5jdJdS8J73K3uqqOq9abMt7EswY1MXZIvRe//8Q
         PDgT4r+ZsBHZwTnd27QYEFbs66xpBVLzX9x2XhnE9Q2//uIa3QF9KJkaqCBzUfNxOX
         fDqZOohgPBgWwVhmCt0SAJKOxBaCc5QMKmaDdHE2DnrANA/rESQBiKBQ+O9cXnTnTc
         HxYwhNUnCF6qQ==
Subject: [PATCH 2/2] xfs_io: don't count fsmaps before querying fsmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:18 -0700
Message-ID: <162750697870.45811.17448937976740124721.stgit@magnolia>
In-Reply-To: <162750696777.45811.13113252405327690016.stgit@magnolia>
References: <162750696777.45811.13113252405327690016.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There's a bunch of code in fsmap.c that tries to count the GETFSMAP
records so that it can size the fsmap array appropriately for the
GETFSMAP call.  It's pointless to iterate the entire result set /twice/
(unlike the bmap command where the extent count is actually stored in
the fs metadata), so get rid of the duplicate walk.

In other words: Iterate over the records using the default chunk size
instead of doing one call to find the size and doing a giant allocation
and GETFSMAP call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/fsmap.c |   30 ------------------------------
 1 file changed, 30 deletions(-)


diff --git a/io/fsmap.c b/io/fsmap.c
index 9f179fa8..f540a7c0 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -372,13 +372,11 @@ fsmap_f(
 	char			**argv)
 {
 	struct fsmap		*p;
-	struct fsmap_head	*nhead;
 	struct fsmap_head	*head;
 	struct fsmap		*l, *h;
 	struct xfs_fsop_geom	fsgeo;
 	long long		start = 0;
 	long long		end = -1;
-	int			nmap_size;
 	int			map_size;
 	int			nflag = 0;
 	int			vflag = 0;
@@ -492,34 +490,6 @@ fsmap_f(
 	h->fmr_flags = UINT_MAX;
 	h->fmr_offset = ULLONG_MAX;
 
-	/* Count mappings */
-	if (!nflag) {
-		head->fmh_count = 0;
-		i = ioctl(file->fd, FS_IOC_GETFSMAP, head);
-		if (i < 0) {
-			fprintf(stderr, _("%s: xfsctl(XFS_IOC_GETFSMAP)"
-				" iflags=0x%x [\"%s\"]: %s\n"),
-				progname, head->fmh_iflags, file->name,
-				strerror(errno));
-			exitcode = 1;
-			free(head);
-			return 0;
-		}
-		if (head->fmh_entries > map_size + 2) {
-			map_size = 11ULL * head->fmh_entries / 10;
-			nmap_size = map_size > (1 << 24) ? (1 << 24) : map_size;
-			nhead = realloc(head, fsmap_sizeof(nmap_size));
-			if (nhead == NULL) {
-				fprintf(stderr,
-					_("%s: cannot realloc %zu bytes\n"),
-					progname, fsmap_sizeof(nmap_size));
-			} else {
-				head = nhead;
-				map_size = nmap_size;
-			}
-		}
-	}
-
 	/*
 	 * If this is an XFS filesystem, remember the data device.
 	 * (We report AG number/block for data device extents on XFS).

