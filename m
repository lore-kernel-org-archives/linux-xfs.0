Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32571 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdFOUfE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 16:35:04 -0400
Subject: [PATCH v9 0/3] xfsprogs 4.12: GETFSMAP support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Jun 2017 13:34:49 -0700
Message-ID: <149755888982.3424.6925834871301440055.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This patchset implements the userspace components of the new GETFSMAP
ioctl that is now in upstream for 4.12.  This release contains various
cleanups that came up in the discussion of the v8 patchset; it should
apply directly to for-next.

The first two patches refactor string-to-number conversion routines.

The third patch chooses a faster crc32c algorithm, which provides
a small (~5%) decrease in xfs_repair runtime for metadata-heavy fses.

The fourth patch adds some autoconf magic so that client programs can
detect a platform supporting FSMAP (currently Linux) and stuff in our
own header if the system headers do not provide it.

The fifth patch introduce a 'fsmap' command to xfs_io so that users can
query the raw reverse mapping data that is exported by fsmap.  If the
experimental rmapbt feature is enabled, the returned results will be
straight out of the rmapbt; otherwise, the extent information is
synthesized out of the free space btres.

The sixth patch delegates xfs_repair's rmap comparison function to the
new libxfs version that was introduced as a part of the getfsmap kernel
patches.

The remainder of the patch set introduces xfs_spaceman, which is a new
tool to manage disk space on a mounted XFS filesystem.  The new tool can
call FITRIM, manage space reservations, and display summary information
about the free space on the filesystem.  This information is probably
most useful for developers and people surveying free space
fragmentation.

Note: The primary user of the GETFSMAP information will be the media
scan phase of the upcoming xfs_scrub tool, which will be posted later.

Questions?  Comments?

--D
