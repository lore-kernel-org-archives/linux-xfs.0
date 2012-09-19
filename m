Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JLYXW5252512 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 16:34:33 -0500
Subject: [GIT PULL] XFS update for 3.6-rc7
Message-Id: <20120919213542.0E11F426BF4@whiskey.americas.sgi.com>
Date: Wed, 19 Sep 2012 16:35:42 -0500 (CDT)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull these 2 bugfixes for XFS.  There is a fix for crashes on unmount
   and a fix for a race when discarding xfs_bufs.

Thanks,
	Ben

The following changes since commit a672e1be30d5bc848cd0067c55ed29b2015b7c17:

  xfs: check for possible overflow in xfs_ioc_trim (2012-08-23 14:48:44 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.6-rc7

for you to fetch changes up to 0ba6e5368c302819da7aff537e0d7eff2616c6a6:

  xfs: stop the sync worker before xfs_unmountfs (2012-09-18 16:51:26 -0500)

----------------------------------------------------------------
xfs: bugfixes for 3.6-rc7

- fix a regression related to xfs_sync_worker racing with unmount.
- fix a race while discarding xfs buffers.

----------------------------------------------------------------
Ben Myers (1):
      xfs: stop the sync worker before xfs_unmountfs

Carlos Maiolino (1):
      xfs: fix race while discarding buffers [V4]

 fs/xfs/xfs_buf.c   |  5 ++++-
 fs/xfs/xfs_buf.h   | 41 ++++++++++++++++++++++++-----------------
 fs/xfs/xfs_super.c |  1 +
 3 files changed, 29 insertions(+), 18 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
