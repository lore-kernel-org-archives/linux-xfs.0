Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22E4C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A4D20FC3
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:22:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T4sXRE2k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgJESWl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:22:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53710 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:22:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095I9Nb7101416;
        Mon, 5 Oct 2020 18:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=AXLli1emCdQbLlYGbD7PEMies2bhKCJTvtu0Q6RPFCg=;
 b=T4sXRE2kynEWeCnnzhgoJ2zYEy7RWW1a7JKRjkIiG95e06ODIjrQ1r5gRrnqYHsxMZ3x
 yp9U/EBlDcnhNufywjpuD0Nxdq4Zt2Ur6tVKZYDCFe8yBLH1Qkk8ejz3lXSeklYUpFLV
 WRUBFW0IujRrIF6UV30bAuBCK42EBnIrg7gQXE5xQRh/K5/RKAtbfK8vgGHxLPxj4yrQ
 4j0sGJ9wc1NmBkXDP6e0J86/3Ng0H6XhQSmCMXlHNeAgQaQYBE4Rk0Vvi2eJ43yumR3j
 +lm73cUlKfwiAAjNbkftuO2cxheI6drJnvJkfGNefHTnmGUwYaI0fE7C3vWMLN5cugSl BA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxmpysx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:20:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA5EY019060;
        Mon, 5 Oct 2020 18:20:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33y37vn3u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:20:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095IKWWj030190;
        Mon, 5 Oct 2020 18:20:32 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:20:31 -0700
Subject: [PATCH v4 0/3] xfs: fix inode use-after-free during log recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de
Date:   Mon, 05 Oct 2020 11:20:30 -0700
Message-ID: <160192203063.2569680.11574287082065783377.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this second series, I try to fix a use-after-free that I discovered
during development of the dfops freezer, where BUI recovery releases the
inode even if it requeues itself.  If the inode gets reclaimed, the fs
corrupts memory and explodes.  The fix is to make the dfops capture
struct take over ownership of the inodes if there's any more work to be
done.  This is a bit clunky, but it's a simpler mechanism than saving
inode pointers and inode numbers and introducing tagged structures so
that we can distinguish one from the other.

v2: rebase atop the new defer capture code
v3: only capture one inode, move as much of the defer capture code to
xfs_defer.c as we can
v4: make defer capture ihold the inode, and the caller still gets to
iunlock and irele it

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-bmap-intent-recovery-5.10
---
 fs/xfs/libxfs/xfs_defer.c  |   43 ++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.h  |   11 +++++-
 fs/xfs/xfs_bmap_item.c     |   84 ++++++++++++++++++++------------------------
 fs/xfs/xfs_extfree_item.c  |    2 +
 fs/xfs/xfs_log_recover.c   |    7 +++-
 fs/xfs/xfs_refcount_item.c |    2 +
 fs/xfs/xfs_rmap_item.c     |    2 +
 7 files changed, 95 insertions(+), 56 deletions(-)

