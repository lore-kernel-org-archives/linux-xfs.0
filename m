Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26250C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0066520658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgLaWqf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:46:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgLaWqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMjr3O018982
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yKEs0EHDOGtbf07Kr0AstJZTTsWdEQdbRXZuR7VtMY4=;
 b=nkLcjKBoObqGTi6H/YBTVwIJPOc1ZzJskP7xKUsJbp9IiP1Y2loxooD+ksw706FgO5pc
 eyozXOMsA48Xp0T4qk2MVHO96c3X08dCcQapAJS7ScRNV1HdXbR8TsuSOlHkCllFo7Qg
 HUOUPXLSIv50vZKFZkpypE+ULeAwq8B5meOYaPMuM+c5HNZVteT5Vsa4Jj1iN0ZuCQVF
 Q6pid/vMqj2c4Hpu3OJEzd6eiNFanORUjW1jFA+2TkHgzq2NHeiah8pULQ67ZAZ31K5h
 YmDOXl+UugwL1oCkmggt5aod7KyPlqXFbaBI7VkfM+1bTwAJq7L2mSMFK5cTVpugThV8 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35nvkquwag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj4dg015863
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35pf40pa6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:53 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMjqD2009080
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:45:52 -0800
Subject: [PATCHSET 0/3] xfs: widen EFI format to support rt
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:45:51 -0800
Message-ID: <160945475134.2832126.16125427327148545751.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Realtime reverse mapping (and beyond that, realtime reflink) needs to be
able to defer file mapping and extent freeing work in much the same
manner as is required on the data volume.  Make the extent freeing log
items operate on rt extents in preparation for realtime rmap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-extfree-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-extfree-intents
---
 fs/xfs/libxfs/xfs_alloc.c      |    1 +
 fs/xfs/libxfs/xfs_bmap.c       |   37 ++++++++++++++++------
 fs/xfs/libxfs/xfs_bmap.h       |    8 +++--
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 +
 fs/xfs/libxfs/xfs_ialloc.c     |    4 +-
 fs/xfs/libxfs/xfs_log_format.h |    3 ++
 fs/xfs/libxfs/xfs_refcount.c   |    8 +++--
 fs/xfs/libxfs/xfs_rtbitmap.c   |    4 ++
 fs/xfs/scrub/alloc_repair.c    |    3 +-
 fs/xfs/scrub/repair.c          |    5 ++-
 fs/xfs/xfs_extfree_item.c      |   67 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_reflink.c           |    2 +
 12 files changed, 112 insertions(+), 32 deletions(-)

