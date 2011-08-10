Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AAHZFs175696 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:17:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9484D18A0C91
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 03:17:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	blCIZByxfYmJYfqX for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 03:17:34 -0700 (PDT)
Date: Wed, 10 Aug 2011 06:17:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix splice/direct-IO deadlock
Message-ID: <20110810101733.GC27114@infradead.org>
References: <1312785927-10662-1-git-send-email-david@fromorbit.com>
	<1312785927-10662-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312785927-10662-3-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 08, 2011 at 04:45:27PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> lockdep reports splice vs direct-io write lock inversions due to
> generic_file_splice_write() taking the inode->i_mutex inside
> XFS_IOLOCK_EXCL context. These lock contexts are inverted, hence can
> deadlock.  Use splice_write_to_file() with an actor that does not
> take the i_mutex to avoid these problems.

I don't think the locking model is quite correct yet.  We'll still
hold the iolock and i_mutex over
splice_from_pipe_begin/splice_from_pipe_next/splice_from_pipe_end,
which call into the pipe code, and take other i_mutex instances that
may deadlock against ours.

It also means we hold the iolock over generic_write_sync which calls
into ->fsync which takes the iolock with my latests changes.

I think we'll have to take the locking and i_size updates into the
actor, and behave like the other filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
