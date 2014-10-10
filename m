Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7368F7F5F
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53056304053
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jyFcjPoBGp2LMHjR (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:07 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Fix block zeroing when punching holes in indirect
	block files
Date: Fri, 10 Oct 2014 16:23:15 +0200
Message-Id: <1412951028-4085-11-git-send-email-jack@suse.cz>
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

free_holes_block() passed local variable as a block pointer
to ext4_clear_blocks(). Thus ext4_clear_blocks() zeroed out this local
variable instead of proper place in inode / indirect block. We later
zero out proper place in inode / indirect block but don't dirty the
inode / buffer again which can lead to subtle issues (some changes e.g.
to inode can be lost).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/indirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 8a57e9fcd1b9..9d381707a6fc 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1329,8 +1329,8 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
 		if (level == 0 ||
 		    (bh && all_zeroes((__le32 *)bh->b_data,
 				      (__le32 *)bh->b_data + addr_per_block))) {
-			ext4_free_data(handle, inode, parent_bh, &blk, &blk+1);
-			*i_data = 0;
+			ext4_free_data(handle, inode, parent_bh,
+				       i_data, i_data + 1);
 		}
 		brelse(bh);
 		bh = NULL;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
