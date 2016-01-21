Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96C6C7F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 17:22:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68155304032
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 15:22:32 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	J5PNrAOpvZej3ZGr for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 15:22:29 -0800 (PST)
Date: Fri, 22 Jan 2016 10:22:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: update #2 for 4.5-rc1
Message-ID: <20160121232227.GH20456@dastard>
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
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the changes from the tag below? This is the
second update for XFS that I mentioned in the original pull request
last week. It contains a revert for a suspend regression in 4.4 and
a fix for a long standing log recovery issue that has been further
exposed by all the log recovery changes made in the original 4.5
merge.

There is one more thing in this pull request - one that I forgot to
merge into the origin. That is, pulling the XFS_IOC_FS[GS]ETXATTR
ioctl up to the VFS level so that other filesystems can also use it
for modifying project quota IDs. This allows the new ext4 project
quota functionality to work with the XFs quota tools to manage
project quotas, which means the ext4 project quota code can be
tested against all the xfstests project quota tests that are written
around xfs_quota. The original branch I posted has been used by Ted
in the ext4 tree, so I have not modified it to add SOBs, etc. I've
added those tags in the summary for the tag for this pull request,
hence they shouldn't ever get lost.

Thanks!

-Dave.

The following changes since commit dde7f55bd000696acc38296c21241971e1840142:

  Merge branch 'xfs-misc-fixes-for-4.5-2' into for-next (2016-01-12 07:04:30 +1100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.5-2

for you to fetch changes up to ee3804d9f94c5a391c66386b70b9fe5a58775507:

  Merge branch 'xfs-misc-fixes-for-4.5-3' into for-next (2016-01-19 08:28:36 +1100)

----------------------------------------------------------------

xfs: Update 2 for 4.5-rc1

This update contains:

o promotion of XFS_IOC_FS[GS]ETXATTR ioctl to the vfs level so that
  it can be shared with other filesystems. The ext4 project quota
  functionality is the first target for this. The commits in this
  series have not been updated with review or final SOB tags because
  the branch they were originally published in was needed by ext4.
  Those tags are:

  Reviewed-by: Theodore Ts'o <tytso@mit.edu>
  Signed-off-by: Dave Chinner <david@fromrobit.com>

o Revert a change that is causing suspend failures.
o Fix a use-after-free that can occur on log mount failures. Been
  around forever, but now exposed by other changes to log recovery
  made in the first 4.5 merge.

----------------------------------------------------------------
Dave Chinner (7):
      fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
      xfs: use FS_XFLAG definitions directly
      xfs: introduce per-inode DAX enablement
      Merge branch 'xfs-setxattr-promotion' into for-next
      Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
      xfs: log mount failures don't wait for buffers to be released
      Merge branch 'xfs-misc-fixes-for-4.5-3' into for-next

 fs/xfs/libxfs/xfs_format.h |   11 +++++-
 fs/xfs/libxfs/xfs_fs.h     |   38 +-----------------
 fs/xfs/xfs_buf.c           |   10 +++++
 fs/xfs/xfs_inode.c         |   60 ++++++++++++++++++-----------
 fs/xfs/xfs_ioctl.c         |   92 ++++++++++++++++++++++++++------------------
 fs/xfs/xfs_iops.c          |    4 +-
 fs/xfs/xfs_trans_ail.c     |    1 -
 include/uapi/linux/fs.h    |   33 ++++++++++++++++
 8 files changed, 147 insertions(+), 102 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
