Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68CSu89242758 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 07:28:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F00E52720D
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2011 05:28:54 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PVv4bPRtuS6HTUzs for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2011 05:28:54 -0700 (PDT)
Date: Fri, 8 Jul 2011 08:28:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/28] patch queue for Linux 3.1, V3
Message-ID: <20110708122852.GB3289@infradead.org>
References: <20110707110535.205001532@bombadil.infradead.org>
	<20110708101848.GJ1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110708101848.GJ1026@dastard>
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

On Fri, Jul 08, 2011 at 08:18:48PM +1000, Dave Chinner wrote:
> On Thu, Jul 07, 2011 at 07:05:35AM -0400, Christoph Hellwig wrote:
> > This version addresses the review comments.  The biggest change is that
> > the byteswaps of constants are now moved into a different patch and
> > applied more broadly.
> 
> Not sure you've noticed these new warnings from the patchset
> (gcc 4.4.4-6 debian):
> 
> fs/xfs/xfs_inode.c: In function ???xfs_itruncate_data???:
> fs/xfs/xfs_inode.c:1352: warning: unused variable ???mp???
> fs/xfs/xfs_inode_item.c: In function ???xfs_inode_item_unlock???:
> fs/xfs/xfs_inode_item.c:632: warning: unused variable ???ip???
> 
> They were in the previous version, too, so they are not new to this
> iteration.

Oh, it's both variables used only in DEBUG builds.  I'll update the
series to fix it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
