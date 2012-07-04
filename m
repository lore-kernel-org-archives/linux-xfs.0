Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q645sOWa170863 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 00:54:25 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	eQU5KEsgoYSx8Hwu (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 22:54:21 -0700 (PDT)
Date: Wed, 4 Jul 2012 01:54:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Backporting the concurrent direct IO write fix to 3.4
Message-ID: <20120704055419.GA27500@infradead.org>
References: <4FF2F41F.5000504@gmail.com> <20120703160949.GD855@infradead.org>
	<20120703231122.GB19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703231122.GB19223@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Kerin Millar <kerframil@gmail.com>

On Wed, Jul 04, 2012 at 09:11:22AM +1000, Dave Chinner wrote:
> Is it? So we will have long term support kernels for 3.0.x, 3.2.x
> and now 3.4.x? 3.0.x is the long term stable kernel I'm targetting
> for backports and there's no way I can really handle more than
> that...

I remember Greg announced 3.4 to be long term in addition to 3.0
recently.  3.2 only is the Debian release kernel, for which the
maintainers offered to maintain it as a formal stable release
on kernel.org

And yes, it's getting not only confusing but also way to much work
for subsystem maintainers.

I'm still happy to backport fixes to 3.0, but for more invasive work
it's getting a bit too old now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
