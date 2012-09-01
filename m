Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q81NTj9A197815 for <xfs@oss.sgi.com>; Sat, 1 Sep 2012 18:29:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MdEefJ2nZK1jh1PJ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Sep 2012 16:30:40 -0700 (PDT)
Date: Sat, 1 Sep 2012 19:30:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/13] xfs: move inode locking functions to xfs_inode.c
Message-ID: <20120901233040.GH31634@infradead.org>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346328017-2795-13-git-send-email-david@fromorbit.com>
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

On Thu, Aug 30, 2012 at 10:00:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ilock() and friends really aren't related to the inode cache in
> any way, so move them to xfs_inode.c with all the other inode
> related functionality.
> 
> While doing this move, move the xfs_ilock() tracepoints to *before*
> the lock is taken so that when a hang on a lock occurs we have
> events to indicate which process and what inode we were trying to
> lock when the hang occurred. This is much better than the current
> silence we get on a hang...

Looks good.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
