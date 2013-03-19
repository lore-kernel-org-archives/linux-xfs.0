Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3CF117F53
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 17:13:34 -0500 (CDT)
Subject: [GIT PULL] XFS fixes for 3.9-rc4
Message-Id: <20130319221330.6C8BB500B4B@whiskey.americas.sgi.com>
Date: Tue, 19 Mar 2013 17:13:30 -0500 (CDT)
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

Please pull these fixes for XFS.  There is a fix for a potential
infinite loop which was introduced in 4d559a3bcb73, a fix for the return
type of xfs_iomap_eof_prealloc_initial_size from a1e16c26660b, and a fix
for a failed buffer readahead causing subsequent callers to fail
incorrectly.

Thanks,
Ben


The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.9-rc4

for you to fetch changes up to e001873853d87674dd5b3cfa2851885023616695:

  xfs: ensure we capture IO errors correctly (2013-03-18 13:39:10 -0500)

----------------------------------------------------------------
- Fix for a potential infinite loop which was introduced in 4d559a3bcb73
- Fix for the return type of xfs_iomap_eof_prealloc_initial_size
  from a1e16c26660b
- Fix for a failed buffer readahead causing subsequent callers to
  fail incorrectly

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix potential infinite loop in xfs_iomap_prealloc_size()

Dave Chinner (1):
      xfs: ensure we capture IO errors correctly

Mark Tinguely (1):
      xfs: fix xfs_iomap_eof_prealloc_initial_size type

 fs/xfs/xfs_buf.c   |    6 ++++++
 fs/xfs/xfs_iomap.c |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
