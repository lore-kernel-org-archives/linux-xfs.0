Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8B5A7F53
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 18:10:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A3F08F804C
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 16:10:13 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dXeCJn5O8YPiDa2Z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 16:10:11 -0800 (PST)
Date: Wed, 6 Jan 2016 16:09:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 34/76] xfs: implement XFS_IOC_SWAPEXT when rmap btree is
	enabled
Message-ID: <20160107000939.GA8015@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090008.12713.25755.stgit@birch.djwong.org>
	<20160103121728.GC28429@infradead.org>
	<20160104234033.GD28330@birch.djwong.org>
	<20160105024130.GI19802@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160105024130.GI19802@dastard>
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

On Tue, Jan 05, 2016 at 01:41:30PM +1100, Dave Chinner wrote:
> On Mon, Jan 04, 2016 at 03:40:33PM -0800, Darrick J. Wong wrote:
> > On Sun, Jan 03, 2016 at 04:17:28AM -0800, Christoph Hellwig wrote:
> > > On Sat, Dec 19, 2015 at 01:00:08AM -0800, Darrick J. Wong wrote:
> > > > Implement extent swapping when reverse-mapping is enabled.
> > > 
> > > Can you just fold this into the previous patch?  There seem to be a lot
> > > of patches in the series that would benefit from merging, but this
> > > is the one that really screams for it :)
> > 
> > The only reason I'm keeping Dave's original rmap patches separate is because
> > the last time I checked with Dave, he said that he'd made a few bugfixes to his
> > patchset that hadn't yet been sent out, so I'd like to merge those fixes into
> > the original patches before starting any combining work.
> 
> I haven't had a chance to sort any of those out fully, so it's
> probably best if you combine all your patches to minimise the
> separation and I'll send delta patches (if still relevant) as I work
> through it all in the next couple of weeks...

Ok, I'll start combining them as I remove all the kerneldoc comments.  I think
I've gotten all the "CoW reservations left over at unmount" bugs out, so I'll
probably have a slimmer patchset in a week or two.

(Or everything will go nuts on some weird arch like arm64 and kablooie...)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
