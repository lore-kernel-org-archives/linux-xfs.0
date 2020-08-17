Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCC5C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997F12065D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cwrLI+Tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgHQW46 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:56:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgHQW45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:56:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMusU3136103;
        Mon, 17 Aug 2020 22:56:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=dMjcJGJlB/pWhjPhJF1FFq4HETm51X/QSW3VSzhKoiU=;
 b=cwrLI+Tr0pvbAfJqGv+feq6dcI2PTDBPPGuoahSwWWqnE115EndlhWtRodBvXbqrlkyn
 ImKpufXVhn6s/S6KbrpqoC2NaogTNCj54YSw9fD+VZismhZEJZQ5ZT6ui5ghFTFyzRPn
 XlIdBTQ4fPGi2vHN7/Ecru1EIzS9e8f9d5hLG+dGSaHP0u7VueEhA1N5vS63CDN5mnDT
 B6JTHIhB6uhYwgXKlFAutKckJu8nMZSetvpgfT9wDnh6qvQfnOls2JgPHU8C3gQktYHP
 u59lgwEDbxUr1g66Bi9rRqtEt+T6JOZBILpM2EQ+uXiki9RzlGNeoAwfb9rc6V0X6OBo KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn1fs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:56:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMljuA075667;
        Mon, 17 Aug 2020 22:56:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32xsm18k4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:56:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMunge024376;
        Mon, 17 Aug 2020 22:56:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:56:49 -0700
Subject: [PATCH v2 00/11] xfs: widen timestamps to deal with y2038
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Mon, 17 Aug 2020 15:56:48 -0700
Message-ID: <159770500809.3956827.8869892960975362931.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series performs some refactoring of our timestamp and inode
encoding functions, then retrofits the timestamp union to handle
timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
to the non-root dquot timer fields to boost their effective size to 34
bits.  These two changes enable correct time handling on XFS through the
year 2486.

v2: rebase to 5.9, having landed the quota refactoring

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bigtime
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   60 +++++++++++++++++
 fs/xfs/libxfs/xfs_format.h     |  139 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_fs.h         |    1 
 fs/xfs/libxfs/xfs_inode_buf.c  |  132 ++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_inode_buf.h  |    7 +-
 fs/xfs/libxfs/xfs_log_format.h |   21 ++++--
 fs/xfs/libxfs/xfs_quota_defs.h |    9 ++-
 fs/xfs/libxfs/xfs_sb.c         |    2 +
 fs/xfs/scrub/inode.c           |   31 +++++++--
 fs/xfs/scrub/quota.c           |    8 ++
 fs/xfs/xfs_dquot.c             |   66 ++++++++++++++++---
 fs/xfs/xfs_dquot.h             |    4 +
 fs/xfs/xfs_inode.c             |   11 +++
 fs/xfs/xfs_inode_item.c        |   97 ++++++++++++++++++++++++++--
 fs/xfs/xfs_inode_item.h        |    3 +
 fs/xfs/xfs_ioctl.c             |    3 +
 fs/xfs/xfs_ondisk.h            |   30 ++++++++-
 fs/xfs/xfs_qm.c                |    2 +
 fs/xfs/xfs_qm_syscalls.c       |   18 +++--
 fs/xfs/xfs_super.c             |   14 +++-
 20 files changed, 531 insertions(+), 127 deletions(-)

