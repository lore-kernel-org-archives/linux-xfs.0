Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C6CBD7F58
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 03:43:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2D9F304066
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 01:43:10 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 29cb6fX0yP1xcdcE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 01:43:09 -0800 (PST)
Date: Tue, 3 Dec 2013 01:43:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] xfs: introduce xlog_copy_iovec
Message-ID: <20131203094309.GC4906@infradead.org>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084000.853201203@bombadil.infradead.org>
	<20131203012120.GQ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203012120.GQ10988@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 03, 2013 at 12:21:20PM +1100, Dave Chinner wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good - I think the helper was worth the effort. ;)

This one is very different from the version I had earlier.  Took me a
long rainy Saturday to arrive at this version..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
