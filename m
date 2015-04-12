Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DC3A7F60
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 10:09:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F877304039
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 08:09:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id O641827fvvf0CHbj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Apr 2015 08:09:33 -0700 (PDT)
Date: Sun, 12 Apr 2015 08:09:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] xfs: fix direct IO completion issues
Message-ID: <20150412150932.GA10115@infradead.org>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428673080-23052-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 10, 2015 at 11:37:55PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This patchset addresses the deeper problems Brian outlined in the
> description of this patch:
> 
> http://oss.sgi.com/archives/xfs/2015-04/msg00071.html
> 
> The basic issues is that DIO completion can run in interrupt context
> and it does things it should not do in interrupt context because Bad
> Things Will Happen.

Where do we complete DIO writes from irq context?  Since my direct-io.c
changes from a few years ago that should not be the case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
