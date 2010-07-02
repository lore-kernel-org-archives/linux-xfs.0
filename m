Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o622dsIW222165 for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 21:39:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72077420D00
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 19:42:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	LUSrRPCkEKrsJ5ol for <xfs@oss.sgi.com>;
	Thu, 01 Jul 2010 19:42:39 -0700 (PDT)
Date: Fri, 2 Jul 2010 12:42:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
Message-ID: <20100702024235.GX24712@dastard>
References: <4C26A51F.8020909@tlinx.org> <201006302025.20289@zmi.at>
	<20100630233029.GO24712@dastard> <201007011025.04391@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007011025.04391@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, Jul 01, 2010 at 10:25:03AM +0200, Michael Monnerie wrote:
> On Donnerstag, 1. Juli 2010 Dave Chinner wrote:
> > > From another Linux ("saturn"), I do an rsync via an rsync-module,
> > > and have already 4 Versions where the ".vhd" file of that Windows
> > > Backup is destroyed on "saturn". So the corruption happens when
> > > starting rsync @saturn, copying orion->saturn, both having XFS.
> > 
> > Are you running rsync locally on saturn (i.e. pulling data)? If so,
> > can you get an strace of the rsync of that file so we can see what
> > the order or operations being done on the file is. If you are
> > pushing data to saturn, does the problem go away if you pull it (and
> > vice versa)?
> 
> Oh dear, I made a mistake. It's a push @orion, doing
> rsync -aPvHAXy / saturn::orionbackup/
> 
> The problem is: I cannot 100% replicate it. I found the problem once, 
> moved the dir with the broken file away and synced again. Again broken. 
> Then I reported here. Meanwhile, Windows has done a new backup, that 
> file doesn't seem to get broken. But with another fresh Windows backup, 
> it came again. I don't know if it depends on the file, it happened 4 
> times until now.

So it's the rsync daemon on saturn that is doing all the IO?

> I rsynced today 3 times, twice with the openSUSE kernel and once with 
> 2.6.34, no problem. Sorry (or maybe "lucky me"?).
> 
> > > 852c268f-cf1a-11de-b09b-806e6f6e6963.vhd* ??????????? ? ?    ?     
> > >       ?            ? 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd
> > 
> > On the source machine, can you get a list of the xattrs on the
> > inode?
>
> How would I do that? "getfattr" on that file gives no return, does that 
> mean it doesn't have anything to say? I never do that things, so there 
> shouldn't be any attributes set.

"getfattr -d"

> > > and on dmesg:
> > > [125903.343714] Filesystem "dm-0": corrupt inode 649642 ((a)extents
> > > = 5).  Unmount and run xfs_repair. [125903.343735]
> > > ffff88011e34ca00: 49 4e 81 c0 02 02 00 00 00 00 03 e8 00 00 00 64 
> > > IN.............d [125903.343756] Filesystem "dm-0": XFS internal
> > > error xfs_iformat_extents(1) at line 558 of file
> > > /usr/src/packages/BUILD/kernel-desktop-2.6.31.12/linux-2.6.31/fs/xf
> > >s/xfs_inode.c.  Caller 0xffffffffa032c0ad
> > 
> > That seems like a different problem to what linda is seeing
> > because this is on-disk corruption. can you dump the bad inode via:
> > 
> > # xfs_db -x -r -c "inode 649642" -c p <dev>
> 
> Uh, that's a long output.
> 
> # xfs_db -x -r -c "inode 649642" -c p /dev/swraid0/backup 
.....
> u.bmx[0-4] = [startoff,startblock,blockcount,extentflag] 0:
> [0,549849376,2097151,0] 1:[2097151,551946527,2097151,0] 2:
> [4194302,554043678,2097151,0] 3:[6291453,556140829,2097151,0] 4:
> [8388604,558237980,539421,0]
> a.sfattr.hdr.totsize = 4
> a.sfattr.hdr.count = 40
> a.sfattr.list[0].namelen = 35
> a.sfattr.list[0].valuelen = 136
> a.sfattr.list[0].root = 1
> a.sfattr.list[0].secure = 0
> a.sfattr.list[0].name =
> "\035GI_ACL_FILE\000\000\000\005\000\000\000\001\377\377\377\377\000\a\000\000\000\000\000\002\000\000\004"
> a.sfattr.list[0].value = 
> "\346\000\a\000\000\000\000\000\004\377\377\377\377\000\006\000\000\000\000\000\020\377\377\377\377\000\000\000\000\000\000\000
> \377\377\377\377\000\000\000\000\000IN\201\377\002\002\000\000\000\000\003\350\000\000\000d\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\002L\025\356\025\000\000\000\000L\022\337\316\000\000\000\000L\025\356\025\024\'\314\214\000\000\000\000\000\000\004\242\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\001\000\000\c\001\000\000\000\000\000\000\000\000\006\273"

>From the metadump, I can see that other valid .vhd files are in
local format with:

core.forkoff = 9
a.sfattr.hdr.totsize = 83
a.sfattr.hdr.count = 1
a.sfattr.list[0].namelen = 12
a.sfattr.list[0].valuelen = 64
a.sfattr.list[0].root = 1
a.sfattr.list[0].secure = 0
a.sfattr.list[0].name = "SGI_ACL_FILE"
a.sfattr.list[0].value = <snipped>


All the broken inodes are in the same format as the valid .vhd files,
but the shortform attribute header is completely toast. Once I correct the
header and the lengths, the only thing that looks wrong is:

xfs_db> p a.sfattr.list[0].name
a.sfattr.list[0].name = "\035GI_ACL_FILE"

The first character of the name is bad, everything after that -
including the attribute value - is identical to that on other
inodes.  What this implies is that we've overwritten the start of
the attribute fork with something, and that looks exactly like the
swap extents problems that we've fixed recently....

> > Hmmmm - do you run xfs_fsr? The errors reported and the corrutpion
> > above are exactly what I'd expect from the swap extent bugs we fixed
> > a while back....
> 
> Yes, xfs_fsdr was running. Disabled it now, and compiled and changed to 
> kernel 2.6.34 now. Hope that's OK ;-)

Ok, so we have identified a potential cause. Either disabling fsr or
upgrading to 2.6.34 should be sufficient to avoid the problem. If no
problem show up now you are on 2.6.34, then I'd switch fsr back on
and see if they show up again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
