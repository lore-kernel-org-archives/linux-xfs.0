Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 22:51:10 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q5p7Sj024673
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 22:51:07 -0700
Date: Fri, 26 Sep 2008 15:52:35 +1000
Subject: [GIT PULL] XFS update for 2.6.27
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080926055235.9973458C52AE@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

The following changes since commit 6ef190cc92e33565accff6a320f0e7d90480bfe7:
  Roland Dreier (1):
        IPoIB: Fix crash when path record fails after path flush

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/linux-2.6 master

Lachlan McIlroy (2):
      [XFS] Fix extent list corruption in xfs_iext_irec_compact_full().
      [XFS] Remove xfs_iext_irec_compact_full()

 fs/xfs/xfs_inode.c |   94 ++--------------------------------------------------
 1 files changed, 3 insertions(+), 91 deletions(-)
