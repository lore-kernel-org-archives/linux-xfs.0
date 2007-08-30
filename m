Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 12:53:41 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UJrZ4p025940
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 12:53:37 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7UJra9U013844
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 15:53:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7UJraQC684408
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 15:53:36 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7UJrZDK001676
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 15:53:35 -0400
Date: Thu, 30 Aug 2007 14:53:43 -0500
From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: ZFS, XFS, and EXT4 compared
Message-ID: <20070830145343.57ce5137@gara>
In-Reply-To: <1188499930.8980.16.camel@toonses.gghcwest.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
	<20070830083747.018cfe8a@gara>
	<1188499930.8980.16.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

On Thu, 30 Aug 2007 11:52:10 -0700
"Jeffrey W. Baker" <jwbaker@acm.org> wrote:

> On Thu, 2007-08-30 at 08:37 -0500, Jose R. Santos wrote:  
> > On Wed, 29 Aug 2007 23:16:51 -0700
> > "Jeffrey W. Baker" <jwbaker@acm.org> wrote:  
> > > http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html  
> > 
> > FFSB:
> > Could you send the patch to fix FFSB Solaris build?  I should probably
> > update the Sourceforge version so that it built out of the box.  
> 
> Sadly I blew away OpenSolaris without preserving the patch, but the gist
> of it is this: ctime_r takes three parameters on Solaris (the third is
> the buffer length) and Solaris has directio(3c) instead of O_DIRECT.  

If you ever run these workloads again, a tested patch would be greatly
appreciated since I do not currently have access to a OpenSolaris box.

> > I'm also curious about your choices in the FFSB profiles you created.
> > Specifically, the very short run time and doing fsync after every file
> > close.  When using FFSB, I usually run with a large run time (usually
> > 600 seconds) to make sure that we do enough IO to get a stable
> > result.  
> 
> With a 1GB machine and max I/O of 200MB/s, I assumed 30 seconds would be
> enough for the machine to quiesce.  You disagree?  The fsync flag is in
> there because my primary workload is PostgreSQL, which is entirely
> synchronous.  

On your results, you mentioned that you are able to get about 150MB/s
out of the RAID controller and here you said you're getting about
200MB/s in FFSB?  Then it does probably mean that you needed to run for
an extended period of time since it could mean that you could be doing
a lot from page cache.  You could verify that you get the same results,
by doing one of the runs with a larger run time and comparing it to one
of the previous runs.

The fsync flag only does fsync at file close time, not at each IO
transaction on a selected file.  For the purposes of testing
PostgreSQL, wouldn't testing with O_DIRECT be more what you are looking
for?

> > Running longer means that we also use more of the disk
> > storage and our results are not base on doing IO to just the beginning
> > of the disk.  When running for that long period of time, the fsync flag
> > is not required since we do enough reads and writes to cause memory
> > pressure and guarantee IO going to disk.  Nothing wrong in what you
> > did, but I wonder how it would affect the results of these runs.  
> 
> So do I :)  I did want to finish the test in a practical amount of time,
> and it takes 4 hours for the RAID to build.  I will do a few hours-long
> runs of ffsb with Ext4 and see what it looks like.  

Been there.  I fell your pain. :)

> > The agefs options you use are also interesting since you only utilize a
> > very small percentage of your filesystem.  Also note that since create
> > and append weight are very heavy compare to deletes, the desired
> > utilization would be reach very quickly and without that much
> > fragmentation.  Again, nothing wrong here, just very interested in your
> > perspective in selecting these setting for your profile.  
> 
> The aging takes forever, as you are no doubt already aware.  It requires
> at least 1 minute for 1% utilization.  On a longer run, I can do more
> aging.  The create and append weights are taken from the README.  

Yes it does take for ever, but since you're doing so very little aging,
why even run it in the first place.  It will make you're runs go faster
if you just don't use it. :)

Did such a small aging created noticeable difference in the results?
It may have, since I've never run aging with such a small run time my
self.

> > Don't mean to invalidate the Postmark results, just merely pointing out
> > a possible error in the assessment of the meta-data performance of ZFS.
> > I say possible since it's still unknown if another workload will be
> > able to validate these results.  
> 
> I don't want to pile scorn on XFS, but the postmark workload was chosen
> for a reasonable run time on XFS, and then it turned out that it runs in
> 1-2 seconds on the other filesystems.  The scaling factors could have
> been better chosen to exercise the high speeds of Ext4 and ZFS.  The
> test needs to run for more than a minute to get meaningful results from
> postmark, since it uses truncated whole number seconds as the
> denominator when reporting.
> 
> One thing that stood out from the postmark results is how ext4/sw has a
> weird inverse scaling with respect to the number of subdirectories.
> It's faster with 10000 files in 1 directory than with 100 files each in
> 100 subdirectories.  Odd, no?

Not so weird since inode allocator tries to spread directory inode
across multiple block groups which could cause larger seeks on very
meta-data intensive workloads.  I'm actually working on a feature to
address this sort of issue in ext4.

Granted, if you really wanted to simulate file server performance, you
would want to start your workload with a huge fileset to begging with
where the data is spread across a larger chunk of the disk.  The
benchmark performance deficiencies on ext4 on a clean filesystem should
be a lot less noticeable. 

Yet another reason why I don't particularly like postmark.

> > Did you gathered CPU statistics when running these benchmarks?  
> 
> I didn't bother.  If you buy a server these days and it has fewer than
> four CPUs, you got ripped off.  

At the same time you can order a server with several dual port 4GB
fiber channel card and really big and expensive disk arrays with lots
of fast write caches.  Here you could see the negative effects of a CPU
hog filesystem.

For desktop or relatively small server setup, I agree that CPU of
utilization of a filesystem would be mostly insignificant/irelevant.
 
> -jwb
>   


-JRS
