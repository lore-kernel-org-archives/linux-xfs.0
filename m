Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8F117CB6
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 07:13:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5EDA3AC038
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 05:13:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SaZGe8IUEctExkIY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2016 05:13:26 -0700 (PDT)
Date: Thu, 7 Jul 2016 08:13:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
Message-ID: <20160707121323.GA10134@laptop.bfoster>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
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
To: Kaho Ng <ngkaho1234@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 07, 2016 at 07:01:35PM +0800, Kaho Ng wrote:
> I am trying to investigate how freelist allocator in xfs interacts
> with freespace B+Tree allocator.
> First I prepared a patch
> <https://gist.github.com/22ffca35929e67c08759b057779b7566> on
> linux-source/fs/xfs/libxfs/xfs_alloc.c to print debugging messages
> (The kernel version used is linux-3.10.0-327.22.2.el7).
> Then, I wrote a simple utility
> <https://gist.github.com/992364ceca984d3f14099ec94aaacd9d> to make
> TONS of
> holes in a filesystem by calling fallocate() to punch holes in a file
> that is almost as large as the volume size.
> 
> I created an XFS filesystem image by the following steps:
> 1. fallocate -l 80G /mnt/disk2/xfs
> 2. mkfs.xfs -f -d agcount=1 /mnt/disk2/xfs
> 
> Then I created a large file by fallocate:
> fallocate -l 85823746048 /mnt/test/abc
> 
> which left only 4 blocks available in the volume finally:
> /dev/loop0      20961280 20961276         4 100% /mnt/test
> 
> The result of xfs_bmap against /mnt/test/abc:
> /mnt/test/abc:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET              TOTAL FLAGS
>    0: [0..167624503]:  83000..167707503  0 (83000..167707503) 167624504 10000
> 
> After that, I used the hole-punching utility above to create holes on
> the files, and captured the output of kmsg.
> 
> When reading the log output
> <https://gist.github.com/890076405e1c13c0a952a579e25e6afe> , I
> realised that there is no B+Tree split
> triggered by xfs_alloc_fix_freelist() when calling xfs_free_extent().
> Isn't B+Tree split possible in by-size B+Tree even when truncating a
> longer freespace record to shorter one? But what I found in the log is
> only a few tree shrinks... And when reading the source code of
> freespace allocator I found that a B+Tree growth in this case is
> impossible at least...
> 

I'd suggest to use a combination of xfs_db and tracepoints/xfsstats to
identify what's happening in your test sequence. E.g., unmount and use
xfs_db to identify the state of the free space btree(s) before and after
various points of your test. See [1] for examples of how to use xfs_db
to explore on-disk data structures. See 'man trace-cmd' to work with
tracepoints and /proc/fs/xfs/stats (and /proc/sys/fs/xfs/stats_clear) to
view runtime statistics (which I believe already includes the number of
btree splits).

Brian

[1] http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
