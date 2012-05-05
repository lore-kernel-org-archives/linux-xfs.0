Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q45NeW6i018311 for <xfs@oss.sgi.com>; Sat, 5 May 2012 18:40:32 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GMFi4hRLTWn90e0E for <xfs@oss.sgi.com>;
	Sat, 05 May 2012 16:40:30 -0700 (PDT)
Date: Sun, 6 May 2012 09:40:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Cleancache support in XFS
Message-ID: <20120505234028.GF25351@dastard>
References: <20120430173112.GA16257@beaver>
	<20120430191218.GA23530@infradead.org>
	<20120502080220.GA20504@beaver>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120502080220.GA20504@beaver>
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
To: Alexey Vlasov <renton@renton.name>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, May 02, 2012 at 12:02:20PM +0400, Alexey Vlasov wrote:
> On Mon, Apr 30, 2012 at 03:12:18PM -0400, Christoph Hellwig wrote:
> > > 
> > > Could you please tell me if you are planning to support cleancache in
> > > XFS?
> > 
> > As soon as someone submits a patch.  In theory it should just work, but
> > the cleancache maintainer require a completely idiotic one liner to
> > actually enable it.  Feel free to submit it once you actually tested it.
> 
> Cleancache_init_fs () I can actually put where it it should be  but I
> think it won't be enough. I think there some hooks needed (as for brtfs)
> but I can't fix it as I'm far from programming.

XFS uses mpage_readpages() so doesn't need other hooks. btrfs has
it's own readpage path, so needs them for that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
