Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72998C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 17:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46701207FD
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 17:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kos3bBCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407038AbfIXRSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 13:18:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407033AbfIXRSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 13:18:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OGx6oN062810
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2019 17:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=7UJIIe+WSBQqCxzRzbFtF3VptlmnAQD7wAiNrB+0m0o=;
 b=kos3bBCGidJcedM23huReq78bIK/byhfNoJTv65RouYZWeBbN1AEH9h4jzgQT1X+h1Fv
 0OgIVk/X50k9ed90R9AlFYJCiyuTHlY9x/bTsTM8TsR2a7FjJiDiM15U+zgUlB4ettnA
 tSAwhya7+GpS+7cQk4jyrNoHo/Id8e2tSdlwSqjK+/TbQF6+6YpTYGGzfUAQXrFRhpn4
 HPf4yzFeIN8ec7rX1TVvwUDKv7gzIYwF4TNeNtTXyeYM2lBu5J1hGOPETad7jzVtVvK4
 bKYqB4883Xdc7NwfLup4yZUN6yd+pD8ZziOLDJ1e4lOpcn4JUmzw7QidyvRekfFzlPLz jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9tqmpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2019 17:18:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OGwnD3146221
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2019 17:18:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v6yvp6rxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2019 17:18:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8OHIlKY007720
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2019 17:18:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 10:18:47 -0700
Date:   Tue, 24 Sep 2019 10:18:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 88d32d3983e7
Message-ID: <20190924171846.GA2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  I figure I might as well push along the bug fixes and
trivial cleanups that have come in.

The new head of the for-next branch is commit:

88d32d3983e7 xfs: avoid unused to_mp() function warning

New Commits:

Aliasgar Surti (1):
      [583e4eff98fa] xfs: removed unneeded variable

Austin Kim (1):
      [88d32d3983e7] xfs: avoid unused to_mp() function warning

Brian Foster (1):
      [e20e174ca1bd] xfs: convert inode to extent format after extent merge due to shift

Darrick J. Wong (1):
      [ce840429260a] xfs: revert 1baa2800e62d ("xfs: remove the unused XFS_ALLOC_USERDATA flag")

Eric Sandeen (1):
      [6f4ff81a4602] xfs: log proper length of superblock


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.h |  7 ++++---
 fs/xfs/libxfs/xfs_bmap.c  | 13 +++++++++++--
 fs/xfs/libxfs/xfs_sb.c    |  2 +-
 fs/xfs/scrub/alloc.c      |  3 +--
 fs/xfs/xfs_sysfs.c        | 13 -------------
 5 files changed, 17 insertions(+), 21 deletions(-)
