Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150224.lelvis3swlrtllnc@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx1.redhat.com ([209.132.183.28]:45900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751510AbdBXTxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Feb 2017 14:53:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: quotacheck vs. dquot reclaim deadlock
Date: Fri, 24 Feb 2017 14:53:18 -0500
Message-Id: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Martin Svec <martin.svec@zoner.cz>

Hi all,

Here's one more stab at the quotacheck vs. dquot reclaim deadlock. The
details of the deadlock are in the commit log. This is a completely new
approach from v1. Rather than disable dquot reclaim entirely, this
pushes on the queued buffer for already flush locked dquots to cycle the
lock and allow the flush to proceed. This is the general approach that
has been used to avoid this problem in XFS since before v3.5 (where the
regression was introduced) to as far back as I can tell.

I've also tacked on an RFC patch to submit dquot buffers after the
quotacheck buffer reset since the topic of doing so as an alternative
fix keeps coming up wrt to this issue. Note that this patch is for
reference and discussion purposes only, as it is broken. The purpose of
including it here is to separate the discussion of performance (memory
efficiency in this case) from the goal of correctness.

As it is, I don't like patch 3 because for the cost to make it actually
work, I don't think it provides enough practical benefit by itself. We
still, for example, load in the entire dquot buffer space all at once
during the buffer reset. If we're going to rework quotacheck for memory
usage, better (IMO) would be to explore an approach that allows more
granular management of both buffers and dquots, rather than do the work
to take quotacheck apart and put it back together again for an
incremental gain. Other options here might be to try and find a way to
avoid the use of dquots entirely by working directly on the buffers,
implement a dirty buffer lru and dquot analog to the inode DONTCACHE
mode (with immediate flush), implement a userspace quotacheck, more
creative batching, or perhaps other high-level ideas.

I'm also not convinced that memory consumption of the dquot traversal is
enough of a problem in practice for a quotacheck rewrite to be high
priority, as most filesystems probably won't have enough dquots for it
to be. I've been experimenting with a filesystem with 600k project
quotas and don't reproduce a problem with as little as 1GB RAM (no
swap). Thoughts?

Brian

v2:
- Added quotacheck error handling fixup patch.
- Push buffers with flush locked dquots for deadlock avoidance rather
  than bypass dquot reclaim.
- Added RFC patch for quotacheck early buffer list submission.
v1: http://www.spinics.net/lists/linux-xfs/msg04304.html

Brian Foster (3):
  xfs: fix up quotacheck buffer list error handling
  xfs: push buffer of flush locked dquot to avoid quotacheck deadlock
  [RFC] xfs: release buffer list after quotacheck buf reset

 fs/xfs/xfs_buf.c   | 39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_qm.c    | 33 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h |  1 +
 4 files changed, 73 insertions(+), 1 deletion(-)

-- 
2.7.4

