Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 21:39:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m824dfum005288
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 21:39:42 -0700
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA02593 for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 14:41:06 +1000
Message-ID: <48BCC5B1.7080300@sgi.com>
Date: Tue, 02 Sep 2008 14:48:49 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Filesystem corruption writing out unlinked inodes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've been looking into a case of filesystem corruption and found
that we are flushing unlinked inodes after the inode cluster has
been freed - and potentially reallocated as something else.  The
case happens when we unlink the last inode in a cluster and that
triggers the cluster to be released.

The code path of interest here is:

xfs_fs_clear_inode()
	->xfs_inactive()
		->xfs_ifree()
			->xfs_ifree_cluster()
	->xfs_reclaim()
		-> queues inode on deleted inodes list

... and later on

xfs_syncsub()
	->xfs_finish_reclaim_all()
		->xfs_finish_reclaim()
			->xfs_iflush()

When the inode is unlinked it gets logged in a transaction so
xfs_iflush() considers it dirty and writes it out but by this
time the cluster has been reallocated.  If the cluster is
reallocated as user data then the checks in xfs_imap_to_bp will
complain because the inode magic will be incorrect but if the
cluster is reallocated as another inode cluster then these checks
wont detect that.

I modified xfs_iflush() to bail out if we try to flush an
unlinked inode (ie nlink == 0) and that avoids the corruption but
xfs_repair now has problems with inodes marked as free but with
non-zero nlink counts.  Do we really want to write out unlinked
inodes?  Seems a bit redundant.

Other options could be to delay the release of the inode cluster
until the inode has been flushed or move the flush into xfs_ifree()
before releasing the cluster.  Looking at xfs_ifree_cluster() it
scans the inodes in a cluster and tries to lock them and mark them
stale - maybe we can leverage this and avoid flushing staled inodes.
If so we'd need to tighten up the locking.

Does anyone have suggestions which direction we should take?

Lachlan
