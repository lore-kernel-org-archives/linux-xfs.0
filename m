Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B75327F37
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 05:53:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56B3FAC001
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 03:53:24 -0700 (PDT)
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]) by
	cuda.sgi.com with ESMTP id sIbmVCl0loEweddD (version=TLSv1.2
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 03:53:21 -0700 (PDT)
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] xfs: constify sysfs_ops structures
Date: Sun, 11 Oct 2015 12:42:26 +0200
Message-Id: <1444560146-22737-1-git-send-email-Julia.Lawall@lip6.fr>
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
To: Dave Chinner <david@fromorbit.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

These sysfs_ops structures are never modified.  All other sysfs_ops
structures in the kernel are declared as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/xfs/xfs_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index aa03670..192c865 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -112,7 +112,7 @@ xfs_dbg_store(
 	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
 }
 
-static struct sysfs_ops xfs_dbg_ops = {
+static const struct sysfs_ops xfs_dbg_ops = {
 	.show = xfs_dbg_show,
 	.store = xfs_dbg_store,
 };
@@ -227,7 +227,7 @@ xfs_log_store(
 	return xfs_attr->store ? xfs_attr->store(buf, count, log) : 0;
 }
 
-static struct sysfs_ops xfs_log_ops = {
+static const struct sysfs_ops xfs_log_ops = {
 	.show = xfs_log_show,
 	.store = xfs_log_store,
 };

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
