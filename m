Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E71A7F3F
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F48A8F8050
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:07 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2GBfcoJUB5y5PNkh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:05 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix buffer double free in ext4_alloc_branch()
Date: Fri, 10 Oct 2014 16:23:16 +0200
Message-Id: <1412951028-4085-12-git-send-email-jack@suse.cz>
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

Error recovery in ext4_alloc_branch() calls ext4_forget() even for
buffer corresponding to indirect block it did not allocate. This leads
to brelse() being called twice for that buffer (once from ext4_forget()
and once from cleanup in ext4_ind_map_blocks()) leading to buffer use
count misaccounting. Eventually (but often much later because there
are other users of the buffer) we will see messages like:
VFS: brelse: Trying to free free buffer

Another manifestation of this problem is an error:
JBD2 unexpected failure: jbd2_journal_revoke: !buffer_revoked(bh);
inconsistent data on disk

The fix is easy - don't forget buffer we did not allocate. Also add an
explanatory comment because the indexing at ext4_alloc_branch() is
somewhat subtle.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 594009f5f523..3b91d240da4d 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -389,7 +389,13 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	return 0;
 failed:
 	for (; i >= 0; i--) {
-		if (i != indirect_blks && branch[i].bh)
+		/*
+		 * We want to ext4_forget() only freshly allocated indirect
+		 * blocks.  Buffer for new_blocks[i-1] is at branch[i].bh and
+		 * buffer at branch[0].bh is indirect block / inode already
+		 * existing before ext4_alloc_branch() was called.
+		 */
+		if (i > 0 && i != indirect_blks && branch[i].bh)
 			ext4_forget(handle, 1, inode, branch[i].bh,
 				    branch[i].bh->b_blocknr);
 		ext4_free_blocks(handle, inode, NULL, new_blocks[i],
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
