Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83F3C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FF020720
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:45:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ctU9FkHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgGPGpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:45:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgGPGpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:45:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hOuW080461
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=olM2yqxPYFMerWemBPBzFcj4PNxUxxuJK7gwQojXjL4=;
 b=ctU9FkHx56epN56pJ24dYh4Z0IJqDgHepsl+8nzsnSTLhgJsd/n15tbH132aqkDd6fK1
 FVt57abS2bLh3HNN4OabPtbMV+2GCUkCxI1xj/1qQBtwk3KMqMCZ8bhK+JF68iQdY0rO
 Q/WWQf0w/IVWhSvwE17tNUmIrCeY/BYr8iAydTnJD0tCYswZpOlUYs/K5iHps3TFwwVb
 RkCqjdPjMK0lUMvHWiX9Zm7WyNVpza20MtqZkpgjjFnjCffWqxSPw8w+xtftHUoRTwqd
 852vKRQ1oIvk7/152wcvfhKNdEJSQMFghPFloG6GGqirhKE3r87PU/ykAiiJC39IJFq0 Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274urfhah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hn4B061658
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0srfaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:22 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06G6jKON007015
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:45:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:45:20 -0700
Subject: [PATCH v5 00/11] xfs: separate dquot type from flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:45:19 -0700
Message-ID: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series tries to clean up some of the messier parts of dquot flags
handling.  We begin by cleaning up a bunch of dquot flag misuse, so that
now xfs quota functions only take record type information; remove a
bunch of other helper macros that duplicate the "what type is this?"
predicates, and make all the quota type switching logic the same.

We make a fundamental distinction here -- from now on, xfs quota
function only take XFS_DQTYPE_{USER,GROUP,PROJ} as a type parameter.
This means that anything trying to extract the quota record type from an
incore dquot had better use xfs_dquot_type() to extract the type flags.
Right now there's no difference since there are no other type flags, but
this will become important when y2038 timestamps shows up.

Finally, we create a new xfs_dqtype_t to represent all that is an incore
dquot record type, and rename the ondisk d_flags field to d_type to make
the quota type information more self contained.

TLDR: dquot type information is now a separate field, and quota
functions now only take the XFS_DQTYPE flags that signal user, group, or
project quota.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
---
 fs/xfs/libxfs/xfs_dquot_buf.c   |   25 +++++----
 fs/xfs/libxfs/xfs_format.h      |   13 +++++
 fs/xfs/libxfs/xfs_quota_defs.h  |   25 +++++----
 fs/xfs/scrub/quota.c            |   14 +++--
 fs/xfs/scrub/repair.c           |   10 ++--
 fs/xfs/scrub/repair.h           |    4 +-
 fs/xfs/xfs_buf_item_recover.c   |    9 ++-
 fs/xfs/xfs_dquot.c              |  103 +++++++++++++++++++++------------------
 fs/xfs/xfs_dquot.h              |   73 ++++++++++++++++++----------
 fs/xfs/xfs_dquot_item_recover.c |   12 ++---
 fs/xfs/xfs_icache.c             |    4 +-
 fs/xfs/xfs_iomap.c              |   36 +++++++-------
 fs/xfs/xfs_qm.c                 |   79 +++++++++++++++---------------
 fs/xfs/xfs_qm.h                 |   55 +++++++++------------
 fs/xfs/xfs_qm_bhv.c             |    2 -
 fs/xfs/xfs_qm_syscalls.c        |   17 ++----
 fs/xfs/xfs_quota.h              |   10 ++--
 fs/xfs/xfs_quotaops.c           |    8 ++-
 fs/xfs/xfs_trace.h              |   21 ++++++--
 fs/xfs/xfs_trans_dquot.c        |   34 ++++++++-----
 20 files changed, 302 insertions(+), 252 deletions(-)

