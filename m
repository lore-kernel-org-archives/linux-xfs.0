Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Oct 2007 16:08:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9JN8O3X023057
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2007 16:08:25 -0700
Date: Sat, 20 Oct 2007 09:08:15 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: implement fallocate V2
Message-ID: <20071019230815.GK66820511@sgi.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070716053751.GN12413810@sgi.com> <4718F2EF.9050808@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4718F2EF.9050808@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 19, 2007 at 01:09:51PM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> > Initial implementation of ->fallocate for XFS.
> > 
> > Version 2:
> > 
> > o Make allocation and setting the file size atomic.
> > o Drop deallocate/punch functionality
> > o use mode field appropriately to determine if size needs changing.
> > 
> 
> Dave, I don't see this in CVS or in git.  Did it get lost and/or abandoned?

lost. I don't think I got a review of it, and I got swamped in other stuff
at about the same time.... I'll look at it monday.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
