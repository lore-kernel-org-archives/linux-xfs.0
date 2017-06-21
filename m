Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19640 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdFUBLR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 21:11:17 -0400
Subject: [RFC PATCH 0/4] xfs: more configurable error injection
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Jun 2017 18:11:12 -0700
Message-ID: <149800747210.23118.6423951814449227184.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

Hi all,

This is a small patch set that exposes all the error injection tags
under /sys/fs/xfs/$dev/errortag/.  Each tag gets its own sysfs
attribute; you can enable a tag via:

# echo $num > /sys/fs/xfs/$dev/errortag/$tagname

The tag names are the same ones as xfs_io's inject command, and the
number units are the denominator of the occurrence frequency, which is
to say that they're the same units as XFS_RANDOM_*.  1 = all the time,
2 = half the time, 100 = 1% of the time, etc.

The purpose of this patch series is twofold -- first, the old ioctl
interface doesn't allow us to control how often errors actually get
injected.  The extra flexibility enables us to write regression tests
where we set up the next operation to fail, as well as tests that set a
low frequency of trouble and try to run longer tests.  Second, with
error injection knobs appearing in sysfs we might as well move them all
to the same place.  Third, now we can individually /disable/ error
injectors, whereas the ioctl interface can only turn all of them off at
once.

Note that the old ioctls are not going away; their behavior is
unchanged.

Comments and questions are, as always, welcome.

--D
