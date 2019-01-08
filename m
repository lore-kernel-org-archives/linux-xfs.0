Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44448 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbfAHUgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:36:22 -0500
Subject: [PATCH 1/5] xfs: abort xattr scrub if fatal signals are pending
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:36:11 -0800
Message-ID: <154697977104.2839.13982629875715451312.stgit@magnolia>
In-Reply-To: <154697976479.2839.3584921201780682011.stgit@magnolia>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, sandeen@sandeen.net

From: Darrick J. Wong <darrick.wong@oracle.com>

The extended attribute scrubber should abort the "read all attrs" loop
if there's a fatal signal pending on the process.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/attr.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 81d5e90547a1..9960bc5b5d76 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -82,6 +82,11 @@ xchk_xattr_listent(
 
 	sx = container_of(context, struct xchk_xattr, context);
 
+	if (xchk_should_terminate(sx->sc, &error)) {
+		context->seen_enough = 1;
+		return;
+	}
+
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
 		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
