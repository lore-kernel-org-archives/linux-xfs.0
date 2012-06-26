Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5Q7prS2074013 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 02:51:53 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GFGn7qCHTyGNNnEn (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Jun 2012 00:51:49 -0700 (PDT)
Date: Tue, 26 Jun 2012 03:51:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [regression] stack overflow in xfs_buf_iodone_callbacks
Message-ID: <20120626075147.GA22780@infradead.org>
References: <20120621091803.GB10673@dastard>
	<20120621163409.GA7897@infradead.org>
	<20120621232414.GD10673@dastard>
	<20120622164147.GA20617@infradead.org>
	<20120622233955.GY19223@dastard>
	<20120625090657.GA22726@infradead.org>
	<20120626022011.GB19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120626022011.GB19223@dastard>
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

On Tue, Jun 26, 2012 at 12:20:11PM +1000, Dave Chinner wrote:
> We will very soon - CRC checks after reading for disk will be done
> after reads. The patch series I'm working on at the moment
> introduces sanity checks of buffers on read completion - it doesn't
> do CRC checks yet, but it moves all the checks we do on read
> completion into iodone callbacks, and when CRCs are introduced they
> will simply be slotted into those functions....

I'm tempted to move calling of b_iodone into the caller that gets
waken by the completion, as that would help to clean a lot of nasty
bits up, but that's still a bit out.

The whole area aound xfs_bdstrat_cb, xfsbdstrat and buffer error handling
is something that needs a fair amount of attention, and I plan to tackle
a lot of it for 3.6.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
