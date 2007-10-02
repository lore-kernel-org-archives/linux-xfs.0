Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 02:25:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l929PHYa027363
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 02:25:24 -0700
Date: Tue, 2 Oct 2007 19:25:10 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Creation time in XFS
Message-ID: <20071002092509.GF995458@sgi.com>
References: <200709302124.38164.Martin@lichtvoll.de> <470042DC.2040009@sgi.com> <p73ve9r6v3a.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ve9r6v3a.fsf@bingen.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: Timothy Shimmin <tes@sgi.com>, Martin Steigerwald <Martin@lichtvoll.de>, xfs@oss.sgi.com

On Mon, Oct 01, 2007 at 11:30:01AM +0200, Andi Kleen wrote:
> Timothy Shimmin <tes@sgi.com> writes:
> 
> > No XFS does not support creation time. It just has the regular
> > atime,mtime and ctime.
> > There are no plans that I've heard to support it.
> > Not much involved to support it AFAICT but it would either involve
> > changing the ondisk format of the inode or storing it in an EA.
> 
> If you ever change the on disk format adding a file type similar to ext3
> to directories could also greatly speed up find in many cases.

Sure, but that's the directory structure, not inode structure.
They have different versioning methods, and so can be modified
independently.

FWIW, I haven't forgotten abou thtis request, Andi ;) I'll be
modifying the directory structure for CRCs relatively soon, and I
plan to do that modification at the same time so I only need a
single version bump for both....

> > I wonder how this creation time is being exported currently?
> 
> I don't think it is at all currently:

So what is the point? Forensic analysis?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
