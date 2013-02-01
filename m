Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE4387F4C
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 04:44:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F9EDAC002
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 02:44:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MVUGOleLLGjj8Hzs for
	<xfs@oss.sgi.com>; Fri, 01 Feb 2013 02:44:31 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 18/18] ext4: Allow punch hole with bigalloc enabled
Date: Fri,  1 Feb 2013 11:43:44 +0100
Message-Id: <1359715424-32318-19-git-send-email-lczerner@redhat.com>
In-Reply-To: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
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
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

In commits 5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85 and
30bc2ec9598a1b156ad75217f2e7d4560efdeeab we've reworked punch_hole
implementation and there is noting holding us back from using punch hole
on file system with bigalloc feature enabled.

This has been tested with fsx and xfstests.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e7bf594..01cf049 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3530,11 +3530,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		return -EOPNOTSUPP;
 	}
 
-	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
-		/* TODO: Add support for bigalloc file systems */
-		return -EOPNOTSUPP;
-	}
-
 	return ext4_ext_punch_hole(file, offset, length);
 }
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
