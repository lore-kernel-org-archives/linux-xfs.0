Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98C2D7F63
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 18:22:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11563AC006
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:34 -0700 (PDT)
Received: from mail-pb0-f46.google.com (mail-pb0-f46.google.com
	[209.85.160.46]) by cuda.sgi.com with ESMTP id 9axziiYdE1TkSKgW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:32 -0700 (PDT)
Received: by mail-pb0-f46.google.com with SMTP id rq2so788090pbb.5
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 16:22:32 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 5/5] ext4: Defer mmap cmtime update until writeback
Date: Fri, 16 Aug 2013 16:22:12 -0700
Message-Id: <d59d6c9790bd3c36b93343ed91be5e0cda7e5f09.1376679411.git.luto@amacapital.net>
In-Reply-To: <cover.1376679411.git.luto@amacapital.net>
References: <cover.1376679411.git.luto@amacapital.net>
In-Reply-To: <cover.1376679411.git.luto@amacapital.net>
References: <cover.1376679411.git.luto@amacapital.net>
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

A fancier implementation could probably avoid an extra journal
transaction by adding a mapping_test_clear_cmtime call in
ext4_writepages, but this should already be a considerable
improvement -- we'll start one transaction per writepages call
instead of one per page.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dd32a2e..cee6b45 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3236,6 +3236,7 @@ static const struct address_space_operations ext4_aops = {
 	.readpages		= ext4_readpages,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
+	.flush_cmtime		= generic_flush_cmtime,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_write_end,
 	.bmap			= ext4_bmap,
@@ -3252,6 +3253,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.readpages		= ext4_readpages,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
+	.flush_cmtime		= generic_flush_cmtime,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_journalled_write_end,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
@@ -3268,6 +3270,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.readpages		= ext4_readpages,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
+	.flush_cmtime		= generic_flush_cmtime,
 	.write_begin		= ext4_da_write_begin,
 	.write_end		= ext4_da_write_end,
 	.bmap			= ext4_bmap,
@@ -5025,7 +5028,6 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
