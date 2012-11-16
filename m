Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6hQpg067216 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:43:26 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Tkgky9Q3BDOyWdet (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:45:31 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6jTqD019995
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:30 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6jTCr005029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:29 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6jT69010849 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:29 -0600
Message-ID: <50A5E104.2080309@oracle.com>
Date: Fri, 16 Nov 2012 14:45:24 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 04/15] xfs: Introduce a new ioctl(2) to get AG state
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
To: xfs@oss.sgi.com

Introduce a new ioctl(2) to get a.g. state.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ag.h    |    2 +
 fs/xfs/xfs_fs.h    |    1 +
 fs/xfs/xfs_fsops.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c |   19 ++++++++++++++++++
 4 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index e2588d9..7ec7dba 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -248,6 +248,8 @@ typedef struct xfs_ioc_agstate {
 #define XFS_AG_STATE_ALLOC_DENY		(1 << 0)
 #define XFS_AG_ALL_STATE		(XFS_AG_STATE_ALLOC_DENY)
 
+extern int xfs_get_agstate(struct xfs_mount *mp,
+			   struct xfs_ioc_agstate *agstate);
 extern int xfs_set_agstate(struct xfs_mount *mp,
 			   struct xfs_ioc_agstate *agstate);
 
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 991c09e..e306b8f 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -487,6 +487,7 @@ typedef struct xfs_handle {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 #define XFS_IOC_SET_AGSTATE	     _IOW('X', 126, struct xfs_ioc_agstate)
+#define XFS_IOC_GET_AGSTATE	     _IOR('X', 127, struct xfs_ioc_agstate)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3742511..029ab6d 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -182,6 +182,59 @@ error0:
 }
 
 static int
+xfs_get_agstate_private(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno,
+	__uint32_t	*state)
+{
+	xfs_perag_t	*pag;
+	xfs_agf_t	*agf;
+	xfs_buf_t	*bp;
+	int		error = 0;
+
+	pag = xfs_perag_get(mp, agno);
+	if (pag) {
+		*state = pag->pag_state;
+		goto out_put_perag;
+	}
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+			 XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp) {
+		error = ENOMEM;
+		goto out_put_perag;
+	}
+	agf = XFS_BUF_TO_AGF(bp);
+	*state = agf->agf_state;
+
+out_put_perag:
+	xfs_perag_put(pag);
+	return error;
+}
+
+int
+xfs_get_agstate(
+	xfs_mount_t		*mp,
+	xfs_ioc_agstate_t	*agstate)
+{
+	xfs_agnumber_t		agno;
+	__uint32_t		state;
+	int			error;
+
+	agno = agstate->agno;
+	if (agno >= mp->m_sb.sb_agcount)
+		return XFS_ERROR(EINVAL);
+
+	error = xfs_get_agstate_private(mp, agno, &state);
+	if (error)
+		return error;
+
+	agstate->state = state;
+	return 0;
+}
+
+static int
 xfs_growfs_data_private(
 	xfs_mount_t		*mp,	/* mount point for filesystem */
 	xfs_growfs_data_t	*in)	/* growfs data input struct */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index efe39ef..4d3a705 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1615,6 +1615,25 @@ xfs_file_ioctl(
 		return -error;
 	}
 
+	case XFS_IOC_GET_AGSTATE: {
+		xfs_ioc_agstate_t inout;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&inout, arg, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+
+		error = xfs_get_agstate(mp, &inout);
+		if (error)
+			return -error;
+
+		if (copy_to_user(arg, &inout, sizeof(inout)))
+			return -XFS_ERROR(EFAULT);
+
+		return 0;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
