Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0BEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53AF220658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgLaWoo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:44:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgLaWoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:44:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMf7T8145134
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+ArQn4c0Lu6/fwI82F+QuXsfaBORgoV560NtnGWsBWc=;
 b=o945BCoXKsCzB+Tcyd0010gIKxRUJQWKBqwUAm/gDMy6huCCfM1c6KaJR6KxDkSTH9hR
 0uFXGjn9HVIoSFx/BdW18hhPI01eJ5K4V+EEGxNB0JxhLKcK3X0Ny4TRTlNGQ7m0pVIe
 kmV/v1l7HI5OJDJnpbPNva1c7Nj434wUc61LllNSc4Lp9uPdta/WGVHgbW3bzu937wl6
 u9SvGTQxW0JsTHM96xMojsYMSXxqcARi4BEbfv84oCURfvllY4VHfY6i+3eDOaugPlM5
 926kVhLuCy2iGWQm7mL0KJBtnL89aX0bhZUYMbx9VaA/KapQB31/4i/0hkCFSFCOgf5o +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35phm1jt2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMeoaX083678
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35pf307kwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMi2aS024787
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:44:02 -0800
Subject: [PATCHSET 0/3] xfs: indirect health reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:44:01 -0800
Message-ID: <160945464103.2829466.5974313466919932084.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
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

This series enables the XFS health reporting infrastructure to remember
indirect health concerns when resources are scarce.  For example, if a
scrub notices that there's something wrong with an inode's metadata but
memory reclaim needs to kill the incore inode, we ought to be able to
report that indirect observation in the AGI health report.

The first two patches in this series set that up, and the third one
provides a means for xfs_scrub to tell the kernel that it can forget the
indirect problem report.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=indirect-health-reporting
---
 fs/xfs/libxfs/xfs_fs.h        |    4 +-
 fs/xfs/libxfs/xfs_health.h    |   45 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    2 -
 fs/xfs/scrub/health.c         |   83 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h         |    1 
 fs/xfs/scrub/repair.c         |    1 
 fs/xfs/scrub/scrub.c          |    6 +++
 fs/xfs/scrub/trace.h          |    3 +
 fs/xfs/xfs_health.c           |   25 ++++++++----
 fs/xfs/xfs_inode.c            |   30 +++++++++++++++
 fs/xfs/xfs_trace.h            |    1 
 11 files changed, 189 insertions(+), 12 deletions(-)

