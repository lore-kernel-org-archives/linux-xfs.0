Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C762A7F75
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 13:53:18 -0600 (CST)
Subject: [GIT PULL] XFS bugfixes for 3.13-rc4
Message-Id: <20131210195315.3F9504266DC@whiskey.americas.sgi.com>
Date: Tue, 10 Dec 2013 13:53:15 -0600 (CST)
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

   Please pull these bugfixes for xfs.  There is a security fix for memory
   corruption in xfs_attrlist_by_handle, a fix for trim, and a fix for buffer
   overrun in the agfl when growing filesystems with a v4 superblock.

Thanks,
	Ben

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.13-rc4

for you to fetch changes up to f94c44573e7c22860e2c3dfe349c45f72ba35ad3:

  xfs: growfs overruns AGFL buffer on V4 filesystems (2013-12-10 10:04:27 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.13-rc4

- fix for buffer overrun in agfl with growfs on v4 superblock
- return EINVAL if requested discard length is less than a block
- fix possible memory corruption in xfs_attrlist_by_handle()

----------------------------------------------------------------
Dan Carpenter (1):
      xfs: underflow bug in xfs_attrlist_by_handle()

Dave Chinner (1):
      xfs: growfs overruns AGFL buffer on V4 filesystems

Jie Liu (1):
      xfs: don't perform discard if the given range length is less than block size

 fs/xfs/xfs_discard.c | 5 +++--
 fs/xfs/xfs_fsops.c   | 6 +++++-
 fs/xfs/xfs_ioctl.c   | 3 ++-
 fs/xfs/xfs_ioctl32.c | 3 ++-
 4 files changed, 12 insertions(+), 5 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
