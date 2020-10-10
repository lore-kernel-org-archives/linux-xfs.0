Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6059BC3279D
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 301792067C
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="utmkhJPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgJJW5X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:57:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47978 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733272AbgJJUDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Oct 2020 16:03:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHYT6o168390;
        Sat, 10 Oct 2020 17:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XWKee79DKKjjDLk1mQ/jOOomdTKv4paM70LnRJ4mYFk=;
 b=utmkhJPCf9PhMr2BJHiyNCuuly4xDjpl64MuK7xa8vw6J1dv32ONgahadFcWOQgdDdK3
 r+19b2sYeQPWxCSm11tlZYjoBeLyCcYhfwThjTnyllXvxXpDIY67d0LoDAkPoMMomdaq
 gUVzG7cK8m/6ngH3Da28Wnds3LSZahl/WAECl3pEqM05MmzNvkaLjDSgXKgYFCDEp17t
 53qKBQhB28Kfdt2hsnsfjLMYWuZH9mnE0Dn+G7zh384NUXVyW1WAHtWHyVOqGvnQsKs6
 VLkvHtYxLO1the00Y9P2Ny7guOsPPeIhM4UtpkCWL5le/Qx7qFPP7J4a/ODeocGZhiEr rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3432fa96m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 17:34:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHVc1n001205;
        Sat, 10 Oct 2020 17:34:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3434rxwkae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Oct 2020 17:34:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09AHYMZ3023396;
        Sat, 10 Oct 2020 17:34:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 10 Oct 2020 10:34:22 -0700
Subject: [PATCH 0/2] xfs: hopefully the last few rt fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com, hch@lst.de
Date:   Sat, 10 Oct 2020 10:34:21 -0700
Message-ID: <160235126125.1384192.1096112127332769120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010100165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010100165
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the last couple of rt fixes for 5.10.  The first one fixes a
lockdep complaint, and the second one was me realizing I made a major
thinko in an earlier patch: not realizing that xfs_free_file_space
is really a "make contents zero by punching or manually zeroing as
needed" function; the solution is to push all the rt extent alignment
checking up to xfs_file_fallocate.

Updated test case attached.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rt-fixes-5.10
---
 fs/xfs/xfs_bmap_util.c |   17 ++++-------------
 fs/xfs/xfs_file.c      |   10 ++++------
 fs/xfs/xfs_inode.c     |   13 +++++++++++++
 fs/xfs/xfs_inode.h     |    1 +
 fs/xfs/xfs_rtalloc.c   |    4 ++--
 5 files changed, 24 insertions(+), 21 deletions(-)

