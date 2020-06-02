Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87B9C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A3E20738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zvFi338Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFBE1N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:27:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBE1N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:27:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I2oW121439;
        Tue, 2 Jun 2020 04:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=rVWoaCv0go7DJ/OljhwYuc36ObUPA8lfGwF8CVIYoT4=;
 b=zvFi338ZS/q/dIea2axBG/bRKt3uPLi6Uaj01n0MWA0T4Po37HFeon0OCihe7/weD0Ja
 6Sn++8sk3HnO1p1cCQkUA8HyUl7XQvEykgVRPFg1lR9yhct7f8/8cTKMdcRpKP5CN5DG
 Q08pCsIKvDa7rAg25UvcF1+ZsgN4nN6QYIFd+W5eLzlTuZth4YHqvWmaqsRsNZ4jQiSI
 ZoKMz0vUhdd5ePbjz4GZoUq4gmfp8OpAtyYewSpibtHl4ZzC32dn8DSfnqEvfMTbNClP
 I0KysrCyp0sBR1b4jNJe0IcvPYI1cKVo+vupaa4VyWZZfFL3Ioq27lecxRFaMf0+sxtr wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31d5qr20r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HwHC040137;
        Tue, 2 Jun 2020 04:25:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31c18sgfy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:25:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524P2YN019415;
        Tue, 2 Jun 2020 04:25:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:25:02 -0700
Subject: [PATCH v2 00/17] xfs_repair: catch things that xfs_check misses
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:01 -0700
Message-ID: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A long-time goal of mine is to get rid of xfs_check from fstests,
because it is deprecated, adds quite a bit of runtime to the test suite,
and consumes memory like crazy.  We've not been able to do that for lack
of even a basic field-by-field corruption detection comparison between
check and repair, so I temporarily modified the dangerous_repair tests
to warn when check finds something but repair says clean.

The patches below teach xfs_repair to complain about things that it
previously did not catch but xfs_check did.  The one remaining gap is
the lack of quota counter checking, which will be sent in a separate
series once I've worked out all the bugs.

v2: mostly minor updates and add a bunch of RVB tags.  Also pick up the
one quota fix because why not...

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=check-vs-repair
---
 libxfs/libxfs_api_defs.h |    4 +
 quota/edit.c             |   22 +++---
 repair/attr_repair.c     |    2 -
 repair/da_util.c         |   25 +++++--
 repair/dino_chunks.c     |    6 +-
 repair/dinode.c          |  109 +++----------------------------
 repair/dinode.h          |   14 ----
 repair/dir2.c            |   21 ++++++
 repair/phase4.c          |   11 ++-
 repair/phase6.c          |    3 +
 repair/prefetch.c        |    9 +--
 repair/sb.c              |    3 -
 repair/scan.c            |  160 ++++++++++++++++++++++++++++++++--------------
 13 files changed, 196 insertions(+), 193 deletions(-)

