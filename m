Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6JHAwJ4182696 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 12:10:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AADD16825C5
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 10:10:57 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	R9B9BPA1PU0STmdb for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2011 10:10:57 -0700 (PDT)
Date: Tue, 19 Jul 2011 13:10:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix modulo-by-zero error in fsx
Message-ID: <20110719171054.GB31088@infradead.org>
References: <1311047353-23925-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311047353-23925-1-git-send-email-david@fromorbit.com>
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

On Tue, Jul 19, 2011 at 01:49:13PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent fsx fixes has a logic error in the offset trimming code.
> If a read is done when the file size is zero, then the logic error
> causes a offset % 0 opertaion to occur. This causes fsx to get a
> SIGFPE and die.
> 
> This was not discovered during my testing because I was using a
> random seed that didn't trip this condition. Changing the seed to
> that which test 091 uses (the default of 1) causes such an operation
> to occur....

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
