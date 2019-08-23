Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F93C3A589
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 03:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF822341A
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 03:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jS722GSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391160AbfHWD4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 23:56:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42964 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390619AbfHWD4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 23:56:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N3s0AD173810;
        Fri, 23 Aug 2019 03:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=P9/xShzr/HhOHDSmtLw5BDAywVlGdkFNff0MeGne26A=;
 b=jS722GSiTwp3udXxS+Z4Lx0+dJRwu6/5daH76QTNWjOfnZ+dUsUBmR3E5pkuEUNXd0BY
 F9hRFFvIkE3Ivsuk9WTAyoWkIgC2ONqrd36PTf7RD/tJR0Jmh5Zepmxjo7Y/S8ITHjMo
 TFQJFXGREZh8zk7cf4vNIjrv8dQBg6QfzCXglrB2di7bYwV+HEkwm7M7kou+4CQ5OpU0
 RWInjJHFE/w5MDAwDFyQZ2/2whPTvABjBBaVgCTHZ+tVsbIZgcCRlPftXYR3eGY0WJdw
 4MlF39HbamEDWyLsQpHcxN4fDGsCp0X4/qJzYCNvIxNufoVFWDMI7MhUvIKn5fKsbCro aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ue9hq1uq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 03:55:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N3qqUp106451;
        Fri, 23 Aug 2019 03:55:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2uj8kpr2wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 03:55:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7N3tUZ4019055;
        Fri, 23 Aug 2019 03:55:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 20:55:30 -0700
Date:   Thu, 22 Aug 2019 20:55:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails
 due to EDQUOT
Message-ID: <20190823035528.GH1037422@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Benjamin Moody reported to Debian that XFS partially wedges when a chgrp
fails on account of being out of disk quota.  I ran his reproducer
script:

# adduser dummy
# adduser dummy plugdev

# dd if=/dev/zero bs=1M count=100 of=test.img
# mkfs.xfs test.img
# mount -t xfs -o gquota test.img /mnt
# mkdir -p /mnt/dummy
# chown -c dummy /mnt/dummy
# xfs_quota -xc 'limit -g bsoft=100k bhard=100k plugdev' /mnt

(and then as user dummy)

$ dd if=/dev/urandom bs=1M count=50 of=/mnt/dummy/foo
$ chgrp plugdev /mnt/dummy/foo

and saw:

================================================
WARNING: lock held when returning to user space!
5.3.0-rc5 #rc5 Tainted: G        W
------------------------------------------------
chgrp/47006 is leaving the kernel with locks still held!
1 lock held by chgrp/47006:
 #0: 000000006664ea2d (&xfs_nondir_ilock_class){++++}, at: xfs_ilock+0xd2/0x290 [xfs]

...which is clearly caused by xfs_setattr_nonsize failing to unlock the
ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
unlock.

Reported-by: benjamin.moody@gmail.com
Fixes: 253f4911f297 ("xfs: better xfs_trans_alloc interface")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index dd4076ae228a..ea614b4ae052 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -804,6 +804,7 @@ xfs_setattr_nonsize(
 
 out_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_dqrele:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
