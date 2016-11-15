Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59787 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755459AbcKOGdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 01:33:49 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: About difference in extent sharing in btrfs and xfs
Message-ID: <1de48152-0ec5-1bf0-1ea9-b5ccbe4a3867@cn.fujitsu.com>
Date: Tue, 15 Nov 2016 14:33:31 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>

Hi, xfs guys and btrfs guys.

Although the test case generic/372 exists for some time, I noticed that
btrfs always fails the test case, due to the difference in how btrfs
and xfs handle shared extents.

The difference is, btrfs can handle shared extents which points to a 
subset of a larger extent, so it doesn't need to split reflink source.

In case of the test case.

On Disk Extent A:
Bytenr X
|<-----------Data=0x61, Length=320K---------------------------|


File1: File Extent 0 -> Extent A, offset=0, referred len=320K

File2: File Extent 0 -> Hole
        File Extent 64K -> Extent A, offset=192k, refferred len=64k
        File Extent 128K -> Hole
        File Extent 192K -> Extent A, offset=64k, refferred len=64k

Unlike Xfs, Btrfs don't split the source extent, as its file extent has 
more fields which can handle offset/length inside the large extent.


The btrfs way to handle shared extent has its pros and cons.
For example, it's very flex, but it wastes more space for COW since the 
whole extent can only be freed after all referencer is freed.

But since the test case is generic test case, I think it doesn't take 
such btrfs behavior into consideration.
So it always fails on btrfs.

How about moving it to xfs specific tests?

Thanks,
Qu


