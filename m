Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43725 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdFBTvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 15:51:19 -0400
Subject: [PATCH v8 00/10] xfsprogs 4.12: GETFSMAP support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 12:51:14 -0700
Message-ID: <149643307433.15899.922559884171553380.stgit@birch.djwong.org>
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
cleanups that came up in the discussion of the v7 patchset; it should
apply directly to for-next.

The first patch adds some autoconf magic so that client programs can
detect a platform supporting FSMAP (currently Linux) and stuff in our
own header if the system headers do not provide it.

The next two patches introduce a 'fsmap' command to xfs_io so that users
can query the raw reverse mapping data that is exported by fsmap.  If
the experimental rmapbt feature is enabled, the returned results will be
straight out of the rmapbt; otherwise, the extent information is
synthesized out of the free space btres.

The fourth patch delegates xfs_repair's rmap comparison function to the
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
