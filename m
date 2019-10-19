Return-Path: <SRS0=7yvF=YM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198C3CA9EB2
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 18:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEFBE222D1
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 18:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wqf4vTEh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfJSSHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Oct 2019 14:07:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfJSSHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Oct 2019 14:07:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9JI3w5D054263
        for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2019 18:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=ccmhcV49BUmsQZ0dwLD5Z4awdT6XZRTCO5P1kAuI2JY=;
 b=Wqf4vTEh+hWG93ONItfpVD+EEK84fB9Z7XxIyPC/31VYv+v+kQ2/0wzmqff2Oobe7lYV
 xv3ycar9oKKCntHZk0gGWYkfm1L75u0yHICrw3uadOftW0yuWoQ3uciv0pCWJqhRFZZ3
 6GYBJW+Hsyq+PVWdcRAPDpE0waURiCcEWQuVsa1j7Gxq2pO2aRZ5ner93s2bdkQ3ATMQ
 gnDjAhRr/1qGOSxCWEAopBCC+rSzpNXNfDOTgBtxxuyCIY2NNfeudp0fZPyhfBDbaeO0
 yPLk7OQih9s5slfszdl97uzvF0CrrMnQluB6UwvxXMSPUs8rpNFzQ5LnGZgkkjrOl9iF eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4q9e22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2019 18:07:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9JI3sgF036434
        for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2019 18:07:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vqrhe7h63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2019 18:07:05 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9JI74P1024919
        for <linux-xfs@vger.kernel.org>; Sat, 19 Oct 2019 18:07:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Oct 2019 18:07:03 +0000
Date:   Sat, 19 Oct 2019 11:07:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: xfs-5.5-merge updated to 722da9485033
Message-ID: <20191019180703.GD6719@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9415 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=998
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910190170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9415 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910190170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

** NOT-STABLE INTERIM BRANCH ANNOUNCEMENT **

The xfs-5.5-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

This branch is built atop the proposed iomap 5.5 merge branch, for which
I have given everyone until 22 Oct 2019 00:00 UTC to complain if there
are any serious problems.  Until then, please consider this branch
potentially subject to being rebased.  It does not include Christoph's
v3 iomap cleanups, since that'll take a day or two to test anyway.

The new head of the xfs-5.5-merge branch is commit:

722da9485033 xfs: fix inode fork extent count overflow

New Commits:

Brian Foster (11):
      [367caf641367] xfs: track active state of allocation btree cursors
      [aa056ce95480] xfs: introduce allocation cursor data structure
      [2d762b01e0c7] xfs: track allocation busy state in allocation cursor
      [2dc7a360e9f2] xfs: track best extent from cntbt lastblock scan in alloc cursor
      [1c004aefbc49] xfs: refactor cntbt lastblock scan best extent logic into helper
      [8850f861b841] xfs: reuse best extent tracking logic for bnobt scan
      [d12c9a9807a1] xfs: refactor allocation tree fixup code
      [3ef17289f316] xfs: refactor and reuse best extent scanning logic
      [ad2e96cbc3d2] xfs: refactor near mode alloc bnobt scan into separate function
      [9c16806d4643] xfs: factor out tree fixup logic into helper
      [3d899229624f] xfs: optimize near mode bnobt scans with concurrent cntbt lookups

Christoph Hellwig (9):
      [4326f199ff95] xfs: ignore extent size hints for always COW inodes
      [cf59fa63c45a] xfs: pass the correct flag to xlog_write_iclog
      [ca42659bcd68] xfs: remove the unused ic_io_size field from xlog_in_core
      [d960600958ec] xfs: move the locking from xlog_state_finish_copy to the callers
      [dc4ac1fc2182] xfs: call xlog_state_release_iclog with l_icloglock held
      [59693d649f91] xfs: remove dead ifdef XFSERRORDEBUG code
      [355f1bfffb6d] xfs: remove the unused XLOG_STATE_ALL and XLOG_STATE_UNUSED flags
      [87562be8a3fb] xfs: turn ic_state into an enum
      [ec1fe9d7b77e] xfs: remove the XLOG_STATE_DO_CALLBACK state

Dave Chinner (1):
      [722da9485033] xfs: fix inode fork extent count overflow

yu kuai (1):
      [a6026a86ce7f] xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c       | 897 +++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_alloc_btree.c |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c   |  18 +-
 fs/xfs/libxfs/xfs_btree.h       |   3 +
 fs/xfs/libxfs/xfs_dir2_sf.c     |   2 +-
 fs/xfs/libxfs/xfs_iext_tree.c   |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.h  |  14 +-
 fs/xfs/xfs_inode.c              |   6 +
 fs/xfs/xfs_log.c                | 428 ++++++++-----------
 fs/xfs/xfs_log_cil.c            |   2 +-
 fs/xfs/xfs_log_priv.h           |  25 +-
 fs/xfs/xfs_super.h              |  10 +
 fs/xfs/xfs_trace.h              |  33 +-
 14 files changed, 769 insertions(+), 680 deletions(-)
