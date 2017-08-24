Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59482 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753590AbdHXWJV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 18:09:21 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8C761611EBD
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2017 17:07:56 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: xfsprogs: for-next updated to 2fc6b16
Message-ID: <12945512-0b3f-d6c6-ced1-94bf2570d9be@sandeen.net>
Date: Thu, 24 Aug 2017 17:09:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

2fc6b16 xfs_io: clarify the fsmap documentation

(I've also added lightweight tags for old vX.Y.0 releases; I was
wishing for those for some old archaeology recently)

New Commits:

Darrick J. Wong (1):
      [2fc6b16] xfs_io: clarify the fsmap documentation

Eric Sandeen (1):
      [fa9f6f1] xfs_bmap: fix -n documentation in manpage

Nikolay Borisov (6):
      [3d12c08] fiemap: Remove blocksize variable
      [05ef291] fiemap: Make max_extents a global var
      [cb404e2] fiemap: Eliminate num_extents
      [997bfca] fiemap: De-obfuscate last_logical and cur_extent manipulation
      [abd0c76] fiemap: Factor out common code used for printing holes
      [e7eaace] fiemap: Fix semantics of max_extents (-n arguments)


Code Diffstat:

 io/fiemap.c         | 174 +++++++++++++++++++++++++++++++++++-----------------------------------
 io/fsmap.c          |   2 +
 man/man8/xfs_bmap.8 |   5 +-
 man/man8/xfs_io.8   |   7 ++-
 4 files changed, 95 insertions(+), 93 deletions(-)
