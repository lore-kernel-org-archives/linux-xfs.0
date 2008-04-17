Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Apr 2008 20:51:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3H3pAB3008745
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 20:51:13 -0700
Date: Thu, 17 Apr 2008 13:51:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: oss git tree busted....
Message-ID: <20080417035144.GU108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan,

Looks like the last update fom the ptools tree missed a bunch of mods.

This (log of all changes with fs/xfs):

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=history;f=fs/xfs;hb=HEAD

Shows:

  6 days ago  Eric Sandeen  [XFS] Ensure "both" features2 slots are consistent
  6 days ago  David Chinner  [XFS] Fix superblock features2 field alignment problem
  6 days ago  Eric Sandeen  [XFS] remove shouting-indirection macros from xfs_sb.h
  7 days ago  David Chinner  [XFS] Catch log unmount failures.
  7 days ago  David Chinner  [XFS] Sanitise xfs_log_force error checking.
  7 days ago  David Chinner  [XFS] Check for errors when changing buffer pointers.
  7 days ago  David Chinner  [XFS] Don't allow silent errors in xfs_inactive().
  7 days ago  David Chinner  [XFS] Catch errors from xfs_imap().
  7 days ago  David Chinner  [XFS] xaiki@sgi.com xfs_bulkstat_one_dinode() never ...
  7 days ago  David Chinner  [XFS] xfs_iflush_fork() never returns an error.
  7 days ago  David Chinner  [XFS] Catch unwritten extent conversion errors.
  7 days ago  David Chinner  [XFS] xfs_bdwrite() does not return errors.
....

It appears that most of the error checking changes I made have been
pushed. Note that there's an error in one fo the titles that the
scripts have not caught (the reviewers email address!). Can you fix
this commit up?

However the real problem is that there are several mods that have
not been pushed:

	xfs-linux-melb:xfs-kern:30836a
	xfs-linux-melb:xfs-kern:30838a
	xfs-linux-melb:xfs-kern:30845a

These are fixes to my original series, and without them you
cannot mount an XFS filesystem at all. Can you please push these
to the git tree ASAP?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
