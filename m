Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbeEJXOH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 19:14:07 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC v2 2/4] xfs: add verifier check for symlink with append/immutable flags
Date: Thu, 10 May 2018 16:13:57 -0700
Message-Id: <20180510231359.16899-3-mcgrof@kernel.org>
In-Reply-To: <20180510231359.16899-1-mcgrof@kernel.org>
References: <20180510231359.16899-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, darrick.wong@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: sandeen@sandeen.net, dhowells@redhat.com, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

The Linux VFS does not allow a way to set append/immuttable attributes
to symlinks, this is just not possible. If this is detected we can
correct this with xfs_repair, so inform the user.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 5ef5f354587e..42dd81ede3d6 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -242,5 +242,10 @@ xfs_symlink_shortform_verify(
 	/* We /did/ null-terminate the buffer, right? */
 	if (*endp != 0)
 		return __this_address;
+
+	/* Immutable and append flags are not allowed on symlinks */
+	if (ip->i_d.di_flags & (XFS_DIFLAG_APPEND | XFS_DIFLAG_IMMUTABLE))
+		return __this_address;
+
 	return NULL;
 }
-- 
2.17.0

