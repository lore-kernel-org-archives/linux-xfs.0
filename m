Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752392AbdFLMXp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:23:45 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v6 14/20] dax: set errors in mapping when writeback fails
Date: Mon, 12 Jun 2017 08:23:10 -0400
Message-Id: <20170612122316.13244-19-jlayton@redhat.com>
In-Reply-To: <20170612122316.13244-1-jlayton@redhat.com>
References: <20170612122316.13244-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

Jan Kara's description for this patch is much better than mine, so I'm
quoting it verbatim here:

-----------------8<-----------------
DAX currently doesn't set errors in the mapping when cache flushing
fails in dax_writeback_mapping_range(). Since this function can get
called only from fsync(2) or sync(2), this is actually as good as it can
currently get since we correctly propagate the error up from
dax_writeback_mapping_range() to filemap_fdatawrite()

However, in the future better writeback error handling will enable us to
properly report these errors on fsync(2) even if there are multiple file
descriptors open against the file or if sync(2) gets called before
fsync(2). So convert DAX to using standard error reporting through the
mapping.
-----------------8<-----------------

For now, only do this when the FS_WB_ERRSEQ flag is set. The
AS_EIO/AS_ENOSPC flags are not currently cleared in the older code when
writeback initiation fails, only when we discover an error after waiting
on writeback to complete, so we only want to do this with errseq_t based
error handling to prevent seeing duplicate errors on fsync.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-and-Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 2a6889b3585f..ba3b17eefcfc 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -856,8 +856,24 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 			ret = dax_writeback_one(bdev, dax_dev, mapping,
 					indices[i], pvec.pages[i]);
-			if (ret < 0)
+			if (ret < 0) {
+				/*
+				 * For fs' that use errseq_t based error
+				 * tracking, we must call mapping_set_error
+				 * here to ensure that fsync on all open fds
+				 * get back an error. Doing this with the old
+				 * wb error tracking infrastructure is
+				 * problematic though, as DAX writeback is
+				 * synchronous, and the error flags are not
+				 * cleared when initiation fails, only when
+				 * it fails after the write has been submitted
+				 * to the backing store.
+				 */
+				if (mapping->host->i_sb->s_type->fs_flags &
+						FS_WB_ERRSEQ)
+					mapping_set_error(mapping, ret);
 				goto out;
+			}
 		}
 	}
 out:
-- 
2.13.0

