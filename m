Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44Jv56F081331 for <xfs@oss.sgi.com>; Fri, 4 May 2012 14:57:05 -0500
Date: Fri, 4 May 2012 15:00:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v5 PATCH 2/4] xfs: Add pquota fields where gquota is used.
Message-ID: <20120504200032.GV16881@sgi.com>
References: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120314202636.17044.11836.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120314202636.17044.11836.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 14, 2012 at 03:26:36PM -0500, Chandra Seetharaman wrote:
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 7c01cda..8800197 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -516,7 +516,7 @@ xfs_setattr_nonsize(
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
>  		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
> -					 qflags, &udqp, &gdqp);
> +					 qflags, &udqp, &gdqp, NULL);
>  		if (error)
>  			return error;
>  	}
> @@ -552,7 +552,7 @@ xfs_setattr_nonsize(
>  		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
>  			ASSERT(tp);
>  			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						capable(CAP_FOWNER) ?
> +						NULL, capable(CAP_FOWNER) ?
>  						XFS_QMOPT_FORCE_RES : 0);
>  			if (error)	/* out of quota */
>  				goto out_trans_cancel;

I popped an assert in xfs_setattr_nonsize in my testing.  Here is my suggestion:

Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c
+++ xfs/fs/xfs/xfs_iops.c
@@ -594,7 +594,8 @@ xfs_setattr_nonsize(
                }
                if (igid != gid) {
                        if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
-                               ASSERT(!XFS_IS_PQUOTA_ON(mp));
+                               ASSERT(xfs_sb_version_has_no_oquota(&mp->m_sb)
+                                      || !XFS_IS_PQUOTA_ON(mp));
                                ASSERT(mask & ATTR_GID);
                                ASSERT(gdqp);
                                olddquot2 = xfs_qm_vop_chown(tp, ip,

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
