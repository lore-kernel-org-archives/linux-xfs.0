Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27D7E7F51
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 21:12:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14086304051
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 19:12:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	y7T18C6I4tWJ5T5S for <xfs@oss.sgi.com>;
	Thu, 15 May 2014 19:11:59 -0700 (PDT)
Date: Fri, 16 May 2014 12:11:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 3.15-rc6
Message-ID: <20140516021144.GK5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the updates listed below? I found a bunch of
error sign issues while determine what we need to do to rid XFS of
this problem permanently. A couple of the bugs are in data integirty
operations, a couple more are in the new COLLAPSE_RANGE code. One of
these came in through a recent ext4 merge and so I had to update the
base tree to 3.15-rc5 before fixing the issues.

-Dave.

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.15-rc6

for you to fetch changes up to ee4eec478be4677b93775d17bc079efb5922b276:

  xfs: list_lru_init returns a negative error (2014-05-15 09:23:24 +1000)

----------------------------------------------------------------
xfs: fixes for 3.15-rc6

Code inspection of the XFS error number sign translations found a bunch of
issues, including returning incorrectly signed errors for some data integrity
operations. These leak to userspace and result in applications not getting the
errors correctly reported. Hence they need fixing sooner rather than later.

----------------------------------------------------------------
Dave Chinner (9):
      xfs: xfs_dir_fsync() returns positive errno
      xfs: fix incorrect error sign in xfs_file_aio_read
      xfs: xfs_commit_metadata returns wrong errno
      xfs: correct error sign on COLLAPSE_RANGE errors
      xfs: fix wrong errno from xfs_initxattrs
      xfs: fix wrong err sign on xfs_set_acl()
      xfs: negate mount workqueue init error value
      xfs: negate xfs_icsb_init_counters error value
      xfs: list_lru_init returns a negative error

 fs/xfs/xfs_export.c |    2 +-
 fs/xfs/xfs_file.c   |    8 ++++----
 fs/xfs/xfs_iops.c   |   12 ++++++------
 fs/xfs/xfs_qm.c     |   26 ++++++++++++++------------
 fs/xfs/xfs_super.c  |    4 ++--
 5 files changed, 27 insertions(+), 25 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
