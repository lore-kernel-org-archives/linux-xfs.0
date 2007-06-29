Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 17:54:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T0sMtL008407
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 17:54:24 -0700
Date: Fri, 29 Jun 2007 10:54:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement ioctl to mark AGs as "don't use/use"
Message-ID: <20070629005417.GF31489@sgi.com>
References: <1182939325.5313.12.camel@localhost> <20070628045049.GF989688@sgi.com> <46838CAE.9030808@linworks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46838CAE.9030808@linworks.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <ruben.porras@linworks.de>
Cc: xfs@oss.sgi.com

On Thu, Jun 28, 2007 at 12:25:50PM +0200, Ruben Porras wrote:
> Ok, thank you for the explanation, I think that now I got it right.
> Attached is a new patch.

Only one minor nit:

> @@ -558,6 +559,17 @@
>  	ASSERT(args->minlen <= args->maxlen);
>  	ASSERT(args->mod < args->prod);
>  	ASSERT(args->alignment > 0);
> +
> +	/*
> +	 * Return an error if the a.g. should not be allocated.
> +	 * This happens normally during a shrink operation.
> +	 */
> +	pag = (args->pag);

Kill the () here.

Otherwise, looks good.

OOC, do you have any test code for this? xfs_io would be the tool to
teach this ioctl to....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
