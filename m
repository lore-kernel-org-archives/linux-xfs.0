Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DF817F56
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF8F3304048
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kwQckKZKDPFQPr7o for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:19 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/13] libxfs: remove ASSERT on ftype read from disk
Date: Tue, 17 Mar 2015 15:33:11 -0500
Message-Id: <1426624395-8258-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This one is already fixed in the kernel, with
	fb04013 xfs: don't ASSERT on corrupt ftype
but that kernel<->userspace merge is still pending.

In the meantime, just fix it as a one-off here, because ASSERTing
on bad on-disk values when running xfs_repair is a very unfriendly
thing to do.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xfs_da_format.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
index 89a1a21..695e698 100644
--- a/include/xfs_da_format.h
+++ b/include/xfs_da_format.h
@@ -561,7 +561,7 @@ xfs_dir3_dirent_get_ftype(
 	if (xfs_sb_version_hasftype(&mp->m_sb)) {
 		__uint8_t	type = dep->name[dep->namelen];
 
-		ASSERT(type < XFS_DIR3_FT_MAX);
+		//ASSERT(type < XFS_DIR3_FT_MAX);
 		if (type < XFS_DIR3_FT_MAX)
 			return type;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
