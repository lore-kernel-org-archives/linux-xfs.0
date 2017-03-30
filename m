Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38795 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933443AbdC3P6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 11:58:02 -0400
Subject: [PATCH v8 0/9] vfs/xfs/ext4: GETFSMAP support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Mar 2017 08:57:55 -0700
Message-ID: <149088947516.25895.12489128187852930801.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org

Hi all,

This is a patchset implementing the GETFSMAP ioctl that we discussed at
LSFMM 2016[1] and 2017.  GETFSMAP takes two search keys, which are
defined as a tuple of (device, physical block, owner, file offset), and
returns all known space mapping information for the given filesystem.

The XFS implementation is fully complete for filesystems having the new
reverse-mapping feature introduced in 4.8.  For legacy XFS filesystems
and ext4, there is no reverse-mapping data and the returned extent
information is restricted to listing "free", "unknown", or "metadata"
owners.

Space mapping information can be dumped via the xfs_io 'fsmap' command,
and the upcoming xfs_spaceman/e2freefrag utilities analyze the free
extent data to produce free space fragmentations reports.  Further in
the future, the xfs_scrub utility will use GETFSMAP to assist in data
block read verification, and dedupe programs can use it to further
optimize deduplication factors.

Kernel source can be found in the git repo [2] and userspace utilities
in the git repo[3].  This patchset is all ready to go for 4.12 -- the
XFS patches have already been reviewed by Brian Foster; and the ext4
patch has been updated per some of Andreas Dilger's comments.  This
posting will (I hope) be the last one before 4.12.  Test cases have
already been integrated into xfstests, and the manpage will be the last
patch.

I'm particularly looking for acks & reviews of the VFS header, the ext4
patch, and the manpage.  Patches 1, 9, and 10.

Questions?  Comments?

--D

[1] https://lwn.net/Articles/685978/
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
