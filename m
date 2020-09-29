Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D86AC4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90AB208B8
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gxxJdgXs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgI2Rnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:43:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgI2Rnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:43:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdVLS026422;
        Tue, 29 Sep 2020 17:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=LAW6JvsYc3+i3Ehl9llekMEhIc/e2KW9lMtOqG3Rk1Y=;
 b=gxxJdgXsmBchSH8TreuYMfJSmaxmSpg4RoPRsFPjFRNUEN3V8vD9H9OjFI8yH6xa0ZRb
 TszbG/9rnYk9vjXaeGRa6AnQR7ezpaaNS37Fg9DjChe65rU+aZPVxHE8Lr1Yynny3wUh
 P1EQ8BCVVAKRa8DaLhTg76weYKlduM/h1b/ep7x8jFqNQ/gSXQWsGYBIPZ+txg80VMVp
 uNOlWHQ7FQ/Bi+hR5ayYMdDJmi4r9/FWEOk/G6Ua2mhNDRDJ/PYzUvHBUAovsi7N6qCc
 0C9Vi5lmsIcn3QxKfbU7kUBaDcD/vv2iMnMiKcc7vjTbJTw6Z9iLgMOibexbchmjRQoy FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkkva6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:43:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THekTB111488;
        Tue, 29 Sep 2020 17:43:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33tfdsg0g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:43:49 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08THhmeI018889;
        Tue, 29 Sep 2020 17:43:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:43:48 -0700
Subject: [PATCH v3 0/3] xfs: fix inode use-after-free during log recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Date:   Tue, 29 Sep 2020 10:43:47 -0700
Message-ID: <160140142711.830434.5161910313856677767.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
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
v3: only capture one inode, move as much of the defer capture code to
xfs_defer.c as we can

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-bmap-intent-recovery-5.10
---
 fs/xfs/libxfs/xfs_defer.c  |   55 +++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_defer.h  |   11 +++++-
 fs/xfs/xfs_bmap_item.c     |   78 +++++++++++++++++---------------------------
 fs/xfs/xfs_extfree_item.c  |    2 +
 fs/xfs/xfs_log_recover.c   |    7 +++-
 fs/xfs/xfs_refcount_item.c |    2 +
 fs/xfs/xfs_rmap_item.c     |    2 +
 7 files changed, 96 insertions(+), 61 deletions(-)

