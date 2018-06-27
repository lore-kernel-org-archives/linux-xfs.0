Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbeF0CsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:48:00 -0400
Subject: [PATCH 00/10] xfsprogs-4.18: mostly scrub/repair stuff
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 Jun 2018 19:47:44 -0700
Message-ID: <153006766483.20121.9285982017465570544.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a bunch of patches for xfsprogs 4.18.  The first two patches
remove unused crc32 implementations (XFS only uses crc32c) then moves it
to libfrog so all the programs can take advantage of that runtime support
code.  End result is that the binaries shrink by 8k.

Patches 3-8 fix various bugs in xfs_scrub and implement the ability to
schedule and issue online repairs.

Patch 9 wires up xfs_io to be able to call the repair ioctl on behalf of
xfstests.

Patch 10 fixes a regression in xfs_repair that was introduced by other
libxfs metadata verifier strengthening checks.

--D
