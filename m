Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 196D37F59
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EDBE28F8050
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:08 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id tcMzFjHFQvRIIEe5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:07 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix jbd2 warning under heavy xattr load
Date: Fri, 10 Oct 2014 16:23:17 +0200
Message-Id: <1412951028-4085-13-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

When heavily exercising xattr code the assertion that
jbd2_journal_dirty_metadata() shouldn't return error was triggered:

WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1237
jbd2_journal_dirty_metadata+0x1ba/0x260()

CPU: 0 PID: 8877 Comm: ceph-osd Tainted: G    W 3.10.0-ceph-00049-g68d04c9 #1
Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
 ffffffff81a1d3c8 ffff880214469928 ffffffff816311b0 ffff880214469968
 ffffffff8103fae0 ffff880214469958 ffff880170a9dc30 ffff8802240fbe80
 0000000000000000 ffff88020b366000 ffff8802256e7510 ffff880214469978
Call Trace:
 [<ffffffff816311b0>] dump_stack+0x19/0x1b
 [<ffffffff8103fae0>] warn_slowpath_common+0x70/0xa0
 [<ffffffff8103fb2a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81267c2a>] jbd2_journal_dirty_metadata+0x1ba/0x260
 [<ffffffff81245093>] __ext4_handle_dirty_metadata+0xa3/0x140
 [<ffffffff812561f3>] ext4_xattr_release_block+0x103/0x1f0
 [<ffffffff81256680>] ext4_xattr_block_set+0x1e0/0x910
 [<ffffffff8125795b>] ext4_xattr_set_handle+0x38b/0x4a0
 [<ffffffff810a319d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81257b32>] ext4_xattr_set+0xc2/0x140
 [<ffffffff81258547>] ext4_xattr_user_set+0x47/0x50
 [<ffffffff811935ce>] generic_setxattr+0x6e/0x90
 [<ffffffff81193ecb>] __vfs_setxattr_noperm+0x7b/0x1c0
 [<ffffffff811940d4>] vfs_setxattr+0xc4/0xd0
 [<ffffffff8119421e>] setxattr+0x13e/0x1e0
 [<ffffffff811719c7>] ? __sb_start_write+0xe7/0x1b0
 [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
 [<ffffffff8118c65c>] ? fget_light+0x3c/0x130
 [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
 [<ffffffff8118f1f8>] ? __mnt_want_write+0x58/0x70
 [<ffffffff811946be>] SyS_fsetxattr+0xbe/0x100
 [<ffffffff816407c2>] system_call_fastpath+0x16/0x1b

The reason for the warning is that buffer_head passed into
jbd2_journal_dirty_metadata() didn't have journal_head attached. This is
caused by the following race of two ext4_xattr_release_block() calls:

CPU1                                CPU2
ext4_xattr_release_block()          ext4_xattr_release_block()
lock_buffer(bh);
/* False */
if (BHDR(bh)->h_refcount == cpu_to_le32(1))
} else {
  le32_add_cpu(&BHDR(bh)->h_refcount, -1);
  unlock_buffer(bh);
                                    lock_buffer(bh);
                                    /* True */
                                    if (BHDR(bh)->h_refcount == cpu_to_le32(1))
                                      get_bh(bh);
                                      ext4_free_blocks()
                                        ...
                                        jbd2_journal_forget()
                                          jbd2_journal_unfile_buffer()
                                          -> JH is gone
  error = ext4_handle_dirty_xattr_block(handle, inode, bh);
  -> triggers the warning

We fix the problem by moving ext4_handle_dirty_xattr_block() under the
buffer lock. Sadly this cannot be done in nojournal mode as that
function can call sync_dirty_buffer() which would deadlock. Luckily in
nojournal mode the race is harmless (we only dirty already freed buffer)
and thus for nojournal mode we leave the dirtying outside of the buffer
lock.

Reported-by: Sage Weil <sage@inktank.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e175e94116ac..55e611c1513c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -517,8 +517,8 @@ static void ext4_xattr_update_super_block(handle_t *handle,
 }
 
 /*
- * Release the xattr block BH: If the reference count is > 1, decrement
- * it; otherwise free the block.
+ * Release the xattr block BH: If the reference count is > 1, decrement it;
+ * otherwise free the block.
  */
 static void
 ext4_xattr_release_block(handle_t *handle, struct inode *inode,
@@ -538,16 +538,31 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		if (ce)
 			mb_cache_entry_free(ce);
 		get_bh(bh);
+		unlock_buffer(bh);
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
-		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		if (ce)
 			mb_cache_entry_release(ce);
+		/*
+		 * Beware of this ugliness: Releasing of xattr block references
+		 * from different inodes can race and so we have to protect
+		 * from a race where someone else frees the block (and releases
+		 * its journal_head) before we are done dirtying the buffer. In
+		 * nojournal mode this race is harmless and we actually cannot
+		 * call ext4_handle_dirty_xattr_block() with locked buffer as
+		 * that function can call sync_dirty_buffer() so for that case
+		 * we handle the dirtying after unlocking the buffer.
+		 */
+		if (ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		unlock_buffer(bh);
-		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
+		if (!ext4_handle_valid(handle))
+			error = ext4_handle_dirty_xattr_block(handle, inode,
+							      bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
