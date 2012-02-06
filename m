Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16Ci5YK132394 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 06:44:05 -0600
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 0/3] xfs: change available ranges in quota check
Date: Mon, 06 Feb 2012 21:49:51 +0900
Message-ID: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi,

This patch series changes available ranges of softlimit and
hardlimit in quota check. Currently xfs quota allows us to
use disk blocks up to lower than quota limits. They should
be used up to not beyond them.

Thanks.

---

Mitsuo Hayasaka (3):
      xfs: cleanup quota check on disk blocks and inodes reservations
      xfs: make inode quota check more general
      xfs: change available ranges of softlimit and hardlimit in quota check


 fs/xfs/xfs_dquot.c       |   24 ++++++++++++------------
 fs/xfs/xfs_log_recover.c |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   15 +++++++--------
 4 files changed, 24 insertions(+), 25 deletions(-)

-- 
Mitsuo Hayasaka (mitsuo.hayasaka.hu@hitachi.com)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
