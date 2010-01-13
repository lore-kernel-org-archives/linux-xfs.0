Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D8AmaD134205 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 02:10:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBF781C4992B
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 00:11:43 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	P7ppP21mJNhuSyoz for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 00:11:43 -0800 (PST)
Date: Wed, 13 Jan 2010 19:11:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [TuxOnIce-devel] Latest updates.
Message-ID: <20100113081140.GO17483@discord.disaster>
References: <20100113054152.GL17483@discord.disaster>
	<99724068.1731191263362718752.JavaMail.root@mail-au.aconex.com>
	<20100113065740.GN17483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100113065740.GN17483@discord.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nscott@aconex.com>
Cc: TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>, xfs@oss.sgi.com

On Wed, Jan 13, 2010 at 05:57:40PM +1100, Dave Chinner wrote:
> On Wed, Jan 13, 2010 at 05:05:18PM +1100, Nathan Scott wrote:
> > [Looks like tuxonice is a subscriber-only list...]
> > 
> > ----- "Dave Chinner" <david@fromorbit.com> wrote:
> > 
> > > On Wed, Jan 13, 2010 at 02:09:14PM +1100, Nathan Scott wrote:
> > > > > 
> > > Agreed that it is trivial to implement but there are still some
> > > definite traps - like the fact the sb change transaction may be
> > > logged
> > > immediately but the physical superblock may not get written for some
> > > time after the mount.
> > 
> > *nod* ... it will be written when unmounted though...
> 
> suspend in the kernel doesn't unmount filesystems. I have no idea
> what tuxonice does these days, but last time I heard it left them
> mounted but frozen over the suspend/resume cycle.

I found the code - it doesn't unmount filesystems. The git tree is
here:

http://git.kernel.org/?p=linux/kernel/git/nigelc/tuxonice-head.git;a=summary

It appears that it walks the list of superblocks to grab the block
device off each mounted superblock to do it's work, so I don't see
any fundamental problem with using an attribute hanging off
sb->s_root to hold the boot time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
