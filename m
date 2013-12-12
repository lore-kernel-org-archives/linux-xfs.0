Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 090C87F69
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:18:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A846AC004
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:18:57 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tlipIv5NC9IOXsnV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:18:56 -0800 (PST)
Message-Id: <20131212181459.994196463@bombadil.infradead.org>
Date: Thu, 12 Dec 2013 10:14:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] splice: locking changes and code refactoring
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

I've been trying to fix the old splice iolock lock inversion issue in XFS
and started looking over the splice code a little more for it.  It seems
like the root of all evil is that we try to nest i_mutex inside the
pipe_lock instead of outside of it, and I can't find any good reason for
that.  Does anyone remember why it went this way initially?

By fixing that and a few minor issues we can not only fix this issue nicely
in XFS, but also get rid of various bits of code duplication, and poking into
splice internals by the ocfs2 splice_write path.

Btw, does anyone have a good test suite for splice functionality?  xfstests
coverage exits but is not very extensive.

 b/fs/ocfs2/file.c        |    2 
 b/fs/splice.c            |    5 +-
 b/fs/xfs/xfs_file.c      |   26 +++++-----
 b/include/linux/splice.h |    2 
 fs/ocfs2/file.c          |   78 +++++++++----------------------
 fs/splice.c              |  115 +++++++++++++----------------------------------
 include/linux/splice.h   |    7 --
 7 files changed, 76 insertions(+), 159 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
