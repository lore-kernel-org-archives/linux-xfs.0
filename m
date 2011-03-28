Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SC4mkp165424 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 07:04:48 -0500
Date: Mon, 28 Mar 2011 08:07:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: do not immediately reuse busy extent ranges
Message-ID: <20110328120757.GB18346@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.474878707@bombadil.infradead.org>
	<1301086999.2537.688.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301086999.2537.688.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 25, 2011 at 04:03:19PM -0500, Alex Elder wrote:
> > +			 * Can be trimmed to:
> > +			 *    +-------+        OR         +-------+
> > +			 *    fbno fend                   fbno fend
> > +			 *
> > +			 * We prefer the lower bno extent because the next
> > +			 * allocation for this inode will use "end" as the
> > +			 * target for first block.  If the busy segment has
> 
> ...will use the updated value of fend as the target...

I've replaced all these comments based on the text you replied to the
last round (finally..)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
