Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC9F97F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 20:41:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76B2BAC006
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 18:41:34 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3KRWu95HnivmK0v4 for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 18:41:32 -0800 (PST)
Date: Tue, 5 Jan 2016 13:41:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 34/76] xfs: implement XFS_IOC_SWAPEXT when rmap btree is
	enabled
Message-ID: <20160105024130.GI19802@dastard>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090008.12713.25755.stgit@birch.djwong.org>
	<20160103121728.GC28429@infradead.org>
	<20160104234033.GD28330@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160104234033.GD28330@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 03:40:33PM -0800, Darrick J. Wong wrote:
> On Sun, Jan 03, 2016 at 04:17:28AM -0800, Christoph Hellwig wrote:
> > On Sat, Dec 19, 2015 at 01:00:08AM -0800, Darrick J. Wong wrote:
> > > Implement extent swapping when reverse-mapping is enabled.
> > 
> > Can you just fold this into the previous patch?  There seem to be a lot
> > of patches in the series that would benefit from merging, but this
> > is the one that really screams for it :)
> 
> The only reason I'm keeping Dave's original rmap patches separate is because
> the last time I checked with Dave, he said that he'd made a few bugfixes to his
> patchset that hadn't yet been sent out, so I'd like to merge those fixes into
> the original patches before starting any combining work.

I haven't had a chance to sort any of those out fully, so it's
probably best if you combine all your patches to minimise the
separation and I'll send delta patches (if still relevant) as I work
through it all in the next couple of weeks...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
