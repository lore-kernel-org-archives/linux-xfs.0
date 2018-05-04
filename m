Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35688 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeEDReX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 13:34:23 -0400
Subject: [PATCH 2/5] xfs: check type in quota verifier during quotacheck
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8e4dd8ff-5202-0b9d-e3c6-193976d5b3cf@sandeen.net>
Date: Fri, 4 May 2018 12:34:22 -0500
MIME-Version: 1.0
In-Reply-To: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

During quotacheck we send in the quota type, so verify that as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index a926058f7b0c..c00174f32f0d 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -47,7 +47,7 @@ xfs_dquot_verify(
 	struct xfs_mount *mp,
 	xfs_disk_dquot_t *ddq,
 	xfs_dqid_t	 id,
-	uint		 type)	  /* used only when IO_dorepair is true */
+	uint		 type)	  /* used only during quotacheck */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
@@ -69,6 +69,8 @@ xfs_dquot_verify(
 	if (ddq->d_version != XFS_DQUOT_VERSION)
 		return __this_address;
 
+	if (type && ddq->d_flags != type)
+		return __this_address;
 	if (ddq->d_flags != XFS_DQ_USER &&
 	    ddq->d_flags != XFS_DQ_PROJ &&
 	    ddq->d_flags != XFS_DQ_GROUP)
-- 
2.17.0

