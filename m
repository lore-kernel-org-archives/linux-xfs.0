Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFgxIR010301 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:42:59 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFCE61DFBFB
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:37:58 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id PLjcX0ASNOIbIiKl for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:37:58 -0700 (PDT)
From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 0/5] xfstests enhancement and bug fix
Date: Thu, 20 Oct 2011 23:41:17 +0800
Message-Id: <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
References: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
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
To: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Anand Jain <Anand.Jain@oracle.com>

Anand Jain (5):
  updating to fill files with random data
  Added SCRATCH_DEV_POOL to specify multiple disks for the btrfs RAID
  264: Functional test case for the btrfs snapshot
  265: Functional test case for the btrfs raid operations
  _populate_fs should use OPTIND when getopts is used

 264           |  193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out       |    2 +
 265           |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out       |    2 +
 README        |   16 ++++-
 common.config |   11 +++
 common.rc     |   96 ++++++++++++++++++++++++++--
 group         |    2 +
 8 files changed, 498 insertions(+), 11 deletions(-)
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out

-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
