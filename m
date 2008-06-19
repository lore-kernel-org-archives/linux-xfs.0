Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 21:13:54 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J4Dmnk001955
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 21:13:51 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F05B217E5A72
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 21:14:46 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id gUFA6OCxiaYg4qu8 for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 21:14:46 -0700 (PDT)
Date: Thu, 19 Jun 2008 14:14:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: 2.6.26-rc6 link count mismatch for inode
Message-ID: <20080619041441.GW3700@disturbed>
References: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl> <20080618161252.GV3700@disturbed> <BAY103-DAV10F0AFAC45572E50A384AB2AB0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV10F0AFAC45572E50A384AB2AB0@phx.gbl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jun 18, 2008 at 06:39:59PM +0200, Marco Berizzi wrote:
> Dave Chinner wrote:
> 
> > On Mon, Jun 16, 2008 at 11:11:31AM +0200, Marco Berizzi wrote:
> > > Hi Folk,
> > >
> > > I was tring to compile firefox 3.0rc3
> > > and while I was erasing a previous
> > > /tmp/mozilla tree, I started a new
> > > tar xjf mozilla-blabla.
> > > After a while linux 2.6.26-rc6 was
> > > unresponsive: I have unplugged the
> > > power cable. No problem at startup,
> > > but:
> >
> > What are your mount options?
> 
> root@Venus:/etc# cat mtab
> /dev/sda2 / xfs rw 0 0
> 
> root@Venus:/etc# cat fstab
> /dev/sda2        /                xfs         defaults         1   1

[...]

> XFS mounting filesystem sda2
> Ending clean XFS mount for filesystem: sda2
> VFS: Mounted root (xfs filesystem) readonly.
> 
> > I ask because I've
> > seen this sort of directory corruption before when using volatile
> > write caches and yanking the power....
> >
> > i.e. the corruption could have been caused by the way you reset the
> > system, not because of the hang. Do you have any information on what
> > caused the hang?
> 
> The tar xf mozilla-source.tarball was not responding
> nor writing anything on the disk. I did issue also a
> kill -9 'pid of tar xf' but it did not want to die.
> So I think the problem was on the filesystem before
> the incorrect shutdown.

Yeah, it sounds like the I/O subsystem hung somewhere. Without
details I can't say what went wrong. If it happens again doing
this:

# echo w > /proc/sysrq-trigger

To get a dump of all the blocked processes on the console. That
may contain enough info to tell us what the problem is.

> I can retry the test. Let me know if I can do a
> xfs_repair.

Sure, go ahead and fix it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
