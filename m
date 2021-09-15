Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC081C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EBE4610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhIOXMd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232894AbhIOXMd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8739C600D4;
        Wed, 15 Sep 2021 23:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747473;
        bh=QKaMjkDR5Ba/R7Y5mDszeCx87xblo7R7YQk4Sb6r7y4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lDKwRaAjitg6+hAU+t01gso7eH/9JIedG0IvI8Mg/pmLdeNzco2mF2yOy0OtO0l27
         4twJKPLtm1dSJ8jIXZucAO69/WBSvVGYjED1mLycQ0U3aGy+WM3rXduPitxM+I/MvN
         WmUsJCcw71wIK8KlLCO0wRHYnqKsO0kUtrKuYwLF1xZw6lHVEElKdcdo0PSAAo3d+t
         buyhQe2skx+AzzW6sqq2lwM8uwtdOEUqkaQGWlKM19HjlSzXf2S2J1dAhu2Bs9dRBN
         LrE4rOYaGaTM8ZazkFgwom+XazVtShIoSv88eoZ57fBptQuWu5cuSFtFWfQADCUSYj
         1TMhbSvRhgI+A==
Subject: [PATCH 51/61] xfs: perag may be null in xfs_imap()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:13 -0700
Message-ID: <163174747329.350433.16479686939560119558.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 90e2c1c20ac672756a2835b5a92a606dd48a4aa3

Dan Carpenter's static checker reported:

The patch 7b13c5155182: "xfs: use perag for ialloc btree cursors"
from Jun 2, 2021, leads to the following Smatch complaint:

fs/xfs/libxfs/xfs_ialloc.c:2403 xfs_imap()
error: we previously assumed 'pag' could be null (see line 2294)

And it's right. Fix it.

Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index d14437bf..4d297a90 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2393,7 +2393,8 @@ xfs_imap(
 	}
 	error = 0;
 out_drop:
-	xfs_perag_put(pag);
+	if (pag)
+		xfs_perag_put(pag);
 	return error;
 }
 

