Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Mar 2007 00:54:11 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l278s46p017851
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 00:54:06 -0800
Date: Wed, 7 Mar 2007 08:27:53 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] get rid of fname[] for tracing functions
Message-ID: <20070307082753.GA5469@infradead.org>
References: <45EE2EF3.8090707@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EE2EF3.8090707@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Mar 06, 2007 at 09:18:11PM -0600, Eric Sandeen wrote:
> this gets rid of the
> 
> #ifdef XFS_BMAP_TRACE
>        static char             fname[] = "xfs_iextents_copy";
> #endif
> 
> ugliness littered in the bmap code for tracing, and instead just uses 
> gcc's __FUNCTION__, which never gets out of sync with the actual 
> function name....
> 
> It also makes some of this tracing more consistently use the
> 
> #define        XFS_BMBT_TRACE_ARGBI(c,b,i)     \
>        xfs_bmbt_trace_argbi(__FUNCTION__, c, b, i, __LINE__)
> 
> type constructs, to automatically pick up the gcc extensions.

Very nice.  I might hear some people to scream that we should use
the C99 __func__ and not the __FUNCTION__ gccism, but __FUNCTION__
is what the rest of the Linux kernel uses, and can be emulated with
a trivial

	#define __func__ __FUNCTION__

on any non-gcc C99 system.

> the vn tracing could probably get a similar treatment, so that every 
> call to vn_trace_foo wouldn't have to include a function name and a 
> __builtin_return_address, but could be done via macros... it's currently 
> a mishmash of __FUNCTION__ and "function" *shrug* what do you think?

It should probably use __FUNCTION__ and hide use of both __FUNCTION__
and __builtin_return_address behind a macro.
