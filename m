Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753198AbdF2NUc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 09:20:32 -0400
From: jlayton@kernel.org
Subject: [PATCH v8 13/18] dax: set errors in mapping when writeback fails
Date: Thu, 29 Jun 2017 09:19:49 -0400
Message-Id: <20170629131954.28733-14-jlayton@kernel.org>
In-Reply-To: <20170629131954.28733-1-jlayton@kernel.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

Jan Kara's description for this patch is much better than mine, so I'm
quoting it verbatim here:

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

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-and-tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index c22eaf162f95..441280e15d5b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -856,8 +856,10 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 			ret = dax_writeback_one(bdev, dax_dev, mapping,
 					indices[i], pvec.pages[i]);
-			if (ret < 0)
+			if (ret < 0) {
+				mapping_set_error(mapping, ret);
 				goto out;
+			}
 		}
 	}
 out:
-- 
2.13.0

