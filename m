Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AF7C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113B661421
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhGCDFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhGCDFG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E98A061416
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jul 2021 03:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281354;
        bh=2OYPJ75nu2VnWQs/p0fzewViQ3+kNkvRKxqgirgB9nk=;
        h=Date:From:To:Subject:From;
        b=pmy1Pxsq/YThMJe3nrAOWa7It0Wn0aQR8WkqsJ0U5p0z/0gadNkQ8Rdxwiv182VV1
         IJ7q1VW72WerElIBjXSnmdRTbzzo9nAvwVdiGq9vc6h2Q3vCO4xZso3e8S1VYJsdw3
         OItKZVGFDBUU7qqIm4DAcHSfNZvDpszuajvIU2k0u8CbVNI8SGRdqXBaIB16CeytKb
         FG7IgZ12RU2JhjGiqrUsolu+VVR1TGMzeRERvV4xNGVD33Abblaam7ofwiJ1/vqn1S
         fHoNk8hZakteB5QqSr1nVeZVLK7iEy0qWXLIxUJJgf8nm6rtoGsUIch4wfZA0g7xB/
         6SvefHh2973Pw==
Date:   Fri, 2 Jul 2021 20:02:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <20210703030233.GD24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running xfs/168, I noticed a second source of post-shrink
corruption errors causing shutdowns.

Let's say that directory B has a low inode number and is a child of
directory A, which has a high number.  If B is empty but open, and
unlinked from A, B's dotdot link continues to point to A.  If A is then
unlinked and the filesystem shrunk so that A is no longer a valid inode,
a subsequent AIL push of B will trip the inode verifiers because the
dotdot entry points outside of the filesystem.

To avoid this problem, reset B's dotdot entry to the root directory when
unlinking directories, since the root directory cannot be removed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52be5c6d0b3b..03e25246e936 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2817,6 +2817,19 @@ xfs_remove(
 		error = xfs_droplink(tp, ip);
 		if (error)
 			goto out_trans_cancel;
+
+		/*
+		 * Point the unlinked child directory's ".." entry to the root
+		 * directory to eliminate back-references to inodes that may
+		 * get freed before the child directory is closed.  If the fs
+		 * gets shrunk, this can lead to dirent inode validation errors.
+		 */
+		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
+			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
+					tp->t_mountp->m_sb.sb_rootino, 0);
+			if (error)
+				return error;
+		}
 	} else {
 		/*
 		 * When removing a non-directory we need to log the parent
