Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754797AbeDVPF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:05:58 -0400
Subject: [PATCH 00/13] xfs-4.18: quota refactor
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:05:42 -0700
Message-ID: <152440954198.29601.14390250048915099607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@lst.de

Hi all,

Here's a series to refactor and clean out the incohesive mess that
xfs_qm_dqget has become.

I've distinguished three contexts in which dqget can be called, and
converted them into separate externally visible interfaces --
_qm_dqget_next, which returns the first initialized dquot with an id at
least as high as the id passed in; _qm_dqget_inode, which returns the
dquot for a given (inode, type); and so _qm_dqget now only returns the
dquot for a given (id, type).  I removed unused parameters from the
dqattach functions, renamed _qm_dqiterate (since it now only knows how
to zap dquot counters during quotacheck), and added a real function to
iterate all dquots of a given type.

This means that all _dqget variants no longer take QMOPT flags, and
QMOPT_NEXT is gone.  XFS_QMOPT_DQALLOC is now XFS_DQGET_DQALLOC and can
only be specified for functions where it makes sense.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.17-rc1.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
