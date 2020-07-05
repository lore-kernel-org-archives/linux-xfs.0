Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F6AC433E1
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D192220C56
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zgm72Omy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgGEWMu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:12:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:12:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MBgU7001880;
        Sun, 5 Jul 2020 22:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Xv/Q4douvq1ZcbgxhhJsPOc2uJ+D2ZfL9pxC9SgTnmk=;
 b=zgm72Omy1W/BtualJLb4qIqHisf/97Wsvz6QbudtuW4oACiKGRWoZcCKI01qXeX58k4p
 VU/ZSI4y6LtNUCYGT6zF021MeyutcvZrQXqfOrjEHBAFI1shhCZBkJfFdoMNOafH0PDn
 GR/RfcUmtYgQEU+IgEHtv3qDQXWRyxHRF96/ElYwEQD84peXsgC13cYdY6OwK8CRAaAP
 ByM8J/5sK7jHLbTaURyoj8T9QnonLM+gcsdM75dCqKClJwIYCt/sCaWraSXxLaIcTlGw
 8boHyNFD8dHPR7iI4KmaAMOY0wANl9Ujcbeuo4IvKM8vlZ1kv6/eSmXXtARdj+PjczOq WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 322h6r3j2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 05 Jul 2020 22:12:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065M86Ar055600;
        Sun, 5 Jul 2020 22:12:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3233pubj18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Jul 2020 22:12:43 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MCfjs008825;
        Sun, 5 Jul 2020 22:12:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:12:41 -0700
Subject: [PATCH 01/22] xfs: clear XFS_DQ_FREEING if we can't lock the dquot
 buffer to flush
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:12:40 -0700
Message-ID: <159398716016.425236.7588533886277879146.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=3 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
can't lock the dquot buf to flush the dquot.  This prevents the AIL from
blocking on the dquot, but it also forgets to clear the FREEING flag on
its way out.  A subsequent purge attempt will see the FREEING flag is
set and bail out, which leads to dqpurge_all failing to purge all the
dquots.

(copy-pasting from Dave Chinner's identical patch)

This was found by inspection after having xfs/305 hang 1 in ~50
iterations in a quotaoff operation:

[ 8872.301115] xfs_quota       D13888 92262  91813 0x00004002
[ 8872.302538] Call Trace:
[ 8872.303193]  __schedule+0x2d2/0x780
[ 8872.304108]  ? do_raw_spin_unlock+0x57/0xd0
[ 8872.305198]  schedule+0x6e/0xe0
[ 8872.306021]  schedule_timeout+0x14d/0x300
[ 8872.307060]  ? __next_timer_interrupt+0xe0/0xe0
[ 8872.308231]  ? xfs_qm_dqusage_adjust+0x200/0x200
[ 8872.309422]  schedule_timeout_uninterruptible+0x2a/0x30
[ 8872.310759]  xfs_qm_dquot_walk.isra.0+0x15a/0x1b0
[ 8872.311971]  xfs_qm_dqpurge_all+0x7f/0x90
[ 8872.313022]  xfs_qm_scall_quotaoff+0x18d/0x2b0
[ 8872.314163]  xfs_quota_disable+0x3a/0x60
[ 8872.315179]  kernel_quotactl+0x7e2/0x8d0
[ 8872.316196]  ? __do_sys_newstat+0x51/0x80
[ 8872.317238]  __x64_sys_quotactl+0x1e/0x30
[ 8872.318266]  do_syscall_64+0x46/0x90
[ 8872.319193]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 8872.320490] RIP: 0033:0x7f46b5490f2a
[ 8872.321414] Code: Bad RIP value.

Returning -EAGAIN from xfs_qm_dqpurge() without clearing the
XFS_DQ_FREEING flag means the xfs_qm_dqpurge_all() code can never
free the dquot, and we loop forever waiting for the XFS_DQ_FREEING
flag to go away on the dquot that leaked it via -EAGAIN.

Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d6cd83317344..938023dd8ce5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -148,6 +148,7 @@ xfs_qm_dqpurge(
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		} else if (error == -EAGAIN) {
+			dqp->dq_flags &= ~XFS_DQ_FREEING;
 			goto out_unlock;
 		}
 		xfs_dqflock(dqp);

