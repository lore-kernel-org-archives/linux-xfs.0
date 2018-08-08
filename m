Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42052 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbeHHGOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Aug 2018 02:14:43 -0400
Subject: [PATCH v17.2 0/4] xfs-4.19: online repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 Aug 2018 20:56:59 -0700
Message-ID: <153370061966.25077.161884080659267764.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com, allison.henderson@oracle.com

Hi all,

This is the seventeenth revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.

New for v17.2 are a few fixes suggested by Brian Foster in v17.1 and a
rebase of the series atop for-next, which adapts the repair code to the
new way of handling deferred log operations.

This series does not include any of the btree repair functions or the
controversial repair functionality that requires fs freezing; that has
been deferred to a later posting.  The only patches in this series are
the AG header repair functions.

The first patch tightens up the btree root block finder to check that
btree root candidates have no siblings and that there aren't multiple
blocks claiming to be on the root level.

Patches 2-4 implement reconstruction of the AGF/AGI/AGFL headers.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.18-rc8.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
