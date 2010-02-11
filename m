Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1BM3hhl183569 for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 16:03:43 -0600
Subject: [PATCH 0/2] commit_metadata export operation v4
From: Ben Myers <bpm@sgi.com>
Date: Thu, 11 Feb 2010 16:04:55 -0600
Message-ID: <20100211220454.26466.37578.stgit@case>
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
To: bfields@fieldses.org
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

Hey Bruce,

Here is the latest version of the knfsd sync changes.  I have addressed the
suggestions provided by Christoph, Trond, and Dave.  This time rebased atop
for-2.6.34 (I hope).  Sorry for the extra noise.

Thanks,
	Ben

---

Ben Myers (2):
      commit_metadata export operation replacing nfsd_sync_dir
      xfs_export_operations.commit_metadata


 fs/nfsd/nfs3proc.c            |    2 -
 fs/nfsd/nfs4proc.c            |    2 -
 fs/nfsd/nfs4recover.c         |    4 -
 fs/nfsd/nfs4state.c           |    2 -
 fs/nfsd/nfsproc.c             |    4 +
 fs/nfsd/vfs.c                 |  116 +++++++++++++++++++----------------------
 fs/nfsd/vfs.h                 |    3 -
 fs/xfs/linux-2.6/xfs_export.c |   43 +++++++++++++++
 include/linux/exportfs.h      |    6 ++
 9 files changed, 111 insertions(+), 71 deletions(-)

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
