Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 15:22:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VMMWCk026792
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:22:32 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0B7F14C408D
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:22:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id F5aqCPX4bOv43i5X for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:22:33 -0700 (PDT)
Date: Fri, 31 Oct 2008 18:22:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031222232.GB29761@infradead.org>
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org> <20081031001249.GM4985@disturbed> <20081031203123.GA11514@infradead.org> <20081031215430.GB19509@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031215430.GB19509@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 08:54:30AM +1100, Dave Chinner wrote:
> Effectively, yes. 
> 
> Currently we iterate inodes for data and "metadata" sync, and the
> only other concept is writing superblocks. I think most filesystems
> have more types of metadata than this, so it makes sense for sync to
> work on abstracts sync as data and metadata rather than data, inodes
> and superblocks...

Yes, absolutely.  And for those that have inodes as primary / only
metadata besides superblock we can still provide a generic_sync_inodes
helper that just takes a callback to apply to every inode.  Which we
probably want anyway as XFS is the only intree-filesystem that currently
has a more efficient way to iterate inodes.

> > And as we found out it's not just sync that gets it wrong, it's also
> > fsync (which isn't part of the above picture as it's per-inode) that
> > gets this utterly wrong, as well as all kinds of syncs, not just the
> > unmount one.
> 
> Async writeback (write_inode()) has the same problem as fsync -
> writing the inode before waiting for data I/O to complete - which
> means we've got to jump through hoops in the filesystem to avoid
> blocking on inodes that can't be immediately flushed, and often we
> end up writing the inode multiple times and having to issue log
> forces whenw e shouldn't need to. Effectively we have to tell the
> VFS to "try again later" the entire time data is being flushed
> before we can write the inode and it's exceedingly inefficient.....

Yes, that was the couple of sync functions I meant above as the whole
inode writeback path is extremly convoluted - mostly due to the dirty
data vs metadata mixup mess.
