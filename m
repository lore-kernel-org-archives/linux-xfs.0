Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32311 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdBBXuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 18:50:14 -0500
Subject: [RFC PATCH 0/2] ext4: GETFSMAP support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 02 Feb 2017 15:50:05 -0800
Message-ID: <148607940546.553.277589646408670724.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: tytso@mit.edu, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Hi all,

Here's an RFC patchset that partially implements the GETFSMAP ioctl on
ext4.  Because ext4 does not have reverse-mapping data, it uses the same
fallback as XFS does when there's no rmapbt -- we report fixed-location
metadata and the free extents listed in the block bitmaps, then fill in
the rest with "owner unknown".

Yes, this the same GETFSMAP ioctl that we discussed at LSFMM[1] that has
been banging around in my XFS tree[2] for months.

The second patch implements a semi-clone of the XFS FSGEOMETRY ioctl.
The structure that ext4 returns is set up to mirror the XFS structure
where there's overlap.  The magic numbers of the ext4 ioctl are
different to prevent old XFS tools from falling in by accident, though
the intent is to ease adapting of the GETFSMAP xfs tools (xfs_io and
xfs_spaceman) for ext4.

My plan is to hoist the common GETFSMAP definitions (the structure, the
flags, and none of the special owner codes) to the VFS prior to
combining this patchset with its XFS counterpart.  Note: The special
owner codes (FMR_OWN_*) are filesystem specific and will never be
hoisted to the VFS headers in their current form.  However, I thought it
might be useful to push this to the ext4 list for some early review. 

If you want to play with this, I recommend pulling my latest xfsprogs
code from git[3] so that xfs_spaceman and xfs_io work on ext4.

Questions?  Comments?

--D

[1] https://lwn.net/Articles/685978/
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-wtf
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-wtf
