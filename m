Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5FCd7Ds090424 for <xfs@oss.sgi.com>; Fri, 15 Jun 2012 07:39:07 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oLHqNesA0VOHoWuJ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Jun 2012 05:39:06 -0700 (PDT)
Date: Fri, 15 Jun 2012 08:39:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
Message-ID: <20120615123905.GB8151@infradead.org>
References: <1339474826-10414-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339474826-10414-1-git-send-email-david@fromorbit.com>
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

On Tue, Jun 12, 2012 at 02:20:26PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we fail to find an matching extent near the requested extent
> specification during a left-right distance search in
> xfs_alloc_ag_vextent_near, we fail to free the original cursor that
> we used to look up the XFS_BTNUM_CNT tree and hence leak it.
> 
> Reported-by: Chris J Arges <chris.j.arges@canonical.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks correct for now, but mid-term this function absolutely needs
a restructuring with good exit labels and a posisble a split up into
multiple helpers.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
