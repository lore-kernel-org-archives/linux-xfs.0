Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76254C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36E062072C
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgLaWnD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:43:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60488 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgLaWnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:43:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMddvp144506
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SHhMmpqhL1MgfHhZ1Q5vShrLJaOO0mMmnjGsbBbpeq4=;
 b=gyz8ido20HI/ji7fkQXucoLs+U8sgrYS/ES++XpG0WZz8V2CK9i2f0ehJJb/O/QL6IEH
 QjpoY56MGAJyiD16u5n+CezwU7AWeKOg2wR/UDGNkQ9348BgoVEL3t1zKite1NwnKOpf
 YDQLs0JP7HWbkRTwCMtde7Jqz8h5OfdmXA/zx8hQF4JZKkB8mZqMbK92Jmp6hpt0EPFM
 16V43iGsqiLPULYXtxwaaqq2eT4cQRpDKkv7HEppvYTkGcoQGqPgbOW5wQzKBtoFpFtB
 eYNj3iB9QJDUxucBXZRoq2Ij/6NP3Vs/BYFL9VO5KPmAsg3HrifEG/0Yu6M4hiMQQU9L PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35phm1jt1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe7dM015215
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35perpncu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:21 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMgKRh007822
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:42:19 -0800
Subject: [PATCHSET 00/11] xfs: more scrub fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:42:19 -0800
Message-ID: <160945453876.2828246.1383801155362741289.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix a deficiency in the scrubbers where we don't quite properly detect
gaps in records.  Also, enhance the fscounters scrubber to check the
free rt extent count, look for oversized rmaps when checking the bmap,
and verify the non-shared status of extents not explicitly covered by
refcount records.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fixes
---
 fs/xfs/libxfs/xfs_alloc.c      |   23 +++++++++---
 fs/xfs/libxfs/xfs_btree.c      |   79 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h      |    6 +++
 fs/xfs/libxfs/xfs_ialloc.c     |    4 +-
 fs/xfs/libxfs/xfs_inode_fork.c |    2 +
 fs/xfs/libxfs/xfs_refcount.c   |   15 +++++++-
 fs/xfs/libxfs/xfs_rmap.c       |   15 +++++++-
 fs/xfs/scrub/agheader.c        |   33 +++++------------
 fs/xfs/scrub/bmap.c            |   74 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/btree.c           |   49 ++++++++++++++++++++++++-
 fs/xfs/scrub/common.c          |   23 +++++-------
 fs/xfs/scrub/common.h          |    5 +--
 fs/xfs/scrub/fscounters.c      |   50 +++++++++++++++++++++++++
 fs/xfs/scrub/health.c          |    3 +-
 fs/xfs/scrub/quota.c           |    6 ++-
 fs/xfs/scrub/refcount.c        |   80 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/scrub.c           |    2 +
 fs/xfs/scrub/scrub.h           |    1 +
 18 files changed, 402 insertions(+), 68 deletions(-)

