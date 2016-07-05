Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7F317CB9
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 02:29:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7852130404E
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 00:29:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Bad8t39CZtMAobV1 for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2016 00:29:45 -0700 (PDT)
Date: Tue, 5 Jul 2016 17:29:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bad Metadata performances for XFS?
Message-ID: <20160705072942.GZ12670@dastard>
References: <3ED34739A4E85E4F894367D57617CDEF9ED9518B@LAX-EX-MB2.datadirect.datadirectnet.com>
	<20160704225226.GD27480@dastard> <20160705001854.GY12670@dastard>
	<3ED34739A4E85E4F894367D57617CDEF9ED955AB@LAX-EX-MB2.datadirect.datadirectnet.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3ED34739A4E85E4F894367D57617CDEF9ED955AB@LAX-EX-MB2.datadirect.datadirectnet.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Shilong <wshilong@ddn.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

[Please fix you mail program to correctly quote replies - I've done
it manually here so i could work out what your wrote ]

On Tue, Jul 05, 2016 at 01:43:33AM +0000, Wang Shilong wrote:
> From: Dave Chinner [david@fromorbit.com]
> On Tue, Jul 05, 2016 at 08:52:26AM +1000, Dave Chinner wrote:
> > On Mon, Jul 04, 2016 at 05:32:40AM +0000, Wang Shilong wrote:
> > > dd 16GB to /dev/shm/data to use memory backend storage to benchmark metadata performaces.
> 
> > I've never seen anyone create a ramdisk like that before.
> > What's the backing device type? i.e. what block device driver does
> > this use?
> 
> I guess you mean loop device here? It is common file and setup
> as loop0 device here.

For me, the "common" way to test a
filesystem with RAM backing it is to use the brd driver because it
can do DAX, is as light weight and scalable, and doesn't have any of
the quirks that the loop device has.

This is why I ask people to fully describe their hardware, software and
config - assumptions only lead to misunderstandings.

> > > Benchmark tool is mdtest, you can download it from
> > > https://sourceforge.net/projects/mdtest/
> >
> > What version? The sourceforge version, of the github fork that the
> > sourceforge page points to? Or the forked branch of recent
> > development in the github fork?
> 
> I don't think sourceforge version or github version make some
> differences here, you could use any of them.(I used Souceforge version)

They are different, and there's evidence of many nasty hacks in the
github version. it appears that some of them come from the source
forge version. Not particularly confidence inspiring.

> > > Steps to run benchmark
> > > #mkfs.xfs /dev/shm/data
> 
> > Output of this command so we can recreate the same filesystem
> > structure?
> 
> [root@localhost shm]# mkfs.xfs data
> meta-data=data                   isize=512    agcount=4, agsize=1025710 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0
> data     =                       bsize=4096   blocks=4102840, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

As I suspected, mkfs optimised the layout for the small size,
not performance. Performance will likely improve if you increase the
log size to something more reasonably sized for heavy metadata
workloads.

> > > #mount /dev/shm/data /mnt/test
> > > #mdtest -d /mnt/test -n 2000000
> > >
> > > 1 tasks, 2000000 files/directories
> > >
> > > SUMMARY: (of 1 iterations)
> > >    Operation                      Max            Min           Mean        Std Dev
> > >    ---------                      ---            ---           ----        -------
> > >    Directory creation:      24724.717      24724.717      24724.717          0.000
> > >    Directory stat    :    1156009.290    1156009.290    1156009.290          0.000
> > >    Directory removal :     103496.353     103496.353     103496.353          0.000
> > >    File creation     :      23094.444      23094.444      23094.444          0.000
> > >    File stat         :    1158704.969    1158704.969    1158704.969          0.000
> > >    File read         :     752731.595     752731.595     752731.595          0.000
> > >    File removal      :     105481.766     105481.766     105481.766          0.000
> > >    Tree creation     :       2229.827       2229.827       2229.827          0.000
> > >    Tree removal      :          1.275          1.275          1.275          0.000
> > >
> > > -- finished at 07/04/2016 12:54:26 --
> 
> > A table of numbers with no units or explanation as to what they
> > mean. Let me guess - I have to read the benchmark source code to
> > understand what the numbers mean?
> 
> You could look File Creation, Units mean number of files create per seconds.
> (Here it is 23094.444)

Great. What about all the others? How is the directory creation
number different to file creation? What about "tree creation"? What
is the difference between them - a tree implies multiple things are
being indexed, so that's got to be different in some way from file
and directory creation?

Indeed, if these are all measuring operations per second, then why
is tree creation 2000x faster than tree removal when file and
directory removal are 4x faster than creation? They can't all be
measuring single operations, and so the numbers are essentially
meaningless without being able to understand how they are different.

> > > IOPS for file creation is only 2.3W, however compare to Ext4 with same testing.
> 
> > Ummm - what unit of measurement is "W"? Watts?
> 
> Sorry, same as above..

So you made it up?

> > IOWs: Being CPU bound at 25,000 file creates/s is in line with
> > what I'd expect on XFS for a single threaded, single directory
> > create over 2 million directory entries with the default 4k
> > directory block size....
> ----------
> 
> I understand that this is single thread Limit, but I guess there are some
> other Limit here, because even single thread creating 50W files speed
> is twice than 200W files.

What's this W unit mean now? It's not 10000ops/s, like above,
because that just makes no sense at all.  Again: please stop
using shorthand or abbreviations that other people will not
understand. If you meant "the file  create speed is different when
creating 50,000 files versus creating 200,000 files", then write it
out in full because then everyone understands exactly what you mean.

/Assuming/ this is what you meant, then it's pretty obvious why they
are different - it's basic CS alogrithms and math. Answer these two
questions, and you have your answer as to what is going on:

	1. How does the CPU overhead of btree operation scale with
	increasing numbers of items in the btree?

	2. What does that do to the *average* insert rate for N
	insertions into an empty tree for increasing values of N?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
