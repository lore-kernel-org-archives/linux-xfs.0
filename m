Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F180BC3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 15:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAC8722CED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 15:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N0Q093Io"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfH1Pz6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 11:55:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfH1Pz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 11:55:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SFsBWx184518
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 15:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=bfQs/9l1oVAI6ckJrKZP/sKpcMswziHUOKp4w46rSy8=;
 b=N0Q093IoCB4mQZMydezcO+s0jjzbHzF5gDQmYNszgzhW1chiRC5duN4VsmWGcdfUf0e9
 W8+DvlJk+DaSY9uCI+E7jrta46UBe6i7wmja+KGOh6Jjuo/kwtG8N+U1C/6PS1grf/+r
 5GRuwhRnLAcyZtqQhORPbB2q25M+JIm+a++xveY8M16BBMOYitkrF3+YJlCTNkzqk3Wi
 dXwJ0i6BmN1NXVfZgm1yUjpMvsanQJUSogFfjIjAhYWDpQLG2EXQLl9TFyfFk+64or0E
 jJ3XFNY0q0Qmn+lxD+Te8c6kax++enVt442K/9aKYvOQPh3MhKIrSNWg6XXZRq7H/Js7 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2unvnh80cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 15:55:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SFqlLZ081480
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 15:55:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2unduq49ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 15:55:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7SFtsox009509
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 15:55:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 08:55:54 -0700
Date:   Wed, 28 Aug 2019 08:55:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 7f313eda8fcc
Message-ID: <20190828155553.GD1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280161
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
the next update.  This is the first stab at a for-next for 5.4.  Sorry
it's been so late in coming; 5.3 was an unstable trainwreck for a month
(== hard to do any testing) and we also had a lot of bug fixes trickle
in.  There's more on my radar (like Dave's attr series) that I haven't
had time to read yet.

The new head of the for-next branch is commit:

7f313eda8fcc xfs: log proper length of btree block in scrub/repair

New Commits:

Darrick J. Wong (9):
      [519e5869d50d] xfs: bmap scrub should only scrub records once
      [c94613feefd7] xfs: fix maxicount division by zero error
      [7380e8fec16b] xfs: don't return _QUERY_ABORT from xfs_rmap_has_other_keys
      [b521c89027f4] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
      [2ca09177ab9d] xfs: remove unnecessary parameter from xfs_iext_inc_seq
      [bc46ac64713f] xfs: remove unnecessary int returns from deferred rmap functions
      [74b4c5d4a9c0] xfs: remove unnecessary int returns from deferred refcount functions
      [3e08f42ae782] xfs: remove unnecessary int returns from deferred bmap functions
      [ffb5696f7555] xfs: reinitialize rm_flags when unpacking an offset into an rmap irec

Dave Chinner (3):
      [0ad95687c3ad] xfs: add kmem allocation trace points
      [d916275aa4dd] xfs: get allocation alignment from the buftarg
      [f8f9ee479439] xfs: add kmem_alloc_io()

Eric Sandeen (1):
      [7f313eda8fcc] xfs: log proper length of btree block in scrub/repair

Tetsuo Handa (1):
      [707e0ddaf67e] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.

zhengbin (1):
      [71912e08e06b] xfs: remove excess function parameter description in 'xfs_btree_sblock_v5hdr_verify'


Code Diffstat:

 fs/xfs/kmem.c                  | 79 +++++++++++++++++++++++++++++++-----------
 fs/xfs/kmem.h                  | 15 +++-----
 fs/xfs/libxfs/xfs_alloc.c      |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  |  8 ++---
 fs/xfs/libxfs/xfs_bmap.c       | 75 +++++++++++++++------------------------
 fs/xfs/libxfs/xfs_bmap.h       |  4 +--
 fs/xfs/libxfs/xfs_bmap_btree.c | 16 +++++++--
 fs/xfs/libxfs/xfs_btree.c      |  2 --
 fs/xfs/libxfs/xfs_da_btree.c   |  6 ++--
 fs/xfs/libxfs/xfs_defer.c      |  2 +-
 fs/xfs/libxfs/xfs_dir2.c       | 14 ++++----
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++---
 fs/xfs/libxfs/xfs_ialloc.c     |  9 +++--
 fs/xfs/libxfs/xfs_iext_tree.c  |  8 ++---
 fs/xfs/libxfs/xfs_inode_fork.c | 16 ++++-----
 fs/xfs/libxfs/xfs_refcount.c   | 50 +++++++++++---------------
 fs/xfs/libxfs/xfs_refcount.h   | 12 +++----
 fs/xfs/libxfs/xfs_rmap.c       | 41 +++++++++++-----------
 fs/xfs/libxfs/xfs_rmap.h       | 11 +++---
 fs/xfs/libxfs/xfs_types.h      |  8 +++++
 fs/xfs/scrub/attr.c            |  2 +-
 fs/xfs/scrub/bmap.c            | 77 +++++++++++++++++++++++-----------------
 fs/xfs/scrub/fscounters.c      |  2 +-
 fs/xfs/scrub/repair.c          |  2 +-
 fs/xfs/scrub/symlink.c         |  2 +-
 fs/xfs/xfs_acl.c               |  4 +--
 fs/xfs/xfs_attr_inactive.c     |  2 +-
 fs/xfs/xfs_attr_list.c         |  2 +-
 fs/xfs/xfs_bmap_item.c         |  8 ++---
 fs/xfs/xfs_bmap_util.c         | 16 +++------
 fs/xfs/xfs_buf.c               |  7 ++--
 fs/xfs/xfs_buf.h               |  6 ++++
 fs/xfs/xfs_buf_item.c          |  4 +--
 fs/xfs/xfs_dquot.c             |  2 +-
 fs/xfs/xfs_dquot_item.c        |  2 +-
 fs/xfs/xfs_error.c             |  2 +-
 fs/xfs/xfs_extent_busy.c       |  2 +-
 fs/xfs/xfs_extfree_item.c      |  8 ++---
 fs/xfs/xfs_icache.c            |  2 +-
 fs/xfs/xfs_icreate_item.c      |  2 +-
 fs/xfs/xfs_inode.c             |  2 +-
 fs/xfs/xfs_inode_item.c        |  2 +-
 fs/xfs/xfs_ioctl.c             |  4 +--
 fs/xfs/xfs_ioctl32.c           |  2 +-
 fs/xfs/xfs_itable.c            |  4 +--
 fs/xfs/xfs_iwalk.c             |  2 +-
 fs/xfs/xfs_log.c               |  8 ++---
 fs/xfs/xfs_log_cil.c           | 10 +++---
 fs/xfs/xfs_log_recover.c       | 20 ++++++-----
 fs/xfs/xfs_mount.c             |  2 +-
 fs/xfs/xfs_mount.h             |  7 ----
 fs/xfs/xfs_mru_cache.c         |  4 +--
 fs/xfs/xfs_qm.c                |  4 +--
 fs/xfs/xfs_refcount_item.c     | 16 ++++-----
 fs/xfs/xfs_reflink.c           | 23 ++++--------
 fs/xfs/xfs_rmap_item.c         |  6 ++--
 fs/xfs/xfs_rtalloc.c           |  4 +--
 fs/xfs/xfs_trace.h             | 34 ++++++++++++++++++
 fs/xfs/xfs_trans.c             |  4 +--
 fs/xfs/xfs_trans_dquot.c       |  2 +-
 61 files changed, 379 insertions(+), 323 deletions(-)
