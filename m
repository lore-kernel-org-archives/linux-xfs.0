Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 21:45:52 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O4joKM009696
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 21:45:50 -0700
Message-ID: <48D9C653.1030908@sgi.com>
Date: Wed, 24 Sep 2008 14:47:15 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] don't use signed int to store xfs_dqid_t
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

When running xfsqa test 144 with quota's enabled it's possible to
trip the following ASSERT(curid >= 0); from xfs_qm_init_dquot_blk().
The reason this assert was tripped is the signed int currid was assigned
an id from the unsigned xfs_dqid_t this works as long as the MSB in 
xfs_dqid_t
is not set. However if it is this translates to a negative number causing
the assert to trip.

The fix for this is simply replacing the signed int with type xfs_dqid_t
and since xfs_dqid_t is unsigned there is no point checking if it's negative
so remove the assert.


Index: 2.6.x-xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/quota/xfs_dquot.c     2008-09-24 
12:02:41.000000000 +1000
+++ 2.6.x-xfs/fs/xfs/quota/xfs_dquot.c  2008-09-24 14:31:18.374406815 +1000
@@ -370,7 +370,8 @@ xfs_qm_init_dquot_blk(
        xfs_buf_t       *bp)
 {
        xfs_dqblk_t     *d;
-       int             curid, i;
+       xfs_dqid_t      curid;
+       int              i;

        ASSERT(tp);
        ASSERT(XFS_BUF_ISBUSY(bp));
@@ -382,7 +383,6 @@ xfs_qm_init_dquot_blk(
         * ID of the first dquot in the block - id's are zero based.
         */
        curid = id - (id % XFS_QM_DQPERBLK(mp));
-       ASSERT(curid >= 0);
        memset(d, 0, BBTOB(XFS_QI_DQCHUNKLEN(mp)));
        for (i = 0; i < XFS_QM_DQPERBLK(mp); i++, d++, curid++)
                xfs_qm_dqinit_core(curid, type, d);
