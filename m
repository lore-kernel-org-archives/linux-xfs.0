Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40146 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeJJWVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 18:21:31 -0400
Received: by mail-wr1-f53.google.com with SMTP id d2-v6so6120006wro.7
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 07:58:57 -0700 (PDT)
Date: Wed, 10 Oct 2018 16:58:53 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: use offsetof() in place of offset macros for
 __xfsstats
Message-ID: <20181010145853.tzel5ymyktsbiln7@odin.usersys.redhat.com>
References: <20181010123708.7632-1-cmaiolino@redhat.com>
 <20181010123708.7632-3-cmaiolino@redhat.com>
 <20181010144932.GO28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010144932.GO28243@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> >  	uint32_t		xs_rmap_2[__XBTS_MAX];
> > -#define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + __XBTS_MAX)
> >  	uint32_t		xs_refcbt_2[__XBTS_MAX];
> > -#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
> >  	uint32_t		xs_qm_dqreclaims;
> >  	uint32_t		xs_qm_dqreclaim_misses;
> >  	uint32_t		xs_qm_dquot_dups;
> >  	uint32_t		xs_qm_dqcachemisses;
> >  	uint32_t		xs_qm_dqcachehits;
> >  	uint32_t		xs_qm_dqwants;
> > -#define XFSSTAT_END_QM			(XFSSTAT_END_XQMSTAT+2)
> >  	uint32_t		xs_qm_dquot;
> >  	uint32_t		xs_qm_dquot_unused;
> >  /* Extra precision counters */
> > @@ -163,10 +139,12 @@ struct __xfsstats {
> >  	uint64_t		xs_read_bytes;
> >  };
> >  
> > +#define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
> 
> Goes past 80 columns, but otherwise looks ok,
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Ops, sorry, I traded readability+tabs X 80 columns, I think changing the tabs
for spaces is enough to fix it.

Do you want me to send it again?

> 
> --D
> 
> 
> > +
> >  struct xfsstats {
> >  	union {
> >  		struct __xfsstats	s;
> > -		uint32_t		a[XFSSTAT_END_XQMSTAT];
> > +		uint32_t		a[xfsstats_offset(xs_qm_dquot)];
> >  	};
> >  };
> >  
> > -- 
> > 2.17.1
> > 

-- 
Carlos
