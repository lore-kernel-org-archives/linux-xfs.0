Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48886 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbeJJWYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 18:24:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9AEx0EG025086
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 15:02:17 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mxnpr4j27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 15:02:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9AF2Bbq014836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 15:02:12 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9AF2BRl032161
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 15:02:11 GMT
Date: Wed, 10 Oct 2018 08:02:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: use offsetof() in place of offset macros for
 __xfsstats
Message-ID: <20181010150210.GQ28243@magnolia>
References: <20181010123708.7632-1-cmaiolino@redhat.com>
 <20181010123708.7632-3-cmaiolino@redhat.com>
 <20181010144932.GO28243@magnolia>
 <20181010145853.tzel5ymyktsbiln7@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010145853.tzel5ymyktsbiln7@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 04:58:53PM +0200, Carlos Maiolino wrote:
> > >  	uint32_t		xs_rmap_2[__XBTS_MAX];
> > > -#define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + __XBTS_MAX)
> > >  	uint32_t		xs_refcbt_2[__XBTS_MAX];
> > > -#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
> > >  	uint32_t		xs_qm_dqreclaims;
> > >  	uint32_t		xs_qm_dqreclaim_misses;
> > >  	uint32_t		xs_qm_dquot_dups;
> > >  	uint32_t		xs_qm_dqcachemisses;
> > >  	uint32_t		xs_qm_dqcachehits;
> > >  	uint32_t		xs_qm_dqwants;
> > > -#define XFSSTAT_END_QM			(XFSSTAT_END_XQMSTAT+2)
> > >  	uint32_t		xs_qm_dquot;
> > >  	uint32_t		xs_qm_dquot_unused;
> > >  /* Extra precision counters */
> > > @@ -163,10 +139,12 @@ struct __xfsstats {
> > >  	uint64_t		xs_read_bytes;
> > >  };
> > >  
> > > +#define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
> > 
> > Goes past 80 columns, but otherwise looks ok,
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ops, sorry, I traded readability+tabs X 80 columns, I think changing the tabs
> for spaces is enough to fix it.
> 
> Do you want me to send it again?

<shrug> If Dave elects to fix it on the way in that's fine with me.

Though I guess so long as I'm being pedantic about things that 'f' ought
to be parentheses-wrapped too, e.g.

#define xfsstats_offset(f) (offsetof(struct __xfsstats, (f)) / sizeof(uint32_t))

--D

> > 
> > --D
> > 
> > 
> > > +
> > >  struct xfsstats {
> > >  	union {
> > >  		struct __xfsstats	s;
> > > -		uint32_t		a[XFSSTAT_END_XQMSTAT];
> > > +		uint32_t		a[xfsstats_offset(xs_qm_dquot)];
> > >  	};
> > >  };
> > >  
> > > -- 
> > > 2.17.1
> > > 
> 
> -- 
> Carlos
