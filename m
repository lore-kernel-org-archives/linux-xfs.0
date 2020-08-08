Return-Path: <SRS0=JHMh=BS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF29C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Aug 2020 17:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D1442072D
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Aug 2020 17:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h/ENYuab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgHHRQd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Aug 2020 13:16:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgHHRQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Aug 2020 13:16:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 078HGWbS007798
        for <linux-xfs@vger.kernel.org>; Sat, 8 Aug 2020 17:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kmM1+PCFed6RR5rNF4KVdu/sMltEeXvaPcJ76XtsiYE=;
 b=h/ENYuabuWzW6J4THV74KosvGOezu72QHwKKHZK4B5rK83msQAo4ZO7iP2YsWzbwyQUx
 kZLOi1XzOUBZ+bQPVzuf+wLW3w14ulO4vZi0zGE72Q9vB9QjbOVDAroy7hvQUP1Q2P/Q
 HCrboCjVO59D1C7+UGMxc8jPwwlZQmHl28NwJO1zAg8UNUrIvnvK+rq77LlOdhXUN04Z
 SfsSIMArUESqy6Zs27ilHoJea84B6F24cTXelbY+Cg81cOYEKIVczUAX6PXVMZ/GIwmr
 Dj3onIJwyrLhlxcWWligOd48B1rI8cfP0WqFaoj3x84MploZvltrgm03WTqLjkryfoDH 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32sm0m9c7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 08 Aug 2020 17:16:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 078HE75g185694
        for <linux-xfs@vger.kernel.org>; Sat, 8 Aug 2020 17:16:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32sh5rejr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 08 Aug 2020 17:16:31 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 078HGUnf006791
        for <linux-xfs@vger.kernel.org>; Sat, 8 Aug 2020 17:16:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 08 Aug 2020 10:16:30 -0700
Date:   Sat, 8 Aug 2020 10:16:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 96cf2a2c7556
Message-ID: <20200808171628.GE6096@magnolia>
References: <20200729185230.GE3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729185230.GE3151642@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9707 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008080130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9707 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=2 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008080131
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
the next update.

The new head of the for-next branch is commit:

96cf2a2c7556 xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

New Commits:

Eiichi Tsukata (1):
      [96cf2a2c7556] xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Randy Dunlap (1):
      [b63da6c8dfa9] xfs: delete duplicated words + other fixes


Code Diffstat:

 fs/xfs/libxfs/xfs_sb.c        | 2 +-
 fs/xfs/xfs_attr_list.c        | 2 +-
 fs/xfs/xfs_buf_item.c         | 2 +-
 fs/xfs/xfs_buf_item_recover.c | 2 +-
 fs/xfs/xfs_dquot.c            | 2 +-
 fs/xfs/xfs_export.c           | 2 +-
 fs/xfs/xfs_inode.c            | 4 ++--
 fs/xfs/xfs_inode_item.c       | 4 ++--
 fs/xfs/xfs_iomap.c            | 2 +-
 fs/xfs/xfs_log_cil.c          | 2 +-
 fs/xfs/xfs_log_recover.c      | 2 +-
 fs/xfs/xfs_refcount_item.c    | 2 +-
 fs/xfs/xfs_reflink.c          | 2 +-
 fs/xfs/xfs_sysfs.h            | 6 ++++--
 fs/xfs/xfs_trans_ail.c        | 4 ++--
 15 files changed, 21 insertions(+), 19 deletions(-)
