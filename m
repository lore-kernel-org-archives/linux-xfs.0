Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 07:58:46 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UEwf4p005268
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 07:58:43 -0700
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7UDbpBc011887
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 09:37:52 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7UDbhZi012809
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 09:37:43 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7UDbgHF470318
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 07:37:43 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7UDbg8h004253
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 07:37:42 -0600
Date: Thu, 30 Aug 2007 08:37:47 -0500
From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: ZFS, XFS, and EXT4 compared
Message-ID: <20070830083747.018cfe8a@gara>
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

On Wed, 29 Aug 2007 23:16:51 -0700
"Jeffrey W. Baker" <jwbaker@acm.org> wrote:

Nice comparisons.

> I have a lot of people whispering "zfs" in my virtual ear these days,
> and at the same time I have an irrational attachment to xfs based
> entirely on its lack of the 32000 subdirectory limit.  I'm not afraid of

The 32000 subdir limit should be fixed on the latest rc kernels.

> ext4's newness, since really a lot of that stuff has been in Lustre for
> years.  So a-benchmarking I went.  Results at the bottom:
> 
> http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html

FFSB:
Could you send the patch to fix FFSB Solaris build?  I should probably
update the Sourceforge version so that it built out of the box.

I'm also curious about your choices in the FFSB profiles you created.
Specifically, the very short run time and doing fsync after every file
close.  When using FFSB, I usually run with a large run time (usually
600 seconds) to make sure that we do enough IO to get a stable
result.  Running longer means that we also use more of the disk
storage and our results are not base on doing IO to just the beginning
of the disk.  When running for that long period of time, the fsync flag
is not required since we do enough reads and writes to cause memory
pressure and guarantee IO going to disk.  Nothing wrong in what you
did, but I wonder how it would affect the results of these runs.

The agefs options you use are also interesting since you only utilize a
very small percentage of your filesystem.  Also note that since create
and append weight are very heavy compare to deletes, the desired
utilization would be reach very quickly and without that much
fragmentation.  Again, nothing wrong here, just very interested in your
perspective in selecting these setting for your profile.

Postmark:

I've been looking at the postmark results and I'm becoming more convince
that the meta-data results in ZFS may be artificially high due to the
nature of the workload.  For one thing,  I find it very interesting
(e.i. odd) that 9050KB/s reads and 28360KB/s writes shows up multiple
times even across filesystems.  The data set on postmark is also very
limited in size and the run times are small enough that it is difficult
to get an idea of sustained meta-data performance on any of the
filesystems.  Base on the ZFS numbers, it seems that there is hardly
any IO being done on the ZFS case given the random nature of the
workload and the high numbers it's achieving.

In short, I don't think postmark is a very good workload to sustain ZFS
claim as the meta-data king.  It may very well be the case, but I would
like to see that proven with another workload.  One that actually show
sustained meta-data performance across a fairly large fileset would be
preferred.  FFSB could be use simulate a meta-data intensive workload
as well and it has better control over the fileset size and run time to
make the results more interesting. 

Don't mean to invalidate the Postmark results, just merely pointing out
a possible error in the assessment of the meta-data performance of ZFS.
I say possible since it's still unknown if another workload will be
able to validate these results.

General:
Did you gathered CPU statistics when running these benchmarks?  For
some environments, having the ratio filesystem performance vs CPU
utilization would be good information to have since some workloads are
CPU sensitive and being 20% faster while consuming 50% more CPU may not
necessarily be a good thing.  While this may be less of an issue in the
future since CPU performance seems to be increasing at a much faster
pace than IO and disk performance, it would still be another
interesting data point.

> 
> Short version: ext4 is awesome.  zfs has absurdly fast metadata
> operations but falls apart on sequential transfer.  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel.
> 
> It would be nice if mke2fs would copy xfs's code for optimal layout on a
> software raid.  The mkfs defaults and the mdadm defaults interact badly.
>
> Postmark is somewhat bogus benchmark with some obvious quantization
> problems.

Ah...  Guess you agree with me about the postmark results validity. ;)

> Regards,
> jwb
> 


-JRS
