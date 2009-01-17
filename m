Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HHXcYU027551 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 11:33:38 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD1A6181038E
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 09:33:36 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id EhLZqxhTvntwRtp5 for
	<xfs@oss.sgi.com>; Sat, 17 Jan 2009 09:33:36 -0800 (PST)
Message-ID: <4972166D.5000006@sandeen.net>
Date: Sat, 17 Jan 2009 11:33:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: help with xfs_repair on 10TB fs
References: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>
In-Reply-To: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>
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
To: Alberto Accomazzi <aaccomazzi@gmail.com>
Cc: xfs@oss.sgi.com

Alberto Accomazzi wrote:
> I need some help with figuring out how to repair a large XFS
> filesystem (10TB of data, 100+ million files).  xfs_repair seems to
> have crapped out before finishing the job and now I'm not sure how to
> proceed.
> 
> The system is a CentOS 5.2 storage server with a 3ware controller and
> 16 x 1TB drives, 32GB RAM and 64GB swap.  After clearing the issues
> with bad blocks on the disks, yesterday we set out to fix the
> filesystem.  This is the list of relevant packages that yum reports
> installed:
> 
> kmod-xfs.x86_64                          0.4-1.2.6.18_53.1.14.e installed
> kmod-xfs.x86_64                          0.4-2                  installed
> kmod-xfs.x86_64                          0.4-1.2.6.18_92.1.10.e installed
> xfsdump.x86_64                           2.2.46-1.el5.centos    installed
> xfsprogs.x86_64                          2.9.4-1.el5.centos     installed
> xfsprogs-devel.x86_64                    2.9.4-1.el5.centos     installed
> kernel.x86_64                            2.6.18-92.1.13.el5.cen installed

How did it "crap out?"

You could pretty easily run the very latest xfsprogs here by rebuilding
the src.rpm from

http://kojipkgs.fedoraproject.org/packages/xfsprogs/2.10.2/3.fc11/src/

> After bringing the system back, a mount of the fs reported problems:
> 
> Starting XFS recovery on filesystem: sdb1 (logdev: internal)
> Filesystem "sdb1": XFS internal error xfs_btree_check_sblock at line 334 of file
>  /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_btree.c.  Caller 0x
> ffffffff882fa8d2

so log replay is failing now; but that indicates an unclean shutdown.
Something else must have happened between the xfs_repair and this mount
instance?

> Call Trace:
>  [<ffffffff882eacc9>] :xfs:xfs_btree_check_sblock+0xbc/0xcb
>  .....
> 
> An xfs_check on the device suggests how to solve the problem:
> 
> alberto@adsduo-54: sudo xfs_check /dev/sdb1
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.

Just means that you have a dirty log.

> xfs_info reports the following for the filesystem:
> 
> meta-data=/dev/sdb1              isize=256    agcount=32, agsize=98361855 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=3147579360, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> So last night I started an "xfs_repair -L" on the device, which
> proceeded through step 6 before quitting at some point in the middle
> of the night without giving me many clues ast to what went wrong.  I
> know that this process uses a ton of memory so we loaded the server
> with 32GB of RAM (the swap file is 64GB) and before goint to sleep I
> noticed that the xfs_repair was using about 24GB of RAM.  I put the
> complete log of xfs_repair online at:
> http://www.cfa.harvard.edu/~alberto/ads/xfs_repair.log

wow, that's messy

> bad hash table for directory inode 58134992 (no data entry): rebuilding
> rebuilding directory inode 58134992
> rebuilding directory inode 58345355
> rebuilding directory inode 60221905
> 
> So I'm lead to believe that xfs_repair died before completing the job.
>  Should I try again?  Does anyone have an idea why this might have
> happened?  Is it possible that we still don't have enough memory in
> the system for xfs_repair to do the job?  Also, it's not clear to me
> how xfs_repair works.  Assuming we won't be able to get it to complete
> all of its steps, has it in fact repaired the filesystem somewhat or
> are all the changes mentioned while it runs not committed to the
> filesystem until the end of the run?

I don't see any evidence of it dying in the logs; either it looks like
it's still progressing, or it's stuck.

> For lack of better ideas I'm running an xfs_check at the moment.  It's
> been running for close to an hour and has used almost 29GB of memory
> so far.  No errors reported.

xfs_check doesn't actually repair anything, just FWIW.

I'd rebuild the srpm I mentioned above and give xfs_repair another shot
with that newer version, at this point.

-Eric

> TIA,
> 
> -- Alberto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
