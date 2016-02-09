Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A32197CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 01:55:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D98F304039
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 23:55:18 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KwsZ1EiKeaEALh8Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 23:55:14 -0800 (PST)
Date: Mon, 8 Feb 2016 23:55:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/23] xfs/122: support refcount/rmap data structures
Message-ID: <20160209075506.GB6346@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011303.23099.40721.stgit@birch.djwong.org>
	<20160209074330.GK19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209074330.GK19486@dastard>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 06:43:30PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:13:03PM -0800, Darrick J. Wong wrote:
> > Include the refcount and rmap structures in the golden output.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/122     |    3 +++
> >  tests/xfs/122.out |    4 ++++
> >  tests/xfs/group   |    2 +-
> >  3 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/xfs/122 b/tests/xfs/122
> > index e6697a2..758cb50 100755
> > --- a/tests/xfs/122
> > +++ b/tests/xfs/122
> > @@ -90,6 +90,9 @@ xfs_da3_icnode_hdr
> >  xfs_dir3_icfree_hdr
> >  xfs_dir3_icleaf_hdr
> >  xfs_name
> > +xfs_owner_info
> > +xfs_refcount_irec
> > +xfs_rmap_irec
> >  xfs_alloctype_t
> >  xfs_buf_cancel_t
> >  xfs_bmbt_rec_32_t
> 
> So this is going to cause failures on any userspace that doesn't
> know about these new types, right?
> 
> Should these be conditional in some way?

I wasn't sure how to handle this -- I could just keep the patch at the head of
my stack (unreleased) until xfsprogs pulls in the appropriate libxfs pieces?
So long as we're not dead certain of the final format of the rmapbt and
refcountbt, there's probably not a lot of value in putting this in (yet).

--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
