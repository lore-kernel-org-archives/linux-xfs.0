Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F07A87F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 12:37:14 -0500 (CDT)
Subject: [GIT PULL] XFS update for 3.10-rc5
Message-Id: <20130606173711.80340500B5E@whiskey.americas.sgi.com>
Date: Thu,  6 Jun 2013 12:37:11 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Please pull these updates for XFS.  Here are several fixes for
filesystems with CRC support turned on:  fixes for quota, remote
attributes, and recovery.  There is also some feature work related to
CRCs:  the implementation of CRCs for the inode unlinked lists,
disabling noattr2/attr2 options when appropriate, and bumping the
maximum number of ACLs.

I would have preferred to defer this last category of items to 3.11.
This would require setting a feature bit for the on-disk changes, so
there is some pressure to get these in 3.10.  I believe this represents
the end of the CRC related queue.

Thanks,
Ben

The following changes since commit 7bc0dc271e494e12be3afd3c6431e5216347c624:

  xfs: rework remote attr CRCs (2013-05-30 17:26:31 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-v3.10-rc5

for you to fetch changes up to 0a8aa1939777dd114479677f0044652c1fd72398:

  xfs: increase number of ACL entries for V5 superblocks (2013-06-06 10:52:15 -0500)

----------------------------------------------------------------
xfs: update for 3.10-rc5

- Rework of dquot CRCs
- Fix for remote attribute invalidation of a leaf
- Fix ordering of transaction replay in recovery
- Implement CRCs for inode unlinked list
- Disable noattr2/attr2 mount options when CRCs are enabled
- Bump the limitation of ACL entries for v5 superblocks

----------------------------------------------------------------
Dave Chinner (6):
      xfs: rework dquot CRCs
      xfs: fix remote attribute invalidation for a leaf
      xfs: fix log recovery transaction item reordering
      xfs: inode unlinked list needs to recalculate the inode CRC
      xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
      xfs: increase number of ACL entries for V5 superblocks

 Documentation/filesystems/xfs.txt |  3 ++
 fs/xfs/xfs_acl.c                  | 31 +++++++++------
 fs/xfs/xfs_acl.h                  | 31 +++++++++++----
 fs/xfs/xfs_attr_leaf.c            |  2 +-
 fs/xfs/xfs_dquot.c                | 37 ++++++++---------
 fs/xfs/xfs_inode.c                | 16 ++++++++
 fs/xfs/xfs_log_recover.c          | 84 +++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_qm.c                   | 40 ++++++++++++++-----
 fs/xfs/xfs_quota.h                |  2 +
 fs/xfs/xfs_super.c                | 11 +++++
 10 files changed, 198 insertions(+), 59 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
