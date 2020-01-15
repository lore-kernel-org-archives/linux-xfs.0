Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C927DC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC98214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PuCtmaki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgAORNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:13:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44488 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgAORNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:13:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FHDDmo023856
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 17:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=4LtYRq4Jw+/tjm2S2ZFoJkJ6wim/lqlw9q0Hi3a3McI=;
 b=PuCtmakiKCg9/9XwT5SQsFwuPi4q9oYHdj3u3J0zTRx0F4+CLhZG1Rw3H8MTx8Yjcw9k
 NDeNW66Rk+3fvA/TKqIYtWyk3TZ1z+cM8S9kK+eG6c3p3IBJSAbXr1jMOQQBXDAjIqHS
 Jqy1JCmFAAYGDLlKe/0RXH65b0sDDMniXrNIrrvvmiFdrsMQChwp370bhBYT7x2/U4Rk
 73YrB/GlgJoUVB7k86/Le+8kBBpaEhEIcBLZa1UVb48mzr8C6lx4ckL2JtcM94HDbG9X
 oQuGAzWJGFPLp9NvZpnR+rl8nLCatnaie8rvZ6aqyS+FUl/mfZdLQf67LDhVYIQ7+d8g nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73twd81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 17:13:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FHDouI085744
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 17:13:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1apy0kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 17:13:51 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FHDkhf029618
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 17:13:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:13:46 -0800
Date:   Wed, 15 Jan 2020 09:13:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to ca78eee7b4ac
Message-ID: <20200115171345.GC8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150131
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
the next update.  Still reading hch's attr cleanup series and hoping
someone has time to review the two series I just posted.

The new head of the for-next branch is commit:

ca78eee7b4ac xfs: Add __packed to xfs_dir2_sf_entry_t definition

New Commits:

Allison Henderson (1):
      [d29f781c32b1] xfs: Remove all strlen in all xfs_attr_* functions for attr names.

Arnd Bergmann (2):
      [3b62f000c86a] xfs: rename compat_time_t to old_time32_t
      [b8a0880a37e2] xfs: quota: move to time64_t interfaces

Christoph Hellwig (4):
      [953aa9d136f5] xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HANDLE
      [84fd081f8ae9] xfs: reject invalid flags combinations in XFS_IOC_ATTRMULTI_BY_HANDLE
      [8cde9f259c7d] xfs: also remove cached ACLs when removing the underlying attr
      [780d29057781] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag

Darrick J. Wong (4):
      [7cb41b1d14e1] xfs: remove bogus assertion when online repair isn't enabled
      [a5084865524d] xfs: introduce XFS_MAX_FILEOFF
      [4bbb04abb4ee] xfs: truncate should remove all blocks, not just to the end of the page cache
      [932befe39dde] xfs: fix s_maxbytes computation on 32-bit kernels

Eric Sandeen (1):
      [5a57c05b56b6] xfs: remove shadow variable in xfs_btree_lshift

Vincenzo Frascino (1):
      [ca78eee7b4ac] xfs: Add __packed to xfs_dir2_sf_entry_t definition


Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++-----
 fs/xfs/libxfs/xfs_attr.h      | 15 +++++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c |  4 ++--
 fs/xfs/libxfs/xfs_btree.c     |  2 --
 fs/xfs/libxfs/xfs_da_btree.h  |  4 +++-
 fs/xfs/libxfs/xfs_da_format.h |  4 +---
 fs/xfs/libxfs/xfs_format.h    |  7 +++++++
 fs/xfs/scrub/repair.h         |  1 -
 fs/xfs/xfs_acl.c              | 11 ++++++----
 fs/xfs/xfs_dquot.c            |  6 +++---
 fs/xfs/xfs_inode.c            | 24 +++++++++++-----------
 fs/xfs/xfs_ioctl.c            | 20 +++++++++++++++---
 fs/xfs/xfs_ioctl32.c          |  9 +++++++-
 fs/xfs/xfs_ioctl32.h          |  2 +-
 fs/xfs/xfs_iops.c             |  6 ++++--
 fs/xfs/xfs_qm.h               |  6 +++---
 fs/xfs/xfs_quotaops.c         |  6 +++---
 fs/xfs/xfs_reflink.c          |  3 ++-
 fs/xfs/xfs_super.c            | 48 +++++++++++++++++++------------------------
 fs/xfs/xfs_trans_dquot.c      |  8 +++++---
 fs/xfs/xfs_xattr.c            | 14 ++++++++-----
 21 files changed, 127 insertions(+), 87 deletions(-)
