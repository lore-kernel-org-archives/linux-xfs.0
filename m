Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5UNRnBQ154405 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 18:27:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A0E7158190F
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 16:30:33 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	fjOpeLzrocDO2bcp for <xfs@oss.sgi.com>;
	Wed, 30 Jun 2010 16:30:33 -0700 (PDT)
Date: Thu, 1 Jul 2010 09:30:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: rsync and corrupt inodes (was xfs_dump problem)
Message-ID: <20100630233029.GO24712@dastard>
References: <4C26A51F.8020909@tlinx.org> <20100628022744.GX6590@dastard>
	<4C2A749E.4060006@tlinx.org> <201006302025.20289@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201006302025.20289@zmi.at>
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

On Wed, Jun 30, 2010 at 08:25:20PM +0200, Michael Monnerie wrote:
> On Mittwoch, 30. Juni 2010 Linda Walsh wrote:
> > But have another XFS problem that is much more reliably persistent.
> > I don't know if they are at all related, but since I have this
> >  problem that's a bit "stuck", it's easier to "reproduce".
>  
> I think my problem is similar. I have a Linux ("orion") running Samba. 
> A Win7 client uses it to store it's "Windows Backup". That's OK.
> 
> From another Linux ("saturn"), I do an rsync via an rsync-module, 
> and have already 4 Versions where the ".vhd" file of that Windows Backup 
> is destroyed on "saturn". So the corruption happens when starting 
> rsync @saturn, copying orion->saturn, both having XFS.

Are you running rsync locally on saturn (i.e. pulling data)? If so,
can you get an strace of the rsync of that file so we can see what
the order or operations being done on the file is. If you are
pushing data to saturn, does the problem go away if you pull it (and
vice versa)?

> As I cannot delete the broken files, I moved the whole dir away, 
> and did an rsync again. The same file destroyed again on saturn.
> Some days later, again 2 versions which are destroyed.
> 
> The difference to Linda is, I get:
> drwx------+ 2 zmi  users     4096 Jun 12 03:15 ./
> drwxr-xr-x  7 root root       154 Jun 30 04:00 ../
> -rwx------+ 1 zmi  users 56640000 Jun 12 03:05 852c268f-cf1a-11de-b09b-806e6f6e6963.vhd*
> ??????????? ? ?    ?            ?            ? 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd 

On the source machine, can you get a list of the xattrs on the
inode?

> and on dmesg:
> [125903.343714] Filesystem "dm-0": corrupt inode 649642 ((a)extents = 5).  Unmount and run xfs_repair.
> [125903.343735] ffff88011e34ca00: 49 4e 81 c0 02 02 00 00 00 00 03 e8 00 00 00 64  IN.............d
> [125903.343756] Filesystem "dm-0": XFS internal error xfs_iformat_extents(1) at line 558 of file /usr/src/packages/BUILD/kernel-desktop-2.6.31.12/linux-2.6.31/fs/xfs/xfs_inode.c.  Caller 0xffffffffa032c0ad

That seems like a different problem to what linda is seeing
because this is on-disk corruption. can you dump the bad inode via:

# xfs_db -x -r -c "inode 649642" -c p <dev>

> [125903.343791] Pid: 17696, comm: ls Not tainted 2.6.31.12-0.2-desktop #1

That's getting a bit old now.

This kernel does not have any of the swap extent guards we added to
avoid fsr corrupting inodes with attribute forks, and the above
corruption report and the repair output look exactly like I saw when
intentionally corrupting inodes with xfs_fsr.

> Trying to "xfs_repair -n" seems to find errors, see attachment "repair1.log"

Hmmmm - do you run xfs_fsr? The errors reported and the corrutpion
above are exactly what I'd expect from the swap extent bugs we fixed
a while back....

> Trying to "xfs_repair" crashes, see attachment "repair2.log"
> 
> Saturns kernel is 2.6.31.12-0.2-desktop from openSUSE 11.2, 
> xfs_repair is 3.1.2 (I tried down several versions down to 3.0.1, all without success).
> 
> Even after xfs_metadump and xfs_mdrestore the error exists, and cannot be 
> repaired with xfs_repair, because that crashes.
> 
> I've put a new metadump containing only the broken stuff for public review:
> http://zmi.at/saturn_bigdata.metadump.only_broken.bz2 (197 MB)

I'll take a look.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
