Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9DroE080635 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:14:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73F3519C308
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:13:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bHg7VpbEl1j7SN4Q for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:13:32 -0700 (PDT)
Date: Mon, 16 Mar 2009 05:13:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] [XFS] Block callers of xfs_flush_inodes() correctly.
Message-ID: <20090316091331.GC2636@infradead.org>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237116707-25793-4-git-send-email-david@fromorbit.com>
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
Cc: mpatocka@redhat.com, xfs@oss.sgi.com

On Sun, Mar 15, 2009 at 10:31:45PM +1100, Dave Chinner wrote:
> xfs_flush_inodes() currently uses a magic timeout to wait for
> some inodes to be flushed before returning. This isn't
> really reliable but used to be the best that could be done
> due to deadlock potential of waiting for the entire flush.
> 
> Now the inode flush is safe to execute while we hold page
> and inode locks, we can wait for all the inodes to flush
> synchronously. Convert the wait mechanism to a completion
> to do this efficiently. This should remove all remaining
> spurious ENOSPC errors from the delayed allocation reservation
> path.

Why do we queue it up to a different thread if we synchronously wait
for it anyway?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
