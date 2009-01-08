Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08Ml4aB015416 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 16:47:04 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A74CF17C0906
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 14:47:02 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	jLhHVAEAi4HOZWNa for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 14:47:02 -0800 (PST)
Date: Fri, 9 Jan 2009 09:41:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS suddenly corrupted inode
Message-ID: <20090108224121.GH9448@disturbed>
References: <50407.88.130.217.97.1231386402.squirrel@cavemail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50407.88.130.217.97.1231386402.squirrel@cavemail.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: "dusty@gmx.li" <dusty@gmx.li>
Cc: xfs@oss.sgi.com

On Thu, Jan 08, 2009 at 03:46:42AM -0000, dusty@gmx.li wrote:
> Hello,
> 
> I don't know if I address the right people, but I would appreciate any help.
> I run a xfs file system ontop of a dm-crypted 3ware 8xxx controller
> powered raid-5. This worked for more than one year without any problem on
> two different computers.
> Last year I encountered an inode corruption on pc2 and after running
> xfs_repair everything seemed fine. After a short while the same error
> reappeared. I ran xfs_repair again and so on. The times the file system
> stayed stable became more and more short. So I decided to back everything
> up and run mkfs.xfs again. The System is now stable again for about 3
> month.
> 
> Today I found again an inode corruption. But this time on the other pc
> (pc1=jasmin) that has the same setup and hardware. Currently I don't want
> to mess around with the system before anybody may have a look at what the
> problems trigger is.
> 
> This is what I remember from the first time:
> The inode corruption was logged in the syslog the first time during a
> xfs_fsr.

xfs_fsr is essentially acting as a scrubber at this point, so it's
no surprise it was the first to find this.

> The filesystem is now no longer mounted and the first xfs syslog messages
> are:
> 
> Jan  7 05:08:32 jasmin Filesystem "dm-3": corrupt inode 2971 ((a)extents =
> 4).  Unmount and run xfs_repair.
> Jan  7 05:08:32 jasmin 00000000: 49 4e 81 f8 02 02 00 00 00 00 00 00 00 00
> 27 10  IN............'.
> Jan  7 05:08:32 jasmin Filesystem "dm-3": XFS internal error
> xfs_iformat_extents(1) at line 619 of file fs/xfs/xfs_inode.c.  Caller
> 0xffffffff80339322
> Jan  7 05:08:32 jasmin Pid: 26656, comm: smbd Tainted: P        
> 2.6.25-gentoo-r7 #1

Tainted kernel. Have you always run with binary modules?

> jasmin ~ # xfs_repair -n /dev/mapper/crypt
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
> local inode 2147909181 attr too small (size = 3, min size = 4)
> bad attribute fork in inode 2147909181, would clear attr fork
> would have cleared inode 2147909181

Hmmm...

> jasmin ~ # xfs_db -r -c "inode 2147909181" -c "p" /dev/mapper/crypt
> core.magic = 0x494e
> core.mode = 0100770
....
> core.naextents = 0
> core.forkoff = 7
> core.aformat = 1 (local)
....
> next_unlinked = null
> u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,180758896,1517,0]
> a.sfattr.hdr.totsize = 3
> a.sfattr.hdr.count = 0

Ok, so there's an attribute fork header but no attributes.
Do you add/remove attributes (e.g. ACLs) from files?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
