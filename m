Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEA4C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 18:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A7A2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 18:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uT8G+2xE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIJSdU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 14:33:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgIJS3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 14:29:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AIStXG110765
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 18:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=XmTce+rR5HehvTOCw0woY1Q7NpIimZY1mfRc9H8Bidk=;
 b=uT8G+2xEHw4OdVGrCEQSbArwunVetPSrhDmw0m4FAKqgnjWC3fbZfS0BQvFvLqoH/aeM
 VOV8Um7udmXukDwMn6LZ9rlQ7JRzpA0WOtI9ycKm81sE5If6ORbgTdaJd2l7OrwIhVhQ
 hd66uxH/aWbKs9o9dKm3VQXPU+EuCbvrCtnO6r+aC7+sL5Jjbix9POeDc1ErQUFhS2xz
 BX74O3jMmNjM2iBuenw6vus6a3YRYdZex8IJc1lkNtWXgaj0JvYzOlbiJznJe+kfl97B
 83Y+690wJ4zgAr/8c3yjSDp3JMh4wXJryz6NCMiNDAewL8+0TApS8U3R8lRS+G1JMKaN Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mm9unn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 18:28:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AIF8ju097742
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 18:26:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmkae7pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 18:26:54 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AIQsqQ013316
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 18:26:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 11:26:53 -0700
Date:   Thu, 10 Sep 2020 11:26:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 18a1031619de
Message-ID: <20200910182650.GO7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=2 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100170
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
the next update after -rc6.  The biggest changes in here are two new
features: large timestamps and an expansion of the AGI that will
hopefully decrease mount times.

The new head of the for-next branch is commit:

18a1031619de xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size

New Commits:

Carlos Maiolino (6):
      [771915c4f688] xfs: remove kmem_realloc()
      [08639d86fa65] xfs: Remove kmem_zalloc_large()
      [ce7726a988d8] xfs: remove typedef xfs_attr_sf_entry_t
      [acfc932f77d2] xfs: Remove typedef xfs_attr_shortform_t
      [66f8e544b5ea] xfs: Use variable-size array for nameval in xfs_attr_sf_entry
      [7724567d7d15] xfs: Convert xfs_attr_sf macros to inline functions

Christoph Hellwig (15):
      [c7946f84d768] xfs: refactor the buf ioend disposition code
      [7c33cf679d3d] xfs: mark xfs_buf_ioend static
      [bbc47cac42be] xfs: refactor xfs_buf_ioend
      [eac248182d16] xfs: move the buffer retry logic to xfs_buf.c
      [e16c1144305e] xfs: fold xfs_buf_ioend_finish into xfs_ioend
      [0a0c8460a0e7] xfs: refactor xfs_buf_ioerror_fail_without_retry
      [be3e01085400] xfs: remove xfs_buf_ioerror_retry
      [b6df21f61c8b] xfs: lift the XBF_IOEND_FAIL handling into xfs_buf_ioend_disposition
      [13a6bfd2fb60] xfs: simplify the xfs_buf_ioend_disposition calling convention
      [a5b961a4f46b] xfs: use xfs_buf_item_relse in xfs_buf_item_done
      [d43e1ee50999] xfs: clear the read/write flags later in xfs_buf_ioend
      [d34c0ccf4c0b] xfs: remove xlog_recover_iodone
      [00a7bf8b898e] xfs: simplify xfs_trans_getsb
      [afd44ff1d8de] xfs: remove xfs_getsb
      [543439229b03] xfs: reuse _xfs_buf_read for re-reading the superblock

Darrick J. Wong (19):
      [10dd2c7d4af6] xfs: store inode btree block counts in AGI header
      [0004f136c4cd] xfs: use the finobt block counts to speed up mount times
      [624dc3cca517] xfs: support inode btree blockcounts in online scrub
      [30deae31eab5] xfs: support inode btree blockcounts in online repair
      [0d168b604808] xfs: enable new inode btree counters feature
      [504ec27394bc] xfs: explicitly define inode timestamp range
      [9fe2ad7b2d73] xfs: refactor quota expiration timer modification
      [7f20c7a4a37e] xfs: refactor default quota grace period setting code
      [bc504d6e17f6] xfs: refactor quota timestamp coding
      [54ba865f63c4] xfs: move xfs_log_dinode_to_disk to the log recovery code
      [45e06fe6d122] xfs: redefine xfs_timestamp_t
      [0944f39f176c] xfs: redefine xfs_ictimestamp_t
      [de63a670b67d] xfs: widen ondisk inode timestamps to deal with y2038+
      [4434089b2d08] xfs: widen ondisk quota expiration timestamps to handle y2038+
      [2504dbb2c049] xfs: trace timestamp limits
      [75b89018eb33] xfs: enable big timestamps
      [7c0073f2994c] xfs: force the log after remapping a synchronous-writes file
      [fd2d6c0c1144] xfs: make sure the rt allocator doesn't run off the end
      [18a1031619de] xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size

Dave Chinner (12):
      [718ecc50359e] xfs: xfs_iflock is no longer a completion
      [03e0f3b77e12] xfs: add log item precommit operation
      [b2341f2b41b6] xfs: factor the xfs_iunlink functions
      [cb2e6066b979] xfs: add unlink list pointers to xfs_inode
      [138d87bf4e5d] xfs: replace iunlink backref lookups with list lookups
      [eeea5367d0b7] xfs: mapping unlinked inodes is now redundant
      [73d6110273bf] xfs: updating i_next_unlinked doesn't need to return old value
      [720d8a952088] xfs: validate the unlinked list pointer on update
      [a4223a3882fc] xfs: re-order AGI updates in unlink list updates
      [538d3d74a95a] xfs: combine iunlink inode update functions
      [50b9451ec6d0] xfs: add in-memory iunlink log item
      [596fb4a448e1] xfs: reorder iunlink remove operation in xfs_ifree

Gao Xiang (1):
      [f5e0b8c04f59] xfs: arrange all unlinked inodes into one list

Zheng Bin (1):
      [34c6209d59ed] xfs: Remove unneeded semicolon


Code Diffstat:

 fs/xfs/Makefile                  |   1 +
 fs/xfs/kmem.c                    |  22 --
 fs/xfs/kmem.h                    |   7 -
 fs/xfs/libxfs/xfs_ag.c           |   5 +
 fs/xfs/libxfs/xfs_attr.c         |  14 +-
 fs/xfs/libxfs/xfs_attr_leaf.c    |  43 ++-
 fs/xfs/libxfs/xfs_attr_sf.h      |  29 +-
 fs/xfs/libxfs/xfs_da_format.h    |   6 +-
 fs/xfs/libxfs/xfs_dquot_buf.c    |  35 ++
 fs/xfs/libxfs/xfs_format.h       | 211 +++++++++++-
 fs/xfs/libxfs/xfs_fs.h           |   1 +
 fs/xfs/libxfs/xfs_ialloc.c       |   5 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |  65 +++-
 fs/xfs/libxfs/xfs_iext_tree.c    |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c    | 130 ++++---
 fs/xfs/libxfs/xfs_inode_buf.h    |  15 +-
 fs/xfs/libxfs/xfs_inode_fork.c   |   8 +-
 fs/xfs/libxfs/xfs_log_format.h   |   7 +-
 fs/xfs/libxfs/xfs_log_recover.h  |   1 -
 fs/xfs/libxfs/xfs_quota_defs.h   |   8 +-
 fs/xfs/libxfs/xfs_sb.c           |   6 +-
 fs/xfs/libxfs/xfs_shared.h       |   3 +
 fs/xfs/libxfs/xfs_trans_inode.c  |  17 +-
 fs/xfs/scrub/agheader.c          |  30 ++
 fs/xfs/scrub/agheader_repair.c   |  24 ++
 fs/xfs/scrub/inode.c             |  31 +-
 fs/xfs/scrub/symlink.c           |   2 +-
 fs/xfs/xfs_acl.c                 |   2 +-
 fs/xfs/xfs_attr_list.c           |   6 +-
 fs/xfs/xfs_bmap_util.c           |  16 +
 fs/xfs/xfs_buf.c                 | 208 ++++++++++--
 fs/xfs/xfs_buf.h                 |  17 +-
 fs/xfs/xfs_buf_item.c            | 264 +--------------
 fs/xfs/xfs_buf_item.h            |  12 +
 fs/xfs/xfs_buf_item_recover.c    |   2 +-
 fs/xfs/xfs_dquot.c               |  66 +++-
 fs/xfs/xfs_dquot.h               |   3 +
 fs/xfs/xfs_error.c               |   2 -
 fs/xfs/xfs_file.c                |  17 +-
 fs/xfs/xfs_icache.c              |  21 +-
 fs/xfs/xfs_inode.c               | 706 +++++++++------------------------------
 fs/xfs/xfs_inode.h               |  42 +--
 fs/xfs/xfs_inode_item.c          |  61 +++-
 fs/xfs/xfs_inode_item.h          |   5 +-
 fs/xfs/xfs_inode_item_recover.c  |  76 +++++
 fs/xfs/xfs_ioctl.c               |   7 +-
 fs/xfs/xfs_iunlink_item.c        | 168 ++++++++++
 fs/xfs/xfs_iunlink_item.h        |  25 ++
 fs/xfs/xfs_log_recover.c         | 253 +++++++-------
 fs/xfs/xfs_mount.c               |  38 +--
 fs/xfs/xfs_mount.h               |   2 +-
 fs/xfs/xfs_ondisk.h              |  38 ++-
 fs/xfs/xfs_qm.c                  |  13 +
 fs/xfs/xfs_qm.h                  |   4 +
 fs/xfs/xfs_qm_syscalls.c         |  18 +-
 fs/xfs/xfs_quota.h               |   8 -
 fs/xfs/xfs_rtalloc.c             |  13 +-
 fs/xfs/xfs_super.c               |  38 ++-
 fs/xfs/xfs_trace.h               |  30 +-
 fs/xfs/xfs_trans.c               |  93 +++++-
 fs/xfs/xfs_trans.h               |   8 +-
 fs/xfs/xfs_trans_buf.c           |  46 +--
 fs/xfs/xfs_trans_dquot.c         |   6 +
 63 files changed, 1726 insertions(+), 1336 deletions(-)
 create mode 100644 fs/xfs/xfs_iunlink_item.c
 create mode 100644 fs/xfs/xfs_iunlink_item.h
