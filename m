Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C5C307F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:59:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E78930406B
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:59:20 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JdrSPQzm6gyWOcGC for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 12:59:17 -0700 (PDT)
Date: Wed, 25 Jun 2014 05:59:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS updates] XFS development tree branch,
	xfs-libxfs-restructure, updated. xfs-for-linus-3.16-rc1-13107-gc59a5ac
Message-ID: <20140624195914.GI9508@dastard>
References: <20140623072359.C16CF7F47@oss.sgi.com>
	<20140623080618.GY9508@dastard>
	<20140624142522.GB45839@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140624142522.GB45839@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 24, 2014 at 10:25:36AM -0400, Brian Foster wrote:
> On Mon, Jun 23, 2014 at 06:06:18PM +1000, Dave Chinner wrote:
> > On Mon, Jun 23, 2014 at 02:23:59AM -0500, xfs@oss.sgi.com wrote:
> > > This is an automated email from the git hooks/post-receive script. It was
> > > generated because a ref change was pushed to the repository containing
> > > the project "XFS development tree".
> > > 
> > > The branch, xfs-libxfs-restructure has been updated
> > >   discards  fcec2eb6a31bde491f4ce9ddd94b41c8aacccd43 (commit)
> > >   discards  e3584e38615389850684fcffd699d97e2e06f2d6 (commit)
> > >   discards  f212d6fcf5c1cc3a3980dd320804c1dfb9f49b75 (commit)
> > >   discards  e10404cf914273de8016d5992c7049bdb9a9a089 (commit)
> > >   discards  f3a19b3ad85dcc4a073270e1fb594eff37709788 (commit)
> > >   discards  d5a6cda3cf2c0860543db26bb5df7ed4404f74cd (commit)
> > >   c59a5ac xfs: global error sign conversion
> > >   63d512e libxfs: move source files
> > >   547a71f libxfs: move header files
> > >   62c9454 xfs: create libxfs infrastructure
> > >   b474c7a xfs: Nuke XFS_ERROR macro
> > >   d99831f xfs: return is not a function
> > >   16b9057 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> > >   9c1d528 Merge commit '9f12600fe425bc28f0ccba034a77783c09c15af4' into for-linus
> > >   8d02076 ->splice_write() via ->write_iter()
> > >   412dd3a Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
> > >   23adbe1 fs,userns: Change inode_capable to capable_wrt_inode_uidgid
> > >   bf97f3b xfs: switch to ->write_iter()
> > >   b4f5d2c xfs: switch to ->read_iter()
> > >   b318891 xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
> > >   0c94933 iov_iter_truncate()
> > >   71d8e53 start adding the tag to iov_iter
> > >   31b1403 switch {__,}blockdev_direct_IO() to iov_iter
> > >   a6cbcd4 get rid of pointless iov_length() in ->direct_IO()
> > >   d8d3d94 pass iov_iter to ->direct_IO()
> > >   cb66a7a kill generic_segment_checks()
> > >   f8579f8 generic_file_direct_write(): switch to iov_iter
> > >       from  fcec2eb6a31bde491f4ce9ddd94b41c8aacccd43 (commit)
> > > 
> > > Those revisions listed above that are new to this repository have
> > > not appeared on any other notification email; so we list those
> > > revisions in full, below.
> > 
> > This looks like a lot of non-libxfs changes, but it's mostly just
> > noise from the rebase from 3.15.0 to the current master branch at
> > 3.16-rc2.
> > 
> > I've added all the negation fixes that Brian noted, and tested all
> > the different config options (m,y,n) for the libxfs restructure. I
> > haven't come across any problems over the weekend, so I'd like to
> > push this out so that we can get this dev cycle properly underway.
> > If people can ack this, I'll add all the appropriate sign-offs and
> > push it.
> > 
> 
> The changes look good to me and I don't see any failures that aren't
> common with for-next, so:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks, Brian.

> That said, I am seeing a BUG() on for-next kernels via repeated xfs/297
> runs. Output is appended below.

Yup, I'm still seeing those stale delalloc block asserts quite
regularly. There was a lull after the last round of fixes I did, but
in the last couple of months they've beena regular occurrence in my
testing again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
