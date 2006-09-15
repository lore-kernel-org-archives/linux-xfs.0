Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Sep 2006 22:09:28 -0700 (PDT)
Received: from asteria.debian.or.at (asteria.debian.or.at [86.59.21.34])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8F59IZd009014
	for <xfs@oss.sgi.com>; Thu, 14 Sep 2006 22:09:19 -0700
Date: Fri, 15 Sep 2006 05:10:21 +0200
From: Peter Palfrader <peter@palfrader.org>
Subject: Re: Bug#387057: xfsprogs: repeated xfs_repair does not fix the filesystem
Message-ID: <20060915031021.GT5221@asteria.noreply.org>
References: <87zmd4jdzz.fsf@tac.ki.iif.hu> <200609140157.LAA22186@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200609140157.LAA22186@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: 387057@bugs.debian.org

On Thu, 14 Sep 2006, Barry Naujok wrote:

> > Still, xfs_check reported:
> > => link count mismatch for inode 400254 (name ?), nlink 0, counted 2
> > => link count mismatch for inode 4239409 (name ?), nlink 0, counted 2
> > => link count mismatch for inode 8388736 (name ?), nlink 39, 
> > counted 38
> > 
> > Further runs of xfs_repair didn't bring any change.  On the root
> > filesystem the results are much the same, but xfs_check reports:
> > => sb_ifree 3042, counted 3041
> > 
> > I read that xfs_check is being obsoleted in the future, but not sure
> > which program to trust.  Are my filesystems healthy or not?
> 
> This has been reported before, can you try running an older xfsprogs before
> 2.8.10 and see how that goes? I think with the dir2 fixes, the nlink stuff
> might be a tad broken. I'll also look into it from my end.


I have just had a similar problem.  xfs_repair 2.8.11 did its stuff,
moving a few items into lost+found in the process.  After mounting,
trying to rmdir the directories under lost+found the filesystem was shut
down immediately again:

| [  434.590246] Ending clean XFS mount for filesystem: md0
| [  447.677811] xfs_inotobp: xfs_imap()  returned an error 22 on md0.  Returning error.
| [  447.678090] xfs_iunlink_remove: xfs_inotobp()  returned an error 22 on md0.  Returning error.
| [  447.678383] xfs_inactive:    xfs_ifree() returned an error = 22 on md0
| [  447.678605] xfs_force_shutdown(md0,0x1) called from line 1763 of file fs/xfs/xfs_vnodeops.c.  Return address = 0xffffffff803ca50a
| [  447.678986] Filesystem "md0": I/O Error Detected.  Shutting down filesystem: md0

Downgrading xfsprogs to 2.6.20 solves the issue:

} [...]
} Phase 7 - verify and correct link counts...
} resetting inode 789921 nlinks from 0 to 2
} resetting inode 4290022 nlinks from 0 to 2
} resetting inode 4290023 nlinks from 0 to 2
} resetting inode 4290024 nlinks from 0 to 2
} resetting inode 4290025 nlinks from 0 to 2
} [..]
} resetting inode 59501189 nlinks from 0 to 2
} resetting inode 63698112 nlinks from 0 to 2
} resetting inode 63698118 nlinks from 0 to 2
} done

Now my filesystem appears functional again.  If you need any more info,
I still have an image of the filesystem prior to the treatment with
2.6.20.

Cheers,
Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
