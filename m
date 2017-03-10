Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20406 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932705AbdCJXTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 18:19:55 -0500
Subject: [PATCH v6A 00/19] xfs: online scrub support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 10 Mar 2017 15:19:49 -0800
Message-ID: <148918798893.6959.7972227235163150709.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi all,

[Yes, this is a pre-LSFMM patch dump.]

This is the sixth revision of a patchset that adds to XFS kernel support
for online metadata scrubbing and repair.  There aren't any on-disk
format changes.  Changes since v5 include bug fixes to the repair code
to eliminate weird hangs and to do a better job of temporarily stopping
access to the filesystem in the rare event that we need todo so to
rebuild something.  For my own dogfooding amusement, I now perform
automated periodic scans of the XFS filesystems on my development
workstations, which (so far) haven't destroyed anything or blown up.

Online scrub/repair support consists of four major pieces -- first, an
ioctl that maps physical extents to their owners (GETFSMAP; queued for
4.12); second, various in-kernel metadata scrubbing ioctls to examine
metadata records and cross-reference them with other filesystem
metadata; third, an in-kernel mechanism for rebuilding damaged metadata
objects and btrees; and fourth, a userspace component to coordinate
scrubbing and repair operations.

This new utility, xfs_scrub, is separate from the existing offline
xfs_repair tool.  The program uses GETFSMAP and various XFS ioctls to
iterate all XFS metadata and asks the kernel to check the metadata and
repair it if necessary.

Per reviewer request, the v6 patch series has been broken into four
smaller series -- this first one to add the minimum code necessary to
scrub objects; a second one to add the ability to cross reference with
other metadata; a third one containing the rebuilding code; and a fourth
series with the userspace tool code.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.11-rc1.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
