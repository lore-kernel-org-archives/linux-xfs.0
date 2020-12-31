Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26A0C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E68206C0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgLaWsv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:48:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgLaWsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:48:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMinMC147486
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HIHxL3bM5rQOX4FXNOgT0GY3A9OmkGepJMSVGHka7YA=;
 b=IwVWomkUPhl5w1G6Jbb51m4M+Yd0dgK+AYMHTOYPQ+kv1yl8Gv7Ck0HWXdnz+Z/Yyqvf
 RPUFnw0cyOkkzwUqRtdSz3LXd5PytmaS8kso8Mf2jS/B+1hCXSmzCe43Abq+GtoWFdcA
 7BfInceGWPt88fGAAuUzg2SCynmGUnuS1SX6l+IN1FowEmsiHNi9ZkmkmL6J0f8xzJx0
 scIOHjoywnlkPiv44HqymOm4vA4QNhyS0SsdeD0GE2psUsfE/YbdGClQoc7UQhY/e3S7
 kkD4+wMeiicw3F14JbvNLV5aLNi5wMXXzaVIVbfy3CnKzw55HrNZSNqhkm5dtytwf8G2 rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35phm1jt4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:48:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMk4rp153709
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35pexuku8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMk8TE025494
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:46:08 -0800
Subject: [PATCHSET RFC 0/4] xfs: noalloc allocation groups
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:46:07 -0800
Message-ID: <160945476756.2833576.10783012050510414718.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series creates a new NOALLOC flag for allocation groups that causes
the block and inode allocators to look elsewhere when trying to
allocate resources.  This is either the first part of a patchset to
implement online shrinking (set noalloc on the last AGs, run fsr to move
the files and directories) or freeze-free rmapbt rebuilding (set
noalloc to prevent creation of new mappings, then hook deletion of old
mappings).  This is still totally a research project.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=noalloc-ags

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=noalloc-ags
---
 fs/xfs/libxfs/xfs_ag.c      |  120 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h      |    4 +
 fs/xfs/libxfs/xfs_ag_resv.c |   26 ++++++++-
 fs/xfs/libxfs/xfs_fs.h      |    5 ++
 fs/xfs/libxfs/xfs_ialloc.c  |    5 +-
 fs/xfs/scrub/fscounters.c   |    3 +
 fs/xfs/xfs_fsops.c          |   14 +++++
 fs/xfs/xfs_ioctl.c          |    4 +
 fs/xfs/xfs_mount.h          |   11 ++--
 fs/xfs/xfs_super.c          |    1 
 fs/xfs/xfs_trace.h          |   46 ++++++++++++++++
 11 files changed, 227 insertions(+), 12 deletions(-)

