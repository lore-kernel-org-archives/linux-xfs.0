Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 15:30:36 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1SNUPDS032464
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 15:30:29 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 726BAEECB81
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 15:30:53 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id lJb3ab1KmGyIU0lZ for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 15:30:53 -0800 (PST)
Date: Fri, 29 Feb 2008 00:30:48 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, mainline-only] remove dmapi cruft in xfs_file.c
Message-ID: <20080228233047.GA29818@lst.de>
References: <20080208044405.GB15013@lst.de> <47C73849.3090406@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C73849.3090406@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Feb 28, 2008 at 04:40:09PM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > The dmapi cruft in xfs_file.c is totally out of date in mainline vs
> > CVS, and at this point just removing this code which can't be used on
> > mainline at all seems to be the best option to keep it maintainable.
> 
> When doing this should probably whack the:
> 
> #ifdef HAVE_FOP_OPEN_EXEC
>         .open_exec      = xfs_file_open_exec,
> #endif
> 
> from xfs_file_operations, too?

Yes,  but no urgeny for now as we've missed the .25 window anyway.
