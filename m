Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF62BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E4E720678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgLaWnf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:43:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgLaWne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:43:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMerV7015877
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Tugk2gjcYogoLyR1zU2KhSwZJ3RZdhT4I0FAaYC/f20=;
 b=EdCdBAbG/1Canjid3YIcv+d83xwAGZOrkvAaDk0J9iFFzdzvcXzRcoSUMdvdYzwvSPi/
 M2KXl2VIkV+HMNj98KQQU6Gq9Vn6P+9f21Wy6raIhqcbLPg0jgZLF52mGK6+mUdDUPvQ
 NwAT8nlvw6iWZL/Kn5eDd46uwwd2RQZQvkfV6hcqDQYJdehUMj6O98btLBWSHMHt5w6W
 NKM6tlm2m3xHZvfoDub28jCUZYwG5nxyKmfbuoCk41a8UDYRszoPh7vGCW92mzqxr6ex
 eeXvcJdfCFlpqEcvcx951OPN9qfJY4Vi7Tr75q8rPH3PriLHXnblKI7TUWblmDYtTQMu 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35nvkquw8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe5bV143844
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35pexukt8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:52 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMgq5U008066
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:42:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:42:51 -0800
Subject: [PATCHSET v2 0/3] xfs: prepare repair for bulk loading
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:42:49 -0800
Message-ID: <160945456931.2828613.13702340014662951445.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=974 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=984 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add some new helper functions (and debug knobs) to online repair to
prepare us to stage new btrees.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-prep-for-bulk-loading
---
 fs/xfs/scrub/agheader_repair.c |    1 
 fs/xfs/scrub/common.c          |    1 
 fs/xfs/scrub/repair.c          |  395 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |   58 ++++++
 fs/xfs/scrub/scrub.c           |    2 
 fs/xfs/scrub/trace.h           |   36 ++++
 fs/xfs/xfs_extfree_item.c      |    2 
 fs/xfs/xfs_globals.c           |   12 +
 fs/xfs/xfs_sysctl.h            |    2 
 fs/xfs/xfs_sysfs.c             |   54 +++++
 10 files changed, 561 insertions(+), 2 deletions(-)

