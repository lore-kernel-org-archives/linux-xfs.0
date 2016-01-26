Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8802B7CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 07:10:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 75F588F8039
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 05:10:02 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 3y3AAE5JV9aGnHSV (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 05:10:00 -0800 (PST)
Date: Tue, 26 Jan 2016 14:10:11 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/7 V3] quota: add new quotactl Q_GETNEXTQUOTA
Message-ID: <20160126131011.GC23820@quack.suse.cz>
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Just for reference attached are two patches that implement support for
Q_GETNEXTQUOTA and Q_XGETNEXTQUOTA in quota-tools. I have used it for
testing XFS and VFS infrastructure for these new quotactls.

								Honza
On Fri 22-01-16 12:25:29, Eric Sandeen wrote:
> This adds a new quotactl, Q_GETNEXTQUOTA.
> 
> Q_GETNEXTQUOTA is exactly like Q_GETQUOTA, except that it will
> return quota information for the id equal to or greater than
> the id requested.  In other words, if the specified id has
> no quota, the command will return quota information for the
> next higher id which does have a quota set.  If no higher id
> has an active quota, -ESRCH is returned.
> 
> So if you ask for id X, you can get back quota for id X,
> id X+N, or -ESRCH if no higher id has a quota.
> 
> This allows filesystems to do efficient iteration in kernelspace,
> much like extN filesystems do in userspace when asked to report
> all active quotas.
> 
> Today, filesystems such as XFS require getpwent()-style iterations,
> and for systems which have i.e. LDAP backends, this can be very
> slow, or even impossible if iteration is not allowed in the
> configuration.
> 
> Patches 1 and 4 are just small fixups that turned up along the way;
> 2 and 3 add the actual quota plumbing, and the rest are xfs-specific
> to allow xfs to support this new interface.
> 
> For non-xfs quota, this does require a new structure which is
> able to pass back the discovered ID along with the quota info.
> For xfs-quota, the id is already present in the structure.
> 
> V3:
> * Remove 32-bit compat stuff (i686/x86_64 at least works w/o it...)
> * Require CAP_SYS_ADMIN for these calls
> * Pass back found ID in &qid passed to ->get_nextdqblk, rather
>   than modifying struct qc_dqblk
> * Munge that found ID back through user-namespace conversions
>   before returning it in the user structure.
> 
> Thanks,
> -Eric
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--J2SCkAp4GZ/dPZZf
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Scan-dquots-using-Q_GETNEXTQUOTA.patch"

>From 9ae91376373b1b0a8d4573834d0d99722a5909f6 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 26 Jan 2016 13:10:59 +0100
Subject: [PATCH 1/2] Scan dquots using Q_GETNEXTQUOTA

Check for new kernel quotactl Q_GETNEXTQUOTA and if available use it for
scanning all dquot structures.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 quota.h           | 14 ++++++++++++++
 quotaio_generic.c | 34 ++++++++++++++++++++++++++++++++++
 quotaio_generic.h |  4 ++++
 quotaio_meta.c    | 14 +++++++++++++-
 4 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/quota.h b/quota.h
index 0c3842774e6f..0607e04b1f02 100644
--- a/quota.h
+++ b/quota.h
@@ -63,6 +63,7 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
 #define Q_SETINFO  0x800006	/* set information about quota files */
 #define Q_GETQUOTA 0x800007	/* get user quota structure */
 #define Q_SETQUOTA 0x800008	/* set user quota structure */
+#define Q_GETNEXTQUOTA 0x800009	/* get disk limits and usage >= ID */
 
 /*
  * Quota structure used for communication with userspace via quotactl
@@ -91,6 +92,19 @@ struct if_dqblk {
 	u_int32_t dqb_valid;
 };
 
+struct if_nextdqblk {
+	u_int64_t dqb_bhardlimit;
+	u_int64_t dqb_bsoftlimit;
+	u_int64_t dqb_curspace;
+	u_int64_t dqb_ihardlimit;
+	u_int64_t dqb_isoftlimit;
+	u_int64_t dqb_curinodes;
+	u_int64_t dqb_btime;
+	u_int64_t dqb_itime;
+	u_int32_t dqb_valid;
+	u_int32_t dqb_id;
+};
+
 /*
  * Structure used for setting quota information about file via quotactl
  * Following flags are used to specify which fields are valid
diff --git a/quotaio_generic.c b/quotaio_generic.c
index 5001a56f8a6b..06b16e791624 100644
--- a/quotaio_generic.c
+++ b/quotaio_generic.c
@@ -161,3 +161,37 @@ int generic_scan_dquots(struct quota_handle *h,
 	free(dquot);
 	return ret;
 }
+
+int vfs_scan_dquots(struct quota_handle *h,
+		    int (*process_dquot)(struct dquot *dquot, char *dqname))
+{
+	struct dquot *dquot = get_empty_dquot();
+	qid_t id = 0;
+	struct if_nextdqblk kdqblk;
+	int ret;
+
+	dquot->dq_h = h;
+	while (1) {
+		ret = quotactl(QCMD(Q_GETNEXTQUOTA, h->qh_type),
+			       h->qh_quotadev, id, (void *)&kdqblk);
+		if (ret < 0)
+			break;
+
+		/*
+		 * This is a slight hack but we know struct if_dqblk is a
+		 * subset of struct if_nextdqblk
+		 */
+		generic_kern2utildqblk(&dquot->dq_dqb,
+				       (struct if_dqblk *)&kdqblk);
+		dquot->dq_id = kdqblk.dqb_id;
+		ret = process_dquot(dquot, NULL);
+		if (ret < 0)
+			break;
+		id = kdqblk.dqb_id + 1;
+	}
+	free(dquot);
+
+	if (errno == ESRCH)
+		return 0;
+	return ret;
+}
diff --git a/quotaio_generic.h b/quotaio_generic.h
index 5edc11cd947e..a7930f0214bd 100644
--- a/quotaio_generic.h
+++ b/quotaio_generic.h
@@ -27,4 +27,8 @@ int generic_scan_dquots(struct quota_handle *h,
 			int (*process_dquot)(struct dquot *dquot, char *dqname),
 			int (*get_dquot)(struct dquot *dquot));
 
+/* Scan all dquots using kernel quotactl to get existing ids */
+int vfs_scan_dquots(struct quota_handle *h,
+		    int (*process_dquot)(struct dquot *dquot, char *dqname));
+
 #endif
diff --git a/quotaio_meta.c b/quotaio_meta.c
index e52b4f4322f1..ad6ff7ab2299 100644
--- a/quotaio_meta.c
+++ b/quotaio_meta.c
@@ -8,6 +8,7 @@
 
 #include <string.h>
 #include <stdlib.h>
+#include <errno.h>
 
 #include <sys/types.h>
 
@@ -55,7 +56,18 @@ static int meta_commit_dquot(struct dquot *dquot, int flags)
 
 static int meta_scan_dquots(struct quota_handle *h, int (*process_dquot)(struct dquot *dquot, char *dqname))
 {
-	return generic_scan_dquots(h, process_dquot, vfs_get_dquot);
+	struct if_nextdqblk kdqblk;
+	int ret;
+
+	ret = quotactl(QCMD(Q_GETNEXTQUOTA, h->qh_type), h->qh_quotadev, 0,
+		       (void *)&kdqblk);
+	/*
+	 * Fall back to scanning using passwd if Q_GETNEXTQUOTA is not
+	 * supported
+	 */
+	if (ret < 0 && (errno == ENOSYS || errno == EINVAL))
+		return generic_scan_dquots(h, process_dquot, vfs_get_dquot);
+	return vfs_scan_dquots(h, process_dquot);
 }
 
 struct quotafile_ops quotafile_ops_meta = {
-- 
2.6.2


--J2SCkAp4GZ/dPZZf
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-Add-support-for-scanning-using-Q_XGETNEXTQUOTA.patch"

>From 304bed24716fdbb7c636ea8df0462d4f979f23a0 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 26 Jan 2016 14:06:59 +0100
Subject: [PATCH 2/2] Add support for scanning using Q_XGETNEXTQUOTA

Add support for scanning of all available quota structures using
Q_XGETNEXTQUOTA quotactl.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 quotaio_xfs.c | 42 +++++++++++++++++++++++++++++++++++++++---
 quotaio_xfs.h |  1 +
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/quotaio_xfs.c b/quotaio_xfs.c
index 903c03e6d3f8..14646411dbab 100644
--- a/quotaio_xfs.c
+++ b/quotaio_xfs.c
@@ -191,15 +191,51 @@ static int xfs_get_dquot(struct dquot *dq)
 	return 0;
 }
 
+static int xfs_kernel_scan_dquots(struct quota_handle *h,
+		int (*process_dquot)(struct dquot *dquot, char *dqname))
+{
+	struct dquot *dquot = get_empty_dquot();
+	qid_t id = 0;
+	struct xfs_kern_dqblk xdqblk;
+	int ret;
+
+	dquot->dq_h = h;
+	while (1) {
+		ret = quotactl(QCMD(Q_XGETNEXTQUOTA, h->qh_type),
+			       h->qh_quotadev, id, (void *)&xdqblk);
+		if (ret < 0)
+			break;
+
+		xfs_kern2utildqblk(&dquot->dq_dqb, &xdqblk);
+		dquot->dq_id = xdqblk.d_id;
+		ret = process_dquot(dquot, NULL);
+		if (ret < 0)
+			break;
+		id = xdqblk.d_id + 1;
+	}
+	free(dquot);
+
+	if (errno == ESRCH)
+		return 0;
+	return ret;
+}
+
 /*
  *	Scan all known dquots and call callback on each
  */
 static int xfs_scan_dquots(struct quota_handle *h, int (*process_dquot) (struct dquot *dquot, char *dqname))
 {
-	if (!XFS_USRQUOTA(h) && !XFS_GRPQUOTA(h))
-		return 0;
+	int ret;
+	struct xfs_kern_dqblk xdqblk;
 
-	return generic_scan_dquots(h, process_dquot, xfs_get_dquot);
+	ret = quotactl(QCMD(Q_XGETNEXTQUOTA, h->qh_type), h->qh_quotadev, 0,
+		       (void *)&xdqblk);
+	if (ret < 0 && (errno == ENOSYS || errno == EINVAL)) {
+		if (!XFS_USRQUOTA(h) && !XFS_GRPQUOTA(h))
+			return 0;
+		return generic_scan_dquots(h, process_dquot, xfs_get_dquot);
+	}
+	return xfs_kernel_scan_dquots(h, process_dquot);
 }
 
 /*
diff --git a/quotaio_xfs.h b/quotaio_xfs.h
index 54725b044d63..2236da48f832 100644
--- a/quotaio_xfs.h
+++ b/quotaio_xfs.h
@@ -46,6 +46,7 @@
 #define Q_XSETQLIM   XQM_CMD(0x4)	/* set disk limits only */
 #define Q_XGETQSTAT  XQM_CMD(0x5)	/* returns fs_quota_stat_t struct */
 #define Q_XQUOTARM   XQM_CMD(0x6)	/* free quota files' space */
+#define Q_XGETNEXTQUOTA	XQM_CMD(0x9)	/* get disk limits and usage >= ID */
 
 /*
  * fs_disk_quota structure:
-- 
2.6.2


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--J2SCkAp4GZ/dPZZf--
