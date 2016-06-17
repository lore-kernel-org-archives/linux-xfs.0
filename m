Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 741797CD6
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:18:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37D138F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:33 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id crC8StLsn5BqRc7C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:31 -0700 (PDT)
Subject: [PATCH 005/119] xfs: check for a valid error_tag in errortag_add
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:18:24 -0700
Message-ID: <146612630452.12839.3528211000490660021.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Currently we don't check the error_tag when someone's trying to set up
error injection testing.  If userspace passes in a value we don't know
about, send back an error.  This will help xfstests to _notrun a test
that uses error injection to test things like log replay.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 88693a9..355619a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -61,6 +61,9 @@ xfs_errortag_add(int error_tag, xfs_mount_t *mp)
 	int len;
 	int64_t fsid;
 
+	if (error_tag >= XFS_ERRTAG_MAX)
+		return -EINVAL;
+
 	memcpy(&fsid, mp->m_fixedfsid, sizeof(xfs_fsid_t));
 
 	for (i = 0; i < XFS_NUM_INJECT_ERROR; i++)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
