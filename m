Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdF3NDH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Jun 2017 09:03:07 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EEB64EB9CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2017 13:03:06 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (unknown [10.40.205.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6026587E3D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2017 13:03:06 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Check for m_errortag initialization in xfs_errortag_test
Date: Fri, 30 Jun 2017 15:03:01 +0200
Message-Id: <20170630130301.32264-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

While adding error injection into IO completion, I notice the lack of
initialization check in xfs_errortag_test(), make the error injection
mechanism unable to be used there.

IO completion is executed a few times before the error injection
mechanism is initialized, so to be safer, make xfs_errortag_test() check
if the errortag is properly initialized.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_error.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 26c32bc..2f4feb9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -233,6 +233,17 @@ xfs_errortag_test(
 {
 	unsigned int		randfactor;
 
+	/*
+	 * To be able to use error injection anywhere, we need to ensure error
+	 * injection mechanism is already initialized.
+	 *
+	 * Code paths like I/O completion can be called before the
+	 * initialization is complete, but be able to inject errors in such
+	 * places is still useful.
+	 */
+	if (!mp->m_errortag)
+		return false;
+
 	ASSERT(error_tag < XFS_ERRTAG_MAX);
 	randfactor = mp->m_errortag[error_tag];
 	if (!randfactor || prandom_u32() % randfactor)
-- 
2.9.4

