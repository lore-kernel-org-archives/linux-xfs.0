Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC9F97CB3
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 01:10:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F71230404E
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 23:10:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JQMGiAcTzHHK9oXe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Sep 2016 23:10:53 -0700 (PDT)
Date: Mon, 19 Sep 2016 23:10:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] [RFC] xfs: make xfs btree stats less huge
Message-ID: <20160920061042.GL9314@birch.djwong.org>
References: <1473755322-883-1-git-send-email-david@fromorbit.com>
	<20160920041652.GK9314@birch.djwong.org>
	<20160920055945.GG340@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160920055945.GG340@dastard>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 20, 2016 at 03:59:45PM +1000, Dave Chinner wrote:
> On Mon, Sep 19, 2016 at 09:16:52PM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 13, 2016 at 06:28:42PM +1000, Dave Chinner wrote:
> > > -	__uint32_t		xs_rmap_2_decrement;
> > > -	__uint32_t		xs_rmap_2_lshift;
> > > -	__uint32_t		xs_rmap_2_rshift;
> > > -	__uint32_t		xs_rmap_2_split;
> > > -	__uint32_t		xs_rmap_2_join;
> > > -	__uint32_t		xs_rmap_2_alloc;
> > > -	__uint32_t		xs_rmap_2_free;
> > > -	__uint32_t		xs_rmap_2_moves;
> > > +#define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF+__XBTS_MAX)
> > > +	__uint32_t		xs_abtb_2[__XBTS_MAX];
> > > +#define XFSSTAT_END_ABTC_V2		(XFSSTAT_END_ABTB_V2+__XBTS_MAX)
> > > +	__uint32_t		xs_abtc_2[__XBTS_MAX];
> > > +#define XFSSTAT_END_BMBT_V2		(XFSSTAT_END_ABTC_V2+__XBTS_MAX)
> > > +	__uint32_t		xs_bmbt_2[__XBTS_MAX];
> > > +#define XFSSTAT_END_IBT_V2		(XFSSTAT_END_BMBT_V2+__XBTS_MAX)
> > > +	__uint32_t		xs_ibt_2[__XBTS_MAX];
> > > +#define XFSSTAT_END_FIBT_V2		(XFSSTAT_END_IBT_V2+__XBTS_MAX)
> > > +	__uint32_t		xs_fibt_2[__XBTS_MAX];
> > > +#define XFSSTAT_END_RMAP_V2		(XFSSTAT_END_FIBT_V2+__XBTS_MAX)
> > > +	__uint32_t		xs_rmap_2[__XBTS_MAX];
> > 
> > Are you planning to merge this before or after the refcount btree?
> 
> Doesn't matter - either way I'll fix up one of them on merge into
> the for-next tree...
> 
> > 
> > >  #define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RMAP_V2+6)
> > >  	__uint32_t		xs_qm_dqreclaims;
> > >  	__uint32_t		xs_qm_dqreclaim_misses;
> > > @@ -229,26 +165,58 @@ struct xfsstats {
> > >  	__uint64_t		xs_read_bytes;
> > >  };
> > >  
> > > +struct xfsstats {
> > > +	union {
> > > +		struct __xfsstats	s;
> > > +		uint32_t		a[XFSSTAT_END_XQMSTAT];
> > > +	};
> > 
> > /me wonders if there ought to be a build time check to make sure that
> > these two are really the same size?  They look all right as is, but
> > I can see myself forgetting to change something and screwing it up. :(
> 
> It isn't the same size, because struct __xfsstats has three u64
> stats at the end that aren't part of the u32 array indexed by
> XFSSTAT_END_XQMSTAT. If we get the calculation of
> XFSSTAT_END_XQMSTAT wrong , then the output of the stats in the proc
> and sysfs files is screwed up because it treats the stats as an
> array of u32 items of that same size.  So it's fairly obvious when
> it gets broken...

Well ok, how about a build time check that the sizes are off by exactly how
much we expect them to be?  I guess I'd eventually notice the /proc output
looking weird after staring at bad numbers for long enough... ;)

<shrug> Your call though. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
