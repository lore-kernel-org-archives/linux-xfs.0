Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49522CA9EAF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 119072173B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="covp+ndr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfJVBog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 21:44:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48990 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 21:44:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1iYUb010435
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2019 01:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=CTyA1zMPErAyVVLxLEypZwBHFPrQ0msBDlqF+wLbKsk=;
 b=covp+ndrrGDMOYy6/AkjzRncA5j0iI1sPN9ZtXhu6u6b7MyC2ihPCKXoE3FX0yz73fdW
 NE6Foy/y7kdGhO3KLo3ldLkUcjVfYOMYqgr0eAyzH2UiFOkM/q6iODeYD/8Lpt0/ca6m
 OiMyXZmOUVOzEB60a24P3W2wWUVw1S3oVo+zjcy03BCenrxIqgf8gaJLmj1+xABeaemt
 31s72Rjq5gGi9PF3Ytzpb6teBGeuQZVbudxfdZss9RorxhPwAtpjLiOm1KyH9HAAgkrQ
 j/tUJAMm/6Xb8OspoMigMk1DTauLf+9ln6z6Il96HySTlQC2Nj/9II8ke0R0ZLOyLOI3 Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqtepkcbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2019 01:44:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1cDWd143093
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2019 01:44:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vrcnbbhf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2019 01:44:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9M1iX7V002816
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2019 01:44:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 18:44:33 -0700
Date:   Mon, 21 Oct 2019 18:44:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 1e190f8e8098
Message-ID: <20191022014432.GI913374@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=898
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=981 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220015
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
the next update.  Now that the iomap branch is stable, here's all the
xfs stuff that's been backing up behind that.  There's a (re-sent)
allocator patch series from Brian that I'll look at first thing
tomorrow.

The new head of the for-next branch is commit:

1e190f8e8098 xfs: improve the IOMAP_NOWAIT check for COW inodes

New Commits:

Brian Foster (11):
      [f6b428a46d60] xfs: track active state of allocation btree cursors
      [f5e7dbea1e3e] xfs: introduce allocation cursor data structure
      [d6d3aff20377] xfs: track allocation busy state in allocation cursor
      [c62321a2a0ea] xfs: track best extent from cntbt lastblock scan in alloc cursor
      [396bbf3c657e] xfs: refactor cntbt lastblock scan best extent logic into helper
      [fec0afdaf498] xfs: reuse best extent tracking logic for bnobt scan
      [4a65b7c2c72c] xfs: refactor allocation tree fixup code
      [78d7aabdeea3] xfs: refactor and reuse best extent scanning logic
      [0e26d5ca4a40] xfs: refactor near mode alloc bnobt scan into separate function
      [d29688257fd4] xfs: factor out tree fixup logic into helper
      [dc8e69bd7218] xfs: optimize near mode bnobt scans with concurrent cntbt lookups

Christoph Hellwig (21):
      [bdb2ed2dbdc2] xfs: ignore extent size hints for always COW inodes
      [cd95cb962b7d] xfs: pass the correct flag to xlog_write_iclog
      [2c68a1dfbd8e] xfs: remove the unused ic_io_size field from xlog_in_core
      [390aab0a1640] xfs: move the locking from xlog_state_finish_copy to the callers
      [df732b29c807] xfs: call xlog_state_release_iclog with l_icloglock held
      [032cc34ed517] xfs: remove dead ifdef XFSERRORDEBUG code
      [fe9c0e77acc5] xfs: remove the unused XLOG_STATE_ALL and XLOG_STATE_UNUSED flags
      [1858bb0bec61] xfs: turn ic_state into an enum
      [4b29ab04ab0d] xfs: remove the XLOG_STATE_DO_CALLBACK state
      [0d45e3a20822] xfs: also call xfs_file_iomap_end_delalloc for zeroing operations
      [dd26b84640cc] xfs: remove xfs_reflink_dirty_extents
      [ffb375a8cf20] xfs: pass two imaps to xfs_reflink_allocate_cow
      [ae36b53c6c60] xfs: refactor xfs_file_iomap_begin_delay
      [36adcbace24e] xfs: fill out the srcmap in iomap_begin
      [43568226a4a3] xfs: factor out a helper to calculate the end_fsb
      [690c2a38878e] xfs: split out a new set of read-only iomap ops
      [a526c85c2236] xfs: move xfs_file_iomap_begin_delay around
      [f150b4234397] xfs: split the iomap ops for buffered vs direct writes
      [12dfb58af61d] xfs: rename the whichfork variable in xfs_buffered_write_iomap_begin
      [5c5b6f7585d2] xfs: cleanup xfs_direct_write_iomap_begin
      [1e190f8e8098] xfs: improve the IOMAP_NOWAIT check for COW inodes

Dave Chinner (1):
      [3f8a4f1d876d] xfs: fix inode fork extent count overflow

yu kuai (1):
      [e5e634041bc1] xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c       | 897 +++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_alloc_btree.c |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c   |  18 +-
 fs/xfs/libxfs/xfs_btree.h       |   3 +
 fs/xfs/libxfs/xfs_dir2_sf.c     |   2 +-
 fs/xfs/libxfs/xfs_iext_tree.c   |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.h  |  14 +-
 fs/xfs/xfs_aops.c               |   9 +-
 fs/xfs/xfs_bmap_util.c          |   3 +-
 fs/xfs/xfs_file.c               |  23 +-
 fs/xfs/xfs_inode.c              |   6 +
 fs/xfs/xfs_iomap.c              | 675 +++++++++++++++---------------
 fs/xfs/xfs_iomap.h              |   4 +-
 fs/xfs/xfs_iops.c               |   6 +-
 fs/xfs/xfs_log.c                | 428 ++++++++-----------
 fs/xfs/xfs_log_cil.c            |   2 +-
 fs/xfs/xfs_log_priv.h           |  25 +-
 fs/xfs/xfs_reflink.c            | 136 +-----
 fs/xfs/xfs_reflink.h            |   4 +-
 fs/xfs/xfs_super.h              |  10 +
 fs/xfs/xfs_trace.h              |  33 +-
 22 files changed, 1164 insertions(+), 1145 deletions(-)
