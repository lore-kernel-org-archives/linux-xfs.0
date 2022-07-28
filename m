Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6A0C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 18:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiG1SRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiG1SRa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 14:17:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E446053E;
        Thu, 28 Jul 2022 11:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51AD3B824DA;
        Thu, 28 Jul 2022 18:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC039C433C1;
        Thu, 28 Jul 2022 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659032246;
        bh=qA7jtNsv7LzYSOnmo1TQj1iYXWIxa+f5Fv6H06m0ysk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YLBRk1MLNIzAPeCSZdIxcm2g6p6+LS1ngbexIaauwtcr05ikEvTUAzN7Qq+RFeNKb
         QfRAp/AhzurRoBMZccmDrej7Xse+JVc7P4z/BJqiA2eJz67DqiWbpFzHPtT7h3w3DB
         JvHGa2dKHr/p3WVpSE7LGmj4QpoksFlzT7pETokxsmOqvn3jjKZ9uWSlQzplEkqXFi
         NNRQ4ndo9EFmgoy/mwxzl/rzwKpEUy3CXPi9dEZu2mLIRcXh3JeMgk8j0lFceQpbi6
         f+jn475T53GYP7Fcz5PfI6aMaLY8ep8QFojZmIP72C+cbsKi1X7vV1zuHpzP5Xqymg
         oxm6V8ILE3QTQ==
Subject: [PATCH 3/3] seek_sanity_test: use XFS ioctls to determine file
 allocation unit size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     liuyd.fnst@fujitsu.com, liuyd.fnst@fujitsu.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 28 Jul 2022 11:17:26 -0700
Message-ID: <165903224646.2338516.11839049913536195078.stgit@magnolia>
In-Reply-To: <165903222941.2338516.818684834175743726.stgit@magnolia>
References: <165903222941.2338516.818684834175743726.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

liuyd.fnst@fujitsu.com reported that my recent change to the seek sanity
test broke NFS.  I foolishly thought that st_blksize was sufficient to
find the file allocation unit size so that applications could figure out
the SEEK_HOLE granularity.  Replace that with an explicit callout to XFS
ioctls so that xfs realtime will work again.

Fixes: e861a302 ("seek_sanity_test: fix allocation unit detection on XFS realtime")
Reported-by: liuyd.fnst@fujitsu.com
Tested-by: liuyd.fnst@fujitsu.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/seek_sanity_test.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)


diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 1030d0c5..78f835e8 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -40,6 +40,28 @@ static void get_file_system(int fd)
 	}
 }
 
+/* Compute the file allocation unit size for an XFS file. */
+static int detect_xfs_alloc_unit(int fd)
+{
+	struct fsxattr fsx;
+	struct xfs_fsop_geom fsgeom;
+	int ret;
+
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, &fsgeom);
+	if (ret)
+		return -1;
+
+	ret = ioctl(fd, XFS_IOC_FSGETXATTR, &fsx);
+	if (ret)
+		return -1;
+
+	alloc_size = fsgeom.blocksize;
+	if (fsx.fsx_xflags & XFS_XFLAG_REALTIME)
+		alloc_size *= fsgeom.rtextsize;
+
+	return 0;
+}
+
 static int get_io_sizes(int fd)
 {
 	off_t pos = 0, offset = 1;
@@ -47,6 +69,10 @@ static int get_io_sizes(int fd)
 	int shift, ret;
 	int pagesz = sysconf(_SC_PAGE_SIZE);
 
+	ret = detect_xfs_alloc_unit(fd);
+	if (!ret)
+		goto done;
+
 	ret = fstat(fd, &buf);
 	if (ret) {
 		fprintf(stderr, "  ERROR %d: Failed to find io blocksize\n",
@@ -54,16 +80,8 @@ static int get_io_sizes(int fd)
 		return ret;
 	}
 
-	/*
-	 * st_blksize is typically also the allocation size.  However, XFS
-	 * rounds this up to the page size, so if the stat blocksize is exactly
-	 * one page, use this iterative algorithm to see if SEEK_DATA will hint
-	 * at a more precise answer based on the filesystem's (pre)allocation
-	 * decisions.
-	 */
+	/* st_blksize is typically also the allocation size */
 	alloc_size = buf.st_blksize;
-	if (alloc_size != pagesz)
-		goto done;
 
 	/* try to discover the actual alloc size */
 	while (pos == 0 && offset < alloc_size) {

