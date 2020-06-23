Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6A6C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 04:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2B3120771
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 04:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FKsfUxx7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgFWEBo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 00:01:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgFWEBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 00:01:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3w9Hm062347;
        Tue, 23 Jun 2020 04:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=aYNPhVGAZdrz6FKQL30d7O+RW9ex5tFx3TtwcG+uZpY=;
 b=FKsfUxx7xSgpVpOIETSz+5vEK2XDA3mo2yiCmBxDMJDQIQzNSkfwQVLyTV2aXPhEL0oe
 Tp5sU6RZXgkeLF2//GXvKlF00oN92/r7/m6t9KPWcJdicgqFS0Ea6C/EAE1L8G4rOatZ
 JK/HGfZhkFFmrOkuLrLYUn4GDRysyqEK9xb9+IIxr8e0qgwLoZgBOsEA52fHEB/6Fqqz
 ZhI5Tx+MMu8hxjCQI7mcr8mRHUZCkEhTXnyc//rfeIaZjC9nuqmJFKx8MzibNPsbrbHr
 cDcoei4w+hRMZm/e7Y0PlHaPGqVlet5ZCA8RvxDKvull5G2mWmoXlKFq1aLjDA5VO2JX ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31sebbatwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 04:01:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3w8eG171343;
        Tue, 23 Jun 2020 04:01:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31svc2yp65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 04:01:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05N41UOZ021185;
        Tue, 23 Jun 2020 04:01:38 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 04:01:30 +0000
Subject: [PATCH 0/3] xfs: reflink cleanups
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Mon, 22 Jun 2020 21:01:29 -0700
Message-ID: <159288488965.150128.10967331397379450406.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a few patches cleaning up some problems with reflink.  The
first patch is the largest -- it reorganizes the remapping loop so that
instead of running one transaction for each extent in the source file
regardless of what's in the destination file, we look at both files to
find the longest extent we can swap in one go, and run a transaction for
just that piece.  This fixes a problem of running out of block
reservation when the filesystem is very fragmented.

The second patch fixes some goofiness in the reflink prep function, and
the third patch moves the "lock two inodes" code into xfs_inode.c since
none of that is related to reflink.

Mr. Torok: Could you try applying these patches to a recent kernel to
see if they fix the fs crash problems you were seeing with duperemove,
please?

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reflink-cleanups
---
 fs/xfs/libxfs/xfs_bmap.h |   13 +-
 fs/xfs/xfs_file.c        |    4 -
 fs/xfs/xfs_inode.c       |   93 +++++++++++++
 fs/xfs/xfs_inode.h       |    3 
 fs/xfs/xfs_reflink.c     |  325 +++++++++++++++++++---------------------------
 fs/xfs/xfs_reflink.h     |    2 
 fs/xfs/xfs_trace.h       |   52 -------
 fs/xfs/xfs_trans_dquot.c |   13 +-
 8 files changed, 252 insertions(+), 253 deletions(-)

