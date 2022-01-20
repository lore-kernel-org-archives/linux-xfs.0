Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18770C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345173AbiATAWm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbiATAWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAE4C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:22:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAEFE61514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB1FC004E1;
        Thu, 20 Jan 2022 00:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638161;
        bh=z4Qu22fByLKWtPUvGbxv61cb0TWCKWod82JvBqYc5bU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OGKE9Ggl+WV7yA22byalGjbZTbkhG7KgnKoFEU5zS+NhgvgTB9+tCN0vDrtA7H1jn
         waF/AFIDnTykF1wjHCjedPWbT08AUYZOvPw/9DxCdtISA5IfJu04alFi3pl+SJcuQ/
         IfTFSAAm8eIhXmhmF7qtBZ5Zvyv+orEFLkSdt6n8a5wZ0slSVi+MmwwNAtNbV4AySq
         huFXhpevkDu1FU04JTr9VCFufbf70cnc7VtZ7bQHsGrcPlXK+/GkigsYXUtHtb/U/r
         Ov/DtJ6RU/Ygdn2AKx/t6297AzfjqeHW1bae/rdc8MlMnDEx3ejy9yES/LaGsclNLu
         VELYH3szmd9+w==
Subject: [PATCH 12/17] xfs_scrub: report optional features in version string
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:40 -0800
Message-ID: <164263816090.863810.16834243121150635355.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ted T'so reported brittleness in the fstests logic in generic/45[34] to
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

