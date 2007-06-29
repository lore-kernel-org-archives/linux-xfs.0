Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 02:25:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T9P9tL015530
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 02:25:11 -0700
Message-ID: <4684CFF1.70700@sgi.com>
Date: Fri, 29 Jun 2007 19:25:05 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: [GIT PULL] XFS lockdep fix for 2.6.22
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>, xfs-oss <xfs@oss.sgi.com>

Hi Linus,

We have a patch to help for lockdep annotations which were
busted in XFS.
We still have more work to go - on to next lockdep warning.

Please pull from the for-linus branch:
     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

  fs/xfs/xfs_inode.h    |   15 +++++++++------
  fs/xfs/xfs_vnodeops.c |    4 ++--
  2 files changed, 11 insertions(+), 8 deletions(-)

through these commits:

commit 09ff7bd79164131cc041777e291a951a7adb8ab4
Author: David Chinner <dgc@sgi.com>
Date:   Fri Jun 29 17:26:09 2007 +1000

     [XFS] Fix lockdep annotations for xfs_lock_inodes

     SGI-PV: 967035
     SGI-Modid: xfs-linux-melb:xfs-kern:29026a

     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

--Tim
