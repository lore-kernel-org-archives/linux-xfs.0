Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E3BC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 16:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC09E24653
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 16:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iZxA2ubY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgAUQrE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 11:47:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34566 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAUQrE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 11:47:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LGN4dm094927
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 16:47:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=JIJI+3TBZYQWfhKcysHryuZSKoNkK3MCWBL5mM5t1cU=;
 b=iZxA2ubYodN+gbGW3bJ9hbm2L0O/q8GPdpXsa+LYYFKfNmrSVIg0/nFYAbswrTbW/RgK
 KkYxRlRWpj2WbM5cogQeRFs3xQLvbTYRIxculmjTg+WUrJ0YS3c0WanGSsN3Xv0D4qKL
 mRuRhYL0O3DbS3/T6X/VFQLU3V8SuV8f2JMs5qqlUwJ42g0JPtLkvqc3FzBVOMJC++0y
 9rx9qOK6rpQMl7e9YV8z0CWlvZTLSaLMNLxZ8BRXtq8H08CJNjfCLjOP8gEBxTVVIC0t
 NWUb5lmiOQ5Iu3Mw13C68AohFfT+y5oF84a5p2rdgWf8/PuheKq6TpECAY2o+miBjzef eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseuee0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 16:47:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LGNxEL114477
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 16:47:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xnpeetj48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 16:47:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LGl019011749
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 16:47:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 08:47:00 -0800
Date:   Tue, 21 Jan 2020 08:46:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to aa124436f329
Message-ID: <20200121164659.GB8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210132
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
the next update.  Still clanking away at Christoph's attr cleanup
series, need help.... :/

The new head of the for-next branch is commit:

aa124436f329 xfs: change return value of xfs_inode_need_cow to int

New Commits:

Allison Henderson (1):
      [d29f781c32b1] xfs: Remove all strlen in all xfs_attr_* functions for attr names.

Arnd Bergmann (2):
      [3b62f000c86a] xfs: rename compat_time_t to old_time32_t
      [b8a0880a37e2] xfs: quota: move to time64_t interfaces

Christoph Hellwig (5):
      [953aa9d136f5] xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HANDLE
      [84fd081f8ae9] xfs: reject invalid flags combinations in XFS_IOC_ATTRMULTI_BY_HANDLE
      [8cde9f259c7d] xfs: also remove cached ACLs when removing the underlying attr
      [780d29057781] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
      [7b53b868a181] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read

Darrick J. Wong (11):
      [7cb41b1d14e1] xfs: remove bogus assertion when online repair isn't enabled
      [a5084865524d] xfs: introduce XFS_MAX_FILEOFF
      [4bbb04abb4ee] xfs: truncate should remove all blocks, not just to the end of the page cache
      [932befe39dde] xfs: fix s_maxbytes computation on 32-bit kernels
      [8edbb26b0602] xfs: refactor remote attr value buffer invalidation
      [e8db2aafcedb] xfs: fix memory corruption during remote attr value buffer invalidation
      [0bb9d159bd01] xfs: streamline xfs_attr3_leaf_inactive
      [c64dd49b5112] xfs: clean up xfs_buf_item_get_format return value
      [c3d5f0c2fb85] xfs: complain if anyone tries to create a too-large buffer log item
      [b7df5e92055c] xfs: make struct xfs_buf_log_format have a consistent size
      [8a6453a89dc1] xfs: check log iovec size to make sure it's plausibly a buffer log format

Eric Sandeen (1):
      [5a57c05b56b6] xfs: remove shadow variable in xfs_btree_lshift

Vincenzo Frascino (1):
      [ca78eee7b4ac] xfs: Add __packed to xfs_dir2_sf_entry_t definition

zhengbin (1):
      [aa124436f329] xfs: change return value of xfs_inode_need_cow to int


Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c        |  14 ++--
 fs/xfs/libxfs/xfs_attr.h        |  15 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   9 ---
 fs/xfs/libxfs/xfs_attr_remote.c |  89 +++++++++++++++++-------
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +
 fs/xfs/libxfs/xfs_btree.c       |   2 -
 fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
 fs/xfs/libxfs/xfs_da_format.h   |   4 +-
 fs/xfs/libxfs/xfs_format.h      |   7 ++
 fs/xfs/libxfs/xfs_log_format.h  |  19 +++--
 fs/xfs/scrub/repair.h           |   1 -
 fs/xfs/xfs_acl.c                |  11 +--
 fs/xfs/xfs_attr_inactive.c      | 149 ++++++++++++----------------------------
 fs/xfs/xfs_buf_item.c           |  45 ++++++++----
 fs/xfs/xfs_buf_item.h           |   1 +
 fs/xfs/xfs_dquot.c              |   6 +-
 fs/xfs/xfs_file.c               |   7 +-
 fs/xfs/xfs_inode.c              |  24 +++----
 fs/xfs/xfs_ioctl.c              |  20 +++++-
 fs/xfs/xfs_ioctl32.c            |   9 ++-
 fs/xfs/xfs_ioctl32.h            |   2 +-
 fs/xfs/xfs_iomap.c              |   2 +-
 fs/xfs/xfs_iops.c               |   6 +-
 fs/xfs/xfs_log_recover.c        |   6 ++
 fs/xfs/xfs_ondisk.h             |   1 +
 fs/xfs/xfs_qm.h                 |   6 +-
 fs/xfs/xfs_quotaops.c           |   6 +-
 fs/xfs/xfs_reflink.c            |   9 +--
 fs/xfs/xfs_reflink.h            |   2 +-
 fs/xfs/xfs_super.c              |  48 ++++++-------
 fs/xfs/xfs_trans_dquot.c        |   8 ++-
 fs/xfs/xfs_xattr.c              |  14 ++--
 33 files changed, 300 insertions(+), 252 deletions(-)
