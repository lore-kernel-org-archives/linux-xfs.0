Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32746 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdBRBRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2017 20:17:41 -0500
Subject: [RFC PATCH v6 0/8] vfs/xfs/ext4: GETFSMAP support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Feb 2017 17:17:18 -0800
Message-ID: <148738063792.29384.10681837280402457846.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Hi all,

This is an RFC patchset implementing the GETFSMAP ioctl that we
discussed at LSFMM 2016[1].  GETFSMAP takes two search keys, which are
defined as a tuple of (device, physical block, owner, file offset), and
returns all known space mapping information for the given filesystem.

The XFS implementation is fully complete for filesystems having the new
reverse-mapping feature introduced in 4.8.  For legacy XFS filesystems
and ext4, there is no reverse-mapping data and the returned extent
information is restricted to listing "free", "unknown", or "metadata"
owners.

Space mapping information can be dumped via the xfs_io 'fsmap' command,
and the upcoming xfs_spaceman utility analyzes the free extent data to
produce free space fragmentations reports.  Further in the future, the
xfs_scrub utility will use GETFSMAP to assist in data block read
verification.

Kernel source can be found in the git repo [2] and userspace utilities
in the git repo[3].  The XFS patches have been hanging around in my
repos for months accumulating fixes; the ext4 patches are newish.

Note: This patchset is headed for 4.12 at the earliest.

Questions?  Comments?

--D

[1] https://lwn.net/Articles/685978/
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
