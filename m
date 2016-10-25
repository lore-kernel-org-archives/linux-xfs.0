Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45665 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932328AbcJYXDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:03:42 -0400
Subject: [PATCH v10 00/39] xfsprogs: add reflink and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:03:38 -0700
Message-ID: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the tenth revision of a patchset that adds to XFS userland tool
support for mapping multiple file logical blocks to the same physical
block (reflink/deduplication).

The core libxfs patches from the kernel have already been imported into
for-next, so this patch series contains fixes for those patches followed
by patches for the userspace programs themselves to support reflink.

If you're going to start using this mess, you probably ought to just
pull from my github trees for xfsprogs[1] and xfstests[2].  Kernel
support is in 4.9-rc1 or later.

The patches have been xfstested with x64, ppc64, and armhf; all tests
in the clone and rmap groups pass.  AFAICT they don't cause any new
failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/xfsprogs/tree/djwong-devel
[2] https://github.com/djwong/xfstests/tree/djwong-devel
