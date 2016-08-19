Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 613997CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 21:07:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E461FAC004
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 19:07:41 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id E3pnp8V4E3PgScfV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 19:07:40 -0700 (PDT)
Date: Thu, 18 Aug 2016 19:07:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: dropping IRIX support in xfsprogs
Message-ID: <20160819020739.GA595@infradead.org>
References: <20160818174742.GA14464@infradead.org>
	<20160818205914.GI19025@dastard>
	<20160818215642.GA17607@infradead.org>
	<20160818224332.GJ19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160818224332.GJ19025@dastard>
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

On Fri, Aug 19, 2016 at 08:43:32AM +1000, Dave Chinner wrote:
> I don't have any objections to them - I've jus tbeen busy with other
> stuff and haven't merged them yet. You may as well just build on top
> of them for the moment. I also don't want to force Darrick to have
> to constantly rebase his userspace patchset, so I'm trying to get
> all the rmap support merged before taking anything else into
> xfsprogs...

At least the patches from Felix shouldn't conflict at all with the
rmap work.  I'll just wait until both the rmap work and the largefile
bits are merged and will prepare the IRIX removal after that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
