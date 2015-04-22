Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D1677F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 17:02:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D46130404E
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 15:02:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AoXV6BhA2MZlC76B (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 15:02:47 -0700 (PDT)
Date: Wed, 22 Apr 2015 18:02:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't trigger fsync log force based on inode pin
	count
Message-ID: <20150422220244.GA48944@bfoster.bfoster>
References: <1429713466-22137-1-git-send-email-bfoster@redhat.com>
	<20150422161509.GA27237@infradead.org>
	<20150422171322.GB6688@bfoster.bfoster>
	<20150422211845.GP21261@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150422211845.GP21261@dastard>
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

On Thu, Apr 23, 2015 at 07:18:45AM +1000, Dave Chinner wrote:
> On Wed, Apr 22, 2015 at 01:13:23PM -0400, Brian Foster wrote:
> > On Wed, Apr 22, 2015 at 09:15:09AM -0700, Christoph Hellwig wrote:
> > > On Wed, Apr 22, 2015 at 10:37:46AM -0400, Brian Foster wrote:
> > > > There are probably a couple different ways to handle this. We could log
> > > > the inode in the bmap cases in order to preserve the pincount check.
> > > 
> > > I'd favor that.  For one performance should be better, second we really
> > > need to dirty the inode anyway for v5 file systems as that's the
> > > mechanism used to increment di_changecount.
> > > 
> > 
> > Yeah, that's a good point. I noticed that in xfs_trans_log_inode() when
> > debugging but didn't think much about it since I reproduced on v4. I can
> > get performance back with the aforementioned cil push fix, but if the
> > path forward is behavior where the inode is going to be logged anyways,
> > that is decent reason to emulate such behavior in the pre-v5 case.
> > 
> > Note that we have the following in xfs_bmapi_write():
> > 
> >         if (bma.logflags)
> >                 xfs_trans_log_inode(tp, ip, bma.logflags);
> 
> Which, essentially, only contains flags when we do a extent-to-btree
> conversion or vice versa, so we effectively never log the inode on
> unwritten extent conversions unless the size changes.
> 
> I agree with Christoph - we should just unconditionally log the
> inode in xfs_bmap_add_extent_unwritten_real() as it's a user visible
> data change we need to bump di_changecount for. i.e. NFS client can
> see the unwritten data after a data write has started and changed the
> timestamps/write count, but then the IO completion makes the data
> visible and hence the change count needs to be bumped again...
> 

Ok, that works for me. I'll give it a shot.

> > ... and some other places. I don't reproduce this particular problem on
> > v5, so something else might be logging the inode here. That strikes me
> > as not what we want with regard to the change count, however..
> 
> Larger inode size with v5, so it's entirely possible that v5 is not
> triggering the problemon this test because the extent list is
> remaining in local format and so any updates are logging the inode
> directly....
> 

That was what I thought at first but I bumped the extent count a couple
times and still couldn't reproduce. I was curious enough to track it
down and it is actually the time update again. For whatever reason, I
think the crc mechanism is throwing the timing off and just hiding the
problem again. E.g., no-op xfs_vn_time_update() and the problem
reproduces on v5 as well.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
