Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3B967F62
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:18:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC9718F8065
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:18:54 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 80wYPN7QtTBqM5vu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:18:53 -0800 (PST)
Message-Id: <20131212181844.501136902@bombadil.infradead.org>
Date: Thu, 12 Dec 2013 10:15:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] splice: move balance_dirty_pages_ratelimited into
	pipe_to_file
References: <20131212181459.994196463@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-splice-move-balance_dirty_pages_ratelimited-into-pip.patch
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
To: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Try to balance the dirty pages for every written pages instead of once
per system call, mirroring the regular write path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/file.c |    2 --
 fs/splice.c     |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6fff128..a77ef6e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2494,8 +2494,6 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 			ret = err;
 		else
 			*ppos += ret;
-
-		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	return ret;
diff --git a/fs/splice.c b/fs/splice.c
index 46a08f7..fcb459d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -759,6 +759,10 @@ int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	}
 	ret = pagecache_write_end(file, mapping, sd->pos, this_len, this_len,
 				page, fsdata);
+	if (ret)
+		goto out;
+
+	balance_dirty_pages_ratelimited(mapping);
 out:
 	return ret;
 }
@@ -1034,7 +1038,6 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 			ret = err;
 		else
 			*ppos += ret;
-		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	return ret;
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
