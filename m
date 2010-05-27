Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RCJGAU132330 for <xfs@oss.sgi.com>; Thu, 27 May 2010 07:19:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1219D37B448
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 05:21:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eJEJHiF9tTKU4m6W for
	<xfs@oss.sgi.com>; Thu, 27 May 2010 05:21:40 -0700 (PDT)
Date: Thu, 27 May 2010 08:21:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Re-initialise lockdep context for all inodes in
	reclaim
Message-ID: <20100527122138.GA14632@infradead.org>
References: <1274925546-31468-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274925546-31468-1-git-send-email-david@fromorbit.com>
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

On Thu, May 27, 2010 at 11:59:06AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We re-initialise the lockdep context for inode iolocks when dropping an inode,
> but not when we delete an inode. Now that we can reclaim inodes from a shrinker,
> we can get get false lockdep warnings about inode iolock inversions during
> reclaim of deleted inodes. Hence we need to re-initialise the iolock in the
> delete path as well.

clear_inode also gets called when we delete an inode, so at least
the rationale for this isn't quite right.  It seems like we re-acquire
new lockdep dependecies between clear_inode and destroy_inode that your
shrinker doesn't like.  What lockdep report do you see?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
