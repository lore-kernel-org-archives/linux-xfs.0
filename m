Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23552 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbdK3Vv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 16:51:57 -0500
Date: Thu, 30 Nov 2017 13:51:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] xfs_db: print structure padding fields consistently
Message-ID: <20171130215149.GL21412@magnolia>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094860737.27182.5422098949147661107.stgit@magnolia>
 <5fc6a92d-b7f7-2dae-862c-d266cc46df99@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fc6a92d-b7f7-2dae-862c-d266cc46df99@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 03:37:54PM -0600, Eric Sandeen wrote:
> On 11/17/17 1:56 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > We are very inconsistent about how we print padding fields in on-disk
> > structures -- sometimes we hide it from printall, sometimes we deviate
> > from unsigned hex values, etc.  Make this all consistent -- never hide
> > padding values, always print them as unsigned hex integers.
> 
> I'm not sure I see the point to cluttering up structure printing
> with padding, and would prefer to hide them /all/ by default (and
> set them all to hex printing when explicitly asked for).
> 
> Consistency is good but I'm not sure we need to consistently print
> values that are never even used...?

Ok.  Will you take a patch that changes them all to FLD_SKIPALL?

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/attr.c  |   10 +++++-----
> >  db/dir2.c  |    4 ++--
> >  db/dquot.c |    4 ++--
> >  3 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/db/attr.c b/db/attr.c
> > index 75fe239..ba8313c 100644
> > --- a/db/attr.c
> > +++ b/db/attr.c
> > @@ -73,7 +73,7 @@ const field_t	attr_blkinfo_flds[] = {
> >  	{ "forw", FLDT_ATTRBLOCK, OI(BOFF(forw)), C1, 0, TYP_ATTR },
> >  	{ "back", FLDT_ATTRBLOCK, OI(BOFF(back)), C1, 0, TYP_ATTR },
> >  	{ "magic", FLDT_UINT16X, OI(BOFF(magic)), C1, 0, TYP_NONE },
> > -	{ "pad", FLDT_UINT16X, OI(BOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
> > +	{ "pad", FLDT_UINT16X, OI(BOFF(pad)), C1, 0, TYP_NONE },
> >  	{ NULL }
> >  };
> >  
> > @@ -94,7 +94,7 @@ const field_t	attr_leaf_entry_flds[] = {
> >  	{ "local", FLDT_UINT1,
> >  	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_LOCAL_BIT - 1), C1, 0,
> >  	  TYP_NONE },
> > -	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, FLD_SKIPALL, TYP_NONE },
> > +	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, 0, TYP_NONE },
> >  	{ NULL }
> >  };
> >  
> > @@ -105,7 +105,7 @@ const field_t	attr_leaf_hdr_flds[] = {
> >  	{ "usedbytes", FLDT_UINT16D, OI(LHOFF(usedbytes)), C1, 0, TYP_NONE },
> >  	{ "firstused", FLDT_UINT16D, OI(LHOFF(firstused)), C1, 0, TYP_NONE },
> >  	{ "holes", FLDT_UINT8D, OI(LHOFF(holes)), C1, 0, TYP_NONE },
> > -	{ "pad1", FLDT_UINT8X, OI(LHOFF(pad1)), C1, FLD_SKIPALL, TYP_NONE },
> > +	{ "pad1", FLDT_UINT8X, OI(LHOFF(pad1)), C1, 0, TYP_NONE },
> >  	{ "freemap", FLDT_ATTR_LEAF_MAP, OI(LHOFF(freemap)),
> >  	  CI(XFS_ATTR_LEAF_MAPSIZE), FLD_ARRAY, TYP_NONE },
> >  	{ NULL }
> > @@ -567,7 +567,7 @@ const field_t	attr3_leaf_hdr_flds[] = {
> >  	{ "usedbytes", FLDT_UINT16D, OI(LH3OFF(usedbytes)), C1, 0, TYP_NONE },
> >  	{ "firstused", FLDT_UINT16D, OI(LH3OFF(firstused)), C1, 0, TYP_NONE },
> >  	{ "holes", FLDT_UINT8D, OI(LH3OFF(holes)), C1, 0, TYP_NONE },
> > -	{ "pad1", FLDT_UINT8X, OI(LH3OFF(pad1)), C1, FLD_SKIPALL, TYP_NONE },
> > +	{ "pad1", FLDT_UINT8X, OI(LH3OFF(pad1)), C1, 0, TYP_NONE },
> >  	{ "freemap", FLDT_ATTR_LEAF_MAP, OI(LH3OFF(freemap)),
> >  	  CI(XFS_ATTR_LEAF_MAPSIZE), FLD_ARRAY, TYP_NONE },
> >  	{ NULL }
> > @@ -589,7 +589,7 @@ const field_t	attr3_node_hdr_flds[] = {
> >  	{ "info", FLDT_ATTR3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
> >  	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
> >  	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
> > -	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
> > +	{ "pad", FLDT_UINT32X, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
> >  	{ NULL }
> >  };
> >  
> > diff --git a/db/dir2.c b/db/dir2.c
> > index 3e21a7b..bd9c6aa 100644
> > --- a/db/dir2.c
> > +++ b/db/dir2.c
> > @@ -171,7 +171,7 @@ const field_t	da_blkinfo_flds[] = {
> >  	{ "forw", FLDT_DIRBLOCK, OI(DBOFF(forw)), C1, 0, TYP_INODATA },
> >  	{ "back", FLDT_DIRBLOCK, OI(DBOFF(back)), C1, 0, TYP_INODATA },
> >  	{ "magic", FLDT_UINT16X, OI(DBOFF(magic)), C1, 0, TYP_NONE },
> > -	{ "pad", FLDT_UINT16X, OI(DBOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
> > +	{ "pad", FLDT_UINT16X, OI(DBOFF(pad)), C1, 0, TYP_NONE },
> >  	{ NULL }
> >  };
> >  
> > @@ -977,7 +977,7 @@ const field_t	da3_node_hdr_flds[] = {
> >  	{ "info", FLDT_DA3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
> >  	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
> >  	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
> > -	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
> > +	{ "pad", FLDT_UINT32X, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
> >  	{ NULL }
> >  };
> >  
> > diff --git a/db/dquot.c b/db/dquot.c
> > index 4e35df4..222c082 100644
> > --- a/db/dquot.c
> > +++ b/db/dquot.c
> > @@ -76,7 +76,7 @@ const field_t	disk_dquot_flds[] = {
> >  	{ "btimer", FLDT_INT32D, OI(DOFF(btimer)), C1, 0, TYP_NONE },
> >  	{ "iwarns", FLDT_QWARNCNT, OI(DOFF(iwarns)), C1, 0, TYP_NONE },
> >  	{ "bwarns", FLDT_QWARNCNT, OI(DOFF(bwarns)), C1, 0, TYP_NONE },
> > -	{ "pad0", FLDT_INT32D, OI(DOFF(pad0)), C1, FLD_SKIPALL, TYP_NONE },
> > +	{ "pad0", FLDT_UINT32X, OI(DOFF(pad0)), C1, 0, TYP_NONE },
> >  	{ "rtb_hardlimit", FLDT_QCNT, OI(DOFF(rtb_hardlimit)), C1, 0,
> >  	  TYP_NONE },
> >  	{ "rtb_softlimit", FLDT_QCNT, OI(DOFF(rtb_softlimit)), C1, 0,
> > @@ -84,7 +84,7 @@ const field_t	disk_dquot_flds[] = {
> >  	{ "rtbcount", FLDT_QCNT, OI(DOFF(rtbcount)), C1, 0, TYP_NONE },
> >  	{ "rtbtimer", FLDT_INT32D, OI(DOFF(rtbtimer)), C1, 0, TYP_NONE },
> >  	{ "rtbwarns", FLDT_QWARNCNT, OI(DOFF(rtbwarns)), C1, 0, TYP_NONE },
> > -	{ "pad", FLDT_UINT16X, OI(DOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
> > +	{ "pad", FLDT_UINT16X, OI(DOFF(pad)), C1, 0, TYP_NONE },
> >  	{ NULL }
> >  };
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
