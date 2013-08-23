Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 58EDD7F5A
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 19:03:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A41B304064
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:47 -0700 (PDT)
Received: from mail-pb0-f54.google.com (mail-pb0-f54.google.com
	[209.85.160.54]) by cuda.sgi.com with ESMTP id knsof1YX4hwjXUJr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:46 -0700 (PDT)
Received: by mail-pb0-f54.google.com with SMTP id ro12so2491013pbb.27
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:45 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 5/7] ext4: Defer mmap cmtime updates
Date: Thu, 22 Aug 2013 17:03:21 -0700
Message-Id: <a1e8b33cb80c0b5f6b437f35f298031c6b29c212.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/ext4/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dd32a2e..2cb2961 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2382,8 +2382,11 @@ static int ext4_writepages(struct address_space *mapping,
 	 * a transaction for special inodes like journal inode on last iput()
 	 * because that could violate lock ordering on umount
 	 */
-	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+	if (!mapping->nrpages ||
+	    !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		mapping_flush_cmtime(mapping);
 		return 0;
+	}
 
 	if (ext4_should_journal_data(inode)) {
 		struct blk_plug plug;
@@ -2391,6 +2394,7 @@ static int ext4_writepages(struct address_space *mapping,
 
 		blk_start_plug(&plug);
 		ret = write_cache_pages(mapping, wbc, __writepage, mapping);
+		mapping_flush_cmtime(mapping);
 		blk_finish_plug(&plug);
 		return ret;
 	}
@@ -2525,6 +2529,7 @@ retry:
 		if (ret)
 			break;
 	}
+	mapping_flush_cmtime(mapping);
 	blk_finish_plug(&plug);
 	if (!ret && !cycled) {
 		cycled = 1;
@@ -3238,6 +3243,7 @@ static const struct address_space_operations ext4_aops = {
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_write_end,
+	.update_cmtime_deferred	= generic_update_cmtime_deferred,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -3254,6 +3260,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_journalled_write_end,
+	.update_cmtime_deferred	= generic_update_cmtime_deferred,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_journalled_invalidatepage,
@@ -3270,6 +3277,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_da_write_begin,
 	.write_end		= ext4_da_write_end,
+	.update_cmtime_deferred	= generic_update_cmtime_deferred,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_da_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -5025,7 +5033,6 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int retries = 0;
 
 	sb_start_pagefault(inode->i_sb);
-	file_update_time(vma->vm_file);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
