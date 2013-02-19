Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A4A87F54
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 10:35:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0FFEAC005
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 08:35:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id K1gfxhaaWTF1IH22 for
	<xfs@oss.sgi.com>; Tue, 19 Feb 2013 08:35:05 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1JGYtZB005860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 11:34:56 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1JGYtWJ003690
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 11:34:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 3/7] xfs: cap prealloc size to free space before shift
Date: Tue, 19 Feb 2013 11:37:27 -0500
Message-Id: <1361291851-24714-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
References: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
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

With the addition of quota preallocation throttling, we want to
support a general algorithm that considers the maximum allowable
prealloc size and recommended shift modifier from various sources
(i.e., global fs state and all applicable quotas for an inode).

Update the current global free space throttle algorithm to cap the
preallocation size to the free space available in the filesystem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index daa08f6..3b41c18 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -412,6 +412,9 @@ xfs_iomap_prealloc_size(
 		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
 			shift++;
 	}
+	if (alloc_blocks > freesp)
+		alloc_blocks = freesp;
+
 	if (shift)
 		alloc_blocks >>= shift;
 	/*
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
