Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U79L4c188242 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 02:09:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B72AE124053B
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 00:09:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	l0at5e0rq2Rg1Dke for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 00:09:20 -0700 (PDT)
Date: Thu, 30 Jun 2011 03:09:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/27] xfs: kill struct xfs_dir2_sf
Message-ID: <20110630070918.GA21449@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140339.466443510@bombadil.infradead.org>
	<20110630070449.GJ561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630070449.GJ561@dastard>
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

On Thu, Jun 30, 2011 at 05:04:49PM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2011 at 10:01:24AM -0400, Christoph Hellwig wrote:
> > The list field of it is never cactually used, so all uses can simply be
> > replaced with the xfs_dir2_sf_hdr_t type that it has as first member.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I can't help but think this would have been a much smaller patch if
> you rolled the contents of the xfs_dir2_sf_hdr_t into xfs_dir2_sf_t
> and killed the xfs_dir2_sf_hdr_t instead. There's many more
> occurrences of xfs_dir2_sf_t than there are xfs_dir2_sf_hdr_t.

It would have been simpler, but using the xfs_dir2_sf_hdr_t makes
more sense to me.  If there's broad disagreement with this (and
the similar changes for the other structures) I'll revisit the naming
scheme.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
