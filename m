Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 17:15:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l980F1oi015789
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 17:15:03 -0700
Date: Mon, 8 Oct 2007 10:14:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error
Message-ID: <20071008001452.GX995458@sgi.com>
References: <470831E6.4030704@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470831E6.4030704@fastmail.co.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Max Waterman <davidmaxwaterman+kernel@fastmail.co.uk>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[please cc xfs@oss.sgi.com on XFS bug reports. thx.]

On Sun, Oct 07, 2007 at 09:09:58AM +0800, Max Waterman wrote:
> Hi,
> 
> I have just had an XFS error occur while deleting some directory
> hierarchy. I hope this is the correct place to report it.

.....
> This is in syslog :
> 
> > Oct  6 23:40:33 jeeves kernel: xfs_da_do_buf: bno 16777216
                                                  ^^^^^^^^^^^^^
> > Oct  6 23:40:33 jeeves kernel: dir: inode 2095141277
> > Oct  6 23:40:33 jeeves kernel: Filesystem "md2": XFS internal error xfs_da_do_buf(1) at line 1994 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff889b2de4

Did you ever run 2.6.17-2.6.17.6? If so, this implies:

http://oss.sgi.com/projects/xfs/faq.html#dir2

> I am fairly sure there is nothing I can do about this, but I thought it
> prudent to mention it. Searching turned up some similar issues, but they
> seem related to a previous kernel version and claimed to be fixed in
> subsequent versions.

Yes, but those previous corruptions get left on disk as a landmine
for you to trip over some time later, even on a kernel that has the
bug fixed.

I suggest that you run xfs_check on the filesystem and if that
shows up errors, run xfs_repair onteh filesystem to correct them.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
