Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB5FC07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D770061424
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhGCDAx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhGCDAx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9F561416;
        Sat,  3 Jul 2021 02:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281100;
        bh=Bc9TtbWRmMDD3mscuUiLKulSYp6wqMxekd79zVkgfI8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KaqTZzEdp9G3WoZuLLbDx+ZTj05ad0dj0E4tfMooXlJAjXtFQaHD4q0nGO8j8brWj
         2dF+lSOqXXirKjCOkJ1evODaPSqqyueVeTUK3dUs9Go4tH5bA4zw1CKnNQlQCvctJe
         2dK0mTYR12wSM/IT5T7oSZn9VFqnYpDgEar4B0cDR8mhDa+uqv1AwXL7t88G4qVwNT
         7KEyTzG4TyGarQps/ukqw3V+xE0hDkFLK1hqMZmIuLpXvCOwZQvA7lT7rdnxb6cMXc
         RA3fn4650v4Z/MKh1mjEW0Zspj1Gya1lYAG4PJtIFiK9O2/CBmwGy5XCLpJ6oP56KS
         u7xp3+zgasg3Q==
Subject: [PATCH 2/2] xfs_io: don't count fsmaps before querying fsmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:20 -0700
Message-ID: <162528110051.38807.5958877066692397152.stgit@locust>
In-Reply-To: <162528108960.38807.10502298775223215201.stgit@locust>
References: <162528108960.38807.10502298775223215201.stgit@locust>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

