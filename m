Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6HFkS5G088576 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 10:46:28 -0500
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id WWg9ghJ8GfmTuWei for
	<xfs@oss.sgi.com>; Tue, 17 Jul 2012 08:46:27 -0700 (PDT)
Date: Tue, 17 Jul 2012 08:46:26 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
Subject: Re: [PATCH 0/5] do not take the iolock in inode reclaim context
In-Reply-To: <20120717071923.GD15473@infradead.org>
Message-ID: <alpine.DEB.2.00.1207170845060.30672@cobra.newdream.net>
References: <20120704151328.928543446@bombadil.infradead.org>
	<20120717071923.GD15473@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: sage@newdream.net, xfs@oss.sgi.com

On Tue, 17 Jul 2012, Christoph Hellwig wrote:
> ping/  I'd really like to get this queued up for 3.6

I forget if I mentioned this before, but I pulled this series into our 
testing branch and have had no problems (aside from the last patch not 
applying to my tree) in qa (ceph on xfs) over the last couple of weeks.

sage


> 
> On Wed, Jul 04, 2012 at 11:13:28AM -0400, Christoph Hellwig wrote:
> > This series should fix the (false-positive) lockdep warnings Sage
> > has seen while testing ceph workloads with heavy attr usage.
> > 
> > Btw, you probably should create the XFS filesystems for Ceph usage
> > with large inodes to avoid going out of line for the attributes.
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
