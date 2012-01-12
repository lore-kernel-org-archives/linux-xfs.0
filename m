Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C1L70L205324 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 19:21:07 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id eMFWHRJUIuVKPAqH for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 17:21:05 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Protect ext4_page_mkwrite with sb_start_write -
	sb_end_write
Date: Thu, 12 Jan 2012 02:20:52 +0100
Message-Id: <1326331253-6497-4-git-send-email-jack@suse.cz>
In-Reply-To: <1326331253-6497-1-git-send-email-jack@suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org

Since ext4_page_mkwrite() calls into __block_page_mkwrite() it has to
provide freezing protection on it's own.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..fbe998b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4733,11 +4733,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	get_block_t *get_block;
 	int retries = 0;
 
-	/*
-	 * This check is racy but catches the common case. We rely on
-	 * __block_page_mkwrite() to do a reliable check.
-	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -4805,5 +4801,6 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	sb_end_write(inode->i_sb);
 	return ret;
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
