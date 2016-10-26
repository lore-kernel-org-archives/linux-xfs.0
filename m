Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31386 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754722AbcJZRx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 13:53:29 -0400
Date: Wed, 26 Oct 2016 10:52:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/39] xfs_db: dump refcount btree data
Message-ID: <20161026175257.GF26572@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743667365.11035.7315587935264063644.stgit@birch.djwong.org>
 <20161026102813.GG29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026102813.GG29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:28:13AM -0700, Christoph Hellwig wrote:
> > @@ -47,7 +47,7 @@ const field_t	agf_flds[] = {
> >  	{ "versionnum", FLDT_UINT32D, OI(OFF(versionnum)), C1, 0, TYP_NONE },
> >  	{ "seqno", FLDT_AGNUMBER, OI(OFF(seqno)), C1, 0, TYP_NONE },
> >  	{ "length", FLDT_AGBLOCK, OI(OFF(length)), C1, 0, TYP_NONE },
> > -	{ "roots", FLDT_AGBLOCK, OI(OFF(roots)), CI(XFS_BTNUM_AGF),
> > +	{ "roots", FLDT_AGBLOCK, OI(OFF(roots)), CI(XFS_BTNUM_AGF) + 1,

NAK.  The 'roots' array in the AGF is only three items long.  Adding one
here makes it pick up 'bnolevel' as the root of a fourth tree, which is
incorrect.  Same applies to the 'levels' array; it should also be left
alone.

(The refcount_root and refcount_level field definitions are ok.)

> >  	  FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
> 
> Please replace XFS_BTNUM_AGF with a proper XFS_NUM_AG_BTREES or
> similar define.  Without that this line and the ones below are black
> magic.

The naming here is awkward, indeed.  The agf_roots[] and agf_levels[]
arrays are declared to be XFS_BTNUM_AGF (3) elements long.  That was
fine when we wanted to root the rmapbt in that third slot, but now it's
weird because the refcountbt is the fourth tree to be rooted in the AGF.

Increasing XFS_BTNUM_AGF would have screwed up the on-disk format way
back when we could change the disk format, and instead renaming the
constant to XFS_AGF_ROOT_ARRAY_LEN is still somewhat misleading since
the agf_root array doesn't cover all the AGF roots.

I guess I could enlarge the comment for XFS_BTNUM_AGF to warn that
there are other btree roots in the AGF, though it felt like that was
fairly obvious.

--D

> Otherwise this looks fine to me.
