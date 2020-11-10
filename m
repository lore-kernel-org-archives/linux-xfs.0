Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2684C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54C8206F1
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b4DiDX4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbgKJSkW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:40:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54954 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJSkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:40:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAINtX0086634;
        Tue, 10 Nov 2020 18:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=67zaRI62BbomN9LPbHvIbuyGWxK7vV7o+SkA8Ju1QEU=;
 b=b4DiDX4pDE05NwNHGCPGGKep7c7fDVEk9tGS6zbTa1dXV2N02pDIldEwwdqe32Wbza98
 figVz3L9Z2YOQPfry1A3RcVkgf5abgmyGTP63tI6cRMEznvYlJtmjRzO9IMspQyNPFQX
 NDDtrhbFlpSM4UKHlYaU4yiH8sV2iwjfpFdmUPCVnC2klmtzdzr+gQiDL4KhUiJHrj+F
 ytmX86RHQ6bkm8y6l4EoOdXhXtv+O2w+55JbcbO3ze+MjBoKD3dYUNKx+qUdvU9odqr9
 KsbMwORg1q3e1quaW0zYu92VrqLmfq7qrl01batSSSem1ZdDiovi/I8hWvQ9fhXPBnff Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3awf15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:40:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAIP6Sj188196;
        Tue, 10 Nov 2020 18:40:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34qgp788cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:40:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AAIeG8M009973;
        Tue, 10 Nov 2020 18:40:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:40:15 -0800
Date:   Tue, 10 Nov 2020 10:40:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULL] xfsprogs: sync with 5.10, messily
Message-ID: <20201110184014.GC9699@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=59 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=59
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Assuming that Eric approves of the new patches 3, 8, and 9 in the series
I just sent, this is a pull request to pull in all the changes needed
for 5.10.

Granted I'm not sure where we are as far as reviewing the userspace
tooling changes needed to support inode btree counters or bigtime.  I
suppose I could have shoved all that to the end to make the libxfs sync
parts cleaner.

Anyhow, I'll start reading Allison's delayed xattr series and hope the
rest of you take a look at the other 5.10 bug fixes that are sitting on
the list. :)

--D

The following changes since commit 75379bd4b2c5a5924fd6ca203bbaaf41dc6c71cd:

  xfsprogs: Release v5.9.0 (2020-10-20 11:41:03 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-5.10-sync-part2_2020-11-10

for you to fetch changes up to 73304f9226372be509b3e7301d6f393b49f90e10:

  xfs: set xefi_discard when creating a deferred agfl free log intent item (2020-11-10 09:53:32 -0800)

----------------------------------------------------------------
xfsprogs: sync with 5.10, part 2

The second part of syncing libxfs with 5.10.

----------------------------------------------------------------
Carlos Maiolino (5):
      xfs: remove kmem_realloc()
      xfs: remove typedef xfs_attr_sf_entry_t
      xfs: Remove typedef xfs_attr_shortform_t
      xfs: Use variable-size array for nameval in xfs_attr_sf_entry
      xfs: Convert xfs_attr_sf macros to inline functions

Christoph Hellwig (2):
      xfs: move the buffer retry logic to xfs_buf.c
      xfs: simplify xfs_trans_getsb

Darrick J. Wong (58):
      mkfs: allow users to specify rtinherit=0
      mkfs: don't pass on extent size inherit flags when extent size is zero
      xfs: remove unnecessary parameter from scrub_scan_estimate_blocks
      xfs_db: report ranges of invalid rt blocks
      xfs_repair: skip the rmap and refcount btree checks when the levels are garbage
      xfs_repair: correctly detect partially written extents
      xfs_repair: directly compare refcount records
      libxfs-apply: don't add duplicate headers
      xfs_db: add a directory path lookup command
      xfs_db: add an ls command
      xfs: store inode btree block counts in AGI header
      xfs: use the finobt block counts to speed up mount times
      xfs: support inode btree blockcounts in online repair
      xfs_db: support displaying inode btree block counts in AGI header
      xfs_db: add inobtcnt upgrade path
      xfs_repair: check inode btree block counters in AGI
      xfs_repair: regenerate inode btree block counters in AGI
      mkfs: enable the inode btree counter feature
      xfs: enable new inode btree counters feature
      libxfs: create a real struct timespec64
      libxfs: refactor NSEC_PER_SEC
      libfrog: define LIBFROG_BULKSTAT_CHUNKSIZE to remove dependence on XFS_INODES_PER_CHUNK
      libfrog: convert cvttime to return time64_t
      xfs_quota: convert time_to_string to use time64_t
      xfs_db: refactor timestamp printing
      xfs_db: refactor quota timer printing
      xfs_logprint: refactor timestamp printing
      xfs: explicitly define inode timestamp range
      xfs: refactor quota expiration timer modification
      xfs: refactor default quota grace period setting code
      xfs: refactor quota timestamp coding
      xfs: move xfs_log_dinode_to_disk to the log recovery code
      xfs: redefine xfs_timestamp_t
      xfs: redefine xfs_ictimestamp_t
      xfs: widen ondisk inode timestamps to deal with y2038+
      xfs: widen ondisk quota expiration timestamps to handle y2038+
      libxfs: propagate bigtime inode flag when allocating
      libfrog: list the bigtime feature when reporting geometry
      xfs_db: report bigtime format timestamps
      xfs_db: support printing time limits
      xfs_db: add bigtime upgrade path
      xfs_quota: support editing and reporting quotas with bigtime
      xfs_repair: support bigtime timestamp checking
      mkfs: format bigtime filesystems
      xfs: enable big timestamps
      xfs: don't free rt blocks when we're doing a REMAP bunmapi call
      xfs: log new intent items created as part of finishing recovered intent items
      xfs: avoid shared rmap operations for attr fork extents
      xfs: remove xfs_defer_reset
      xfs: proper replay of deferred ops queued during log recovery
      xfs: xfs_defer_capture should absorb remaining block reservations
      xfs: xfs_defer_capture should absorb remaining transaction reservation
      xfs: fix an incore inode UAF in xfs_bui_recover
      xfs: change the order in which child and parent defer ops are finished
      xfs: periodically relog deferred intent items
      xfs: only relog deferred intent items if free space in the log gets low
      xfs: fix high key handling in the rt allocator's query_range function
      xfs: set xefi_discard when creating a deferred agfl free log intent item

Eric Sandeen (1):
      mkfs: clarify valid "inherit" option values

Kaixu Xia (4):
      xfs: use the existing type definition for di_projid
      xfs: fix some comments
      xfs: remove the redundant crc feature check in xfs_attr3_rmt_verify
      xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local}

 db/Makefile                |   3 +-
 db/agi.c                   |   2 +
 db/attrshort.c             |  46 ++--
 db/check.c                 |  37 ++-
 db/command.c               |   2 +
 db/command.h               |   2 +
 db/dquot.c                 |   6 +-
 db/field.c                 |  10 +-
 db/field.h                 |   1 +
 db/fprint.c                | 133 ++++++++--
 db/fprint.h                |   4 +
 db/inode.c                 |  13 +-
 db/metadump.c              |  12 +-
 db/namei.c                 | 612 +++++++++++++++++++++++++++++++++++++++++++++
 db/sb.c                    | 158 +++++++++++-
 db/timelimit.c             | 160 ++++++++++++
 db/xfs_admin.sh            |   6 +-
 include/kmem.h             |   2 +-
 include/libxfs.h           |   1 -
 include/platform_defs.h.in |  30 +++
 include/xfs.h              |   2 +
 include/xfs_fs_compat.h    |  12 +
 include/xfs_inode.h        |  33 ++-
 include/xfs_mount.h        |   5 +
 include/xfs_trace.h        |   2 +
 include/xfs_trans.h        |  27 +-
 include/xqm.h              |  20 +-
 libfrog/bulkstat.h         |   4 +
 libfrog/convert.c          |   6 +-
 libfrog/convert.h          |   2 +-
 libfrog/fsgeom.c           |   6 +-
 libxfs/kmem.c              |   2 +-
 libxfs/libxfs_api_defs.h   |   4 +
 libxfs/libxfs_priv.h       |   2 -
 libxfs/rdwr.c              |  11 +-
 libxfs/trans.c             |   7 +-
 libxfs/util.c              |   7 +-
 libxfs/xfs_ag.c            |   5 +
 libxfs/xfs_alloc.c         |   1 +
 libxfs/xfs_attr.c          |  14 +-
 libxfs/xfs_attr_leaf.c     |  43 ++--
 libxfs/xfs_attr_remote.c   |   2 -
 libxfs/xfs_attr_sf.h       |  29 ++-
 libxfs/xfs_bmap.c          |  19 +-
 libxfs/xfs_bmap.h          |   2 +-
 libxfs/xfs_da_format.h     |  24 +-
 libxfs/xfs_defer.c         | 230 +++++++++++++++--
 libxfs/xfs_defer.h         |  37 +++
 libxfs/xfs_dquot_buf.c     |  35 +++
 libxfs/xfs_format.h        | 211 +++++++++++++++-
 libxfs/xfs_fs.h            |   1 +
 libxfs/xfs_ialloc.c        |   5 +
 libxfs/xfs_ialloc_btree.c  |  65 ++++-
 libxfs/xfs_iext_tree.c     |   2 +-
 libxfs/xfs_inode_buf.c     | 130 +++++-----
 libxfs/xfs_inode_buf.h     |  17 +-
 libxfs/xfs_inode_fork.c    |   8 +-
 libxfs/xfs_log_format.h    |   7 +-
 libxfs/xfs_quota_defs.h    |   8 +-
 libxfs/xfs_rmap.c          |  27 +-
 libxfs/xfs_rtbitmap.c      |  11 +-
 libxfs/xfs_sb.c            |   6 +-
 libxfs/xfs_shared.h        |   3 +
 libxfs/xfs_trans_inode.c   |  17 +-
 libxlog/xfs_log_recover.c  |   2 +-
 logprint/log_misc.c        |  29 ++-
 logprint/log_print_all.c   |   3 +-
 logprint/logprint.h        |   2 +
 man/man8/mkfs.xfs.8        |  48 +++-
 man/man8/xfs_admin.8       |  21 ++
 man/man8/xfs_db.8          |  43 ++++
 mkfs/xfs_mkfs.c            |  70 +++++-
 quota/edit.c               |  79 +++++-
 quota/quota.c              |  16 +-
 quota/quota.h              |   9 +-
 quota/report.c             |  16 +-
 quota/util.c               |   5 +-
 repair/attr_repair.c       |  24 +-
 repair/dinode.c            | 226 +++++++++++------
 repair/phase5.c            |   5 +
 repair/quotacheck.c        |  11 +-
 repair/rmap.c              |   4 +-
 repair/scan.c              |  65 ++++-
 scrub/common.c             |   2 -
 scrub/fscounters.c         |   9 +-
 scrub/fscounters.h         |   2 +-
 scrub/inodes.c             |   5 +-
 scrub/phase6.c             |   7 +-
 scrub/phase7.c             |   5 +-
 scrub/progress.c           |   1 -
 tools/libxfs-apply         |  14 +-
 91 files changed, 2609 insertions(+), 465 deletions(-)
 create mode 100644 db/namei.c
 create mode 100644 db/timelimit.c
