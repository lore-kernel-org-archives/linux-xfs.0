Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D4167CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 10:51:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2F45304048
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 08:51:17 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 51EAkIyGeJe5UKEC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 08:51:16 -0700 (PDT)
Date: Thu, 4 Aug 2016 08:50:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: store rmapbt block count in the AGF
Message-ID: <20160804155042.GW8590@birch.djwong.org>
References: <20160803214613.GF8593@birch.djwong.org>
	<20160804154439.GA15656@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160804154439.GA15656@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 04, 2016 at 08:44:39AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 03, 2016 at 02:46:13PM -0700, Darrick J. Wong wrote:
> > Track the number of blocks used for the rmapbt in the AGF.  When we
> > get to the AG reservation code we need this counter to quickly
> > make our reservation during mount.
> > 
> > v2: Actually include growfs support.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c      |    1 +
> >  fs/xfs/libxfs/xfs_format.h     |   11 ++++++++---
> >  fs/xfs/libxfs/xfs_rmap_btree.c |    6 ++++++
> >  fs/xfs/xfs_fsops.c             |    1 +
> >  4 files changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 776ae2f..af1a72e 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2264,6 +2264,7 @@ xfs_alloc_log_agf(
> >  		offsetof(xfs_agf_t, agf_longest),
> >  		offsetof(xfs_agf_t, agf_btreeblks),
> >  		offsetof(xfs_agf_t, agf_uuid),
> > +		offsetof(xfs_agf_t, agf_rmap_blocks),
> >  		sizeof(xfs_agf_t)
> >  	};
> >  
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index f814d42..e6a8bea 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -640,12 +640,15 @@ typedef struct xfs_agf {
> >  	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
> >  	uuid_t		agf_uuid;	/* uuid of filesystem */
> >  
> > +	__be32		agf_rmap_blocks;	/* rmapbt blocks used */
> > +	__be32		agf_padding;		/* padding */
> 
> Now _spare?  It could easily be used by the next new field.

The reflink patches will (almost immediately) consume agf_padding
and the next spare for refcount_{root,level,blocks}.

--D

> Otherwise this looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
