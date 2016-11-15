Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44657 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755484AbcKOHr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 02:47:29 -0500
Date: Mon, 14 Nov 2016 23:47:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: About difference in extent sharing in btrfs and xfs
Message-ID: <20161115074715.GA23680@birch.djwong.org>
References: <1de48152-0ec5-1bf0-1ea9-b5ccbe4a3867@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1de48152-0ec5-1bf0-1ea9-b5ccbe4a3867@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>

On Tue, Nov 15, 2016 at 02:33:31PM +0800, Qu Wenruo wrote:
> Hi, xfs guys and btrfs guys.
> 
> Although the test case generic/372 exists for some time, I noticed that
> btrfs always fails the test case, due to the difference in how btrfs
> and xfs handle shared extents.
> 
> The difference is, btrfs can handle shared extents which points to a subset
> of a larger extent, so it doesn't need to split reflink source.
> 
> In case of the test case.
> 
> On Disk Extent A:
> Bytenr X
> |<-----------Data=0x61, Length=320K---------------------------|
> 
> 
> File1: File Extent 0 -> Extent A, offset=0, referred len=320K
> 
> File2: File Extent 0 -> Hole
>        File Extent 64K -> Extent A, offset=192k, refferred len=64k
>        File Extent 128K -> Hole
>        File Extent 192K -> Extent A, offset=64k, refferred len=64k
> 
> Unlike Xfs, Btrfs don't split the source extent, as its file extent has more
> fields which can handle offset/length inside the large extent.

XFS doesn't split the extent either, internally.  The FIEMAP
implementation cross-references extent data with the refcount records,
using extra struct fiemap_extent to report precisely which blocks are
shared and which aren't.  ocfs2 exhibits the same behavior.

It's only btrfs that reports file1 as having one big shared extent when
only parts of that extent are actually shared.  I'd rather btrfs only
report blocks that are actually shared as shared, but since fiemap
results can be obsolete as soon as the ioctl returns I don't consider it
a huge priority.

> The btrfs way to handle shared extent has its pros and cons.
> For example, it's very flex, but it wastes more space for COW since the
> whole extent can only be freed after all referencer is freed.

Wait, what?  So if I reflinked a single block of file1 into file3 and
then deleted file1 and file2, btrfs would hold on to all 320K?

> But since the test case is generic test case, I think it doesn't take such
> btrfs behavior into consideration.
> So it always fails on btrfs.
> 
> How about moving it to xfs specific tests?

I'd prefer the testcase be left in generic/ and _notrun'd on btrfs since
two of the three reflink fses have this behavior.

(Assuming the btrfs behavior doesn't get changed.)

--D

> 
> Thanks,
> Qu
> 
> 
