Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 21:02:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6442SEe013458
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 21:02:28 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4387DA25BA
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 21:03:30 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id O75QAt5Cj2EK0LMP for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 21:03:30 -0700 (PDT)
Date: Fri, 4 Jul 2008 14:03:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: user defined cache
Message-ID: <20080704040315.GD29319@disturbed>
References: <1215139205.7187.33.camel@quadski>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215139205.7187.33.camel@quadski>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Warwick Boote <wboote@civica.com.au>
Cc: xfs@oss.sgi.com

On Fri, Jul 04, 2008 at 12:40:05PM +1000, Warwick Boote wrote:
> Hi all,
> 
> Do you know of setting or layered file system that enables me to define
> a large buffer in main memory and cache writes to this buffer?

I know there's wrapper libraries that do this - like FFIO -
but I don't think there's a free one.

However, why doesn't the page cache do what you want already?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
