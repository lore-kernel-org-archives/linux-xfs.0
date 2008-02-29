Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 19:49:48 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T3nbSa020653
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 19:49:40 -0800
Date: Fri, 29 Feb 2008 14:50:00 +1100
Subject: [GIT PULL] XFS update for 2.6.25-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080229035000.7B24058C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_super.c |   14 +++++++-------
 fs/xfs/xfs_clnt.h            |    2 +-
 fs/xfs/xfs_ialloc.c          |    2 +-
 fs/xfs/xfs_mount.h           |    2 +-
 fs/xfs/xfs_vfsops.c          |    4 ++--
 5 files changed, 12 insertions(+), 12 deletions(-)

through these commits:

commit b7405bb65a83e819dd3b21a6d9636c279d9ce79a
Author: Niv Sardi <xaiki@sgi.com>
Date:   Fri Feb 29 13:58:40 2008 +1100

    [XFS] If you mount an XFS filesystem with no mount options at all, then
    the "ikeep" option is set rather than "noikeep".
    
    This regression was introduced in 970451.
    
    With no mount options specified, xfs_parseargs() does the following:
    
    int ikeep = 0;
    
    args->flags |= XFSMNT_BARRIER;
    
    args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
    
    if (!options)
    
    goto done;
    
    It only sets the above two options by default and before, it also used to
    set XFSMNT_IDELETE by default.
    
    If options are specified, then
    
    if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
    
    args->flags |= XFSMNT_IDELETE;
    
    is executed later on which is skipped by the "goto done;" above.
    
    The solution is to invert the logic.
    
    SGI-PV: 977771
    SGI-Modid: xfs-linux-melb:xfs-kern:30590a
    
    Signed-off-by: Niv Sardi <xaiki@sgi.com>
    Signed-off-by: Barry Naujok <bnaujok@sgi.com>
    Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
