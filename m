Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DADEC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 22:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61DA62339E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 22:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfHUWOw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 18:14:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbfHUWOw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 18:14:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D03FA2F6B6
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 22:14:52 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3364260603
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 22:14:52 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsdump: find root inode, not first inode
Message-ID: <f66f26f7-5e29-80fc-206c-9a53cf4640fa@redhat.com>
Date:   Wed, 21 Aug 2019 17:14:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Wed, 21 Aug 2019 22:14:52 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The prior effort to identify the actual root inode in a filesystem
failed in the (rare) case where inodes were allocated with a lower
number than the root.  As a result, the wrong root inode number
went into the dump, and restore would fail with:

xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.

Fix this by iterating over a chunk's worth of inodes until we find
a directory inode with generation 0, which should only be true
for the real root inode.

Fixes: 25195ebf107 ("xfsdump: handle bind mount targets")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/dump/content.c b/dump/content.c
index 30232d4..9f9c03b 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -1384,7 +1384,7 @@ baseuuidbypass:
 	/* figure out the ino for the root directory of the fs
 	 * and get its struct xfs_bstat for inomap_build().  This could
 	 * be a bind mount; don't ask for the mount point inode,
-	 * find the actual lowest inode number in the filesystem.
+	 * actually find the root inode number in the filesystem.
 	 */
 	{
 		stat64_t rootstat;
@@ -1404,20 +1404,36 @@ baseuuidbypass:
 			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
 		assert(sc_rootxfsstatp);
 
-		/* Get the first valid (i.e. root) inode in this fs */
-		bulkreq.lastip = (__u64 *)&lastino;
-		bulkreq.icount = 1;
-		bulkreq.ubuffer = sc_rootxfsstatp;
-		bulkreq.ocount = &ocount;
-		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
-			mlog(MLOG_ERROR,
-			      _("failed to get bulkstat information for root inode\n"));
+		/*
+		 * Find the root inode in this fs.  It is (rarely) possible to
+		 * have a non-root inode come before the root inode, so iterate
+		 * over a chunk's worth looking for the first dir inode with
+		 * bs_gen == 0, which should only be true for the root inode.
+		 */
+		for (i = 0; i < 64; i++) {
+			bulkreq.lastip = (__u64 *)&lastino;
+			bulkreq.icount = 1;
+			bulkreq.ubuffer = sc_rootxfsstatp;
+			bulkreq.ocount = &ocount;
+			if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
+				mlog(MLOG_ERROR,
+_("failed to get bulkstat information for root inode\n"));
+				return BOOL_FALSE;
+			}
+			/* found it? */
+			if ((sc_rootxfsstatp->bs_mode & S_IFMT) == S_IFDIR &&
+			    sc_rootxfsstatp->bs_gen == 0)
+				break;
+		}
+
+		if (i == 64) {
+			mlog(MLOG_ERROR, _("failed to find root inode\n"));
 			return BOOL_FALSE;
 		}
 
 		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
 			mlog (MLOG_NORMAL | MLOG_NOTE,
-			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
+_("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
 			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
 

