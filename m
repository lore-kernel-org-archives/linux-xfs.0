Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669ADC2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 16:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4282225B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 16:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DXTdou+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgKTQzo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Nov 2020 11:55:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729569AbgKTQzo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Nov 2020 11:55:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AKGoJnC166425
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 16:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=JRMVX3l3Nm8xvrz2Ti2Q8fh+cBbvFtncSHMJP0zwt3k=;
 b=DXTdou+RlXo+hWavTWvnina0vMcxFx4bXMkt7J94Ci4rneTeuxDcHwcXk+2FxZTtN+u2
 XN3yefXUxiEOUUO534U6oZrP7d5GkfDW/IwB4xxKc6RukM26LuaJUwnrUn6ozRnMljbv
 griYcQK+W/bsX8T2UHmtbzwvg4jIWCi/hKCxrttuzC48SClUpPcM1vKtL8s0TFkJD34E
 HGU3DuqjuVT0dq+/DwTvAxB6i6MiUAEQ8+ZS7KIrOnMLkRMfyPdqCRc21GaWHWWp8dpg
 iqgOFcreFPcV8ETjvs195bkJ94WH7JqMwzcIb7hibSs9gt+DIzDCWIo+SkxwHD+TqA3w rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76mbmp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 16:55:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AKGohC5020399
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 16:55:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34ts61st2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 16:55:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AKGtfHb021725
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 16:55:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Nov 2020 08:55:41 -0800
Date:   Fri, 20 Nov 2020 08:55:40 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to eb8409071a1d
Message-ID: <20201120165540.GI9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=2 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200115
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
the next update.  I wasn't planning to advance the branch twice in as
many days, but Eric found regressions with one of last week's patches
and that needed to get reverted asap.

The new head of the for-next branch is commit:

eb8409071a1d xfs: revert "xfs: fix rmap key and record comparison functions"

New Commits:

Darrick J. Wong (5):
      [e95b6c3ef131] xfs: fix the minrecs logic when dealing with inode root child blocks
      [498fe261f0d6] xfs: strengthen rmap record flags checking
      [6b48e5b8a20f] xfs: directory scrub should check the null bestfree entries too
      [27c14b5daa82] xfs: ensure inobt record walks always make forward progress
      [eb8409071a1d] xfs: revert "xfs: fix rmap key and record comparison functions"

Dave Chinner (1):
      [883a790a8440] xfs: don't allow NOWAIT DIO across extent boundaries

Gao Xiang (1):
      [ada49d64fb35] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)

Yu Kuai (1):
      [595189c25c28] xfs: return corresponding errcode if xfs_initialize_perag() fail


Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c  |  8 +++++++-
 fs/xfs/libxfs/xfs_rmap_btree.c | 16 +++++++--------
 fs/xfs/scrub/bmap.c            |  8 ++++----
 fs/xfs/scrub/btree.c           | 45 +++++++++++++++++++++++++-----------------
 fs/xfs/scrub/dir.c             | 27 ++++++++++++++++++-------
 fs/xfs/xfs_iomap.c             | 29 +++++++++++++++++++++++++++
 fs/xfs/xfs_iwalk.c             | 27 ++++++++++++++++++++++---
 fs/xfs/xfs_mount.c             | 11 ++++++++---
 8 files changed, 127 insertions(+), 44 deletions(-)
