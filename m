Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EErwYQ131155 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:53:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6353D708A7
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:54:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vvHnDjuFA7yUmmdM for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:54:47 -0700 (PDT)
Date: Tue, 14 Sep 2010 10:54:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/18] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20100914145447.GE3400@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-8-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 14, 2010 at 08:56:06PM +1000, Dave Chinner wrote:
> Hence we can stop marking VFS inodes dirty during transaction commit or when
> changing timestamps during transactions. This will keep the inodes in the
> superblock dirty list to those containing data or unlogged metadata changes.

But we also use xfs_ichgtime for non-transacion size updates, e.g.
for truncate of zero length files.  With this patch we lose track of
the timestamp updates for this case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
