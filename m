Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbeEJXOG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 19:14:06 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC v2 0/4] vfs: detect symlink corruption with attributes
Date: Thu, 10 May 2018 16:13:55 -0700
Message-Id: <20180510231359.16899-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, darrick.wong@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: sandeen@sandeen.net, dhowells@redhat.com, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

Filesystems which detect symlinks with append/immutable should inform
users their filesystem is corrupted and their respective filesystem
checker tool should fix this.

In lieu of this though users may be stuck with pesky files or
directories which they cannot remove. We cannot expect all filesystems
to be updated to address this, so since the VFS does not let filesystems
set these attributes -- let the VFS enable users to remove symlink with
these attributes, but also provide a fallback warning, in case the
users's own filesystem does not catch it.

Sending again as RFC as this just goes compile tested so far, and it
is still unclear if this is the direction we want to go with this.

v2:

As per Darrick, even though the VFS should probably allow not so popular
filesystems to delete corrupt symlinks with append/immutable -- popular
filesystems should check for this themselves and inform the users of
corruption. These filesystems should have their respective filesystem
checker tools updated to correct this as well.

v1:

Sent out a single patch just to ignore the append/immutable attributes
set on symlinks.

Luis R. Rodriguez (4):
  vfs: skip extra attributes check on removal for symlinks
  xfs: add verifier check for symlink with append/immutable flags
  ext4: add verifier check for symlink with append/immutable flags
  btrfs: verify symlinks with append/immutable flags

 fs/btrfs/inode.c                   |  9 +++++++++
 fs/ext4/inode.c                    |  7 +++++++
 fs/namei.c                         | 24 ++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_symlink_remote.c |  5 +++++
 4 files changed, 43 insertions(+), 2 deletions(-)

-- 
2.17.0

