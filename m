Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932329AbdHVPEQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 11:04:16 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BBE46612234
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 10:02:54 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to b97ad96
Message-ID: <cb8e0f77-bb29-6bec-88d6-c5c2f375d0a9@sandeen.net>
Date: Tue, 22 Aug 2017 10:04:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

b97ad96 xfs_repair: fix thread creation failure recovery

New Commits:

Andreas Gruenbacher (1):
      [866d7fc] xfs_io: add seek consistency checks

Darrick J. Wong (4):
      [a749e25] xfs_db: reset metadump output flag
      [6a07c22] xfs_db: free field list when failing out of fuzz
      [ef209a9] xfs_db: make write/fuzz -c and -d work on non-crc filesystems
      [592c101] xfs_db: bit fuzzing should read the right bit when flipping

Jan Tulak (1):
      [02c3e10] mkfs: add missing translation

Jeff Mahoney (4):
      [8d2666e] fsr: fix uninitialized fs usage after timeout
      [53dc81d] xfs_repair: clear pthread_t when pthread_create fails
      [e8ff627] xfs_repair: add prefetch trace calls to debug thread creation failures
      [b97ad96] xfs_repair: fix thread creation failure recovery


Code Diffstat:

 db/fuzz.c         | 21 ++++++++++++---------
 db/metadump.c     |  1 +
 db/write.c        |  7 +++++--
 fsr/xfs_fsr.c     | 13 +++++++------
 io/seek.c         | 13 ++++++++++++-
 mkfs/xfs_mkfs.c   |  2 +-
 repair/prefetch.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 7 files changed, 80 insertions(+), 26 deletions(-)
