Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jan 2008 23:07:36 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0B77RKO026384
	for <xfs@oss.sgi.com>; Thu, 10 Jan 2008 23:07:31 -0800
Date: Fri, 11 Jan 2008 18:07:36 +1100
Subject: [GIT PULL] XFS update for 2.6.24-rc8
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080111070737.115D758C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_file.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

through these commits:

commit aea6ad0ce5e215ce99fe9e3edd9268f696862d8f
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Jan 10 16:43:26 2008 +1100

    [XFS] fix unaligned access in readdir
    
    This patch should fix the issue seen on Alpha with unaligned accesses in
    the new readdir code. By aligning each dirent to sizeof(u64) we'll avoid
    unaligned accesses. To make doubly sure we're not hitting problems also
    rearrange struct hack_dirent to avoid holes.
    
    SGI-PV: 975411
    SGI-Modid: xfs-linux-melb:xfs-kern:30302a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
