Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 14:51:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SLpFXd002247
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:51:15 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94F7B55538B
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:51:12 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id izciBG3dFh4DMLM4 for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 14:51:12 -0700 (PDT)
Date: Wed, 29 Oct 2008 08:51:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] sanitize xlog_in_core_t definition
Message-ID: <20081028215111.GZ4985@disturbed>
References: <20081027133907.GD1109@infradead.org> <20081028051734.GC17077@disturbed> <20081028091614.GC1662@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028091614.GC1662@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Oct 28, 2008 at 05:16:14AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 28, 2008 at 04:17:34PM +1100, Dave Chinner wrote:
> > > -typedef union xlog_in_core2 {
> > > -	xlog_rec_header_t	hic_header;
> > > -	xlog_rec_ext_header_t	hic_xheader;
> > > -	char			hic_sector[XLOG_HEADER_SIZE];
> > > -} xlog_in_core_2_t;
> > > -
> > > -typedef struct xlog_in_core {
> > > -	xlog_iclog_fields_t	hic_fields;
> > > -	xlog_in_core_2_t	*hic_data;
> > > +	xlog_in_core_2_t	*ic_data;
> > > +#define ic_header	ic_data->hic_header
> > >  } xlog_in_core_t;
> > 
> > The ic_data pointer should not be on the same cacheline as the
> > reference count seeing as it is read-only field.
> 
> Makes sense, but I'll leave that for a separate patch to keep things
> bisectable.

ok.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
