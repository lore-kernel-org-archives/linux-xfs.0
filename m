Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD85C7CA1
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 00:36:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E9C4304043
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 22:36:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id hx285khUkPvrLWr0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jul 2016 22:36:46 -0700 (PDT)
Date: Tue, 12 Jul 2016 22:36:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160713053639.GG13625@birch.djwong.org>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<20160602225415.GP12670@dastard> <20160608071130.GB24663@lst.de>
	<20160609233344.GA26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160609233344.GA26977@dastard>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jun 10, 2016 at 09:33:44AM +1000, Dave Chinner wrote:
> On Wed, Jun 08, 2016 at 09:11:30AM +0200, Christoph Hellwig wrote:
> > On Fri, Jun 03, 2016 at 08:54:15AM +1000, Dave Chinner wrote:
> > > On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > > > I've had some vocal user requests to allow enabling reflinks at run time,
> > > > which happens to be a mostly trivial feature.  The only caveat is that we
> > > > need a large enough log size to support the reflink requirements, but for
> > > > typical large file systems that's not an issue.
> > > 
> > > Hmmm - how does this interact with all the rmap code? I was not
> > > planning on enabling reflink without rmap and vice versa simply
> > > because it makes the validation and testing matrix vastly more
> > > complex.
> > 
> > Uh.  So far I've only been testing pure reflink code, mostly because
> > rmap really doesn't buy much for the use case I'm working on.
> > Enabling rmap post-mkfs is defintively a different ballpark, and probably
> > not worth it even if it would be doable.
> 
> Wasn't expecting rmap to ever be dynamically enabled ;)
> 
> So ignoring the testing side of things, and looking more at the
> implementation of the enabling, I'm not sure I really like the idea
> of doing this via a mount option. Because we've got to make
> significant additions to the on disk format in each AG, this seems
> more like a "growfs style" operation than anything. i.e. lock out
> allocation, add all the structures to the AG headers and allocate
> all the blocks needed, re-initialise the per-ag structures with all
> the necessary info, then switch on the feature bit and commit the
> change.

I'd been wondering if we could just make a new FS_SET_GEOMETRY xfsctl
where you'd pass in the same xfs_fsop_geom you got from FSGEOMETRY.
The kernel would either decide that it liked the changes and do them,
or reject the whole thing with -EINVAL.

> It's probably a little more intricate than doing it at mount time,
> but it gets around the fact that users have to add a mount option
> and bounce the filesystem to turn on reflinks.
> I can see this being much easier than a mount option in some
> situations, (e.g. for the root filesystem), and I don't think it's
> much harder to test than the mount option (e.g. the way growfs is
> tested under stress by xfs/104)...

But otherwise we'd probably want to check log size and free counts, and then
fill in the refcount btree root.  We'd also have to make sure that the root
inode chunk doesn't change as a result of xfs_prealloc_blocks changing, since I
think mkfs puts the root inode chunk in the first aligned space after all the
AG metadata.

<shrug> It's been a while, I'll look at this closer when I get back to reflink.

> Your thoughts, Christoph?

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
