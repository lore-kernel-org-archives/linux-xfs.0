Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 19:32:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k862WMDW026638
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 19:32:34 -0700
Date: Wed, 6 Sep 2006 12:31:28 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: race in xfs_rename? (fwd)
Message-ID: <20060906023128.GN10950339@melbourne.sgi.com>
References: <20060906083448.J3365803@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060906083448.J3365803@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@xfs.org>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, xfs@oss.sgi.com

On Wed, Sep 06, 2006 at 08:34:48AM +1000, Nathan Scott wrote:
> Hi Roger,
> 
> I'm gonna be rude and fwd your mail to the list - in the hope
> someone there will be able to help you.  I'm running out of time
> @sgi and have a bunch of stuff still to get done before I skip
> outta here - having to look at the xfs_rename locking right now
> might just be enough to make my head explode. ;)
> 
> cheers.
> 
> ----- Forwarded message from Roger Willcocks <roger@filmlight.ltd.uk> -----
> 
> Date: 05 Sep 2006 14:30:30 +0100
> To: nathans@sgi.com
> X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
> From: Roger Willcocks <roger@filmlight.ltd.uk>
> Subject: race in xfs_rename?
> 
> Hi Nathan,
> 
> I think I must be missing something here:
> 
> xfs_rename calls xfs_lock_for_rename, which i-locks the source file and
> directory, target directory, and (if it already exists) the target file.
> 
> It returns a two-to-four entry list of participating inodes.
> 
> xfs_rename unlocks them all, creates a transaction, and then locks them
> all again.
> 
> Surely while they're unlocked, another processor could jump in and
> fiddle with the underlying files and directories?

I don't think that can happen due to i_mutex locking at the vfs layer
i.e. in do_rename() via lock_rename() and in vfs_rename_{dir,other}().
Hence I think it is safe for XFS to do what it does.

FWIW, in Irix where there is no higher layer locking, XFS has extra
checks and locks (ancestor lock, inode generation count checks, etc)
to ensure nothing changed when the locks were dropped and regained.
AFAICT, the Linux XFS code doesn't need to do of this because the VFS
guarantees us that things won't change.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
