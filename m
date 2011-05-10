Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4A5XKZP048887 for <xfs@oss.sgi.com>; Tue, 10 May 2011 00:33:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 259AF1E244C7
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 22:33:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bvfSVdNISPIpDHct for
	<xfs@oss.sgi.com>; Mon, 09 May 2011 22:33:20 -0700 (PDT)
Date: Tue, 10 May 2011 01:33:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix duplicate workqueue initialisation
Message-ID: <20110510053319.GA3047@infradead.org>
References: <1304993150-15327-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1304993150-15327-1-git-send-email-david@fromorbit.com>
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

On Tue, May 10, 2011 at 12:05:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The workqueue initialisation function is called twice when
> initialising the XFS subsystem. Remove the second initialisation
> call.

Not sure how we got there, but it looks indeed buggy.  I'm kinda
surprised the workqueue code didn't blow up with the duplicate names.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
