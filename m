Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 22:59:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBI6x6Hs020325
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 22:59:10 -0800
Date: Tue, 18 Dec 2007 17:59:11 +1100
Subject: [GIT PULL] XFS update for 2.6.24-rc6
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_file.c |    4 ++--
 fs/xfs/xfs_dir2_block.c     |    6 ++----
 fs/xfs/xfs_dir2_leaf.c      |    2 +-
 fs/xfs/xfs_dir2_sf.c        |    9 +++------
 fs/xfs/xfs_inode.c          |    6 ++++--
 5 files changed, 12 insertions(+), 15 deletions(-)

through these commits:

commit 041388b54ed95cd169546bd83bacd08ee32bd7ea
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Tue Dec 18 16:19:34 2007 +1100

    [XFS] Put the correct offset in dirent d_off
    
    The recent filldir regression fix was not putting the correct d_off in
    each dirent. This was resulting in incorrect cookies being passed to dmapi
    ioctls and the wrong offset appearing in the dirents. readdir was
    unaffected as the filp->f_pos was being updated with the correct offset
    and this was being written into the last dirent in each buffer. Fix the
    XFS code to do the right thing.
    
    SGI-PV: 973746
    SGI-Modid: xfs-linux-melb:xfs-kern:30240a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit c734c79bc397eace039bea406997efa89f879c14
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Tue Dec 18 16:17:41 2007 +1100

    [XFS] Don't wait for pending I/Os when purging blocks beyond eof.
    
    On last close of a file we purge blocks beyond eof. The same code is used
    when we truncate the file size down. In this case we need to wait for any
    pending I/Os for dirty pages beyond the new eof. For the last close case
    we are not changing the file size and therefore do not need to wait for
    any I/Os to complete. This fixes a performance bottleneck where writes
    into the page cache and cache flushes can become mutually exclusive.
    
    SGI-PV: 964002
    SGI-Modid: xfs-linux-melb:xfs-kern:30220a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Peter Leckie <pleckie@sgi.com>
