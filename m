Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A0FC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6344423120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgLFXMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:12:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgLFXMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:12:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N7fHu182974;
        Sun, 6 Dec 2020 23:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=87Y8edO4lzs42wBUwjvKMDJx4/qPpLxOqoa6B0t8gIU=;
 b=LFXQA+B8KR8G1AdCuRfEZljtdaQR7kVq6pgYtZk0WKEwg3mKzEx3SQ76mdZBm+hld9EI
 YtMVNzdFr2p1eMzMXNwz+FgBdtGjeAEHDh3bH1DZdsmK8i+nxLFT2TZGdUYPQK3alCcQ
 6wQtjoL/DY3YVYotvPoVm0qMbzU60JE8hIA+RAEnmk726ISoFZeRVogDcHH8BH1gAMYP
 fXgHqdQ+M+dp/CiOmy2AM/7007+qxut5vA79CAneiezSpypiV6+Hz2JPMMJlpGeYHEcs
 G0FaUkqCwoFF/t86/esZCPQTsJshRlR/IuGLmQ9+npYrqpHwvvd7DQYFOwi4sJkfKRQ8 lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825ktuj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:11:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N6QFm192961;
        Sun, 6 Dec 2020 23:09:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3vpcfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:09:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6N9L3g011100;
        Sun, 6 Dec 2020 23:09:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:09:21 -0800
Subject: [PATCH v2 0/3] xfs: add the ability to flag a fs for repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, sandeen@sandeen.net, bfoster@redhat.com,
        david@fromorbit.com
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:09:20 -0800
Message-ID: <160729616025.1606994.13590463307385382944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This "new feature" adds a new incompat feature flag so that we can force
a sysadmin to run xfs_repair on a filesystem before mounting.  The
intent for this code is to make it so that one can use xfs_db to upgrade
a filesystem to support new V5 features (e.g. y2038 or inode btree
counters).  Because some upgrades may require xfs_repair to fix or add
things before the filesystem goes back into use, this is the means for
xfs_db to force that to happen.

Note: xfs_admin will automatically run repair when required, so
sysadmins won't have to issue the repair command directly.

v2: move all the kernel-specific checks to xfs_fs_fill_super since that's
where we put the rest of them already

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=needsrepair-5.11
---
 fs/xfs/libxfs/xfs_format.h |   10 +++++++++-
 fs/xfs/libxfs/xfs_sb.c     |   27 ---------------------------
 fs/xfs/xfs_super.c         |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 28 deletions(-)

