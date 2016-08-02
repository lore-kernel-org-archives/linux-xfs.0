Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3903C7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 16:38:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4430AC001
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 14:38:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id H0YJy4JqDWd8tdYt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 14:38:25 -0700 (PDT)
Date: Tue, 2 Aug 2016 17:38:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 20/47] xfs: increase XFS_BTREE_MAXLEVELS to fit the rmapbt
Message-ID: <20160802213822.GB8100@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907709719.25461.3104352212846077948.stgit@birch.djwong.org>
	<20160802184845.GC58152@bfoster.bfoster>
	<20160802200635.GJ8590@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802200635.GJ8590@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Tue, Aug 02, 2016 at 01:06:35PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 02, 2016 at 02:48:46PM -0400, Brian Foster wrote:
> > On Wed, Jul 20, 2016 at 09:58:17PM -0700, Darrick J. Wong wrote:
> > > By my calculations, a 1,073,741,824 block AG with a 1k block size
> > > can attain a maximum height of 9.  Assuming a record size of 24
> > > bytes, a key/ptr size of 44 bytes, and half-full btree nodes,
> > > we'd need 53,687,092 blocks for the records and ~6 million blocks
> > > for the keys.  That requires a btree of height 9.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > I believe you.. :) but could you add a bit more detail to the commit log
> > just to describe the calculations (e.g., how many records per leaf
> > block, keys per node block) so 1.) I don't have to try and figure it out
> > ;) (and probably get it wrong) and 2.) so we have a reference in the git
> > repo going forward?
> 
> Block size = 1024b
> sblock CRC header = 56b
> == 1024-56 = 968 bytes for tree data
> 
> rmapbt record = 24b
> == 40 records per leaf block
> 
> rmapbt ptr/key = 44b
> == 22 ptr/keys per block
> 
> Worst case, each block is half full, so 20 records and 11 ptrs per block.
> 
> 1073741824 rmap records / 20 records per block
> == 53687092 leaf blocks
> 
> 53687092 leaves / 11 ptrs per block
> == 4880645 level 1 blocks
> == 443695 level 2 blocks
> == 40336 level 3 blocks
> == 3667 level 4 blocks
> == 334 level 5 blocks
> == 31 level 6 blocks
> == 3 level 7 blocks
> == 1 level 8 block
> 

Thanks! Seems Ok to me.. with that in the commit log:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Yay latency....
> 
> (Hey, at least this isn't ext4 which has no lower bound on block fill...)
> 
> --D
> 
> > 
> > Brian
> > 
> > >  fs/xfs/libxfs/xfs_btree.h |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > index b8bbb21..629ef4f 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > @@ -133,7 +133,7 @@ do {    \
> > >  	}       \
> > >  } while (0)
> > >  
> > > -#define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
> > > +#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
> > >  
> > >  struct xfs_btree_ops {
> > >  	/* size of the key and record structures */
> > > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
