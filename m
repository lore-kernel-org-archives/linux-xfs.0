Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC622C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C4820936
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kY//N/wA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgIQD3I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:29:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIQD3G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:29:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3P04s116105;
        Thu, 17 Sep 2020 03:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=vNew7UGNT0BsyWjSKDvytm8ds25qQkJcAz2UX7igXbU=;
 b=kY//N/wAuhc0aSCX9fxnOITAZC6vTLeycgnRlUoQbeNyUfsoHtKhGgl4ZsILuSwl9dIa
 G+elltq9L/08DmCo50ta9h0UBdiRq0+371ofG9nOCzknPAgprGP4/pUcTOKcySW+3vL0
 9Z7sDpDSlPOidcwcHAV/mujMg2GxqAFguotiscfn6NFOqGZc6XE1GkcYvBjafENmRYaL
 b1Hcuvfzv27Jjq6Rk71YkF6EkbKvnl94GvBntMmfzqiXuoERLng0kbVs78u2xcXGicmg
 1i73Ivdl9+VNJzAswqN+deVc/+/nUNcYKhYvJZhwkngL/zWxLxhH8ifgXN/mNv+pqFkE lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dr5fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:29:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Q2nq060915;
        Thu, 17 Sep 2020 03:29:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33khpmd1ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:29:02 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3T119029996;
        Thu, 17 Sep 2020 03:29:01 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:29:01 +0000
Subject: [PATCH 0/3] xfs: fix how we deal with new intents during recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:29:00 -0700
Message-ID: <160031334050.3624461.17900718410309670962.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This second series of log fixes dates back to an earlier discussion that
Dave and I had about the weird way that log recovery works w.r.t. intent
items.  The current code juggles nested transactions so that it can
siphon off new deferred items for later; this we replace with a new
dfops freezer that captures the log reservation type and remaining block
reservation so that we finish the new deferred items with the same
transaction context as we would have had the system not gone down.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-recovery-intent-chaining
---
 fs/xfs/libxfs/xfs_defer.c       |   66 ++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.h       |   22 ++++++++
 fs/xfs/libxfs/xfs_log_recover.h |    4 +
 fs/xfs/xfs_bmap_item.c          |   16 +-----
 fs/xfs/xfs_extfree_item.c       |    7 +--
 fs/xfs/xfs_log_recover.c        |  105 ++++++++++++++++++++++-----------------
 fs/xfs/xfs_refcount_item.c      |   16 +-----
 fs/xfs/xfs_rmap_item.c          |    7 +--
 fs/xfs/xfs_trans.h              |    4 +
 9 files changed, 160 insertions(+), 87 deletions(-)

