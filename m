Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D63247F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 15:13:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DC26AC001
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 13:13:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FsbNn8wfsWupVDyl for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 13:13:46 -0700 (PDT)
Message-ID: <551073F9.6060908@sandeen.net>
Date: Mon, 23 Mar 2015 15:13:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: PATCH 09/13 V2] libxfs: remove ASSERT on ftype read from disk
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-10-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

This one is already fixed in the kernel, with
	fb04013 xfs: don't ASSERT on corrupt ftype
but that kernel<->userspace merge is still pending.

In the meantime, just fix it as a one-off here, because ASSERTing
on bad on-disk values when running xfs_repair is a very unfriendly
thing to do.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Remove it, don't cplusplus-comment it out!  o_O

diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
index 89a1a21..11f1420 100644
--- a/include/xfs_da_format.h
+++ b/include/xfs_da_format.h
@@ -561,7 +561,6 @@ xfs_dir3_dirent_get_ftype(
 	if (xfs_sb_version_hasftype(&mp->m_sb)) {
 		__uint8_t	type = dep->name[dep->namelen];
 
-		ASSERT(type < XFS_DIR3_FT_MAX);
 		if (type < XFS_DIR3_FT_MAX)
 			return type;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
