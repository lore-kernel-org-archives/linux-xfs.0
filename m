Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36802 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbcKEAJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:09:59 -0400
Subject: [PATCH v2 00/10] xfs: miscellaneous libxfs cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:09:56 -0700
Message-ID: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a patchset that aims to fix various discrepancies between the
kernel and xfsprogs' copies of libxfs/.  They shouldn't affect the
behavior of either codebase while bringing the benefit that libxfs-apply
will run more smoothly.

The patches in this series port various libxfs changes into the kernel
codebase.  There's a patch that refactors the directory freescan code
so that xfs_repair and kernel can use the same code without the macro
wrappers and some other cleanups.

I've tested the first 7 patches successfully against the auto group,
and the ones after that have passed the quick group.

--Darrick

[1] https://github.com/djwong/linux/tree/libxfs-resync
[2] https://github.com/djwong/xfsprogs/tree/libxfs-resync
