Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 06:10:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9EDA3gL024116
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 06:10:04 -0700
Date: Tue, 14 Oct 2008 15:11:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: fw: [PATCH] fix instant oops with tracing enabled
Message-ID: <20081014131140.GB17351@lst.de>
References: <20081013223932.GE10716@disturbed> <48F3EA6F.9000209@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F3EA6F.9000209@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs@oss.sgi.com, hch@lst.de

On Tue, Oct 14, 2008 at 10:40:15AM +1000, Mark Goodwin wrote:
> Lachlan also saw some regressions after merging these patchsets :
> . replace the mount inode list with radix tree traversals
> . clean up sync code

What exactly?  I saw some softlookup in 042, but when applying Dave's
xfs_sync_inodeS_ag fix (or the hal of it applying without the del inodes
tracking in the radix tree) it goes away.

> >If that
> >series is going to be included in the current round of checkins
> >then this patch probably isn't needed.
> 
> The agreed plan for 2.6.28 still has the following patchsets to go in:
> 
> . Combine the XFS and Linux inode structures V2
> . Track reclaimable inodes in inode cache
> . AIL cleanup and bug fixes
> . Account for allocated blocks when expanding directories
> . Check for valid transaction headers in recovery
> . fix remount rw with unrecognized options


3-6 are small bug fixes and should go in ASAP.  I'd really like to see 1
and 2 and volunter to help sorting out any fallout.  Not entirely sure
about the AIL patches - they seem ready but at least they don't have
much impact on everything else.   So if you really want to reduce the
amount of patches those would be the ones.
