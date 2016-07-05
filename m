Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D40637CA6
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 19:22:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F4F9AC002
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 17:22:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9lHkDxdkF5jt8Zx2 for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2016 17:22:28 -0700 (PDT)
Date: Tue, 5 Jul 2016 10:18:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bad Metadata performances for XFS?
Message-ID: <20160705001854.GY12670@dastard>
References: <3ED34739A4E85E4F894367D57617CDEF9ED9518B@LAX-EX-MB2.datadirect.datadirectnet.com>
	<20160704225226.GD27480@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160704225226.GD27480@dastard>
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
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Jul 05, 2016 at 08:52:26AM +1000, Dave Chinner wrote:
> [xfs@oss.sgi.com is where you'll find the XFS developers]
> 
> On Mon, Jul 04, 2016 at 05:32:40AM +0000, Wang Shilong wrote:
> > Hello Guys,
> > 
> >       I happened run some benchmarks for XFS, and found some intresting to share here:
> > Kernel version:
> > [root@localhost shm]# uname -r
> > 4.7.0-rc5+
> > 
> > [root@localhost shm]# cat /proc/cpuinfo  | grep Intel
> > vendor_id	: GenuineIntel
> > model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz

What's the rest of the hardware in the machine?

> > dd 16GB to /dev/shm/data to use memory backend storage to benchmark metadata performaces.

I've never seen anyone create a ramdisk like that before.
What's the backing device type? i.e. what block device driver does
this use?

> > Benchmark tool is mdtest, you can download it from 
> > https://sourceforge.net/projects/mdtest/

What version? The sourceforge version, of the github fork that the
sourceforge page points to? Or the forked branch of recent
development in the github fork?

> > Steps to run benchmark
> > #mkfs.xfs /dev/shm/data

Output of this command so we can recreate the same filesystem
structure?

> > #mount /dev/shm/data /mnt/test
> > #mdtest -d /mnt/test -n 2000000
> > 
> > 1 tasks, 2000000 files/directories
> > 
> > SUMMARY: (of 1 iterations)
> >    Operation                      Max            Min           Mean        Std Dev
> >    ---------                      ---            ---           ----        -------
> >    Directory creation:      24724.717      24724.717      24724.717          0.000
> >    Directory stat    :    1156009.290    1156009.290    1156009.290          0.000
> >    Directory removal :     103496.353     103496.353     103496.353          0.000
> >    File creation     :      23094.444      23094.444      23094.444          0.000
> >    File stat         :    1158704.969    1158704.969    1158704.969          0.000
> >    File read         :     752731.595     752731.595     752731.595          0.000
> >    File removal      :     105481.766     105481.766     105481.766          0.000
> >    Tree creation     :       2229.827       2229.827       2229.827          0.000
> >    Tree removal      :          1.275          1.275          1.275          0.000
> > 
> > -- finished at 07/04/2016 12:54:26 --

A table of numbers with no units or explanation as to what they
mean. Let me guess - I have to read the benchmark source code to
understand what the numbers mean?

> > IOPS for file creation is only 2.3W, however compare to Ext4 with same testing.

Ummm - what unit of measurement is "W"? Watts?

Please, when presenting benchmark results to ask for help with
analysis, be *extremely specific* about what you running and what
the results mean. It's no different from reporting a bug from this
perspective:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

That said, this is a single threaded benchmark. It's well
known that XFS uses more CPU per metadata operation than either ext4
or btrfs, so it won't be any surprise that they are faster than XFS
on this particular test. We've known this for many years now -
perhaps you should watch/read this presentation I did more than 4
years ago now:

http://xfs.org/index.php/File:Xfs-scalability-lca2012.pdf
http://www.youtube.com/watch?v=FegjLbCnoBw

IOWs: Being CPU bound at 25,000 file creates/s is in line with
what I'd expect on XFS for a single threaded, single directory
create over 2 million directory entries with the default 4k
directory block size....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
