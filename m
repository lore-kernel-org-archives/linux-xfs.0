Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81KCrik204599 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 15:13:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC75615A20E3
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 13:13:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id POHuqa8KStNqGEv3 for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 13:13:29 -0700 (PDT)
Date: Tue, 1 Sep 2009 16:13:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: actually enable the swapext compat handler
Message-ID: <20090901201329.GA14400@infradead.org>
References: <20090901180308.GA26071@infradead.org>
	<4A9D79F7.9080702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A9D79F7.9080702@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 01, 2009 at 02:45:59PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > Fix a small typo in the compat ioctl handler that cause the swapext
> > compat handler to never be called.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> > Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> Guilty-party: Eric Sandeen <sandeen@sandeen.net>
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Haha, thanks.  Felix, can you push this one to Linus for 2.6.31?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
