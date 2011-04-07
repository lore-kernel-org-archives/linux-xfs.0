Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p37HG6wN120166 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 12:16:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF87E3BAC5E
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2011 10:19:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cRe9gztWl2WEftAX for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2011 10:19:23 -0700 (PDT)
Date: Thu, 7 Apr 2011 13:19:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] xfs: fix extent format buffer allocation size
Message-ID: <20110407171921.GC6827@infradead.org>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-2-git-send-email-david@fromorbit.com>
	<20110406133816.GA16276@infradead.org>
	<20110407000505.GM31057@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110407000505.GM31057@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Apr 07, 2011 at 10:05:05AM +1000, Dave Chinner wrote:
> The function is needed regardless of XFS_NATIVE_HOST due to the fact
> it is needed to pick the real extents out of the n-core data fork
> when delayed allocation extents are present. This is endian
> independent.

You're right.  I was only looking at the attr fork side where we
don't handle the delalloc extents.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
