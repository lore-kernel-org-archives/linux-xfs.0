Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707A7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31F0761992
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhCWET5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:19:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhCWETs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E8B16198E;
        Tue, 23 Mar 2021 04:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473188;
        bh=Oy2mR/qeC/0tXF/T1jSuG7BtEihUBdRSfPOwZs25P08=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UKUlTylUJlmxf/EZ9uRC8h1nbIazUbVY4FB3ErtKbjg2sHsB9UqpLlaZTuWevt1Tb
         Q4y+pQHHbsM88kRLUhC/2lyFYFNO7TBHaz624tP2bdRkhs+w4QkR1eWmaMe/Q8q3RP
         QdqsPGka5eby/FBwAqKbXk7nBovxxwpsXNJyfPdxWAp8pkdIbPxaw2F7djJP0mk4AK
         xixJMgn49TD4a77FGgaQj6LCQWfbO/1/O5qLz0ydF3WuGB2OUOTja7cT2gP+JeeC0R
         G+azBWicxXrGIIlP5hFxFkHE3GTX8nxJVo8MSQbunGiO2QaZp8Uy0xHMiELMllqTOD
         AALWluOzKYrIQ==
Subject: [PATCH 1/3] populate: create block devices when pre-populating
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:19:48 -0700
Message-ID: <161647318806.3429609.966502470186246038.stgit@magnolia>
In-Reply-To: <161647318241.3429609.1862044070327396092.stgit@magnolia>
References: <161647318241.3429609.1862044070327396092.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I just noticed that the fs population helper creates a chardev file
"S_IFBLK" on the scratch filesystem.  This seems bogus (particularly
since we actually also create a chardev named S_IFCHR) so fix up the
mknod calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index 4135d89d..8f42a528 100644
--- a/common/populate
+++ b/common/populate
@@ -230,7 +230,7 @@ _scratch_xfs_populate() {
 	# Char & block
 	echo "+ special"
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
-	mknod "${SCRATCH_MNT}/S_IFBLK" c 1 1
+	mknod "${SCRATCH_MNT}/S_IFBLK" b 1 1
 
 	# special file with an xattr
 	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
@@ -402,7 +402,7 @@ _scratch_ext4_populate() {
 	# Char & block
 	echo "+ special"
 	mknod "${SCRATCH_MNT}/S_IFCHR" c 1 1
-	mknod "${SCRATCH_MNT}/S_IFBLK" c 1 1
+	mknod "${SCRATCH_MNT}/S_IFBLK" b 1 1
 
 	# special file with an xattr
 	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR

