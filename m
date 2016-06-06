Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5890D7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 13:52:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7AB2AC005
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 11:52:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CSud56VrG1DFZLCj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 11:52:18 -0700 (PDT)
Date: Mon, 6 Jun 2016 11:52:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160606185206.GC5737@birch.djwong.org>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<20160602225415.GP12670@dastard>
	<20160603015832.GA5758@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160603015832.GA5758@birch.djwong.org>
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

On Thu, Jun 02, 2016 at 06:58:33PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 03, 2016 at 08:54:15AM +1000, Dave Chinner wrote:
> > On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > > I've had some vocal user requests to allow enabling reflinks at run time,
> > > which happens to be a mostly trivial feature.  The only caveat is that we
> > > need a large enough log size to support the reflink requirements, but for
> > > typical large file systems that's not an issue.
> > 
> > Hmmm - how does this interact with all the rmap code? I was not
> > planning on enabling reflink without rmap and vice versa simply
> > because it makes the validation and testing matrix vastly more
> > complex. Indeed, having reflink turned on after a filesystem has
> > aged for some time (i.e. from unknown initial conditions) makes
> > validation especially tricky....
> 
> Well...
> 
> It's not strictly impossible, but there will be some problems running
> repair and remounting.
> 
> The patchset doesn't actually check that we satisfy the minimum log
> space requirement, which will result in xfs refusing to mount.  As
> Christoph says, this is only an issue on small FSes, but nevertheless,
> we shouldn't trap the user like that.
> 
> Second, mkfs lays out all the AG btree roots at the start of the AG
> before finding an aligned inode block for the root inode.  xfs_repair
> feeds the same algorithm from the on-disk feature fields to check that
> s_rootino is sane, and gets very unhappy if it doesn't find the root
> inode at the computed location.  Adding the two btree root blocks is
> enough to shift the root inode from 96 to 128.  This all can be fixed,
> but it /was/ convenient not to have to support weirdo upgraded XFSes
> like ext4. :)

We could reprogram mkfs to allocate the root inode at a sufficiently
high block offset that we'll probably never see a collision between
the rootino block and mkfs-time AG btree roots.  That seems like less
work than fiddling with everything that assumes that the first
xfs_prealloc_blocks are reserved for AG metadata to leave a hole for
the rootino chunk.

I think we could create an incompat feature flag to mark this 'high
offset root inode'.  mkfs will turn on the flag if any feature at
least as new as rmap is enabled.  That way, reflink can be turned on
for pre-rmap v5 filesystems (where the increase in AG btree roots
won't move the calculated rootino) or for post-rmap v5 filesystems
(where we put rootino at a high enough offset that we won't have a
problem).

--D

> 
> Furthermore, if you turn on reflink, you should enable the per-AG
> reservations so we don't crash the FS by running out of space when it
> needs a block for the refcountbt.
> 
> --D
> 
> > 
> > Darrick?
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
