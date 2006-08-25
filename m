Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Aug 2006 12:46:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7PJkRDW027504
	for <linux-xfs@oss.sgi.com>; Fri, 25 Aug 2006 12:46:30 -0700
Message-ID: <44EF5368.8000007@sandeen.net>
Date: Fri, 25 Aug 2006 14:45:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Files greater than 2TB on 32 bit SLES9 SP3?
References: <9E7A5312-6215-4BF8-9FBC-1F688AC366BB@astro.wisc.edu> <9754D30D-C670-4D71-AB60-BD6152120B63@astro.wisc.edu>
In-Reply-To: <9754D30D-C670-4D71-AB60-BD6152120B63@astro.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephan Jansen <jansen@astro.wisc.edu>
Cc: linux-xfs@oss.sgi.com

Stephan Jansen wrote:
> 
> Hi,
> 
> Can we create file systems of 3TB and individual files larger than
> 2TB on a 32 bit version of SLES9 SP3 using XFS?  If I read the XFS
> project page correctly then this should work but I thought I'd ask
> the list before I try it.  Thanks.
> 

Yes, this should work.  Block device sizes that large will also require 
that your IO stack is clean with CONFIG_LBD, but I'd expect that it is.

XFS itself should not have any problems with this.

-Eric

> -- 
> 
> ----- Stephan
> 
