Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94CEC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jan 2022 22:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiANWig (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:38:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42406 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiANWig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jan 2022 17:38:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AECADB821BA;
        Fri, 14 Jan 2022 22:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D593C36AE7;
        Fri, 14 Jan 2022 22:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642199913;
        bh=ijVuTQxRWTj2v8H8MrXjMe3pE+tTFzhwXrDNYUJqfO8=;
        h=Date:From:To:Cc:Subject:From;
        b=gjN94l29jr69J6uiK9B27MyjKyKUqOdRDu56g7yfm02puDeBeBLrjrqdM42puIp19
         EyQRuKj7y60oroOJWI8Mk1slW6ojXQyJsTAMlTWGhTx0ICYyGRr6fPUQ8kyn1YEoRs
         jUrsdznEZ/BP44nX7KbPPVLikPBQ3rx/9AWCLPHOkpZ9Mqxl6oaGWx1okwn6yvSDR4
         n5nJ6VxZmLzcoJRDKcedP8dR0ENEXUWqYYsbKF5r2n8mXJXQSOTzdInhKXtaebNKRY
         AdmSAAh4QqR2JJoG2wiLgtR0b8NBO/P+AtSnpf8p3NexMMBgqMzDkWY0M1a94ZyTAS
         dxjahjqvyAk0Q==
Date:   Fri, 14 Jan 2022 14:38:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     xuyang2018.jy@fujitsu.com, Theodore Ts'o <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCHSET 9/8] unwritten_sync: convert XFS_IOC_FREESP64 to ftruncate
Message-ID: <20220114223832.GB90398@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This ioctl will be dropped soon, so port the program to use ftruncate,
which does the same thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/unwritten_sync.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/unwritten_sync.c b/src/unwritten_sync.c
index ebdc8248..45ac7df9 100644
--- a/src/unwritten_sync.c
+++ b/src/unwritten_sync.c
@@ -92,10 +92,11 @@ main(int argc, char *argv[])
 
 		print_getbmapx(file, fd, 0, 0);
 
-		flock.l_whence = 0;
-		flock.l_start= 0;
-		flock.l_len = 0;
-		xfsctl(file, fd, XFS_IOC_FREESP64, &flock);
+		if (ftruncate(fd, 0)) {
+			perror("ftruncate");
+			exit(1);
+		}
+
 		print_getbmapx(file, fd, 0, 0);
 		close(fd);
 	}
