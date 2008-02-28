Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Feb 2008 16:32:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1S0WH7u008816
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 16:32:19 -0800
Subject: TAKE 977771 - 
Message-Id: <20080228003236.9050858C4C0F@chook.melbourne.sgi.com>
Date: Thu, 28 Feb 2008 11:32:36 +1100 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

If you mount an XFS filesystem with no mount options at all, then
the "ikeep" option is set rather than "noikeep".

This regression was introduced in 970451. 

With no mount options specified, xfs_parseargs() does the following:

	int			ikeep = 0;

	args->flags |= XFSMNT_BARRIER;
	args->flags2 |= XFSMNT2_COMPAT_IOSIZE;

	if (!options)
		goto done;

It only sets the above two options by default and before, it also used to
set XFSMNT_IDELETE by default.

If options are specified, then

	if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
		args->flags |= XFSMNT_IDELETE;

is executed later on which is skipped by the "goto done;" above.

The solution is to invert the logic.


Date:  Thu Feb 28 11:32:16 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/xaiki/isms/2.6-xfs
Inspected by:  bnaujok,jeffpc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30590a
fs/xfs/xfsidbg.c - 1.345 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.345&r2=text&tr2=1.344&f=h
	- Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.

fs/xfs/xfs_ialloc.c - 1.197 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.197&r2=text&tr2=1.196&f=h
	- Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.

fs/xfs/xfs_vfsops.c - 1.556 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.556&r2=text&tr2=1.555&f=h
	- Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.

fs/xfs/xfs_clnt.h - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_clnt.h.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.

fs/xfs/xfs_mount.h - 1.259 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.259&r2=text&tr2=1.258&f=h
	- Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.

fs/xfs/linux-2.6/xfs_super.c - 1.410 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.410&r2=text&tr2=1.409&f=h
	- Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.
