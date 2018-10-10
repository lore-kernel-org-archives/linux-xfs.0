Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:35675 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbeJKExA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 00:53:00 -0400
Date: Thu, 11 Oct 2018 08:28:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: use offsetof() in place of offset macros for
 __xfsstats
Message-ID: <20181010212856.GL6311@dastard>
References: <20181010123708.7632-1-cmaiolino@redhat.com>
 <20181010123708.7632-3-cmaiolino@redhat.com>
 <20181010144932.GO28243@magnolia>
 <20181010145853.tzel5ymyktsbiln7@odin.usersys.redhat.com>
 <20181010150210.GQ28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010150210.GQ28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 08:02:10AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 10, 2018 at 04:58:53PM +0200, Carlos Maiolino wrote:
> > > >  	uint32_t		xs_rmap_2[__XBTS_MAX];
> > > > -#define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + __XBTS_MAX)
> > > >  	uint32_t		xs_refcbt_2[__XBTS_MAX];
> > > > -#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
> > > >  	uint32_t		xs_qm_dqreclaims;
> > > >  	uint32_t		xs_qm_dqreclaim_misses;
> > > >  	uint32_t		xs_qm_dquot_dups;
> > > >  	uint32_t		xs_qm_dqcachemisses;
> > > >  	uint32_t		xs_qm_dqcachehits;
> > > >  	uint32_t		xs_qm_dqwants;
> > > > -#define XFSSTAT_END_QM			(XFSSTAT_END_XQMSTAT+2)
> > > >  	uint32_t		xs_qm_dquot;
> > > >  	uint32_t		xs_qm_dquot_unused;
> > > >  /* Extra precision counters */
> > > > @@ -163,10 +139,12 @@ struct __xfsstats {
> > > >  	uint64_t		xs_read_bytes;
> > > >  };
> > > >  
> > > > +#define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
> > > 
> > > Goes past 80 columns, but otherwise looks ok,
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Ops, sorry, I traded readability+tabs X 80 columns, I think changing the tabs
> > for spaces is enough to fix it.
> > 
> > Do you want me to send it again?
> 
> <shrug> If Dave elects to fix it on the way in that's fine with me.
> 
> Though I guess so long as I'm being pedantic about things that 'f' ought
> to be parentheses-wrapped too, e.g.
> 
> #define xfsstats_offset(f) (offsetof(struct __xfsstats, (f)) / sizeof(uint32_t))

I'll clean it up on merge.

Thanks,

Dave.

-- 
Dave Chinner
david@fromorbit.com
