Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB5MmQiN156978 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 16:48:27 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AD9415656DF
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 14:48:23 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JksWvGSCFz18sCRF for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 14:48:23 -0800 (PST)
Date: Tue, 6 Dec 2011 09:48:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RAID60/mdadm/xfs performance tuning
Message-ID: <20111205224820.GB28326@dastard>
References: <CAOO4vO7ewwsqNgpkgk=Pf1XUPts66S5bGLjcFS1OteobfXjkVw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOO4vO7ewwsqNgpkgk=Pf1XUPts66S5bGLjcFS1OteobfXjkVw@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Dec 05, 2011 at 01:50:58PM -0500, Paul Anderson wrote:
> I've set up an software RAID-60 array composed of 7 software RAID6's,
> each with 32k chunks, 18 devices total (16 data, 2 parity), and in
> theory appropriate setup parameters according to a nice white paper
> written by Christoph and presented this last summer at LinuxCon.
> 
> My question is, if the mdraid and XFS are all configured properly,
> would I expect to see any read operations when doing a write-only
> test?  I would have assumed that I would not, since XFS should write
> stripe-aligned sets of data, and in theory nothing needs to be read
> (no read-modify-write going on, I would think).

That depends. What's your "write only" test?

> The performance is great, but I'm wondering if I need to keep looking.

If performance is great, then what's the problem?

> 
> Thanks,
> 
> Paul Anderson
> 
> Here's the details for kernel 2.6.38.5:
> 
> mdadm --detail /dev/md0  (md1, md2, md3, md4, md5, and md6 all the same)
> /dev/md0:
....
>      Chunk Size : 32K
> 
> /dev/md8 is the RAID0 that concatenates the above RAID6's, making a
> single RAID60:
> 
>  mdadm --detail /dev/md8
> /dev/md8:
....
>      Chunk Size : 4096K (this is what the RAID0 container thinks, but
> I ignore it for xfs)

You should set the RAID0 chunk size to the stripe width of the
underlying RAID6 volume (i.e. 512k).

> xfs_info /exports/
> meta-data=/dev/md8               isize=256    agcount=204, agsize=268435448 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=54698370048, imaxpct=1
>          =                       sunit=8      swidth=1024 blks

Because XFS has clearly not been configured correctly. You've given
it a stripe unit of 32k (the RAID6 chunk size), and a width of 4MB
(the RAID0 chunk size).

What you are doing is aligning allocation to individual disks in the
RAID6 volumes but the filesystem doesn't know what the stripe width
of those volumes are so can't really align correctly to the RAID6
geometry. And because it is not set up as a sunit = 128 (512k), it
can't align to the RAID0 on top of it correctly, either.

You need to align all layers of the stack to each other so the
filesystem has a consistent view of stripe unit and widths. In this
configuration, the RAID0 really needs a chunk size of 512k to match
the RAID6 stripe width. Then you can chose from two different valid
alignments for the filesytsem - align to the underlying RAID6 or to
the top level RAID0.

If you have a small file intensive workload, then aligning to the
RAID6 is probably best so that small files can pack full RAID6
stripe widths. If you have a bandwidth intensive workload, then
aligning to the RAID0 is probaly best so that large writes are
aligned to the full stripe width of the underlying RAID6 devices.

Either way, you need to understand and test your workload to improve
on whatever the default XFS settings give you.

> I made the filesystem like this:
> mkfs.xfs -L $(hostname) -l su=32768 -d su=32768,sw=128 /dev/md8
> 
> mount options: inode64,largeio,swalloc,delaylog,logbsize=256k,logbufs=8,noatime,nodiratime

Why largeio,swalloc? Have you determined that you're actually
getting hot disks in your array without it?

FWIW, delaylog and logbufs are the default so you don't need to set
them, and nodiratime is a subset of noatime, so you don't need to
specify that, either.

> I intended to make it with an external log, but forgot.

So you've determined an internal log is a performance bottleneck for
your workload?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
