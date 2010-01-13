Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D6uo5Y128954 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 00:56:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BD02124783F
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 22:57:43 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	WGZbHPirmEZJUZ19 for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2010 22:57:43 -0800 (PST)
Date: Wed, 13 Jan 2010 17:57:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [TuxOnIce-devel] Latest updates.
Message-ID: <20100113065740.GN17483@discord.disaster>
References: <20100113054152.GL17483@discord.disaster>
	<99724068.1731191263362718752.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <99724068.1731191263362718752.JavaMail.root@mail-au.aconex.com>
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

On Wed, Jan 13, 2010 at 05:05:18PM +1100, Nathan Scott wrote:
> [Looks like tuxonice is a subscriber-only list...]
> 
> ----- "Dave Chinner" <david@fromorbit.com> wrote:
> 
> > On Wed, Jan 13, 2010 at 02:09:14PM +1100, Nathan Scott wrote:
> > > > 
> > Agreed that it is trivial to implement but there are still some
> > definite traps - like the fact the sb change transaction may be
> > logged
> > immediately but the physical superblock may not get written for some
> > time after the mount.
> 
> *nod* ... it will be written when unmounted though...

suspend in the kernel doesn't unmount filesystems. I have no idea
what tuxonice does these days, but last time I heard it left them
mounted but frozen over the suspend/resume cycle.

> > Really it comes down to the interface used to read the mount time
> > fromt eh superblock at suspend and resume - can anyone tell me what
> > that is or point me at the code?
> 
> (not me!)
> 
> > Personally I don't see why this needs to be in the superblock - an
> > extended attribute on the root directory of the root filesystem that
> > is written:
> 
> Yeah, that was my first thought too, but I suspect they want to be
> able to query this when the filesystem is unmounted; in which case
> the interface is probably "read a fs-specific magic spot ondisk".
> For this not-mounted query, the EA route would be incredibly painful.

I know, but it's the "read from the magic spot on disk" approach
that I'm most concerned about. It's so easy to implement, but oh so
easy get wrong because block device access is not coherent with the
filesystem. Not to mention that if we change the format of the
"magic spot" then the application breaks, whereas that will not
happen if access is via extended attributes.

Essentially, I don't want to see another boot related, filesystem
interacting application having random problems with XFS and then
doing stupid stuff to try to work around problems caused by
fundamentally broken assumptions made by the application. IMO,
learning from the mistakes the world's most screwed up bootlader
(grub) made is a good idea....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
