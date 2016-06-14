Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 069A27CBE
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 13:13:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE46830405F
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 11:13:32 -0700 (PDT)
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
	[15.241.140.78]) by cuda.sgi.com with ESMTP id Jc9VWdbRTBl7iAQr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 11:13:30 -0700 (PDT)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH-tip 6/6] xfs: Enable reader optimistic spinning for DAX
	inodes
Date: Tue, 14 Jun 2016 14:12:39 -0400
Message-Id: <1465927959-39719-7-git-send-email-Waiman.Long@hpe.com>
In-Reply-To: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
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
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

This patch enables reader optimistic spinning for inodes that are
under a DAX-based mount point.

On a 4-socket Haswell machine running on a 4.7-rc1 tip-based kernel,
the fio test with multithreaded randrw and randwrite tests on the
same file on a XFS partition on top of a NVDIMM with DAX were run,
the aggregated bandwidths before and after the patch were as follows:

  Test      BW before patch     BW after patch  % change
  ----      ---------------     --------------  --------
  randrw        1352 MB/s          2164 MB/s      +60%
  randwrite     1710 MB/s          2550 MB/s      +49%

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/xfs/xfs_icache.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 99ee6ee..09f284f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -71,6 +71,15 @@ xfs_inode_alloc(
 
 	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
 
+	/*
+	 * Enable reader spinning for DAX nount point
+	 */
+	if (mp->m_flags & XFS_MOUNT_DAX) {
+		rwsem_set_rspin_threshold(&ip->i_iolock.mr_lock);
+		rwsem_set_rspin_threshold(&ip->i_mmaplock.mr_lock);
+		rwsem_set_rspin_threshold(&ip->i_lock.mr_lock);
+	}
+
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
 	ip->i_mount = mp;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
