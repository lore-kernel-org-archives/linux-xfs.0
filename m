Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbeGZB1L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 21:27:11 -0400
Subject: [PATCH v17 00/16] xfs-4.19: online repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Jul 2018 17:12:28 -0700
Message-ID: <153256394843.28271.6602121920208272304.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

Hi all,

This is the seventeenth revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.

New for this version of the patch series are fixes for numerous review
comments that came from Dave and Allison.  The long prefixes of the
previous versions have been drastically shortened.  Comments about the
strategies used to repair broken parts of the filesystem have been
expanded where reviewers thought it confusing.  A few data structures
have been renamed to reflect more accurately what they do.

Note, this series does not include any of the controversial repair
functionality that requires fs freezing; that has been deferred to a
later posting.

The first patch pushes a transaction pointer through the per-AG
reservation code so that scrub can reinitialize the per-AG reservations
after repairing metadata while maintaining the AG header lock.

The next two patches move the 'extent list' functionality into a
separate file and rename it xfs_bitmap, since that's what the data
structure actually represents.

Patches 4-14 implement reconstruction of the AGF/AGI/AGFL headers, the
free space btrees, the inode btrees, the inodes, the inode forks, the
inode block maps, symbolic links, and extended attributes.

Patch 15 augments scrub to rebuild extended attributes when any of the
attr blocks are fragmented.

Patch 16 implements reconstruction of quota blocks.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.18-rc6.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
