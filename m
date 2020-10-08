Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735D1C4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22BC62085B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 03:56:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YVDYa8+W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgJHD4G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:56:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgJHD4G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 23:56:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983neHf143377;
        Thu, 8 Oct 2020 03:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ihGB2N5jaISViuUvwuC2i18kSf/UoW/E3nu34HFKpmY=;
 b=YVDYa8+W+LH/xuXum6eXXunCEKeP7p22oweyU/7Cbflag4n4KZzhZHPZmqIiIiGb8Y7f
 gV/G/mfIYtoUz9/7ySuvHPofZQcC1aO1/WAoLXxsjUkRei0lxlXqFSPWDv7H900zFPwN
 1ZS16ofMjRJGonA6Raf/01B/n7KHtiRwryzd67rywTKR7mGwg8QY4qwGobYjBJV5DOEQ
 X7TM3ngigVtM5VaD4Lm+faK7MAZA9Z0mOcsoU+GEg22L7NsDR5xW9XY8OL7yuDeDaZVf
 GfcccbnA07Z8i3JAdO6cJvcurdw409n/et3R5VSoy+42hSI9t6nJ8V3d3bEI56jZAifF iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxn58gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:56:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983jD4S070588;
        Thu, 8 Oct 2020 03:56:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33yyjj36ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:56:02 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0983u1Cl022567;
        Thu, 8 Oct 2020 03:56:01 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:56:01 -0700
Subject: [PATCH 0/2] xfs: a couple of realtime growfs fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        sandeen@redhat.com
Date:   Wed, 07 Oct 2020 20:56:00 -0700
Message-ID: <160212936001.248573.7813264584242634489.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080030
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While I was taking a closer look at Chandan's earlier fixes for the
realtime growfs code, I realized that fstests doesn't actually have a
test case for growing a realtime volume.  I wrote one for testing rmap
expansions on the data device and kludged it to work for realtime, and
watched the kernel trip over a ton of assertions and fail xfs_scrub.

The two patches in this series fix the two problems that I found.  The
first is that inode inactivation will truncate the new bitmap blocks if
we don't set the VFS inode size; and the second is that we don't update
the secondary superblocks with the new rt geometry.

I'll cough up a test case after this patch.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rt-growfs-fixes-5.10
---
 fs/xfs/xfs_rtalloc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

