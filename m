Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Mar 2008 22:28:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2U5SWFT008179
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 22:28:34 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 309D670BFEC
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 22:29:07 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id iwDV3Sr6XVu4hPb6 for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 22:29:07 -0700 (PDT)
Date: Sun, 30 Mar 2008 01:29:07 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [patch] detect and correct bad features2 superblock field
Message-ID: <20080330052907.GB26934@josefsipek.net>
References: <20080220054041.GM155407@sgi.com> <47EEED18.9090206@sandeen.net> <20080330045014.GA26934@josefsipek.net> <47EF1CD4.7070009@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EF1CD4.7070009@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, Mar 29, 2008 at 11:53:40PM -0500, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> > On Sat, Mar 29, 2008 at 08:30:00PM -0500, Eric Sandeen wrote:
> 
> >> Hm, the other problem here may be that if we zero bad_features2, then
> >> any older kernel will mount up as attr2... and run into the corruption
> >> problem I found on F8...
> >>
> >> Should we make features2 and bad_features2 match rather than zeroing
> >> bad_features2?
> > 
> > I thought that was discussed here (or was it on IRC?), and the conclusion
> > was the best way is to always have features2 == bad_features2.  It is the
> > safest way to handle things - the filesystem is guaranteed to work
> > everywhere properly (old & new kernels).  Both the userspace (xfs_repair)
> > and kernel have to of course do the same thing (or bad_features2 with
> > features2, and save the result in both locations).
> > 
> > At least that's what I seem to remember.
> > 
> > Josef 'Jeff' Sipek.
> > 
> 
> It might have been, but it's not what was checked in... *shrug*
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c#rev1.419

I remember the discussion taking place _after_ that commit..so it must have
been userspace-related.

Josef 'Jeff' Sipek.

-- 
I'm somewhere between geek and normal.
		- Linus Torvalds
