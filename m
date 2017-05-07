Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:50629 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdEGVlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 17:41:49 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v47FuPFt008819
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 7 May 2017 15:56:25 GMT
Subject: [PATCH v7 0/9] xfsprogs 4.12: GETFSMAP support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 07 May 2017 08:56:12 -0700
Message-ID: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
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
ioctl that is now in upstream for 4.12.  In order to reduce the amount
of redundant xfs/libxfs patches hitting the list, this patchset only
includes the relevant tool changes; you will need to pull the
djwong-devel tree[1] if you actually want to give the code a try.

The first patch introduce a 'fsmap' command to xfs_io so that users can
query the raw reverse mapping data that is exported by fsmap.  If the
experimental rmapbt feature is enabled, the returned results will be
straight out of the rmapbt; otherwise, the extent information is
synthesized out of the free space btres.

The second patch delegates xfs_repair's rmap comparison function to the
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

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
