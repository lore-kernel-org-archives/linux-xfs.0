Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65B1TvV252490 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 06:01:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 572601E58ECE
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 04:01:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	TknFJlndPSgJk1sB for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 04:01:29 -0700 (PDT)
Date: Tue, 5 Jul 2011 07:01:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] remove filestreams support?
Message-ID: <20110705110127.GA27102@infradead.org>
References: <20110704153443.GA21501@infradead.org>
	<20110705015458.GZ561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110705015458.GZ561@dastard>
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

On Tue, Jul 05, 2011 at 11:54:58AM +1000, Dave Chinner wrote:
> So rather than deprecating the functionality, perhaps we should look
> at implementing it through a simpler, more generic, better
> integrated interface? That will increase the usefulness of the
> functionality for a much wider audience than it has now, and also
> provide the virt/blk throttling folk with exactly the "don't cross
> the streams" functionality they suggest filesystems are unable to
> support easily.....

That does indeed sound simpler, and also more useful.  Do the users
who have chimed in here (and off list) think such a scheme would be
useful for them?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
