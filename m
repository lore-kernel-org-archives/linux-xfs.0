Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58ECFC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34B4520848
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 02:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CsrZRKfG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgH1Cgf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 22:36:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH1Cgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 22:36:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2YWMJ028062;
        Fri, 28 Aug 2020 02:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Zkx6Ks8ileJlStr6ROqHcJnTZTKjKkK3pHb6pPcjF1E=;
 b=CsrZRKfGHgG91eAlIsjKfLUK3q86QVQG2YhZSdC4inDhHZUGOr3cFp87hqAqpUpTbxzz
 iDS2Ga54sFqMlB9LCRhw+SIcRW2ZfqM7rkM/BMBWrWNkplQayAYTAI6CiFAYoGXAIurV
 /oD7pph0R1C2KlyWzzi9U7SZhK+SjIgBJxOrWv1921wkePZDmWUB/hhOlTUDxAacy7El
 awVt33yPMEc4PvnJwX4CDh6NuGKbTS3mn7OVIp1cc4dNx3mTYZVuly66qiPOsB4uzGTW
 KJJNhAeZiN6I6rnUZbtGhAzFOMRDzOXZikeDG3XdpEBKN4/Ql62utxoDSgjV1Y5rDar1 Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbs9krj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 02:36:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S2YvAD091804;
        Fri, 28 Aug 2020 02:36:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9p5b6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 02:36:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S2aWav018704;
        Fri, 28 Aug 2020 02:36:32 GMT
Received: from localhost (/10.159.133.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 19:36:32 -0700
Subject: [PATCH v3 0/5] xfs: add inode btree blocks counters to the AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Aug 2020 19:36:31 -0700
Message-ID: <159858219107.3058056.6897728273666872031.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280020
Sender: linux-xfs-owner@vger.kernel.org
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inobt-counters

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inobt-counters
---
 fs/xfs/libxfs/xfs_ag.c           |    4 ++
 fs/xfs/libxfs/xfs_format.h       |   21 +++++++++++-
 fs/xfs/libxfs/xfs_ialloc.c       |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |   65 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/agheader.c          |   30 ++++++++++++++++++
 fs/xfs/scrub/agheader_repair.c   |   23 +++++++++++++
 fs/xfs/xfs_ondisk.h              |    2 +
 fs/xfs/xfs_super.c               |    4 ++
 8 files changed, 143 insertions(+), 7 deletions(-)

