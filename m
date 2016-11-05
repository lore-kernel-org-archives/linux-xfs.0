Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51161 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbcKEAIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:08:02 -0400
Subject: [PATCH v2 00/16] xfsprogs: miscellaneous libxfs cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:07:57 -0700
Message-ID: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
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

The first two patches fix some problems that Coverity found with the
initial commit of userspace support for reflink.  After that are nine
patches that fix a few places where the kernel and xfsprogs' copies of
libxfs have gotten out of sync.  There's a patch that refactors the
directory freescan code so that xfs_repair and kernel can use the same
code without the macro wrappers, and a second patch adding a script to
show the differences between any file that appears in both libxfs/
directories.

I've tested the first 11 patches successfully against the auto group,
and the ones after that have passed the quick group.

--Darrick

[1] https://github.com/djwong/linux/tree/libxfs-resync
[2] https://github.com/djwong/xfsprogs/tree/libxfs-resync
