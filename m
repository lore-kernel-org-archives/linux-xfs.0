Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD67C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E1260F5E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 20:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhG1UCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 16:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230289AbhG1UCL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 16:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A79861038;
        Wed, 28 Jul 2021 20:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627502529;
        bh=OxxpsPSoKkRP2ZZG546a5hxDKSbzWGP+9IGfRAP0D+M=;
        h=Date:From:To:Cc:Subject:From;
        b=dv6ovOFr3q3MebyXoDW/cAKiL+M2SqkA/LfI4cyXFkZNR8nGZsYOWdfKb5KRxK/M+
         neujhZyfuvwGOr3xYBKfPHJFcI/zfgEpFmIL0uu+kOwZ1uU+bVnYh28d37JvnxNAdS
         5ZjBaxIqj9o5fFPQOI8JErLo+ngV8WSnb6rGTgFWd/vbij7YZn+PNN/k7R+J/lE/Gg
         pEfSIYZGkk4dRv4qcL8B+707rWH7msp0dOf905U7j5DvQXQCizLo4HlOb/+wS9AJbs
         dtXKWEYKXpkTlrFY2BFa84ca7Wr0X200owlEzffbu0lCFxbMLgDnlEs6CSai5/RENC
         MAsqdheSR7veQ==
Date:   Wed, 28 Jul 2021 13:02:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] quota: allow users to truncate group and project quota files
Message-ID: <20210728200208.GH3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 79ac1ae4, I /think/ xfsprogs gained the ability to deal with
project or group quotas.  For some reason, the quota remove command was
structured so that if the user passes both -g and -p, it will only ask
the kernel truncate the group quota file.  This is a strange behavior
since -ug results in truncation requests for both user and group quota
files, and the kernel is smart enough to return 0 if asked to truncate a
quota file that doesn't exist.

In other words, this is a seemingly arbitrary limitation of the command.
It's an unexpected behavior since we don't do any sort of parameter
validation to warn users when -p is silently ignored.  Modern V5
filesystems support both group and project quotas, so it's all the more
surprising that you can't do group and project all at once.  Remove this
pointless restriction.

Found while triaging xfs/007 regressions.

Fixes: 79ac1ae4 ("Fix xfs_quota disable, enable, off and remove commands Merge of master-melb:xfs-cmds:29395a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 quota/state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/quota/state.c b/quota/state.c
index 3ffb2c88..43fb700f 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -463,7 +463,8 @@ remove_extents(
 	if (type & XFS_GROUP_QUOTA) {
 		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
 			return;
-	} else if (type & XFS_PROJ_QUOTA) {
+	}
+	if (type & XFS_PROJ_QUOTA) {
 		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
 			return;
 	}
