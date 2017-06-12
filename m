Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752357AbdFLMXr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:23:47 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v6 16/20] block: convert to errseq_t based writeback error tracking
Date: Mon, 12 Jun 2017 08:23:12 -0400
Message-Id: <20170612122316.13244-21-jlayton@redhat.com>
In-Reply-To: <20170612122316.13244-1-jlayton@redhat.com>
References: <20170612122316.13244-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

This is a very minimal conversion to errseq_t based error tracking
for raw block device access.

Only real change that is strictly required is that we must ensure that
filemap_report_wb_err is unconditionally called after fsync, which is
now done if FS_WB_ERRSEQ is set in fs_flags. That ensures that the
errseq_t in the file is advanced to the latest value in the mapping.

Note that there are internal callers that call sync_blockdev and the
like that are not affected by this. They'll continue to use the
AS_EIO/AS_ENOSPC flags for error reporting like they always have for
now.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/block_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4d62fe771587..4bf865cc99de 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -801,6 +801,7 @@ static struct file_system_type bd_type = {
 	.name		= "bdev",
 	.mount		= bd_mount,
 	.kill_sb	= kill_anon_super,
+	.fs_flags	= FS_WB_ERRSEQ,
 };
 
 struct super_block *blockdev_superblock __read_mostly;
-- 
2.13.0

