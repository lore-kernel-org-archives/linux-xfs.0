Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6esPa066910 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:40:55 -0600
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id irBGyKoJ2bws45ZT for
	<xfs@oss.sgi.com>; Thu, 15 Nov 2012 22:43:00 -0800 (PST)
Date: Fri, 16 Nov 2012 14:42:42 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [xfs:for-next 68/70] fs/xfs/xfs_ialloc_btree.c:186:1: sparse:
	symbol 'xfs_inobt_verify' was not declared. Should it be static?
Message-ID: <50a5e062.XN/BRFaWJHYKYG4f%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_50a5e062.WvqIOmYpaQa1WDXAUd+h2ncalISEqOJshtBq41IiJ0a1ogGz"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <dchinner@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.

--=_50a5e062.WvqIOmYpaQa1WDXAUd+h2ncalISEqOJshtBq41IiJ0a1ogGz
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://oss.sgi.com/xfs/xfs for-next
head:   1813dd64057490e7a0678a885c4fe6d02f78bdc1
commit: 612cfbfe174a89d565363fff7f3961a2dda5fb71 [68/70] xfs: add pre-write metadata buffer verifier callbacks


sparse warnings:

+ fs/xfs/xfs_ialloc_btree.c:186:1: sparse: symbol 'xfs_inobt_verify' was not declared. Should it be static?
fs/xfs/xfs_ialloc_btree.c:227:1: sparse: symbol 'xfs_inobt_read_verify' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation

--=_50a5e062.WvqIOmYpaQa1WDXAUd+h2ncalISEqOJshtBq41IiJ0a1ogGz
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-612cfbf.diff"

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index b38a10e..6a714b5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -52,10 +52,10 @@
  */
 
 #ifdef DEBUG
-xfs_buftarg_t *xfs_dqerror_target;
-int xfs_do_dqerror;
-int xfs_dqreq_num;
-int xfs_dqerror_mod = 33;
+static xfs_buftarg_t *xfs_dqerror_target;
+static int xfs_do_dqerror;
+static int xfs_dqreq_num;
+static int xfs_dqerror_mod = 33;
 #endif
 
 struct kmem_zone		*xfs_qm_dqtrxzone;
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 15a79f8..d60e1d5 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -182,7 +182,7 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
-void
+static void
 xfs_inobt_verify(
 	struct xfs_buf		*bp)
 {
@@ -223,7 +223,7 @@ xfs_inobt_write_verify(
 	xfs_inobt_verify(bp);
 }
 
-void
+static void
 xfs_inobt_read_verify(
 	struct xfs_buf	*bp)
 {

--=_50a5e062.WvqIOmYpaQa1WDXAUd+h2ncalISEqOJshtBq41IiJ0a1ogGz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=_50a5e062.WvqIOmYpaQa1WDXAUd+h2ncalISEqOJshtBq41IiJ0a1ogGz--
