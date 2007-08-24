Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 18:43:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O1hN4p003091
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 18:43:24 -0700
Date: Fri, 24 Aug 2007 11:43:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_RETURN
Message-ID: <20070824014313.GE72985246@sgi.com>
References: <200708232109.50780.lists@gammarayburst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708232109.50780.lists@gammarayburst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Markus Schoder <lists@gammarayburst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:09:50PM +0100, Markus Schoder wrote:
> Got a bunch of the below errors in the log. It occured during a Debian
> upgrade with aptitude. xfs_repair found a lost inode.

Can you post the output of xfs_repair if you still have it? It
would be handy to correlæte the shutdown to an actual error on
disk....

> Kernel is stock 2.6.22.4 plus CFS patch. This is a 64bit kernel on an
> amd64 processor.

Hmmmm - so not exactly a stock kernel then. Which of the 19 versions
the CFS patch was applied? Is it reproducable or only a one-off?
if it's not a one-off problem, have you seen the problem without the
CFS patch?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
