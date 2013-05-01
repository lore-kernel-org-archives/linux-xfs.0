Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCBFF7F9B
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 09:26:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47753AC001
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 07:26:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QjrUpNiLlhEoXHIp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 07:26:35 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r41EQXcK017612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 1 May 2013 14:26:34 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r41EQXe6007768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Wed, 1 May 2013 14:26:34 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r41EQXh0018240 for <xfs@oss.sgi.com>; Wed, 1 May 2013 14:26:33 GMT
Message-ID: <51812614.2010807@oracle.com>
Date: Wed, 01 May 2013 22:26:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Remove xfs_krash from struct xfs_mount
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Remove struct xfs_krash from xfs_mount as there is no user of it nowadays.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_mount.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bc90706..b68e56b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -192,8 +192,6 @@ typedef struct xfs_mount {
 	xfs_dablk_t		m_dirleafblk;	/* blockno of dir non-data v2 */
 	xfs_dablk_t		m_dirfreeblk;	/* blockno of dirfreeindex v2 */
 	uint			m_chsize;	/* size of next field */
-	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
-						 * hash table */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
 	xfs_icsb_cnts_t __percpu *m_sb_cnts;	/* per-cpu superblock counters */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
