Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6SNvn5n099780 for <xfs@oss.sgi.com>; Sat, 28 Jul 2012 18:57:49 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DvJbEAHe8NzM1Yph (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Jul 2012 16:57:48 -0700 (PDT)
Date: Sat, 28 Jul 2012 19:57:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs_io: implement pwritev for vectored writes
Message-ID: <20120728235748.GC10920@infradead.org>
References: <1343255450-28559-1-git-send-email-david@fromorbit.com>
	<1343255450-28559-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343255450-28559-4-git-send-email-david@fromorbit.com>
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

On Thu, Jul 26, 2012 at 08:30:50AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When looking at KVM based direct IO patterns, I noticed that it was
> using preadv and pwritev, and I could not use xfs_io to simulate
> these IO patterns. Extend the pwrite command to be able to issue
> vectored write IO to enable use to simulate KVM style direct IO.
> 
> Also document the new parameters as well as all the missing pwrite
> command parameters in the xfs_io(8) man page.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
