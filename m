Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DA6C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD1C61108
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhEMBDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhEMBDC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A336761090;
        Thu, 13 May 2021 01:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867713;
        bh=vgQ68KpedCzKIZM5tfjPV2KX7oIm4vGUQ/cJ4vsALfo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uqYPU8Uv0JyuBe1z468JAH4nkqPAHO2YeYwLeYCWkcw8lmGVgcW7hwb9YZqAHvtDk
         Qpe4D4Rq+6ZLQWRECz7QfdA84m+YYtuE0i83E4+/fIQ6uqeAY2x+aOA3C44/SgeHHl
         TOfAh7FlQ8MqNNlyFE5Hfv2LU5M2Xqv9Q7eh9jZs5zjZ1aHxRgzaqWKWaWRrtvIIeh
         /+VWiBd3ZsMwgLE0lts/5Is/CYK9uKqugR8jg468sc8yDn4KpecnKfSv/wCiFM2UvH
         P6z8iXHrGfmeet2e4OACq/1N2mM540UhYTKizX7N0UmY8S3ID7syBjfQRaUVytk9JQ
         MIRbml4VFA3NA==
Subject: [PATCH 2/4] xfs: don't propagate invalid extent size hints to new
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:01:53 -0700
Message-ID: <162086771324.3685783.12562187598352097487.stgit@magnolia>
In-Reply-To: <162086770193.3685783.14418051698714099173.stgit@magnolia>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Under the current inode extent size hint validation rules, it's possible
to set extent size hints on directories along with an 'inherit' flag so
that the values will be propagated to newly created regular files.  (The
directories themselves do not care about the hint values.)

For these directories, the alignment of the hint is checked against the
data device even if the directory also has the rtinherit hint set, which
means that one can set a directory's hint value to something that isn't
an integer multiple of the realtime extent size.  This isn't a problem
for the directory itself, but the validation routines require rt extent
alignment for realtime files.

If the unaligned hint value and the realtime bit are both propagated
into a newly created regular realtime file, we end up writing out an
incorrect hint that trips the verifiers the next time we try to read the
inode buffer, and the fs shuts down.  Fix this by cancelling the hint
propagation if it would cause problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0369eb22c1bb..db81e8c22708 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -689,6 +689,7 @@ xfs_inode_inherit_flags(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
+	xfs_failaddr_t		failaddr;
 	unsigned int		di_flags = 0;
 	umode_t			mode = VFS_I(ip)->i_mode;
 
@@ -728,6 +729,14 @@ xfs_inode_inherit_flags(
 	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
 		di_flags |= XFS_DIFLAG_FILESTREAM;
 
+	/* Make sure the extsize actually validates properly. */
+	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
+			VFS_I(ip)->i_mode, ip->i_diflags);
+	if (failaddr) {
+		di_flags &= ~(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT);
+		ip->i_extsize = 0;
+	}
+
 	ip->i_diflags |= di_flags;
 }
 
@@ -737,12 +746,22 @@ xfs_inode_inherit_flags2(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
+	xfs_failaddr_t		failaddr;
+
 	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
 		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 		ip->i_cowextsize = pip->i_cowextsize;
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+
+	/* Make sure the cowextsize actually validates properly. */
+	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
+			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
+	if (failaddr) {
+		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = 0;
+	}
 }
 
 /*

