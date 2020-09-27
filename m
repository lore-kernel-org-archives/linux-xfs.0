Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C635C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F4F23A33
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 23:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eFNx5aWG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgI0Xlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:41:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI0Xlo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 19:41:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNcvUm050878;
        Sun, 27 Sep 2020 23:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=85ywDeAUGCtOzMIXelxhK5gCmiAs3JVRLyQLZsVNtqo=;
 b=eFNx5aWGgggtn9mZcFLNf58Pl5vEn3StzCqroHURGM6IAkGhEIHFydBq7Qm1/L/HlFOB
 4u7EwKnNLE+gqkpwYaDIKikw0qexNBvuJZ9hoDQhh5JexRU/30KVgekfWladh0Ldb4qD
 kbln/PkaKZLsbIC2+D+oMuOu0tjrcc4XVU568ptz+ihZL2f+agJGlWZh+iHl8ihTiKir
 lSmMbhX0zg+NN0Ufgqv7nZ5tctmvmCZ3vENh2BI8kuBgR66Azr38NGLulMwxCO3mF4Fa
 N1IJalbR+A9d1RPnmcVU2qH12E/nM3GKL3RZIp9DitelGvZtw/kdzpMxO1rMUA7QCo/r Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9mtg1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 27 Sep 2020 23:41:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08RNdiUN167925;
        Sun, 27 Sep 2020 23:41:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33tfju3p1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Sep 2020 23:41:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08RNfb0M002174;
        Sun, 27 Sep 2020 23:41:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 27 Sep 2020 16:41:37 -0700
Subject: [PATCH v2 0/3] xfs: fix inode use-after-free during log recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Date:   Sun, 27 Sep 2020 16:41:36 -0700
Message-ID: <160125009588.174612.13196702491335373645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009270227
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this second series, I try to fix a use-after-free that I discovered
during development of the dfops freezer, where BUI recovery releases the
inode even if it requeues itself.  If the inode gets reclaimed, the fs
corrupts memory and explodes.  The fix is to make the dfops capture
struct take over ownership of the inodes if there's any more work to be
done.  This is a bit clunky, but it's a simpler mechanism than saving
inode pointers and inode numbers and introducing tagged structures so
that we can distinguish one from the other.

v2: rebase atop the new defer capture code

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-bmap-intent-recovery-5.10
---
 fs/xfs/libxfs/xfs_defer.c       |   45 ++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_defer.h       |   22 +++++++++++
 fs/xfs/libxfs/xfs_log_recover.h |   11 +++++-
 fs/xfs/xfs_bmap_item.c          |   78 ++++++++++++++++-----------------------
 fs/xfs/xfs_icache.c             |   41 +++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |   35 +++++++++++++++---
 fs/xfs/xfs_trans.h              |    6 ---
 7 files changed, 175 insertions(+), 63 deletions(-)

