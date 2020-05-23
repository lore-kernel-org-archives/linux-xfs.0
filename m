Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAF1C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D729720738
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xFVxalsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgEWQuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 12:50:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEWQuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 12:50:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGfY0c165082;
        Sat, 23 May 2020 16:49:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/dTlDy/dE/5PZVQB1J6IwGhxNKCJtiCnwVGkB3tca0A=;
 b=xFVxalskx8WxEc4FNlBZXTHR+s/+kkjzPTnDHKiqYhAYXwIo44A7T9QgPKzrFalc4qy5
 IRydFg8Kf53GOLa1OY6FKvIRnkWyixm7oJqt1HBUHlXcgCh+k1Cz/+/5CUp4vcWZW9be
 SY5xkUSVu0/detmO0PCCFEp1zMuduXS5IPRzbFdFd3Rt9b1eI2PHlnQ4PKFjj2MrzsFn
 bQI3QHFdlqKuY1gMCud9rOcidqzCLOMbMng2Z9eTnyG/cx5Xm/LyOftnjcIWALh/Me/2
 g7KgyqdPQUsu3BLhl2JJo5kfxUEMxCxpWYgI0u8rSytWzg4VeZUQUpvurwB7UtXmP0Nj KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 316vfn14cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 16:49:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGnSFh169177;
        Sat, 23 May 2020 16:49:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 316u5husmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 16:49:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04NGnXQF015350;
        Sat, 23 May 2020 16:49:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 09:49:33 -0700
Subject: [PATCH v4 0/4] xfs: fix stale disk exposure after crash
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Date:   Sat, 23 May 2020 09:49:31 -0700
Message-ID: <159025257178.493629.12621189512718182426.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set of patches try to shrink the window during which a crash during
writeback can expose stale disk contents.  The first patch causes
delalloc reservations to be converted to unwritten extents for any
writeback that's going on within EOF.  The second patch fixes a minor
error encountered during writeback; and the third patch fixes
speculative preallocation to work when the EOF block could be unwritten.

v3 puts the extent tree walk into the dynamic prealloc sizing function.
v4 fixes a bug with walking the extent map backwards.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=stale-exposure

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=stale-exposure
---
 fs/xfs/libxfs/xfs_bmap.c |   29 +++++++-----
 fs/xfs/xfs_iomap.c       |  107 +++++++++++++++++++++++-----------------------
 2 files changed, 71 insertions(+), 65 deletions(-)

