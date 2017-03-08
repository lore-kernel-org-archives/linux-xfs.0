Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38994 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933330AbdCHAbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 19:31:44 -0500
Subject: [PATCH 2/3] xfs_repair: detect invalid zero-sized symlink inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 Mar 2017 16:30:16 -0800
Message-ID: <148893301680.23674.13130278100191587642.stgit@birch.djwong.org>
In-Reply-To: <148893300446.23674.6348172768180643163.stgit@birch.djwong.org>
References: <148893300446.23674.6348172768180643163.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Mathias Troiden <mathias.troiden@gmail.com>, Christoph Hellwig <hch@lst.de>

From: Brian Foster <bfoster@redhat.com>

Mathias Troiden reproduced a filesystem corruption that resulted in
a zero-sized local format symlink inode. This is invalid state and
results in an inode that cannot be accessed or modified.

The kernel detects this problem on inode access, fails and warns the
user to umount and run xfs_repair. Unfortunately, xfs_repair doesn't
even detect the problem. Thus the user has no path to recovery.

Update xfs_repair to check for invalid zero-sized symlinks and flag
them as corrupted. This results in tossing the inode, but returns
the fs to a valid state.

Reported-by: Mathias Troiden <mathias.troiden@gmail.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 8d01409..d664f87 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1385,6 +1385,11 @@ process_symlink(
 		return(1);
 	}
 
+	if (be64_to_cpu(dino->di_size) == 0) {
+		do_warn(_("zero size symlink in inode %" PRIu64 "\n"), lino);
+		return 1;
+	}
+
 	/*
 	 * have to check symlink component by component.
 	 * get symlink contents into data area

