Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C66357CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 22:40:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96B988F804C
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:40:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5houIhDvzUuF2DGp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:40:39 -0700 (PDT)
Date: Mon, 29 Aug 2016 20:40:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 800b269
Message-ID: <20160830034012.GJ22760@birch.djwong.org>
References: <20160826062508.GG19025@dastard>
	<20160826074844.GA17137@infradead.org>
	<20160829013111.GN19025@dastard>
	<20160829145249.GF22760@birch.djwong.org>
	<20160829232308.GQ19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829232308.GQ19025@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 30, 2016 at 09:23:08AM +1000, Dave Chinner wrote:
> On Mon, Aug 29, 2016 at 07:52:49AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 29, 2016 at 11:31:12AM +1000, Dave Chinner wrote:
> > > On Fri, Aug 26, 2016 at 12:48:44AM -0700, Christoph Hellwig wrote:
> > > > Hi Dave,
> > > > 
> > > > please consider: "[PATCH] iomap: don't set FIEMAP_EXTENT_MERGED for
> > > > extent based filesystems"
> > > > 
> > > > for 4.8.  It fixes a regression in the iomap-based fiemap
> > > > implementation, and it's fairly trivial as well.
> > > 
> > > Oh, damn, I thought I got that one. I'll append it to the
> > > series and push it out.
> > 
> > It might be a good idea to pick up "xfs: track log done items directly
> > in the deferred pending work item" too, if it fixes the slab
> > corruptions that Christoph reported.
> 
> Doesn't apply cleanly to the 4.8 tree, and the xfs_defer_finish()
> code is quite different, so you'll need to rebase and resend that
> patch if you think it needs to be applied to the 4.8-rc kernel.
> I can always send it to Linus later.

Heh, I forgot to shove it to the head of the queue before mailing it.
Will resend with that fixed.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
