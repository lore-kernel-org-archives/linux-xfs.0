Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 827E07F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 08:14:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CFBB304048
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 06:14:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id IJAnL7GZ02fNnMj1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 06:14:28 -0800 (PST)
Date: Mon, 13 Jan 2014 06:14:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140113141416.GA30117@infradead.org>
References: <20131212181459.994196463@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212181459.994196463@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

ping?  Would be nice to get this into 3.14

On Thu, Dec 12, 2013 at 10:14:59AM -0800, Christoph Hellwig wrote:
> I've been trying to fix the old splice iolock lock inversion issue in XFS
> and started looking over the splice code a little more for it.  It seems
> like the root of all evil is that we try to nest i_mutex inside the
> pipe_lock instead of outside of it, and I can't find any good reason for
> that.  Does anyone remember why it went this way initially?
> 
> By fixing that and a few minor issues we can not only fix this issue nicely
> in XFS, but also get rid of various bits of code duplication, and poking into
> splice internals by the ocfs2 splice_write path.
> 
> Btw, does anyone have a good test suite for splice functionality?  xfstests
> coverage exits but is not very extensive.
> 
>  b/fs/ocfs2/file.c        |    2 
>  b/fs/splice.c            |    5 +-
>  b/fs/xfs/xfs_file.c      |   26 +++++-----
>  b/include/linux/splice.h |    2 
>  fs/ocfs2/file.c          |   78 +++++++++----------------------
>  fs/splice.c              |  115 +++++++++++++----------------------------------
>  include/linux/splice.h   |    7 --
>  7 files changed, 76 insertions(+), 159 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
