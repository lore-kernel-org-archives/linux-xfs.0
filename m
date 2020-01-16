Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3E2C33CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A54320661
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 06:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BcCacUaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgAPGP6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 01:15:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43732 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbgAPGP6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 01:15:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G6EKHx022318;
        Thu, 16 Jan 2020 06:15:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=+vaspq5CkDs2g7j98XuFelypMj1b+RMHICEBxqoXmBI=;
 b=BcCacUaC4Fq8Xje0ghOF/kyNMf09RV/6SYYHh/eW2k0JOxwgkhLqxEHu6ZjyPKNQF9LE
 TRp55xxhAG7QFdEp/SBB9ufjxXQqkppaErm9zmzHmCeG0lYc9m4A6juH0z820iYvCF55
 WLzO9ei2NfQkUzZvJxQ+vMMQr1wmnH2RU7nuGC60yi+jfkSy5IxlpJcMlCCOD4GsVqcX
 ueuc4hnmNIYumlB6k1WfgrQtOUu//lfllQKFQ6KOVwO49zlZi7bVJvM7umpLDiOGnOO8
 s5dZ9xl6hSoDM6ud8Mj0Fueu+2J4rhPMq2rNmN/1b5u31SkJ+OlOXJynOsATDFcrwx5O cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73yrf9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 06:15:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G6DcLn038151;
        Thu, 16 Jan 2020 06:15:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xhy22qdtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 06:15:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G6FjQK026470;
        Thu, 16 Jan 2020 06:15:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 22:15:45 -0800
Subject: [PATCH 0/2] xfs: fix stale disk exposure after crash
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 22:15:44 -0800
Message-ID: <157915534429.2406747.2688273938645013888.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160052
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These two patches try to shrink the window during which a crash during
writeback can expose stale disk contents.  The first patch causes
delalloc reservations to be converted to unwritten extents for any
writeback that's going on within EOF.

The second patch selectively relaxes the unwritten writeout requirement
when the entire file is being flushed (ala fsync) and ensures that
writeback of a range after the ondisk EOF is expanded downwards to the
old EOF to ensure that increasing a file's size doesn't leave us
vulnerable to exposure of stale disk contents from a previous
speculative allocation.

This solves the regressions in generic/536 and generic/042.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=stale-exposure

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=stale-exposure
