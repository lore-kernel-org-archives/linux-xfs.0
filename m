Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5792BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F63A20678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgLaWmy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:42:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54408 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgLaWmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:42:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMgDg3152896
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4ZGVgcExeQH2VIhJJrGj7M9ya2VA1jNvCVTkd57x24I=;
 b=yw74VtA1G9ntW/0J5pI/RBuPAypXiuBdN6dK2Mt/zuzqnonzwSDt7/3Xg8t5y8UEVspF
 hnh3qqfLFbtnw1rRXCPjeavTrq+tWqWORh6IjoTObWnLcfDtvNS6AoeeYMm6ZIvzCAJC
 lwhLW0DIbu01/91O9f+iwE2KAt3DSKuO9e4yAegXd8LrrZltmk7bATR82MNdoLLuvutB
 TDhhRfn3CY0QQRlna9KxIsRVvO2a9ZtH8FZrlCfgPNUE/xsjzsgQbTpStoV5ud7tmyyw
 Kmk2u9qeHEFIZARcgjyjd0hKGil7Rgb7naOCPBZjGp3UF4WlzwKTbpHB0UUsk6ZCjRUk pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe8m7015255
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35perpnct4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMgCGg024167
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:42:12 -0800
Subject: [PATCHSET 0/1] xfs: increase pwork parallelism
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:42:11 -0800
Message-ID: <160945453111.2828190.5013589595606335702.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Increase the parallelization factor of the pwork infrastructure so that
we can scale to as many CPUs and AGs as there are in the filesystem.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pwork-parallelism
---
 fs/xfs/xfs_buf.c   |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |    1 +
 fs/xfs/xfs_iwalk.c |    2 +-
 fs/xfs/xfs_mount.c |   39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_pwork.c |   17 +++++------------
 fs/xfs/xfs_pwork.h |    2 +-
 7 files changed, 82 insertions(+), 14 deletions(-)

