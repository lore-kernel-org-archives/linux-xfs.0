Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Oct 2007 01:54:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l998sHSr031928
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2007 01:54:19 -0700
Date: Tue, 9 Oct 2007 18:54:12 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH V2] Ensure sync flushes all dirty data to disk]
Message-ID: <20071009085412.GT23367404@sgi.com>
References: <470B2EEC.5020906@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470B2EEC.5020906@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 09, 2007 at 05:34:04PM +1000, Lachlan McIlroy wrote:
> [V2 adds a comment for dgc]
> 
> In xfs_fs_sync_super() treat a sync the same as a filesystem freeze.
> This is needed to force the log to disk for inodes which are not marked
> dirty in the Linux inode (the inodes are marked dirty on completion of
> the log I/O) and so sync_inodes() will not flush them.
> 
> In xfs_fs_write_inode() a synchronous flush will not get an EAGAIN
> from xfs_inode_flush() and if an asynchronous flush returns EAGAIN
> we should pass it on to the caller.  If we get an error while flushing
> the inode then re-dirty it so we can try again later.

Looks good now, Lachlan.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
