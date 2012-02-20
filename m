Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1KMJGiG113746 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 16:19:16 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yZi8MZHHRQuo14vN (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 14:19:15 -0800 (PST)
Date: Mon, 20 Feb 2012 17:19:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfs: remove the per-filesystem list of dquots
Message-ID: <20120220221915.GA10060@infradead.org>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.615605871@bombadil.infradead.org>
	<20120220221509.GE3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220221509.GE3592@dastard>
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

On Tue, Feb 21, 2012 at 09:15:09AM +1100, Dave Chinner wrote:
> On Sun, Feb 19, 2012 at 09:28:22PM -0500, Christoph Hellwig wrote:
> > Instead of keeping a separate per-filesystem list of dquots we can walk
> > the radix tree for the two places where we need to iterate all quota
> > structures.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Still a bit of a lookup vs iterate hold-off remaining, but I think
> we can live with the reduction now. If it proves to be a noticable
> problem then we can look towards RCU based lookups, I think.
> Otherwise it looks OK to me.

We only walk the list during:

  - mount time for quotacheck
  - umount time
  - full quotaoff

in the first two cases lookups can't happen at all, and in the latter
they at least shoudn't get this far.  So I really don't think it's
a problem.  And the full quotaoff even for quota accounting is something
I'd like to remove sooner or later, it just causes a lot of corner cases
for very little gain.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
