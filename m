Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04587C63697
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 17:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E824246A7
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 17:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LbvaDXXx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgKSRvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 12:51:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgKSRvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Nov 2020 12:51:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHoGYE155872
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 17:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=cpX4O2fVkeq5N1V2cxcKjc4l78BqauWdajP7/c14bDs=;
 b=LbvaDXXx2XCMtbHf/yKb+IEMRwxBqFhY9bXrm5mbYJGE32i0oex/gJz12CF+5/zOp05H
 X2OxgBN6P1PSfzz80CVJEnHMFOBGkhz+vpbAHrMu+xP1oMRdTWTUsExCWEVuIkw3GCG2
 yJDWtUeY/4cokM8xrmouzxaij2raHADVQWjsmfP3f+2ZIt2bPQ26zVZOPPFEVV5uoNLf
 vH6ve2AzY46Q1/boe9vNyKkr38PPyrVNA2B7sL6LDvOznj+SMqosQUag4CgGQWdl3qRq
 f05cTp7fspA5s8TmLExY02f+z4RsFWX2zpWkMBTGF2dXJ9Rmb9FYvhGWVHbixxMn4H9U bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76m6tkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 17:51:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHna1a161584
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 17:51:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34ts0u2p8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 17:51:29 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AJHpSTp022720
        for <linux-xfs@vger.kernel.org>; Thu, 19 Nov 2020 17:51:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 09:51:28 -0800
Date:   Thu, 19 Nov 2020 09:51:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 595189c25c28
Message-ID: <20201119175127.GE9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=2 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011190127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This is still bug fixes, maybe I'll get to 5.11 next
week...

The new head of the for-next branch is commit:

595189c25c28 xfs: return corresponding errcode if xfs_initialize_perag() fail

New Commits:

Darrick J. Wong (4):
      [e95b6c3ef131] xfs: fix the minrecs logic when dealing with inode root child blocks
      [498fe261f0d6] xfs: strengthen rmap record flags checking
      [6b48e5b8a20f] xfs: directory scrub should check the null bestfree entries too
      [27c14b5daa82] xfs: ensure inobt record walks always make forward progress

Gao Xiang (1):
      [ada49d64fb35] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)

Yu Kuai (1):
      [595189c25c28] xfs: return corresponding errcode if xfs_initialize_perag() fail


Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c |  8 +++++++-
 fs/xfs/scrub/bmap.c           |  8 ++++----
 fs/xfs/scrub/btree.c          | 45 ++++++++++++++++++++++++++-----------------
 fs/xfs/scrub/dir.c            | 27 +++++++++++++++++++-------
 fs/xfs/xfs_iwalk.c            | 27 +++++++++++++++++++++++---
 fs/xfs/xfs_mount.c            | 11 ++++++++---
 6 files changed, 90 insertions(+), 36 deletions(-)
