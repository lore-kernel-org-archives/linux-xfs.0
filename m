Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdCAOuY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 09:50:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs_repair: detect invalid zero-sized symlink inodes
Date: Wed,  1 Mar 2017 10:00:03 -0500
Message-Id: <1488380403-5826-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Mathias Troiden <mathias.troiden@gmail.com>

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
---
 repair/dinode.c | 5 +++++
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
-- 
2.7.4

