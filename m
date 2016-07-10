Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 19B257CBB
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 11:58:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8CA02AC001
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 09:58:03 -0700 (PDT)
Received: from mail-pa0-f67.google.com (mail-pa0-f67.google.com
	[209.85.220.67]) by cuda.sgi.com with ESMTP id 7cyqtnc7ueNc3WNm
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2016 09:58:01 -0700 (PDT)
Received: by mail-pa0-f67.google.com with SMTP id q2so608384pap.0
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 09:58:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Mon, 11 Jul 2016 00:57:59 +0800
Message-ID: <CAGeO4WMeat_NoXTkTSKky_YO95BXsSdwvR4rbiEmrxB1h1zVvQ@mail.gmail.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
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
To: xfs@oss.sgi.com

well, a piece of comment about the corner case i mentioned is found in
xfsprogs/repair/phase5.c, but i still have no idea how that is
prevented by the xfs kernel module.

/*
 * We need to leave some free records in the tree for the corner case of
 * setting up the AGFL. This may require allocation of blocks, and as
 * such can require insertion of new records into the tree (e.g. moving
 * a record in the by-count tree when a long extent is shortened). If we
 * pack the records into the leaves with no slack space, this requires a
 * leaf split to occur and a block to be allocated from the free list.
 * If we don't have any blocks on the free list (because we are setting
 * it up!), then we fail, and the filesystem will fail with the same
 * failure at runtime. Hence leave a couple of records slack space in
 * each block to allow immediate modification of the tree without
 * requiring splits to be done.
 *
 * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
 */

On Thu, Jul 7, 2016 at 7:01 PM, Kaho Ng <ngkaho1234@gmail.com> wrote:
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
