Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55A397CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 15:59:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 160B2304039
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 13:59:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QJG6FH9LeIXSld8t for <xfs@oss.sgi.com>;
	Thu, 18 Aug 2016 13:59:17 -0700 (PDT)
Date: Fri, 19 Aug 2016 06:59:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFC: dropping IRIX support in xfsprogs
Message-ID: <20160818205914.GI19025@dastard>
References: <20160818174742.GA14464@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160818174742.GA14464@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 18, 2016 at 10:47:42AM -0700, Christoph Hellwig wrote:
> Hi all,
> 
> I'd like to know if anyone would complain about removing IRIX support
> in xfsprogs?  It very much looks unmaintained for years, and due to
> the IRIX differences in type defintions and kernel interfaces it's
> actually a bit of a drag on xfsprogs, so unlike the other ports
> to FreeBSD and Darwin it would actually be really helpful to remove
> it.
> 
> I'd volunteer to prepare patches to remove the IRIX support and do
> the resulting cleanups.

We dropped support for older irix only filesystems some time ago,
so this seems like a natural progression from that. I have no
objections to removing it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
