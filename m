Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2A4xxwg103523 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 23:00:00 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id PKXy2u1YIkxpvbjv for <xfs@oss.sgi.com>;
	Fri, 09 Mar 2012 20:59:57 -0800 (PST)
Message-ID: <4F5ADFCB.9010602@sandeen.net>
Date: Fri, 09 Mar 2012 22:59:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 1B files, slow file creation, only AG0 used
References: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
In-Reply-To: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
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
To: mike@nauticaltech.com
Cc: xfs@oss.sgi.com

On 3/9/12 8:13 PM, Michael Spiegle wrote:
> We're seeing some very strange behavior with XFS on the default kernel
> for CentOS 5.6 (note, I have also 3.2.9 and witnessed the same issue).

on centos please be sure you're not using the old xfs kmod package, just FYI.
The module shipped with the kernel is what you should use.

>  The dataset on this server is about 1B small files (anywhere from 1KB
> to 50KB).  We first noticed it when creating files in a directory.  A
> simple 'touch' would take over 300ms on a completely idle system.  If
> I simply create a different directory, touching files is 1ms or
> faster.  Example:
> 
> # time touch 0
> real    0m0.323s
> user    0m0.000s
> sys     0m0.323s
> 
> # mkdir tmp2
> # time touch tmp2/0
> real    0m0.001s
> user    0m0.000s
> sys     0m0.000s

If anything this is testament to xfs scalability, if it can make the billion-and-first inode in a single dir in "only" 300ms ;)

You might want to read up on the available docs, i.e.

http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/xfs-allocators.html

probably covers a lot of what you are wondering about.

When you make a new dir, in general xfs will put inodes & files in that dir into a new
AG.

But another thing you are likely running into is the inode32 allocation behavior, also explained in the doc above.
In that case inodes are kept in the lower ags, and data is sprinkled around the higher AGs.

> We've done quite a bit of testing and debugging, and while we don't
> have an answer yet, we've noticed that our filesystem was created with
> the default of 32 AGs.  When using xfs_db, we notice that all
> allocations appear to be in AG0 only.  We've also noticed during
> testing that if we create 512 AGs, the distribution appears to be
> better.  It seems that the AG is actually encoded into the inode, and
> the XFS_INO_TO_AGNO(mp,i) macro is used to determine the AG by
> performing a bitshift.  

Right, the physical location of the inode can be determined from the inode number itself + fs geometry. This is why the default behavior of restricting inodes to 32 bits keeps them all in lower disk blocks; in your case, the lowest AG.

> In our case, the bitshift appears to be
> 32bits, and since the inode is 32bits, we always end up with AG0.
> Does anyone know if our slow file creation issue is related to our use
> of AG0, and if so, what's the best way to utilize additional AGs?

If you mount with -o inode64, inodes may be allocated anywhere on the fs, in any AG. New subdirs go to new AGs, activity will be distributed across the filesystem. As long as your applications can properly handle 64-bit inode numbers, this is probably the way to go.

You would be better off not creating all billion in a single dir, as well.

> Per-AG counts:
> # for x in {0..31}; do echo -n "${x}: "; xfs_db -c "agi ${x}" -c
> "print" -r /dev/sda1 | grep "^count"; done
> 0: count = 1098927744
> 1: count = 0
> 2: count = 0
... <snip> ...

> 29: count = 0
> 30: count = 0
> 31: count = 0
> 
> Some general stats on the server:
> 24x Xeon
> 24GB RAM
> CentOS 5.6
> 20TB of storage
> 1B files
> RAID6, 14 drives, SATA
> 
> Output of "xfs_info /dev/sda1":
> meta-data=/dev/sda1              isize=256    agcount=32, agsize=152575999 blks
>          =                       sectsz=512   attr=0

I wonder why you have attr=0 and 32 ags; pretty old xfsprogs maybe.

> data     =                       bsize=4096   blocks=4882431968, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1

You probably would be better off telling mkfs.xfs what your stripe geometry is, as well.

-Eric

> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
