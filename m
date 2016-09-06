Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B4ED7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 12:14:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 358D48F8050
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:14:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GqaGUMEgseuAH66D (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 10:14:14 -0700 (PDT)
Date: Tue, 6 Sep 2016 10:13:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/71] xfs: introduce refcount btree definitions
Message-ID: <20160906171345.GE16696@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216797030.867.2576348201175433862.stgit@birch.djwong.org>
	<20160906145914.GC24287@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906145914.GC24287@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 07:59:14AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:32:50PM -0700, Darrick J. Wong wrote:
> > Add new per-AG refcount btree definitions to the per-AG structures.
> > =

> > v2: Move the reflink inode flag out of the way of the DAX flag, and
> > add the new cowextsize flag.
> > =

> > v3: Don't allow pNFS to export reflinked files; this will be removed
> > some day when the Linux pNFS server supports it.
> > =

> > [hch: don't allow pNFS export of reflinked files]
> > [darrick: fix the feature test in hch's patch]
> =

> This was such a tiny check in the grand scheme of things, feel free to dr=
op any mention of it

<nod>

> >  /*
> >   * For logging record fields.
> > @@ -105,6 +106,7 @@ do {    \
> >  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
> >  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
> >  	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
> > +	case XFS_BTNUM_REFC: break; \
> =

> I'd merge the refcount stats into this patch, it's a fairly tiny
> addition to an already small patch.

I too thought it was a little strange to modify the same part of the
same macro in two successive patches, but was merely following the
pattern that Dave took in the initial rmap patches.  At the time I
na=EFvely thought that a larger number of patches with fewer changes
per patch would be less cognitive strain, but then the number of
reflink patches took off.

> > +static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
> > +{
> > +	return (XFS_SB_VERSION_NUM(sbp) =3D=3D XFS_SB_VERSION_5) &&
> =

> no need for the braces here..
> =

> >  {
> > -	mp->m_rmap_maxlevels =3D xfs_btree_compute_maxlevels(mp,
> > -			mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > +		mp->m_rmap_maxlevels =3D XFS_BTREE_MAXLEVELS;
> > +	else
> =

> Hmm, any good explanation for the magic XFS_BTREE_MAXLEVELS value
> here?  Maybe even one that could go into a comment?

On a non-reflink filesystem, the maximum number of rmap records is the
number of blocks in the AG, hence the max rmapbt height is
log_$maxrecs($agblocks).  However, with reflink each AG block can have
up to 2^32 (per the refcount record format) owners, which
means that theoretically we could face up to 2^64 rmap records.

Effectively that means that the max rmapbt height must be
XFS_BTREE_MAXLEVELS.  "Fortunately" we'll run out of AG blocks to feed
the rmapbt long before the rmapbt grows taller than that.  The reflink
code uses ag_resv_critical to disallow reflinking when less than 10%
of the per-AG metadata block reservation remains in the hope that the
caller will go beat up some other AG^W^W^W^W^Wmake a copy somewhere
else.

> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index a3c2e2d..6141d68 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -393,6 +393,9 @@ typedef struct xfs_perag {
> >  	struct xfs_ag_resv	pag_meta_resv;
> >  	/* Blocks reserved for just AGFL-based metadata. */
> >  	struct xfs_ag_resv	pag_agfl_resv;
> > +
> > +	/* reference count */
> > +	__uint8_t	pagf_refcount_level;
> >  } xfs_perag_t;
> =

> The indentation doesn't seem to match the fields above.

Oops.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
