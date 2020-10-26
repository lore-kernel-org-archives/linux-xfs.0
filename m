Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFC5C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C0C20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ErGTmMm5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406881AbgJZXfQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55184 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406870AbgJZXfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXEM164636;
        Mon, 26 Oct 2020 23:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=lbCe2r/Z47PF9sXWOIxzaMLAxV9ALAXmTGhXrL7mzHw=;
 b=ErGTmMm5IpRnGrBE/SKX7yKu0qzJ4Z7Wu2wJg4aOF8wrHM3JVwbxqK5uBePpBw5wTheq
 BTOB9qLx/deJoykM7jLCntxUDojhgMbBg1QGeO7i/lN8S0axVSiRuR5LK9r4fN+g1dDo
 UpYzZyT+tPA8PwDhvCzdz77rGHtsmo1DSrEF1t2hZsE1DLnQRTnaqYXVwtlIWg9Niqui
 KK5Np/Rcb6qtZbSDS0w/qwAPac1qU39gZF+h2NNmPbpID8XAVsFcahfQSj/hbLk6t7in
 vKhXpIkG/mk4+UqPM/CMdhjZVJZobwPTnBCbw5jTnV0uHDb9d977S/HGRUN5qbvQeYG7 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3vuru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQEQ9032465;
        Mon, 26 Oct 2020 23:33:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cx1q2aq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXBaT028419;
        Mon, 26 Oct 2020 23:33:11 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:06 -0700
Subject: [PATCH v4 0/9] xfsprogs: add a inode btree blocks counts to the AGI
 header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:05 -0700
Message-ID: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Years ago, Christoph diagnosed a problem where freeing an inode on a
totally full filesystem could fail due to finobt expansion not being
able to allocate enough blocks.  He solved the problem by using the
per-AG block reservation system to ensure that there are always enough
blocks for finobt expansion, but that came at the cost of having to walk
the entire finobt at mount time.  This new feature solves that
performance regression by adding inode btree block counts to the AGI
header.

v2: rebase kernel to 5.9
v3: split logical changes into separate patches
v4: support inobtcounts && !finobt properly

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inobt-counters

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inobt-counters

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=inobt-counters
---
 db/agi.c                  |    2 +
 db/sb.c                   |   78 ++++++++++++++++++++++++++++++++++++++++++++-
 db/xfs_admin.sh           |    4 ++
 libxfs/xfs_ag.c           |    5 +++
 libxfs/xfs_format.h       |   21 +++++++++++-
 libxfs/xfs_ialloc.c       |    1 +
 libxfs/xfs_ialloc_btree.c |   65 +++++++++++++++++++++++++++++++++++---
 man/man8/mkfs.xfs.8       |   15 +++++++++
 man/man8/xfs_admin.8      |   16 +++++++++
 mkfs/xfs_mkfs.c           |   34 +++++++++++++++++++-
 repair/phase5.c           |    5 +++
 repair/scan.c             |   38 ++++++++++++++++++++--
 12 files changed, 272 insertions(+), 12 deletions(-)

