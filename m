Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29E0F7CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 17:43:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF2668F8035
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 15:43:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hCuX6MFqYLjKlsyh for <xfs@oss.sgi.com>;
	Thu, 18 Aug 2016 15:43:44 -0700 (PDT)
Date: Fri, 19 Aug 2016 08:43:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFC: dropping IRIX support in xfsprogs
Message-ID: <20160818224332.GJ19025@dastard>
References: <20160818174742.GA14464@infradead.org>
	<20160818205914.GI19025@dastard>
	<20160818215642.GA17607@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160818215642.GA17607@infradead.org>
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

On Thu, Aug 18, 2016 at 02:56:42PM -0700, Christoph Hellwig wrote:
> On Fri, Aug 19, 2016 at 06:59:14AM +1000, Dave Chinner wrote:
> > We dropped support for older irix only filesystems some time ago,
> > so this seems like a natural progression from that. I have no
> > objections to removing it...
> 
> Ok, I'll start sending patches once you're ok (or not ok)
> with the patches from Felix to turn on LFS support to avoid
> conflicting with those.

I don't have any objections to them - I've jus tbeen busy with other
stuff and haven't merged them yet. You may as well just build on top
of them for the moment. I also don't want to force Darrick to have
to constantly rebase his userspace patchset, so I'm trying to get
all the rmap support merged before taking anything else into
xfsprogs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
