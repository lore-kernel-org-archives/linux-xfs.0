Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884F2C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 17:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A08620836
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 17:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z2o73aFp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCCRbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 12:31:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbgCCRbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 12:31:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023HOHP5018059
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 17:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=nWyqVe6Spvyxa9sg0R+vzv/fs2nni+qxdWPXOCyXPAg=;
 b=Z2o73aFpFkSp8RNuvqjEAoKSKrfVN4F2jfZVi9d95vFVtEaQVAcssVezoe3i9lGvYH56
 +k02Sm1QPTBAfRqTWBEXLZUiaZjO7NxHqIyOKDngN44CcWDTJaPJq6qeAJSn5la5m0SK
 6Fpx0IB8Y7LTWnydJvdI2Ev9WKzgvVD42xde15SDAWfR6/19+emYz6dSzsymQWPYs4HS
 PQVSvp9AoMruaK5FDAnawGKH9BHxksNADD+2Z4zXSbSvzvT2wGx5a1B3So5+4StBkkR1
 +/T2ug//CmXq9Auso35Z6C4JNi+1GBh5NsUtMV8MENjomSwREkx4/G1yMaqu3Z0FfBir gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yffwqrt1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 17:30:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023HEji5033025
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 17:30:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yg1p4xywf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 17:30:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 023HUvGa024441
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 17:30:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 09:30:56 -0800
Date:   Tue, 3 Mar 2020 09:30:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5680c3907361
Message-ID: <20200303173056.GD8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030117
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

5680c3907361 xfs: switch xfs_attrmulti_attr_get to lazy attr buffer allocation

New Commits:

Brian Foster (4):
      [6b789c337a59] xfs: fix iclog release error check race with shutdown
      [b73df17e4c5b] xfs: open code insert range extent split helper
      [dd87f87d87fa] xfs: rework insert range into an atomic operation
      [211683b21de9] xfs: rework collapse range into an atomic operation

Christoph Hellwig (37):
      [3d8f2821502d] xfs: ensure that the inode uid/gid match values match the icdinode ones
      [542951592c99] xfs: remove the icdinode di_uid/di_gid members
      [ba8adad5d036] xfs: remove the kuid/kgid conversion wrappers
      [13b1f811b14e] xfs: ratelimit xfs_buf_ioerror_alert messages
      [4ab45e259f31] xfs: ratelimit xfs_discard_page messages
      [4d542e4c1e28] xfs: reject invalid flags combinations in XFS_IOC_ATTRLIST_BY_HANDLE
      [5e81357435cc] xfs: remove the ATTR_INCOMPLETE flag
      [0eb81a5f5c34] xfs: merge xfs_attr_remove into xfs_attr_set
      [6cc4f4fff10d] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
      [2282a9e65177] xfs: use strndup_user in XFS_IOC_ATTRMULTI_BY_HANDLE
      [d0ce64391128] xfs: factor out a helper for a single XFS_IOC_ATTRMULTI_BY_HANDLE op
      [79f2280b9bfd] xfs: remove the name == NULL check from xfs_attr_args_init
      [4df28c64e438] xfs: remove the MAXNAMELEN check from xfs_attr_args_init
      [ead189adb8ab] xfs: turn xfs_da_args.value into a void pointer
      [a25446224353] xfs: pass an initialized xfs_da_args structure to xfs_attr_set
      [e5171d7e9894] xfs: pass an initialized xfs_da_args to xfs_attr_get
      [c36f533f1407] xfs: remove the xfs_inode argument to xfs_attr_get_ilocked
      [e513e25c380a] xfs: remove ATTR_KERNOVAL
      [d49db18b247d] xfs: remove ATTR_ALLOC and XFS_DA_OP_ALLOCVAL
      [1d7330199400] xfs: replace ATTR_KERNOTIME with XFS_DA_OP_NOTIME
      [377f16ac6723] xfs: factor out a xfs_attr_match helper
      [a9c8c69b4961] xfs: cleanup struct xfs_attr_list_context
      [fe960087121a] xfs: remove the unused ATTR_ENTRY macro
      [2f014aad03d8] xfs: open code ATTR_ENTSIZE
      [3e7a779937a2] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
      [17e1dd83ea21] xfs: rename xfs_attr_list_int to xfs_attr_list
      [f60463195179] xfs: lift common checks into xfs_ioc_attr_list
      [eb241c747463] xfs: lift buffer allocation into xfs_ioc_attr_list
      [53ac39fdb301] xfs: lift cursor copy in/out into xfs_ioc_attr_list
      [5a3930e27ef9] xfs: improve xfs_forget_acl
      [f3e93d95feef] xfs: clean up the ATTR_REPLACE checks
      [d5f0f49a9bdd] xfs: clean up the attr flag confusion
      [254f800f8104] xfs: remove XFS_DA_OP_INCOMPLETE
      [e3a19cdea84a] xfs: embedded the attrlist cursor into struct xfs_attr_list_context
      [f311d771a090] xfs: clean up bufsize alignment in xfs_ioc_attr_list
      [ed02d13f5da8] xfs: only allocate the buffer size actually needed in __xfs_set_acl
      [5680c3907361] xfs: switch xfs_attrmulti_attr_get to lazy attr buffer allocation

Darrick J. Wong (1):
      [93baa55af1a1] xfs: improve error message when we can't allocate memory for xfs_buf

Jules Irenge (1):
      [daebba1b3609] xfs: Add missing annotation to xfs_ail_check()

Qian Cai (1):
      [4982bff1ace1] xfs: fix an undefined behaviour in _da3_path_shift

Zheng Bin (1):
      [d0c7feaf8767] xfs: add agf freeblocks verify in xfs_agf_verify


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c       |  16 ++
 fs/xfs/libxfs/xfs_attr.c        | 351 ++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_attr.h        | 114 +++----------
 fs/xfs/libxfs/xfs_attr_leaf.c   | 119 ++++++--------
 fs/xfs/libxfs/xfs_attr_leaf.h   |   1 -
 fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
 fs/xfs/libxfs/xfs_bmap.c        |  32 +---
 fs/xfs/libxfs/xfs_bmap.h        |   3 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   3 +-
 fs/xfs/libxfs/xfs_da_btree.h    |  11 +-
 fs/xfs/libxfs/xfs_da_format.h   |  12 --
 fs/xfs/libxfs/xfs_fs.h          |  32 +++-
 fs/xfs/libxfs/xfs_inode_buf.c   |   8 +-
 fs/xfs/libxfs/xfs_inode_buf.h   |   2 -
 fs/xfs/scrub/attr.c             |  17 +-
 fs/xfs/xfs_acl.c                | 132 +++++++--------
 fs/xfs/xfs_acl.h                |   6 +-
 fs/xfs/xfs_aops.c               |   2 +-
 fs/xfs/xfs_attr_list.c          | 167 +++----------------
 fs/xfs/xfs_bmap_util.c          |  57 ++++---
 fs/xfs/xfs_buf.c                |   7 +-
 fs/xfs/xfs_dquot.c              |   4 +-
 fs/xfs/xfs_icache.c             |   4 +
 fs/xfs/xfs_inode.c              |  18 +--
 fs/xfs/xfs_inode_item.c         |   4 +-
 fs/xfs/xfs_ioctl.c              | 347 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h              |  35 ++--
 fs/xfs/xfs_ioctl32.c            |  99 ++----------
 fs/xfs/xfs_iops.c               |  23 ++-
 fs/xfs/xfs_itable.c             |   4 +-
 fs/xfs/xfs_linux.h              |  27 +---
 fs/xfs/xfs_log.c                |  13 +-
 fs/xfs/xfs_qm.c                 |  35 ++--
 fs/xfs/xfs_quota.h              |   4 +-
 fs/xfs/xfs_symlink.c            |   4 +-
 fs/xfs/xfs_trace.h              |  63 +++++---
 fs/xfs/xfs_trans_ail.c          |   1 +
 fs/xfs/xfs_xattr.c              |  92 ++++-------
 38 files changed, 762 insertions(+), 1109 deletions(-)
