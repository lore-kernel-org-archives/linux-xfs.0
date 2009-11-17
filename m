Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAHHJfjj053611 for <xfs@oss.sgi.com>; Tue, 17 Nov 2009 11:19:41 -0600
Date: Tue, 17 Nov 2009 11:19:58 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <200911171719.nAHHJwjq017993@stout.americas.sgi.com>
Subject: [GIT PULL] XFS update for 2.6.32
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

Here are two regressions that have been identified in XFS
in the last few days.  I'm hoping to get these fixes into
2.6.32.

					-Alex

The following changes since commit a9366e61b03f55a6e009e687ad10e706714c9907:
  Linus Torvalds (1):
        Merge git://git.infradead.org/users/dwmw2/iommu-2.6.32

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Jan Rekorajski (1):
      XFS bug in log recover with quota (bugzilla id 855)

Nathaniel W. Turner (1):
      xfs: copy li_lsn before dropping AIL lock

 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_trans_ail.c   |   23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 5 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
