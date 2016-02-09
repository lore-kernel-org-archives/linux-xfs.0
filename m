Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 852957CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 02:54:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73C4F8F8040
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 00:54:01 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kKhGjEvD9m8Zaul6 for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 00:53:58 -0800 (PST)
Date: Tue, 9 Feb 2016 19:53:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/23] xfs/122: support refcount/rmap data structures
Message-ID: <20160209085328.GQ19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011303.23099.40721.stgit@birch.djwong.org>
	<20160209074330.GK19486@dastard>
	<20160209075506.GB6346@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209075506.GB6346@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 11:55:06PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 09, 2016 at 06:43:30PM +1100, Dave Chinner wrote:
> > On Mon, Feb 08, 2016 at 05:13:03PM -0800, Darrick J. Wong wrote:
> > > Include the refcount and rmap structures in the golden output.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  tests/xfs/122     |    3 +++
> > >  tests/xfs/122.out |    4 ++++
> > >  tests/xfs/group   |    2 +-
> > >  3 files changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/122 b/tests/xfs/122
> > > index e6697a2..758cb50 100755
> > > --- a/tests/xfs/122
> > > +++ b/tests/xfs/122
> > > @@ -90,6 +90,9 @@ xfs_da3_icnode_hdr
> > >  xfs_dir3_icfree_hdr
> > >  xfs_dir3_icleaf_hdr
> > >  xfs_name
> > > +xfs_owner_info
> > > +xfs_refcount_irec
> > > +xfs_rmap_irec
> > >  xfs_alloctype_t
> > >  xfs_buf_cancel_t
> > >  xfs_bmbt_rec_32_t
> > 
> > So this is going to cause failures on any userspace that doesn't
> > know about these new types, right?
> > 
> > Should these be conditional in some way?
> 
> I wasn't sure how to handle this -- I could just keep the patch at the head of
> my stack (unreleased) until xfsprogs pulls in the appropriate libxfs pieces?
> So long as we're not dead certain of the final format of the rmapbt and
> refcountbt, there's probably not a lot of value in putting this in (yet).

Well, I'm more concerned about running on older/current distros that
don't have support for them in userspace. My brain is mush right
now, so I don't have any brilliant ideas (hence the question, rather
than also presenting a posible solution). I'll have a think; maybe
we can make use of the configurable .out file code we have now?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
