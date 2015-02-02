Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BADAB7FF9
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 13:43:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4480EAC004
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:43:04 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FDbExknP9nHFuc53 for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 11:43:02 -0800 (PST)
Date: Tue, 3 Feb 2015 06:43:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Message-ID: <20150202194300.GN6282@dastard>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-17-git-send-email-hch@lst.de>
	<20150129205232.GB11064@fieldses.org>
	<20150202073024.GA9399@lst.de> <20150202192404.GI6282@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202192404.GI6282@dastard>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Feb 03, 2015 at 06:24:04AM +1100, Dave Chinner wrote:
> On Mon, Feb 02, 2015 at 08:30:24AM +0100, Christoph Hellwig wrote:
> > On Thu, Jan 29, 2015 at 03:52:32PM -0500, J. Bruce Fields wrote:
> > > Who can give us ACKs on these last five fs/xfs patches?  (And is it
> > > going to cause trouble if they go in through the nfsd tree?)
> > 
> > 
> > We'd need ACKs from Dave.  He already has pulled in two patches so
> > we might run into some conflicts.  Maybe the best idea is to add the
> > exportfs patch to both the XFS and nfsd trees, so each of them can
> > pull in the rest?  Or we could commit the two XFS preparation patches
> > to both tree and get something that compiles and works in the nfsd
> > tree.
> 
> This patch has already been committed to the XFS repo.

And it looks like I missed the sync transaction on growfs patch,
too, so I'll commit that one later today.

As to the pNFSD specific changes, I haven't really looked them over
in any great detail yet. My main concern is that there are no
specific regression tests for this yet, I'm not sure how we go about
verifying it actually works properly and we don't inadvertantly
break it in the future. Christoph?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
