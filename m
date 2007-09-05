Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Sep 2007 02:15:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l859FU4p024958
	for <xfs@oss.sgi.com>; Wed, 5 Sep 2007 02:15:32 -0700
Message-ID: <46DE73AA.1090706@sgi.com>
Date: Wed, 05 Sep 2007 19:15:22 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: some XFS fixes for 2.6.23
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, xfs-oss <xfs@oss.sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi Linus,

We have a few XFS fixes for 2.6.23 (meant to do this earlier).
They have been in sgi dev tree and mm tree for a while.

Please pull from the for-linus branch:
     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus


With shortlog:
-------------------------
Christoph Hellwig (4):
       [XFS] Fix sparse NULL vs 0 warnings
       [XFS] Fix sparse warning in kmem_shake_allow
       [XFS] fix ASSERT and ASSERT_ALWAYS
       [XFS] fix sparse shadowed variable warnings

David Chinner (1):
       [XFS] Set filestreams object timeout to something sane.

Eric Sandeen (1):
       [XFS] fix nasty quota hashtable allocation bug
-------------------------

This will update the following files:

  fs/xfs/linux-2.6/kmem.h        |    2 +-
  fs/xfs/linux-2.6/xfs_aops.c    |    8 ++++----
  fs/xfs/linux-2.6/xfs_globals.c |    2 +-
  fs/xfs/quota/xfs_qm.c          |    3 ++-
  fs/xfs/support/debug.h         |   10 ++++++----
  fs/xfs/xfs_da_btree.c          |    1 -
  fs/xfs/xfs_log.c               |   12 ++++++------
  fs/xfs/xfs_log_recover.c       |   12 ++++++------
  8 files changed, 26 insertions(+), 24 deletions(-)

through these commits:

commit 5995cb7d805496362e5af73235145667096fbc6f
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 16 16:49:11 2007 +1000

     [XFS] fix nasty quota hashtable allocation bug

     This git mod: 77e4635ae191774526ed695482a151ac986f3806
     converted to a "greedy" allocation interface, but for the quota hashtables
     it switched from allocating XFS_QM_HASHSIZE (nr of elements)
     xfs_dqhash_t's to allocating only XFS_QM_HASHSIZE *bytes* - quite a lot
     smaller! Then when we converted hsize "back" to nr of elements (the
     division line) hsize went to 0. This was leading to oopses when running
     any quota tests on the Fedora 8 test kernel, but the problem has been
     there for almost a year.

     SGI-PV: 968837
     SGI-Modid: xfs-linux-melb:xfs-kern:29354a

     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 265c1fac38e37e828df09965406e9cc20bfa3588
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 15:38:19 2007 +1000

     [XFS] fix sparse shadowed variable warnings

     - in xfs_probe_cluster rename the inner len to pg_len. There's no harm
       here because the outer len isn't used after the inner len comes into
       existence but it keeps the code clean.
     - in xfs_da_do_buf remove the inner i because they don't overlap
       and they are both the same type.

     SGI-PV: 968555
     SGI-Modid: xfs-linux-melb:xfs-kern:29311a

     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit ee5c80239d5f152d99f69165afbd115518353563
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 15:38:08 2007 +1000

     [XFS] fix ASSERT and ASSERT_ALWAYS

     - remove the != 0 inside the unlikely in ASSERT_ALWAYS because sparse now
       complains about comparisons between pointers and 0
     - add a standalone ASSERT implementation because defining it to
       ASSERT_ALWAYS means the string is expanded before the token passing
       stringification. This way we get the actual content of the
       assertion in the assfail message and don't overflow sparse's
       stringification buffer leading to sparse error messages.

     SGI-PV: 968555
     SGI-Modid: xfs-linux-melb:xfs-kern:29310a

     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 34521c5e4971d01f6ef650fdee59e07be6c2c5e3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 15:37:57 2007 +1000

     [XFS] Fix sparse warning in kmem_shake_allow

     We can't return a masked result of a __bitwise type. Compare it to 0 first
     to keep the behaviour without the warning.

     SGI-PV: 968555
     SGI-Modid: xfs-linux-melb:xfs-kern:29309a

     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 4b80916b29170744632356dd2e801f7c374676eb
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Aug 16 15:37:36 2007 +1000

     [XFS] Fix sparse NULL vs 0 warnings

     Sparse now warns about comparing pointers to 0, so change all instance
     where that happens to NULL instead.

     SGI-PV: 968555
     SGI-Modid: xfs-linux-melb:xfs-kern:29308a

     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 8da22d7a3690818f6d340baa0ea585e71f0c506f
Author: David Chinner <dgc@sgi.com>
Date:   Thu Aug 16 15:20:56 2007 +1000

     [XFS] Set filestreams object timeout to something sane.

     SGI-PV: 968554
     SGI-Modid: xfs-linux-melb:xfs-kern:29303a

     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: Tim Shimmin <tes@sgi.com>
