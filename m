Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q34GEQU4180081 for <xfs@oss.sgi.com>; Wed, 4 Apr 2012 11:14:26 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 3AVsTRhBJlgcGszu for <xfs@oss.sgi.com>;
	Wed, 04 Apr 2012 09:14:24 -0700 (PDT)
Message-ID: <4F7C735E.1040008@sandeen.net>
Date: Wed, 04 Apr 2012 09:14:22 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corrupt xfs on USB HDD : sub-optimal xfs_repair
References: <4F79591C.6090508@daxxi.net>
In-Reply-To: <4F79591C.6090508@daxxi.net>
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
To: xfs@oss.sgi.com
Cc: Dave B <xfs_bugs@daxxi.net>

On 4/2/12 12:45 AM, Dave B wrote:
> 
> Hi,
> 
> The two files in the root directory of a 500GB external USB HDD  became corrupt,
> probably due to a power failure.
> 
> dave@K-Matrix $ ls -l /media/Galaxy/
> ls: cannot access /media/Galaxy/ChnSchld_pre_4-14.tgz: No such file or directory
> ls: cannot access /media/Galaxy/dhr820xu.ext: No such file or directory
> total 24
> ??????????   ? ?    ?        ?                ? ChnSchld_pre_4-14.tgz
> ??????????   ? ?    ?        ?                ? dhr820xu.ext
> drwxr-xr-x   7 dave dave  4096 2012-02-13 12:45 DHR recordings
> drwxr-xr-x 212 dave dave 12288 2008-11-30 00:21 Miles Davis
> drwxr-xr-x   5 dave dave  4096 2012-02-16 06:06 PartImage
> 
> 
> xfs_repair didn't help much; it just removed the two filenames.
> At minimum, I expected two entries in L+F but the L+F directory was not created.
> 
> dave@K-Matrix $ sudo xfs_repair /dev/sdc1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
> entry "ChnSchld_pre_4-14.tgz" in shortform directory 128 references free inode 48145461
> junking entry "ChnSchld_pre_4-14.tgz" in directory inode 128
> entry "dhr820xu.ext" in shortform directory 128 references free inode 48145451
> junking entry "dhr820xu.ext" in directory inode 128

So, I am not sure there was really much to do here.  It's not that the inode was
legit but not linked from anywhere (in which case it would have gone into l+f) -
the inodes seem to be newly initialized, such as this one is:

xfs_db> inode 48145452
xfs_db> p
core.magic = 0x494e
core.mode = 0
core.version = 2
core.format = 0 (dev)
core.nlinkv2 = 0
core.onlink = 0
core.projid = 0
core.uid = 0
core.gid = 0
core.flushiter = 0
core.atime.sec = Wed Dec 31 18:00:00 1969
core.atime.nsec = 000000000
core.mtime.sec = Wed Dec 31 18:00:00 1969
core.mtime.nsec = 000000000
core.ctime.sec = Wed Dec 31 18:00:00 1969
core.ctime.nsec = 000000000
core.size = 0
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 0 (dev)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 2846323697
next_unlinked = null
u.dev = 0

Putting that inode into l+f would not have done you any good.

All the inodes in this cluster have a generation number of 2846323697, which
is due to new inode clusters being initialized with a random generation nr;
it looks for all the world like these inodes are uninitialized.

It might be possible that it's the directory which is corrupt, and therefore
points to wrong inodes... but that doesn't look like the case either,
the rest of the metadata in the dir looks just fine, and a previous version of
the dir entry contains the same inode number:

b0:  5f 34 2d 31 34 2e 74 67 7a 02 de a4 35 0c 02 30  .4.14.tgz...5..0
c0:  64 68 72 38 32 30 78 75 2e 65 78 74 02 de a4 2b  dhr820xu.ext....
d0:  74 02 de a4 2a 0c 02 30 64 68 72 38 32 30 78 75  t......0dhr820xu
e0:  2e 65 78 74 02 de a4 2b 00 00 00 00 00 00 00 00  .ext............

(02DEA42B, the inode nr in question, is in there both times)

I'm really not sure what has gone wrong here, yet.

Dave (Chinner), to be honest I have forgotten what your hunch was, do you
see any hints here?

thanks,

-Eric



>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - r	eset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> 
> 
> See longer console session and before/after metadumps in ~7MB d/l at:
> http://daxxi.net/xfs/Galaxy_500GB_xfs.tar.gz
> user: xfs  ,  p/w: xfs
> (please only d/l if 2x240MB metadumps will be meaningful to you)
> 
> 
> Environment:
> Linux K-Matrix 3.0.0-16-generic #29-Ubuntu SMP Tue Feb 14 12:49:42 UTC 2012 i686 athlon i386 GNU/Linux
> 
> 
> Dave
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
