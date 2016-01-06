Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4C8107F51
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 17:49:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BB7C304059
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 15:49:16 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QZvNffP6PHaRuYrj for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 15:49:13 -0800 (PST)
Date: Thu, 7 Jan 2016 10:49:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and swift
Message-ID: <20160106234904.GL21461@dastard>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
	<20160106220454.GI21461@dastard> <20160106221004.GJ21461@dastard>
	<CAC2B=ZHe+crzN4vTjuNRRFgaxFHDDX2=Jn16EcwY1-ukt1=M6g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZHe+crzN4vTjuNRRFgaxFHDDX2=Jn16EcwY1-ukt1=M6g@mail.gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

On Wed, Jan 06, 2016 at 05:46:33PM -0500, Mark Seger wrote:
> dave, thanks for getting back to me and the pointer to the config doc.
>  lots to absorb and play with.
> 
> the real challenge for me is that I'm doing testing as different levels.
> While i realize running 100 parallel swift PUT threads on a small system is
> not the ideal way to do things, it's the only easy way to get massive
> numbers of objects into the fillesystem and once there, the performance of
> a single stream is pretty poor and by instrumenting the swift code I can
> clearly see excess time being spent in creating/writing the objects and so
> that's lead us to believe the problem lies in the way xfs is configured.
>  creating a new directory structure on that same mount point immediately
> results in high levels of performance.
> 
> As an attempt to try to reproduce the problems w/o swift, I wrote a little
> python script that simply creates files in a 2-tier structure, the first
> tier consisting of 1024 directories and each directory contains 4096
> subdirectories into which 1K files are created.

So you created something with even greater fan-out than what your
swift app is using?

> I'm doing this for 10000
> objects as a time and then timing them, reporting the times, 10 per line so
> each line represents 100 thousand file creates.
> 
> Here too I'm seeing degradation and if I look at what happens when there
> are already 3M files and I write 1M more, I see these creation times/10
> thousand:
> 
>  1.004236  0.961419  0.996514  1.012150  1.101794  0.999422  0.994796
>  1.214535  0.997276  1.306736
>  2.793429  1.201471  1.133576  1.069682  1.030985  1.096341  1.052602
>  1.391364  0.999480  1.914125
>  1.193892  0.967206  1.263310  0.890472  1.051962  4.253694  1.145573
>  1.528848 13.586892  4.925790
>  3.975442  8.896552  1.197005  3.904226  7.503806  1.294842  1.816422
>  9.329792  7.270323  5.936545
>  7.058685  5.516841  4.527271  1.956592  1.382551  1.510339  1.318341
> 13.255939  6.938845  4.106066
>  2.612064  2.028795  4.647980  7.371628  5.473423  5.823201 14.229120
>  0.899348  3.539658  8.501498
>  4.662593  6.423530  7.980757  6.367012  3.414239  7.364857  4.143751
>  6.317348 11.393067  1.273371
> 146.067300  1.317814  1.176529  1.177830 52.206605  1.112854  2.087990
> 42.328220  1.178436  1.335202
> 49.118140  1.368696  1.515826 44.690431  0.927428  0.920801  0.985965
>  1.000591  1.027458 60.650443
>  1.771318  2.690499  2.262868  1.061343  0.932998 64.064210 37.726213
>  1.245129  0.743771  0.996683
> 
> nothing one set of 10K took almost 3 minutes!

Which is no surprise because you have slow disks and a *lot* of
memory. At some point the journal and/or memory is going to fill up
with dirty objects and have to block waiting for writeback. At that
point there's going to be several hundred thousand dirty inodes that
need to be flushed to disk before progress can be made again.  That
metadata writeback will be seek bound, and that's where all the
delay comes from.

We've been through this problem several times now with different
swift users over the past couple of years. Please go and search the
list archives, because every time the solution has been the same:

	- reduce the directory heirarchy to a single level with, at
	  most, the number of directories matching the expected
	  *production* concurrency level 
	- reduce the XFS log size down to 32-128MB to limit dirty
	  metadata object buildup in memory
	- reduce the number of AGs to as small as necessary to
	  maintain /allocation/ concurrency to limit the number of
	  different locations XFS writes to the disks (typically
	  10-20x less than the application level concurrency)
	- use a 3.16+ kernel with the free inode btree on-disk
	  format feature to keep inode allocation CPU overhead low
	  and consistent regardless of the number of inodes already
	  allocated in the filesystem.

> my main questions at this point are is this performance expected and/or
> might a newer kernel help?  and might it be possible to significantly
> improve things via tuning or is it what it is?  I do realize I'm starting
> with an empty directory tree whose performance degrades as it fills, but if
> I wanted to tune for say 10M or maybe 100M files might I be able to expect

The mkfs defaults will work just fine with that many files in the
filesystem. Your application configuration and data store layout is
likely to be your biggest problem here.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
