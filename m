Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C025C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Feb 2022 02:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiBZCyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 21:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBZCyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 21:54:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2244C3206F
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 18:53:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B77261E1E
        for <linux-xfs@vger.kernel.org>; Sat, 26 Feb 2022 02:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068C6C340EF;
        Sat, 26 Feb 2022 02:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645844020;
        bh=7XGY64Q6oqL9m48EuAN8TWxnm8T0NC3a9Jo/yZ1rR2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYnrcKOf6nxoilKZf2gTANy5yrNI4tfKkSIJhMXTZ0KMVhngDui7rEUEFwA9elwFj
         yAdQ1KZ+84Bo4KJ/dbyWTl3SF0FbFnPgydIZoicUCZueLhjkdFyvScjm4X55Zd7zuE
         FvZFLf704kpR1GQ2zG2LamXVFX1bvVXn/fYDtvOENDg6YLbVlHt1QFrxJt29LahT5e
         8P0ZsNGfRdCQ//SDUMQOE3k77mkPf0MBwaq+QZyiIadllBYXpZsieehArljTi36F8k
         2Rx0ffwcOh/4rcLlZYUxvQvCzYLDYFKGN+vqDhA4uL4ngBOtF/sZofU6/oW8GJD8HW
         bXXqBmZQ4eNng==
Date:   Fri, 25 Feb 2022 18:53:39 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: [PATCH v3 12/17] xfs_scrub: report optional features in version
 string
Message-ID: <20220226025339.GX8313@magnolia>
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
v3: only report if -VV specified
---
 scrub/xfs_scrub.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index bc2e84a7..41839c26 100644
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
@@ -592,6 +599,7 @@ main(
 	char			*mtab = NULL;
 	FILE			*progress_fp = NULL;
 	struct fs_path		*fsp;
+	int			vflag = 0;
 	int			c;
 	int			fd;
 	int			ret = SCRUB_RET_SUCCESS;
@@ -670,10 +678,8 @@ main(
 			verbose = true;
 			break;
 		case 'V':
-			fprintf(stdout, _("%s version %s\n"), progname,
-					VERSION);
-			fflush(stdout);
-			return SCRUB_RET_SUCCESS;
+			vflag++;
+			break;
 		case 'x':
 			scrub_data = true;
 			break;
@@ -682,6 +688,18 @@ main(
 		}
 	}
 
+	if (vflag) {
+		if (vflag == 1)
+			fprintf(stdout, _("%s version %s\n"),
+					progname, VERSION);
+		else
+			fprintf(stdout, _("%s version %s %sUnicode\n"),
+					progname, VERSION,
+					XFS_SCRUB_HAVE_UNICODE);
+		fflush(stdout);
+		return SCRUB_RET_SUCCESS;
+	}
+
 	/* Override thread count if debugger */
 	if (debug_tweak_on("XFS_SCRUB_THREADS")) {
 		unsigned int	x;
