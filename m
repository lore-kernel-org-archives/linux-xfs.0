Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E091C43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE662080A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QzB1I5Wr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgIGSCN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 14:02:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34686 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgIGSCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 14:02:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087I0Bhd062822
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=pCXVEJzlSwfZ9zITv40nrk6ZFKSkpK/WeRqF/4N2WHo=;
 b=QzB1I5Wrb8/RU/3SV8wWudwNcYS9S9wsRm5xXGBHt5hLjJry6SiaePDKCJeeaOeYZQwE
 xXlbJM5tGnmd80T4A0OsYHtSJIA74GjvbfiPMrjoWdfOvnuAganYi4HFStJlcQw63f3z
 HLJNMIvBRlqAuYy8aG+JDYfq7Di5cpE8g5eNWu6XQUqHi9BfeYjAB6zg2HfuzOg4AsBC
 PYW/I/7RM1Y+aRioMy3Nrj73VRf0z071UMrjh94QT0IcS2Muv6WUlEZwc1lIMQOvjrdW
 zzk4dFVTfBNvPkCqQT/CLt0j1d1/P1OWm7uHIbM/f0c0AE+ipW01dnFtiux1jeBY35jl 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amqhhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:02:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087I1O7P104246
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmepvrtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:02:07 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087I27dk025029
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:02:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 11:01:03 -0700
Subject: [PATCH 0/3] xfs: fix a few realtime bugs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 11:01:02 -0700
Message-ID: <159950166214.582172.6124562615225976168.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While running fstests with realtime enabled and rtinherit=1, the kernel
tripped over a bunch of bugs related to the realtime support.  The three
patches in this series fix some problems with inode flags being
propagated incorrectly and some math errors in the rt allocator and the
fallocate code that cause filesystem shutdowns.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-bugs
---
 fs/xfs/xfs_bmap_util.c |   16 ++++++++++++++++
 fs/xfs/xfs_inode.c     |    3 ++-
 fs/xfs/xfs_rtalloc.c   |   11 +++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

