Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEEQlwQ212751 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 08:26:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67E241EACD85
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 05:27:12 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CCV6N5fT22GvZDrt for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 05:27:12 -0800 (PST)
Date: Wed, 14 Dec 2011 08:27:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/11] xfs: always return with the iolock held from
	xfs_file_aio_write_checks
Message-ID: <20111214132710.GA30603@infradead.org>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155919.215723395@bombadil.infradead.org>
	<20111213232017.GH3179@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111213232017.GH3179@dastard>
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

On Wed, Dec 14, 2011 at 10:20:17AM +1100, Dave Chinner wrote:
> On Thu, Dec 08, 2011 at 10:58:05AM -0500, Christoph Hellwig wrote:
> > While xfs_iunlock is fine with 0 lockflags the calling conventions are much
> > cleaner if xfs_file_aio_write_checks never returns without the iolock held.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I'm not sure this makes sense by itself. maybe combine it with the
> next patch? Regardless:

I actually had it that way initially but split the patches because the
changes aren't directly related.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
