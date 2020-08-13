Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012AFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD53F2078B
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 23:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0RbIDVR1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHMX3X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 19:29:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMX3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 19:29:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNGgYn101708;
        Thu, 13 Aug 2020 23:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=i/YwT7eUJOevy2xTAt3p+Vzhba+H0q5iwyv6mYG0qdQ=;
 b=0RbIDVR1RgVlu9E9DEKWdMoPbs9uOkbBtDCw45dp1F8lMwvI2fMOP4faU+VdYwgioE8d
 LEsnzUZ4ezLBVO3aJMd7UbpssH6b7FiD7yQoW7JTtg6TfREySAvYruVuSQn869xo8Xu8
 vXPLS7noWBW6Ql0PCl12fYf00J7HDn50sZGRVHDhXRg7i974Gf2QGPt4psLMKQh+YVeU
 dVr3YcrwXBvPWTndiXoS6BTdPnyU28mhljcTSxQlLvMSi2GS6YPgftJJJBkxXuAd0Pqy
 hXIYSwnh5QG4f234Oe0SZq4xuP4zeAHEPayXn1JpjHEmFpOPKDir44Ju0QDRQU9VmIgz mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32w73cakqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 23:29:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DNDcMe190387;
        Thu, 13 Aug 2020 23:27:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32u3h63tgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 23:27:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07DNRH0F016232;
        Thu, 13 Aug 2020 23:27:17 GMT
Received: from localhost (/10.159.233.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 23:27:16 +0000
Subject: [PATCH v2 0/4] xfsprogs: various small enhancements
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 13 Aug 2020 16:27:16 -0700
Message-ID: <159736123670.3063459.13610109048148937841.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This short series contains a couple of enhancements.  The first patch
fixes a bug in xfs_check that we introduced during the 5.8 resync.  The
second patch allows administrators to set the DAX inode flag on the
entire filesystem at format time.  There's also manpage updates and
xfs_db support for the dax inode flag!

In v2 we add some more documentation updates and tweaks suggested by the
maintainer.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.8-fixes
---
 db/check.c          |    4 ++--
 db/inode.c          |    3 +++
 man/man8/mkfs.xfs.8 |   22 ++++++++++++++++++----
 mkfs/xfs_mkfs.c     |   14 ++++++++++++++
 4 files changed, 37 insertions(+), 6 deletions(-)

