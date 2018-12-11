Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33822 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbeLKTDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 14:03:03 -0500
Date: Tue, 11 Dec 2018 11:02:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] mkfs: fix symlink target if_bytes computation for protofile
Message-ID: <20181211190256.GV24487@magnolia>
References: <a7246562-e851-dfc4-ea3f-3b4dd64aca5b@redhat.com>
 <ca4c95cc-c8c5-c876-9ca4-a50794a4bb4f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca4c95cc-c8c5-c876-9ca4-a50794a4bb4f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

When creating a local format symlink, we expect the target buffer in the
data fork to have enough space to contain the null, but we also expect
if_bytes to reflect the length of the target /not/ including the null.
If we don't adjust if_bytes down by one byte, we can run off into
uninitialized memory.  Fix this, which should clean up the spurious
xfs/019 failures for good.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/proto.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index fc07de5f..dc0225bd 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -238,10 +238,18 @@ newfile(
 	flags = 0;
 	mp = ip->i_mount;
 	if (symlink && len <= XFS_IFORK_DSIZE(ip)) {
-		/* Copy the name's trailing NULL as well */
+		/*
+		 * Local format symbolic link targets are supposed to be NULL
+		 * terminated in memory.  This means that if_data must be at
+		 * least one byte longer than the target string's length so
+		 * that there's enough space to hold the null.  However, we
+		 * still expect if_bytes to be strlen(target), which does _not_
+		 * include the null.
+		 */
 		libxfs_idata_realloc(ip, len + 1, XFS_DATA_FORK);
 		if (buf)
 			memmove(ip->i_df.if_u1.if_data, buf, len + 1);
+		ip->i_df.if_bytes = len;
 		ip->i_d.di_size = len;
 		ip->i_df.if_flags &= ~XFS_IFEXTENTS;
 		ip->i_df.if_flags |= XFS_IFINLINE;
