Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752346AbcJEREI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Oct 2016 13:04:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E496AADD9
        for <linux-xfs@vger.kernel.org>; Wed,  5 Oct 2016 17:04:05 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] xfs: clear di_forkoff on ialloc
Message-ID: <bb3e00eb-7334-1ac5-509f-89804583e9ff@suse.com>
Date: Wed, 5 Oct 2016 13:04:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Commit 6dfe5a049f2 (xfs: xfs_attr_inactive leaves inconsistent
attr fork state behind) fixed an issue where an inconsistent
attr fork count persisted on disk if there was concurrent inode
writeback happening after the inode was evicted from the VFS layer.

If one of those inodes landed on disk and was reused, it may have
an invalid di_forkoff, which can cause problems when trying to add
new extended attributes.  Since we clear the rest of the attribute
fork values on ialloc, let's clear di_forkoff as well and ensure the
invalid value won't be encountered.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/xfs/xfs_inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -835,6 +835,7 @@ xfs_ialloc(
 	 */
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_anextents = 0;
+	ip->i_d.di_forkoff = 0;
 
 	/*
 	 * Log the new values stuffed into the inode.

-- 
Jeff Mahoney
SUSE Labs
