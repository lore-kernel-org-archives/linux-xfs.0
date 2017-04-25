Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1176346AbdDYIZE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 04:25:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6A953AB07
        for <linux-xfs@vger.kernel.org>; Tue, 25 Apr 2017 08:25:03 +0000 (UTC)
Date: Tue, 25 Apr 2017 10:25:03 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Reviewing determinism of xfs_reclaim_inodes_ag()
Message-ID: <20170425082503.GN28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>, Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>

I've been staring at xfs_reclaim_inodes_ag() for a bit now to determine
if and how its deterministic it is. Fortunately the code makes it relatively
clear it chugs on 32 xfs_inodes at at a time before cond_resched()'ing. I was
concerned originally if we cond_resched() even if we goto restart but it seems
we do.

While reviewing this however I ran into the following question based on a
comment on the routine. Is such a thing as the below change needed ?

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3531f8f72fa5..05f3c79b4f11 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1157,7 +1157,9 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				struct xfs_inode *ip = batch[i];
 
-				if (done || xfs_reclaim_inode_grab(ip, flags))
+				if (done ||
+				    XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno ||
+				    xfs_reclaim_inode_grab(ip, flags))
 					batch[i] = NULL;
 
 				/*

This is what the code looks like before but pay special attention to the
comment and a race with RCU:

                                if (done || xfs_reclaim_inode_grab(ip, flags))                                                                                                  
                                        batch[i] = NULL;                                                                                                                        
                                                                                                                                                                                
                                /*                                                                                                                                              
                                 * Update the index for the next lookup.                                                                                                        
                                 * Catch overflows into the next AG range                                                                                                       
                                 * which can occur if we have inodes in the                                                                                                     
                                 * last block of the AG and we are                                                                                                              
                                 * currently pointing to the last inode.                                                                                                        
                                 *                                                                                                                                              
                                 * Because we may see inodes that are from                                                                                                      
                                 * the wrong AG due to RCU freeing and                                                                                                          
                                 * reallocation, only update the index if                                                                                                       
                                 * it lies in this AG. It was a race that                                                                                                       
                                 * lead us to see this inode, so another                                                                                                        
                                 * lookup from                                                                                                                                  
                                 * the same index will not find it again.                                                                                                       
                                 */                                                                                                                                             
                                if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=                                                                                                           
                                                                pag->pag_agno)                                                                                                  
                                        continue;                                                                                                                               
                                first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);                                                                                              
                                if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))                                                                                              
                                        done = 1;  

This leads me to believe that without the above change we might be doing an
xfs_reclaim_inode_grab() and subsequent reclaim for an AG which does not match
the pag given xfs_reclaim_inode_grab() does not seem to check the pag matches.

a) Its unclear if the xfs_reclaim_inode() will find the inode after the
first xfs_reclaim_inode_grab() as its a race.
                                                                                                                                                                                
b) Its unclear what the implications of trying xfs_reclaim_inode_grab() followed
by xfs_reclaim_inode() without holding the correct pag mutex could be.

I checked with Jan Kara and he believes the current code is correct but that
its the comment that that may be misleading. As per Jan the race is between
getting an inode reclaimed and grabbing it. Ie, XFS frees the inodes by RCU.
However it doesn't actually *reuse* the inode until RCU period passes
(unlike inodes allocated from slab with SLAB_RCU can be). So it can happen
that inode we have (ip) is actually already reclaimed by the time we get to
xfs_reclaim_inode_grab() and that function detects this (as I_RECLAIM is                                                                                                        
set). Also ip->i_ino will be set to 0 in that case so we must really avoid
using that to update the 'first_index' and 'done'. But it seems to Jan we
take the 'continue' branch only if xfs_reclaim_inode_grab() returned 1
before.
                                                                                                                                                                                
If Jan is correct the comment that inode may be reallocated seems to
be wrong and pretty misleading and the change I suggest above would not be
needed.

Thoughts?

  Luis
