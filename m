Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 22:48:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1Q6mmW4016939
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 22:48:50 -0800
Date: Tue, 26 Feb 2008 17:49:09 +1100
Subject: [GIT PULL] XFS update for 2.6.25-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080226064909.5457F58C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/xfs_bit.c     |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bit.h     |   27 ++-----------
 fs/xfs/xfs_rtalloc.c |   19 ++++++---
 3 files changed, 120 insertions(+), 29 deletions(-)

through these commits:

commit ef8ece55d9b6825c28a5c1a4bd89b94040cb7b32
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Tue Feb 26 17:00:22 2008 +1100

    [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
    platform.
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:30559a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit db69c915e67705daac25cad06d816c09be634de0
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Tue Feb 26 17:00:14 2008 +1100

    [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
    platform.
    
    SGI-PV: 974005
    SGI-Modid: xfs-linux-melb:xfs-kern:30558a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
