Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED827C55179
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 957C424724
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c1ovJhbu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgJ1V4Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:56:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50966 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728586AbgJ1V4O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:56:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S19PxT107416
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=mbRzKuE+dYQ6vBLbKEU2bCOsA9Ba128A1ITfYxyzyt0=;
 b=c1ovJhbuvicir+IkIfPHeuTfyL73SpmSEPY86lCeP/qWSs9+C/2ANBIXuWgd++a2iIaX
 egbzRq4/fGYvn07xBhW78gNg5f01osjUrFJDEgY07S8LfEMaLMnnoveChM//lTkqB8Mh
 Evz7f67bFZdPvVhE6rdB4clTrWAIuW+yv7QaEh1dh6Wdu5nh7xPQjOuoEV3ff/5t+NIc
 mUty5NLbL9GGmnJlJyGztUdP4w5TjRdVZ+HcU3FgKp9neqm7KKUYOirCAJBSy78v6HTn
 wrQCMHuzQKLCphmAes9CTO/mrIlrH/0sNFQ6Xn/XwvNy9SGaLyi+w0sxSrB2gLUCUOKK 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9saw2w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09S16JUh062930
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1rcude-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:14 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09S1ADRk009505
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 01:10:13 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 18:10:13 -0700
Subject: [PATCH 0/2] xfs-documentation: format updates for 5.10
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 27 Oct 2020 18:10:12 -0700
Message-ID: <160384741244.1365004.6341029408891306870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010280002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280002
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This quick series contains all the updates to the ondisk documentation that
were applied in 5.10.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=xfsdocs-5.10
---
 .../allocation_groups.asciidoc                     |   27 ++++++++
 design/XFS_Filesystem_Structure/docinfo.xml        |   14 ++++
 .../internal_inodes.asciidoc                       |    5 ++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    4 +
 .../XFS_Filesystem_Structure/timestamps.asciidoc   |   65 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 6 files changed, 117 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/timestamps.asciidoc

