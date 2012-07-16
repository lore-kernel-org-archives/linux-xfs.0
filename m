Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GEohvv248010 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 09:50:43 -0500
Subject: [GIT PULL] XFS update for 3.5-rc7
Message-Id: <20120716145658.C58D54266DC@whiskey.americas.sgi.com>
Date: Mon, 16 Jul 2012 09:56:58 -0500 (CDT)
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

   Please pull these regression fixes for XFS.  Here we have a fix for a cursor
   leak, a fix for a performance regression, a fix for recursion in
   xfs_buf_iorequest which causes stack overflows, and a fix for error handling
   in xfs_buf_iodone callbacks.

Thanks,
	Ben

The following changes since commit f7bdf03a99efc083608cd9c0c3e03abff311c79e:

  xfs: rename log structure to xlog (2012-06-21 14:21:11 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.5-rc7

for you to fetch changes up to 1632dcc93f55f9ab407b373da1957a727b1a7fe3:

  xfs: do not call xfs_bdstrat_cb in xfs_buf_iodone_callbacks (2012-07-13 13:09:49 -0500)

----------------------------------------------------------------
xfs: regression fixes for 3.5-rc7

 - Really fix a cursor leak in xfs_alloc_ag_vextent_near
 - Fix a performance regression related to doing allocation in workqueues
 - Prevent recursion in xfs_buf_iorequest which is causing stack overflows
 - Don't call xfs_bdstrat_cb in xfs_buf_iodone callbacks

----------------------------------------------------------------
Christoph Hellwig (2):
      xfs: prevent recursion in xfs_buf_iorequest
      xfs: do not call xfs_bdstrat_cb in xfs_buf_iodone_callbacks

Dave Chinner (2):
      xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near
      xfs: don't defer metadata allocation to the workqueue

 fs/xfs/xfs_alloc.c    | 19 +++++++++++++-----
 fs/xfs/xfs_buf.c      | 53 ++++++++++++++++++++++-----------------------------
 fs/xfs/xfs_buf.h      |  1 -
 fs/xfs/xfs_buf_item.c |  2 +-
 4 files changed, 38 insertions(+), 37 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
