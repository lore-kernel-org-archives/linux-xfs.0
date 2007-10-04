Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 23:22:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l946M8tl021452
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 23:22:11 -0700
Date: Thu, 4 Oct 2007 16:21:59 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: fix infinite loop in bulkstat
Message-ID: <20071004062159.GN995458@sgi.com>
References: <4704780C.2020100@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4704780C.2020100@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 04, 2007 at 03:20:12PM +1000, Lachlan McIlroy wrote:
> This fix prevents bulkstat from spinning in an infinite loop.
> 
> Here 'agino' increments through the inodes in an allocation group.
> At the end of the innermost 'for' loop it will hold the value of the
> next inode to look at (ie the first inode in the next cluster/chunk).
> Assigning 'lastino' to 'agino' resets it to the last inode in the
> last inode cluster we just looked at.  This causes us to look up
> the very same cluster and examine all the inodes all over again,
> and again, and again...
> 
> We also want to set 'lastino' for the cases when we're not interested
> in the inode so that the next call to bulkstat wont re-examine the
> same uninteresting inodes.

Looks OK. I think you shoul dalso add a comment to the effect that
lastino needs to be set before continuing to process the next inode
in the loop so it doesn't get forgotten next time someone modifies
the code inside the loop..

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
