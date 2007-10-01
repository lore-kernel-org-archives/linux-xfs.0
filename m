Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 00:24:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l917NuWJ029549
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 00:24:00 -0700
Date: Mon, 01 Oct 2007 17:23:50 +1000
Subject: [GIT PULL] XFS update for 2.6.23 - revert a commit
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Hi Linus,

A problem has been found for the XFS commit b394e43e995d08821588a22561c6a71a63b4ff27
and it needs to be reverted.
It has the potential for worse corruption than what it is meant to fix.

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

Lachlan's description:
    This fix is for a problem that has been in XFS since day one.
    [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.

    It tries to fix an issue where log replay is replaying an inode cluster
    initialisation transaction that should not be replayed because the inode
    cluster on disk is more up to date.  Since we don't log file sizes (we
    rely on inode flushing to get them to disk) then we can't just replay
    all the transations in the log and expect the inode to be completely
    restored.  We lose file size updates.  Unfortunately this fix is causing
    more (serious) problems than it is fixing so please don't push this one
    back just yet.

This will update the following files:

 fs/xfs/xfs_buf_item.h    |    5 ----
 fs/xfs/xfs_log_recover.c |   51 ++-------------------------------------------
 fs/xfs/xfs_trans_buf.c   |    1 -
 3 files changed, 3 insertions(+), 54 deletions(-)

through these commits:

commit 053c59a0a7234bac669992f5b8b933b7d7fc189d
Author: Tim Shimmin <tes@chook.melbourne.sgi.com>
Date:   Mon Oct 1 16:39:37 2007 +1000

    Revert "[XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer."
    
    This reverts commit b394e43e995d08821588a22561c6a71a63b4ff27.
    
    SGI-PV: 969656
    SGI-Modid: xfs-linux-melb:xfs-kern:29804a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

--Tim
