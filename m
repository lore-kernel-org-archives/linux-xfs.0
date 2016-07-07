Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29AFE7CA3
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 17:55:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0457304138
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 15:55:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UlXNsfNRYeOjLZ1M for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2016 15:55:18 -0700 (PDT)
Date: Fri, 8 Jul 2016 08:55:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 026/119] xfs: add owner field to extent allocation and
	freeing
Message-ID: <20160707225516.GI12670@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612643914.12839.17925699349002137545.stgit@birch.djwong.org>
	<20160707151227.GA33740@bfoster.bfoster>
	<20160707190956.GA12567@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160707190956.GA12567@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Thu, Jul 07, 2016 at 12:09:56PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 07, 2016 at 11:12:27AM -0400, Brian Foster wrote:
> > On Thu, Jun 16, 2016 at 06:20:39PM -0700, Darrick J. Wong wrote:
> > > For the rmap btree to work, we have to feed the extent owner
> > > information to the the allocation and freeing functions. This
> > > information is what will end up in the rmap btree that tracks
> > > allocated extents. While we technically don't need the owner
> > > information when freeing extents, passing it allows us to validate
> > > that the extent we are removing from the rmap btree actually
> > > belonged to the owner we expected it to belong to.
....
> > > +/*
> > > + * Special owner types.
> > > + *
> > > + * Seeing as we only support up to 8EB, we have the upper bit of the owner field
> > > + * to tell us we have a special owner value. We use these for static metadata
> > > + * allocated at mkfs/growfs time, as well as for freespace management metadata.
> > > + */
> > > +#define XFS_RMAP_OWN_NULL	(-1ULL)	/* No owner, for growfs */
> > > +#define XFS_RMAP_OWN_UNKNOWN	(-2ULL)	/* Unknown owner, for EFI recovery */
> > > +#define XFS_RMAP_OWN_FS		(-3ULL)	/* static fs metadata */
> > > +#define XFS_RMAP_OWN_LOG	(-4ULL)	/* static fs metadata */
> > > +#define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
> > 
> > How about XFS_RMAP_OWN_AGFL? OWN_AG confuses me into thinking it's for
> > AG headers, but IIUC that is covered by OWN_FS.

AG headers are static metadata, laid down by mkfs. They are always
owned by the filesystem, hence the "OWN_FS" name.

> or _SPACEBT for AG {free,rmap} space btrees?

IIRC, the reason I simply named them as "Owned by the AG" is that
the space tracking btree blocks are always considered free space. THey can
move between the freespace tree and the AGFL without consuming free
space and it's not trivial to separate their classification to
anything other than "blocks used by the AG but are free space" e.g.
in he middle of a transaction that allocates and free
blocks the same block can move like this:

 bnobt block -> AGFL -> cntbt block -> AGFL -> rmapbt block

Hence blocks on the AGFL are considered to be the same as
bno/cnt/rmapbt blocks for the purpose of owner identification.
Otherwise we'd have to modify the rmapbt every time we move a block
to/from the AGFL, and that then leads to recursion problems and lots
of unnecessary overhead...

Feel free to change the names, but I don't think we can change owner
classifications of the blocks they represent...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
