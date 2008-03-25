Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 15:25:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PMOr2m005972
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 15:24:55 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D51286E9726
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 15:25:27 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id j4WB6RUtXNmjLkS1 for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 15:25:27 -0700 (PDT)
Date: Tue, 25 Mar 2008 17:36:58 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 1/1] Documentation: correct XFS defaults for
	ikeep/noikeep mount options
Message-ID: <20080325213658.GB20257@josefsipek.net>
References: <1203316358-31840-1-git-send-email-jeffpc@josefsipek.net> <20080222041036.GA24091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222041036.GA24091@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 21, 2008 at 11:10:36PM -0500, Christoph Hellwig wrote:
> Looks good to me.

Any word on this critical patch? ;)

Josef 'Jeff' Sipek.

> On Mon, Feb 18, 2008 at 01:32:38AM -0500, Josef 'Jeff' Sipek wrote:
> > Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> > ---
> >  Documentation/filesystems/xfs.txt |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> > index 74aeb14..655bdfe 100644
> > --- a/Documentation/filesystems/xfs.txt
> > +++ b/Documentation/filesystems/xfs.txt
> > @@ -59,9 +59,10 @@ When mounting an XFS filesystem, the following options are accepted.
> >  
> >    ikeep/noikeep
> >  	When inode clusters are emptied of inodes, keep them around
> > -	on the disk (ikeep) - this is the traditional XFS behaviour
> > -	and is still the default for now.  Using the noikeep option,
> > -	inode clusters are returned to the free space pool.
> > +	on the disk (ikeep) - this is the traditional XFS behaviour.
> > +	Using the noikeep option, inode clusters are returned to the
> > +	free space pool. noikeep is the default for non-DMAPI mounts,
> > +	while ikeep is the default when DMAPI is in use.
> >  
> >    inode64
> >  	Indicates that XFS is allowed to create inodes at any location
> > -- 
> > 1.5.4.rc2.85.g9de45-dirty
> > 
> > 
> ---end quoted text---
> 

-- 
A CRAY is the only computer that runs an endless loop in just 4 hours...
