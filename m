Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 18:42:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6I1gHbm029587
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 18:42:20 -0700
Date: Wed, 18 Jul 2007 11:41:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [Advocacy] Re: 3ware 9650 tips
Message-ID: <20070718014150.GW12413810@sgi.com>
References: <582908739-1184695294-cardhu_decombobulator_blackberry.rim.net-122921225-@bxe015.bisx.prod.on.blackberry> <469D24A6.6080409@mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <469D24A6.6080409@mandriva.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Giuseppe =?iso-8859-1?Q?Ghib=F2?= <ghibo@mandriva.com>
Cc: b.j.smith@ieee.org, Simon Matter <simon.matter@invoca.ch>, Stuart Levy <slevy@ncsa.uiuc.edu>, Joshua Baker-LePain <jlb17@duke.edu>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com

On Tue, Jul 17, 2007 at 10:20:54PM +0200, Giuseppe Ghibò wrote:
> Indeed XFS is a lot faster than ext3 on many task (e.g.
> copy/moving or delete huge files o creating filesystems or dumping
> with xfsdump), and worked fine, until linux kernels around
> 2.6.15|16|17|18 when it had serious problems about data
> corruptions.

<sigh>

I don't mind advocacy, but misleading FUD about filesystem
corruption, regardless of filesystem type, is *not acceptable* in
any forum.

So, to set the record straight, the only XFS corruption I know of in the
releases you mention above is this:

http://oss.sgi.com/projects/xfs/faq.html#dir2

Which was introduced in 2.6.17-rc1 and fixed in 2.6.18-rc2 (IIRC).i
The only released kernels affected are 2.6.17.0-6. i.e. it was fixed
in 2.6.17.7.

And in the interest of full disclosure, there was another in 2.6.19 (IIRC)
to do with a brand new feature that nobody used (the attr2 bug) - until
it was enabled by default on Fedora and the installer tripped over
it - that was fixed in 2.6.20.

If you know of more, then where are the bug reports?

> Furthermore when you run xfs_repair to fix such errors, you find that it lost
> all the directory names, and places restored files into "random" dirs
> named with "number" names.

Please, a little research would tell you what these mean.

When you lose directory entries on a filesystem for *any* reason,
you'll end up with files named by *inode number* placed in
lost+found because they are guaranteed to be unique.  The names and
the structure that end up in lost+found are certainly not random
and it's not just XFS that does this. e.g. ext2/3/4 does this, too [1]:

"Some of the directory and files may not pop-up at their right
places. Instead they will be located in /lost+found with names after
their inode numbers."

[1] trivial google search "e2fsck lost+found" points to
http://tldp.org/HOWTO/archived/Ext2fs-Undeletion-Dir-Struct/lostnfnd.html

> See for instance:
> 
> http://lkml.org/lkml/2006/8/4/97
> http://lkml.org/lkml/2006/8/28/88

A kernel panic in 2.6.18-rc3/5 due to a bad error handling path that
nobody had hit - or, more correctly, reported - for a couple of
years. This is not a filesystem corrupting bug.

> or http://qa.mandriva.com/show_bug.cgi?id=24716

"------- Comment #3 From Thomas Backlund 2006-08-25 09:32:46 CEST ------- 
What you are hitting is a bug I tried to warn about before releasing 2007b1,
namely kernel.org-2.6.17.6 had a nasty xfs bug, wich mdv 2.6.17.1mdv was based
on, and I tried to point out before beta1 was released that 2.6.17.7 was out
and had this fixed, but no-one with powers to do anything listened..."

And yes, I can see that you raised this bug. I'm sorry that were
affected by this bug, but in reality you should be complaining to
your kernel release team who released a kernel with known serious
corruption bug that they'd been pre-warned about.

IOWs, your evidence points to one data corruption that only affected
2.6.17.0-2.6.17.6 and you *already knew this*. How does this
translate into data corruption problems that span four whole kernel
releases?

Hence in future can you please try to stick to facts as filesystem
corruption is something that we take extremely seriously.

> Also in the recent 2.6.20|21 kernel series I found it has serious
> problems of performance, especially when used in softraid (e.g.
> for storing the vmware huge filedisks images a simple "sync" takes
> fifteen minutes in a raid1).

Where's the bug report? We can't fix what we don't know about.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
