Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 22:17:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S5Hcpq017111
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:17:38 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 998A613130B6
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:17:37 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id hiWTQLCZgpWmF24a for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 22:17:37 -0700 (PDT)
Date: Tue, 28 Oct 2008 16:17:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] sanitize xlog_in_core_t definition
Message-ID: <20081028051734.GC17077@disturbed>
References: <20081027133907.GD1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133907.GD1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:07AM -0400, Christoph Hellwig wrote:
> Move all fields from xlog_iclog_fields_t into xlog_in_core_t instead of having
> them in a substructure and the using #defines to make it look like they were
> directly in xlog_in_core_t.  Also document that xlog_in_core_2_t is grossly
> misnamed, and make all references to it typesafe.
> 
> (First sent on Semptember 15th)

Couple of things.

> @@ -361,41 +371,11 @@ typedef struct xlog_iclog_fields {
>  
>  	/* reference counts need their own cacheline */
>  	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
> -} xlog_iclog_fields_t;
> -
> -typedef union xlog_in_core2 {
> -	xlog_rec_header_t	hic_header;
> -	xlog_rec_ext_header_t	hic_xheader;
> -	char			hic_sector[XLOG_HEADER_SIZE];
> -} xlog_in_core_2_t;
> -
> -typedef struct xlog_in_core {
> -	xlog_iclog_fields_t	hic_fields;
> -	xlog_in_core_2_t	*hic_data;
> +	xlog_in_core_2_t	*ic_data;
> +#define ic_header	ic_data->hic_header
>  } xlog_in_core_t;

The ic_data pointer should not be on the same cacheline as the
reference count seeing as it is read-only field.

Otherwise seems ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
