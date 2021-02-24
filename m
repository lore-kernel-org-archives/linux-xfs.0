Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C1FC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11CF064EDD
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhBXW3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234846AbhBXW3z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 17:29:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9769164EDD;
        Wed, 24 Feb 2021 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614205754;
        bh=kQyV2TbMMfZr8D9sYxxrUAX+uF3sCSyljCSQ7oY3bhM=;
        h=Date:From:To:Cc:Subject:From;
        b=cKBjgDQsUZWqrQemB6LlVR066Ej9/PWTuJmiRIn8LhjuiFiaswLDOxXKKitVwkgI4
         eYATWxeFJHC4b6GUgZag6U59bRaQZ4pYHG7amOpuFvZlzRHxcdRe6PUv+3C81ysVLV
         BwflLG5IRTkmU5zSZ88sfKGLV8NQj7S0Jrnl6V56hyjPJ/7VVXz6m4z/FJeG86SoXX
         O1oQzbFTKZpThhAXUutcU4fI00XsJAbGclr3HgoYgt7475bBWg9s17XoKpvUwd6/I/
         Tm4c4J/6oJQCgnJ9W33rp840uc8BCdcAsTf6a410Mr68MpfxlLi8QMV/DAhLBnUdWe
         eAZlpj3Y7QZjg==
Date:   Wed, 24 Feb 2021 14:29:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] man: document XFS_XFLAG_APPEND behavior for directories
Message-ID: <20210224222913.GF7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For directories, the APPEND flag means that files cannot be unlinked
from the directory.  Files can be linked in or created, just not
unlinked.  Document this behavior, since it's been in the VFS for years
though not explicitly mentioned.  This patch is in preparation for
trying to hoist the fsgetxattr ioctl documentation to the man-pages
project.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man2/ioctl_xfs_fsgetxattr.2 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
index e2cbfca3..2c626a7e 100644
--- a/man/man2/ioctl_xfs_fsgetxattr.2
+++ b/man/man2/ioctl_xfs_fsgetxattr.2
@@ -104,6 +104,7 @@ will be returned.
 .B XFS_XFLAG_APPEND
 The file is append-only - it can only be opened in append mode for
 writing.
+For directories, this means that files cannot be unlinked from this directory.
 Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
 capability can set or clear this flag.
 .TP
