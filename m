Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 16:01:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0N00qqw027859
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 16:00:54 -0800
Message-Id: <200701222359.KAA23050@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_repair speedup changes
Date: Tue, 23 Jan 2007 10:59:57 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <45B53E11.8080406@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Michael Nishimoto' <miken@agami.com>, 'XFS Mailing List' <xfs@oss.sgi.com>
Cc: 'Chandan Talukdar' <chandan@agami.com>

Hi Michael,

It's going to take a little bit of time for me to digest this patch and
to see how it compares to the other work performed by us.

On the surface, it looks quite interesting and I'll benchmark and
analyse the two to see how it compares and integrate the best solution
for the majority of cases.

I'm confused on why the kernel should make any difference to running
xfs_repair. You should be able to get the 2.8.18 xfsprogs tarball from
the FTP site, compile and test it:
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.8.18-1.tar.gz

I'm currently working on converting the phase 2-5 block map to an extent
based format which will improve memory consumption in addition to
speeding it up in most cases.

The only other forseable change is trying to merge phase 3 and phase 6
with directory checking, but I'm not sure how practical/feasible this is
and whether the amount of work will provide a significant performance
increase.

Regards,
Barry.

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Michael Nishimoto
> Sent: Tuesday, 23 January 2007 9:43 AM
> To: XFS Mailing List
> Cc: Chandan Talukdar
> Subject: xfs_repair speedup changes
> 
> Hi everyone,
> 
> agami Systems started on a project to speed up xfs_repair before
> we knew that SGI was working on the same task.  Similar to SGI's
> solution, our approach uses readahead to shorten the runtime.  Agami
> also wanted to change the existing code as little as possible.
> 
> By releasing this patch, we hope to start a discussion which will
> lead to continued improvements in xfs_repair runtimes.  Our patch
> has a couple of ideas which should benefit SGI's code.  Using our
> NAS platform which has 4 CPUs and runs XFS over software RAID5,
> we have seen 5 to 8 times speedup, depending on resources allocated
> to a run.  The test filesystem had 1.4TB of data with 24M files.
> Unfortunately, I have not been able to run the latest CVS code
> against our system due to kernel differences.
> 
> SGI's advantages
> ----------------
> 1. User space cache with maximum number of entries
>     a. means that xfs_repair will cause less interference
>        with other mounted filesystems.
>     b. allows tracking of cache behavior.
> 2. Rewrite phase7 to eliminate unnecessary transaction overhead.
> 
> agami's advantages
> ------------------
> 1. Doesn't depend on AIO & generic DIO working correctly.  Will
>     work with older linux kernels.
> 2.  Parallelism model provides additional benefits
>      a. In phases 3 and 4, many threads can be used to prefetch
>         inode blocks regardless of AG count.
>      b. By processing one AG at a time, drives spend less time seeking
>         when multiple AGs are placed on a single drive due to 
> the volume
>         geometry.
>      c. By placing each prefetch in its own thread, more parallelism
>         is achieved especially when retrieving directory blocks.
> 
> Chandan Talukdar performed all the xfs_repair work over last summer.
> Because the work was done on an old base, I have ported it forward to
> a CVS date of May 17, 2006.  I chose this date because it allows a
> cleaner patch to be delivered.
> 
> I would like to hear suggestions for how to proceed.
> 
>      Michael Nishimoto
> 
