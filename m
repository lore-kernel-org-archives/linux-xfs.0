Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBAAnjRu210701 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 04:49:45 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EUs99ScxjYpO1Mh4 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Dec 2012 02:52:13 -0800 (PST)
Date: Mon, 10 Dec 2012 05:52:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: simplify the fallocate path
Message-ID: <20121210105211.GA2794@infradead.org>
References: <20121208120812.755863148@bombadil.infradead.org>
	<20121208121006.286014845@bombadil.infradead.org>
	<20121210020956.GN15784@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121210020956.GN15784@dastard>
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

On Mon, Dec 10, 2012 at 01:09:56PM +1100, Dave Chinner wrote:
> You don't use this flag anywhere ;)

Fixed.

> While I like most of this series, I don't really like the
> duplication of this piece of code. It seems to me that a simple
> helper like:

I had that in a previous version, but it seemed uglier than just
opencoding it.  I'll give it another try, maybe I can come up
with something nicer now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
