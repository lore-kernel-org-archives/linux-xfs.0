Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35N4Frn028459 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 18:04:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11B1D1A7414D
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 16:06:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	17WAUNjZOBXUsqfi for <xfs@oss.sgi.com>;
	Mon, 05 Apr 2010 16:06:03 -0700 (PDT)
Date: Tue, 6 Apr 2010 09:06:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
Message-ID: <20100405230600.GA3335@dastard>
References: <201004050049.17952.hpj@urpla.net> <20100405004906.GY3335@dastard>
	<201004051335.41857.hpj@urpla.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004051335.41857.hpj@urpla.net>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 05, 2010 at 01:35:41PM +0200, Hans-Peter Jansen wrote:
> On Monday 05 April 2010, 02:49:06 Dave Chinner wrote:
> > On Mon, Apr 05, 2010 at 12:49:17AM +0200, Hans-Peter Jansen wrote:
> > > [Sorry for the cross post, but I don't know where to start to tackle this 
> > >  issue]
> > > 
> > > Hi,
> > > 
> > > on an attempt to get to a current kernel, I suffer from an issue, where a 
> > > simple du on a reasonably big xfs tree leads to invoking the oom killer: 
> > 
> > How big is the directory tree (how many inodes, etc)?
> 
> It's 1.1 TB system backup tree, let's say: many..

1.1TB isn't big anymore. ;)

> > > Apr  4 23:26:02 tyrex kernel: [  488.161105] lowmem_reserve[]: 0 0 0 0
> > > Apr  4 23:26:02 tyrex kernel: [  488.161107] DMA: 18*4kB 53*8kB 31*16kB 20*32kB 14*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3552kB
> > > Apr  4 23:26:02 tyrex kernel: [  488.161112] Normal: 32*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3704kB
> > > Apr  4 23:26:02 tyrex kernel: [  488.161117] HighMem: 17*4kB 29*8kB 47*16kB 16*32kB 6*64kB 30*128kB 53*256kB 27*512kB 14*1024kB 7*2048kB 377*4096kB = 1606044kB
> > > Apr  4 23:26:02 tyrex kernel: [  488.161122] 29947 total pagecache pages
> > > Apr  4 23:26:02 tyrex kernel: [  488.161123] 0 pages in swap cache
> > > Apr  4 23:26:02 tyrex kernel: [  488.161124] Swap cache stats: add 0, delete 0, find 0/0
> > > Apr  4 23:26:02 tyrex kernel: [  488.161125] Free swap  = 2104476kB
> > > Apr  4 23:26:02 tyrex kernel: [  488.161126] Total swap = 2104476kB
> > > Apr  4 23:26:02 tyrex kernel: [  488.165523] 784224 pages RAM
> > > Apr  4 23:26:02 tyrex kernel: [  488.165524] 556914 pages HighMem
> > > Apr  4 23:26:02 tyrex kernel: [  488.165525] 12060 pages reserved
> > > Apr  4 23:26:02 tyrex kernel: [  488.165526] 82604 pages shared
> > > Apr  4 23:26:02 tyrex kernel: [  488.165527] 328045 pages non-shared
> > > Apr  4 23:26:02 tyrex kernel: [  488.165529] Out of memory: kill process 4788 (mysqld-max) score 326208 or a child
> > > Apr  4 23:26:02 tyrex kernel: [  488.165531] Killed process 4788 (mysqld-max) vsz:1304832kB, anon-rss:121428kB, file-rss:4336kB
> > > [...]
> > 
> > Oh, this is a highmem box. You ran out of low memory, I think, which
> > is where all the inodes are cached. Seems like a VM problem or a
> > highmem/lowmem split config problem to me, not anything to do with
> > XFS...
> 
> Might be, I don't have a chance to test this on a different FS. Thanks
> for the answer anyway, Dave. I hope, you don't mind, that I keep you 
> copied on this thread.. 
> 
> This matter is, I cannot locate the problem from the syslog output. Might
> be a "can't see the forest because all the trees" syndrome.

Well, I have to ask why you are running a 32bit PAE kernel when your
CPU is:

<6>[    0.085062] CPU0: Intel(R) Xeon(R) CPU           X3460  @ 2.80GHz stepping 05

64bit capable.  Use a 64 bit kernel and this problem should go away.

> It's hard to believe, that a current kernel on a current system with 12 GB, 
> even if using the insane pae on i586 is not able to cope with an du on a 
> 1.1 TB file tree. Since du is invokable by users, this creates a pretty 
> ugly DOS attack for local users.

Agreed. And FWIW, don't let your filesystems get near ENOSPC on
2.6.34-rc, either....

(i.e. under sustained write load, 2.6.34-rc will hit the OOM killer
on page cache allocation before the filesystem can report ENOSPC to
the user application.  Test 224 in the xfsqa suite on a VM w/ 1GB
RAM will trigger this with > 90% reliability....)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
