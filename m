Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F18F7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 00:38:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1950D304043
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 22:38:31 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id rL9JRjasYwnY1voF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 22:38:30 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r5O5WA3M004507
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 05:32:11 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5O5cRGD021383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 05:38:28 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5O5cRBH021366 for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 05:38:27 GMT
Message-ID: <51C7DB5A.90900@oracle.com>
Date: Mon, 24 Jun 2013 13:38:34 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs: Remove dead function prototype xfs_sync_inode_grab()
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

Remove dead function prototype xfs_sync_inode_grab()
from xfs_icache.h.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_icache.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e0f138c..a01afbb 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -40,7 +40,6 @@ void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
 void xfs_eofblocks_worker(struct work_struct *);
 
-int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag,
 		int flags, void *args),
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
