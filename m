Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E167DC64E90
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 805E320796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ofxGQNHG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgLADiY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60186 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13TYlA065982
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=tprUG7YbUIPsV1BT0TypUBtJ4gxUjr6gxvhqiIMdmRg=;
 b=ofxGQNHG0ifsOUL7Vu58DQZnGd7MD+8b9fP4waICHW8dRs7gYDpzAHvaxOhLm+9j9No+
 JvHuoco7ql/4AuZ1XQAbeVG8dHd15mUnG4YXZf0XYyu0drYOe7dDehjD0bdKbj7NwKcW
 9zyzah5y0yXa4OCYsMLV+qPoYVCj+T4p6ah4KGnArc35SDOy4ptTugGqimd0CX8URac/
 T3UTWHbcIDIt9GTZjfBIQGuFwIfHTjEXdsf9gKag1zlBQ/lyP8F7Jndp8kPz9rxv7LzK
 qLpnl58qiwxNbiWg0BDgWzj2XDKvdI+DcfrkgfvcYfu5umu45rd0J72ZLPzpeif4vsa9 jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2arhkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13UPL6161245
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404mbvs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13bfg7011999
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:40 -0800
Subject: [PATCH 00/10] xfs: strengthen log intent validation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:40 -0800
Message-ID: <160679385987.447963.9630288535682256882.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset hoists the code that checks log intent record validation
into separate functions, and reworks them to use the standard field
validation predicates instead of open-coding them.  This strengthens log
recovery against (some) fuzzed log items.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-recovered-log-intent-validation-5.11
---
 fs/xfs/xfs_bmap_item.c     |   75 ++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_extfree_item.c  |   31 ++++++++++++------
 fs/xfs/xfs_log_recover.c   |    5 ++-
 fs/xfs/xfs_refcount_item.c |   61 ++++++++++++++++++++++--------------
 fs/xfs/xfs_rmap_item.c     |   75 ++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_trace.h         |   19 +++++++++++
 6 files changed, 178 insertions(+), 88 deletions(-)

