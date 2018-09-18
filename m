Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbeIRIL4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 04:11:56 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2C74A70A
        for <linux-xfs@vger.kernel.org>; Tue, 18 Sep 2018 02:41:36 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D2420158A8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Sep 2018 02:41:36 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: don't treat unknown di_flags[2] as corruption in scrub
Message-ID: <be811b64-5630-e9eb-313f-3aa1f809ba79@redhat.com>
Date: Mon, 17 Sep 2018 21:41:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

xchk_inode_flags[2]() currently treats any di_flags[2] values that the
running kernel doesn't recognize as corruption, and calls
xchk_ino_set_corrupt() if they are set.  However, it's entirely possible
that these flags were set in some newer kernel and are quite valid,
but ignored in this kernel.

(Validators don't care one bit about unknown di_flags[2].)

Call xchk_ino_set_warning instead, because this may or may not actually
indicate a problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 5b3b177..e53ed83 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -126,8 +126,9 @@
 {
 	struct xfs_mount	*mp = sc->mp;
 
+	/* Unknown di_flags could simply be from newer kernel */
 	if (flags & ~XFS_DIFLAG_ANY)
-		goto bad;
+		xchk_ino_set_warning(sc, ino);
 
 	/* rt flags require rt device */
 	if ((flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) &&
@@ -172,8 +173,9 @@
 {
 	struct xfs_mount	*mp = sc->mp;
 
+	/* Unknown di_flags2 could simply be from newer kernel */
 	if (flags2 & ~XFS_DIFLAG2_ANY)
-		goto bad;
+		xchk_ino_set_warning(sc, ino);
 
 	/* reflink flag requires reflink feature */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) &&
