Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 12:19:13 -0700 (PDT)
Received: from mx1.pretago.de (mx1.pretago.de [89.110.132.151])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7OJJ64p002491
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 12:19:11 -0700
From: Markus Schoder <lists@gammarayburst.de>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_RETURN
Date: Fri, 24 Aug 2007 20:19:04 +0100
References: <200708232109.50780.lists@gammarayburst.de> <20070824014313.GE72985246@sgi.com>
In-Reply-To: <20070824014313.GE72985246@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200708242019.04219.lists@gammarayburst.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Friday 24 August 2007, David Chinner wrote:
> On Thu, Aug 23, 2007 at 09:09:50PM +0100, Markus Schoder wrote:
> > Got a bunch of the below errors in the log. It occured during a
> > Debian upgrade with aptitude. xfs_repair found a lost inode.
>
> Can you post the output of xfs_repair if you still have it? It
> would be handy to correlæte the shutdown to an actual error on
> disk....

Unfortunately I don't have the output anymore. From memory I recall 
there were two messsages indicating problems:

1. A message about rebuilding a directory at inode 128.
2. A lost inode that was moved to lost+found.

Other than that there were only the usual progress messages.

> > Kernel is stock 2.6.22.4 plus CFS patch. This is a 64bit kernel on
> > an amd64 processor.
>
> Hmmmm - so not exactly a stock kernel then. Which of the 19 versions
> the CFS patch was applied? Is it reproducable or only a one-off?
> if it's not a one-off problem, have you seen the problem without the
> CFS patch?

It is version 19.1 and the problem was a one-off never seen it before or 
since.

-- 
Markus
