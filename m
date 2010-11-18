Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI1sb4W115707 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 19:54:37 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ED72175E889
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 17:56:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YNdDsMiDxRTIsdnE for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 17:56:10 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 5/6] Btrfs: fail if we try to use hole punch
Date: Wed, 17 Nov 2010 20:46:19 -0500
Message-Id: <1290044780-2902-6-git-send-email-josef@redhat.com>
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz

Btrfs doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78877d7..6f08892 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6936,6 +6936,10 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	alloc_start = offset & ~mask;
 	alloc_end =  (offset + len + mask) & ~mask;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
 	/*
 	 * wait for ordered IO before we have any locks.  We'll loop again
 	 * below with the locks held.
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
