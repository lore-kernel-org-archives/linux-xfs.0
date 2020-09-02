Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E445CC433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB72206CD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NntHXHuT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBCz6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:55:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33064 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBCz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:55:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822s6ux089710;
        Wed, 2 Sep 2020 02:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=pJWRtg9dMRs7EtCgKbx6JsK7L7mqXxUepWiQJ+cfnTg=;
 b=NntHXHuTVETEVVaA/i5pi/zTka+kFAOj85tnVuUcMqx9uhiSVolO3wr2fi8TEn7qF+pJ
 a0VwFeUKzSxpD9Fyn1TbT1+HanPUyEhPo/b/0X2zonHFQ7uuL8MVXpeiG/hG0bcyaLws
 XT9dWJexBvjGQY5Ht5m2X6BYXvI1k2nCBXyA8cuErKbSgogytawrgQ0vK+Jaq40MGgCH
 F6Z+iuRa5EOEiILJyJX+ROZ1e6h0SIP/3qP/CVFNSY2ewhG2W5k6B7GTNr67HwY6KMoZ
 pz2SfXHYeWDkFGlmcKFqdBFSHXq0nyDKtSDx8vYqG9BSPFVm1/6oS8qJYCrWFoXHqX8b qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eym7srh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:55:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822tCg8037661;
        Wed, 2 Sep 2020 02:55:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3380kp8hd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:55:54 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0822tsh6005298;
        Wed, 2 Sep 2020 02:55:54 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:55:53 -0700
Subject: [PATCH v4 0/5] xfs: add inode btree blocks counters to the AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 01 Sep 2020 19:55:52 -0700
Message-ID: <159901535219.547164.1381621861988558776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
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
---
 fs/xfs/libxfs/xfs_ag.c           |    5 +++
 fs/xfs/libxfs/xfs_format.h       |   21 +++++++++++-
 fs/xfs/libxfs/xfs_ialloc.c       |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |   68 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/agheader.c          |   30 +++++++++++++++++
 fs/xfs/scrub/agheader_repair.c   |   24 +++++++++++++
 fs/xfs/xfs_ondisk.h              |    2 +
 fs/xfs/xfs_super.c               |    4 ++
 8 files changed, 148 insertions(+), 7 deletions(-)

