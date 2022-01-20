Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0125CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 01:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiATBci (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiATBch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 20:32:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEBFC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 17:32:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90E11B81C53
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 01:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE05C340E8;
        Thu, 20 Jan 2022 01:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642642354;
        bh=Pkwot9qwjYQ2wbfEN8J1YwgVw8H8oibY+jm2fCTbSa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mcugctiqtcXpB3B9ikqz4Pji2uW+YjEE7fCCe8WGcihhdfNVB65yH3bCMWmiTJD38
         KMK+Pfi1GCAs6v1PvsjdgfFHM8OhFgStKt6qamBXbJ2NKV2lyCWjD89XtMmo1WY6mj
         YFbFUml8yNiQM51V+rJ1cDuv2cmlUx5YNQMX1cqBJCROeYL9gymCJHAxP/ucZW+1tq
         AfDQ7VgbMT/DYPys7AYxEL99dJf66ky9cqV1DmxoHenv2x44eP0SMQDRxIaRUh6nRC
         Wt7XbeUF8R/fJQAXYRsjisneO8qR5WlB7ijewcvtZRXH1ESNyYHKtLuRV+t4VWPRkU
         hOHdgMucauXRQ==
Date:   Wed, 19 Jan 2022 17:32:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: [PATCH v2 12/17] xfs_scrub: report optional features in version
 string
Message-ID: <20220120013233.GJ13540@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263816090.863810.16834243121150635355.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164263816090.863810.16834243121150635355.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ted Ts'o reported brittleness in the fstests logic in generic/45[34] to
detect whether or not xfs_scrub is capable of detecting Unicode mischief
in directory and xattr names.  This is a compile-time feature, since we
do not assume that all distros will want to ship xfsprogs with libicu.

Rather than relying on ldd tests (which don't work at all if xfs_scrub
is compiled statically), let's have -V print whether or not the feature
is built into the tool.  Phase 5 still requires the presence of "UTF-8"
in LC_MESSAGES to enable Unicode confusable detection; this merely makes
the feature easier to discover.

Reported-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: correct the name of the reporter
---
 scrub/xfs_scrub.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index bc2e84a7..45e58727 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -582,6 +582,13 @@ report_outcome(
 	}
 }
 
+/* Compile-time features discoverable via version strings */
+#ifdef HAVE_LIBICU
+# define XFS_SCRUB_HAVE_UNICODE	"+"
+#else
+# define XFS_SCRUB_HAVE_UNICODE	"-"
+#endif
+
 int
 main(
 	int			argc,
@@ -670,8 +677,9 @@ main(
 			verbose = true;
 			break;
 		case 'V':
-			fprintf(stdout, _("%s version %s\n"), progname,
-					VERSION);
+			fprintf(stdout, _("%s version %s %sUnicode\n"),
+					progname, VERSION,
+					XFS_SCRUB_HAVE_UNICODE);
 			fflush(stdout);
 			return SCRUB_RET_SUCCESS;
 		case 'x':
