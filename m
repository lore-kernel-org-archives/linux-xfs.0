Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD4657CAF
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 18:56:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B05988F8035
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 16:56:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id J3FFwyzD4kFOBZDe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 16:56:05 -0700 (PDT)
Date: Wed, 13 Jul 2016 16:55:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 040/119] xfs: create helpers for mapping, unmapping, and
	converting file fork extents
Message-ID: <20160713235556.GJ13625@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612652855.12839.8509289990733155675.stgit@birch.djwong.org>
	<20160713182825.GC34396@bfoster.bfoster>
	<20160713184750.GD12567@birch.djwong.org>
	<20160713235408.GQ1922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160713235408.GQ1922@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Jul 14, 2016 at 09:54:08AM +1000, Dave Chinner wrote:
> On Wed, Jul 13, 2016 at 11:47:50AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 13, 2016 at 02:28:25PM -0400, Brian Foster wrote:
> > > On Thu, Jun 16, 2016 at 06:22:08PM -0700, Darrick J. Wong wrote:
> > > > Create two helper functions to assist with mapping, unmapping, and
> > > > converting flag status of extents in a file's data/attr forks.  For
> > > > non-shared files we can use the _alloc, _free, and _convert functions;
> > > > when reflink comes these functions will be augmented to deal with
> > > > shared extents.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_rmap.c |   42 ++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 42 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > > index f92eaa1..76fc5c2 100644
> > > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > > @@ -1123,11 +1123,53 @@ done:
> > > >  	return error;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Convert an unwritten extent to a real extent or vice versa.
> > > > + */
> > > > +STATIC int
> > > > +xfs_rmap_convert(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	xfs_agblock_t		bno,
> > > > +	xfs_extlen_t		len,
> > > > +	bool			unwritten,
> > > > +	struct xfs_owner_info	*oinfo)
> > > > +{
> > > > +	return __xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
> > > > +}
> > > > +
> > > 
> > > Hmm, these all look like 1-1 mappings and they're static as well. Is the
> > > additional interface for reflink? If so, I think it might be better to
> > > punt this down to where it is really used (reflink).
> > 
> > Originally they were, but since the only caller of these functions is
> > _rmap_finish_one, this whole patch can drop out.
> > 
> > Later on in reflink, map/unmap/convert for reflinked files get totally
> > separate "shared" variants, along with corresponding RUI type codes.
> > 
> > Speaking of which, the shared and non-shared alloc/free/convert
> > functions are at a high level the same.  Each function has 8-10 places
> > where they differ (mostly in which btree functions they call) and I
> > wondered -- should I refactor them into a single megafunction that
> > takes a bunch of function pointers?
> 
> Use an ops structure containing function pointers. But that can be
> doen once the code is merged - it doesn't need to be done right
> away.
> 
> > It's a little unwieldly to have
> > so much to pass in, but on the other hand we wouldn't have to maintain
> > two versions of basically the same code.
> 
> An ops structure fixes that problem.

I actually did mean an ops structure; passing in function pointers as
args is wayyyy fugly... but I'd considered that making a bunch of small
functions + a struct might not be much better. :)

--D

> 
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
