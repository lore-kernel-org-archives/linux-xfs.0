Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Apr 2008 14:29:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3TLT55r028714
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 14:29:07 -0700
Date: Wed, 30 Apr 2008 07:29:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: s/i_flags_lock/i_inner_lock/g
Message-ID: <20080429212942.GQ108924158@sgi.com>
References: <4816AEEB.8090907@sgi.com> <20080429053757.GA30708@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429053757.GA30708@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 29, 2008 at 01:37:57AM -0400, Christoph Hellwig wrote:
> On Tue, Apr 29, 2008 at 03:15:23PM +1000, Timothy Shimmin wrote:
> > Hi there,
> >
> > As part of future plans to cache incore versions of acls
> > off the inode, we want to protect its modification by a spin lock.
> > Dave suggested that we use the i_flags_lock but rename it to
> > reflect its more general purpose on other fields, such as "i_inner_lock".
> > This patch is then basically s/i_flags_lock/i_inner_lock/g.
> 
> Not too happpy about that, as I'd rather kill this lock in it's current
> form and use atomic bitops on the flags.  I'd rather use i_lock in the
> Linux inode for the ACLs.

The problem with that is that some of the flags work together and can't
be used as separate bitops. eg. xfs_finish_reclaim() and xfs_iget_core().
Hence they currently need to be protected by a spinlock.

Also, protecting something in the XFs inode with the linux inode lock
could have issues with the lifecycle differences between the inodes.
Just something to be careful of....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
