Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o592po1R037938 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 21:51:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77ACB13357D8
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 03:37:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id toM1WCI60NNsNCLR for
	<xfs@oss.sgi.com>; Fri, 30 Jul 2010 03:37:19 -0700 (PDT)
Date: Fri, 30 Jul 2010 06:29:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100730102943.GA24106@infradead.org>
References: <20100726034545.GE655@dastard>
	<20100730091554.2c9ca1ec@galadriel.home>
	<20100730075746.GA20444@infradead.org> <201007301223.12134@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007301223.12134@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 12:23:08PM +0200, Michael Monnerie wrote:
> On Freitag, 30. Juli 2010 Christoph Hellwig wrote:
> > Recent enough kernel work fine with filesystems that inode64 was used
> > on even if it's not specified anymore.
>  
> Really? Since when exactly? That would be a nice feature. If we can 
> define it clearly, I could put that on the FAQ.

Linux 2.6.35 will be the first kernel with the bugfixes for this to
work.

> But how does it truncate the numbers >int32 and avoid collisions?

It doesn't.  Existing inodes won't nessecarily fit into 32-bits, but
no new inodes above it will be allocated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
