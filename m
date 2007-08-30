Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 11:52:13 -0700 (PDT)
Received: from h001.gghcwest.com (adsl-71-128-90-173.dsl.pltn13.pacbell.net [71.128.90.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UIqA4p011195
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 11:52:10 -0700
Subject: Re: ZFS, XFS, and EXT4 compared
From: "Jeffrey W. Baker" <jwbaker@acm.org>
In-Reply-To: <20070830083747.018cfe8a@gara>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
	 <20070830083747.018cfe8a@gara>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 11:52:10 -0700
Message-Id: <1188499930.8980.16.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jose R. Santos" <jrs@us.ibm.com>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

On Thu, 2007-08-30 at 08:37 -0500, Jose R. Santos wrote:
> On Wed, 29 Aug 2007 23:16:51 -0700
> "Jeffrey W. Baker" <jwbaker@acm.org> wrote:
> > http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html
> 
> FFSB:
> Could you send the patch to fix FFSB Solaris build?  I should probably
> update the Sourceforge version so that it built out of the box.

Sadly I blew away OpenSolaris without preserving the patch, but the gist
of it is this: ctime_r takes three parameters on Solaris (the third is
the buffer length) and Solaris has directio(3c) instead of O_DIRECT.

> I'm also curious about your choices in the FFSB profiles you created.
> Specifically, the very short run time and doing fsync after every file
> close.  When using FFSB, I usually run with a large run time (usually
> 600 seconds) to make sure that we do enough IO to get a stable
> result.

With a 1GB machine and max I/O of 200MB/s, I assumed 30 seconds would be
enough for the machine to quiesce.  You disagree?  The fsync flag is in
there because my primary workload is PostgreSQL, which is entirely
synchronous.

> Running longer means that we also use more of the disk
> storage and our results are not base on doing IO to just the beginning
> of the disk.  When running for that long period of time, the fsync flag
> is not required since we do enough reads and writes to cause memory
> pressure and guarantee IO going to disk.  Nothing wrong in what you
> did, but I wonder how it would affect the results of these runs.

So do I :)  I did want to finish the test in a practical amount of time,
and it takes 4 hours for the RAID to build.  I will do a few hours-long
runs of ffsb with Ext4 and see what it looks like.

> The agefs options you use are also interesting since you only utilize a
> very small percentage of your filesystem.  Also note that since create
> and append weight are very heavy compare to deletes, the desired
> utilization would be reach very quickly and without that much
> fragmentation.  Again, nothing wrong here, just very interested in your
> perspective in selecting these setting for your profile.

The aging takes forever, as you are no doubt already aware.  It requires
at least 1 minute for 1% utilization.  On a longer run, I can do more
aging.  The create and append weights are taken from the README.

> Don't mean to invalidate the Postmark results, just merely pointing out
> a possible error in the assessment of the meta-data performance of ZFS.
> I say possible since it's still unknown if another workload will be
> able to validate these results.

I don't want to pile scorn on XFS, but the postmark workload was chosen
for a reasonable run time on XFS, and then it turned out that it runs in
1-2 seconds on the other filesystems.  The scaling factors could have
been better chosen to exercise the high speeds of Ext4 and ZFS.  The
test needs to run for more than a minute to get meaningful results from
postmark, since it uses truncated whole number seconds as the
denominator when reporting.

One thing that stood out from the postmark results is how ext4/sw has a
weird inverse scaling with respect to the number of subdirectories.
It's faster with 10000 files in 1 directory than with 100 files each in
100 subdirectories.  Odd, no?

> Did you gathered CPU statistics when running these benchmarks?

I didn't bother.  If you buy a server these days and it has fewer than
four CPUs, you got ripped off.

-jwb
