Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5BDC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FDD61241
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbhIXB3K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243765AbhIXB3K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3444F610CB;
        Fri, 24 Sep 2021 01:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446858;
        bh=TLGEAes75D4OnUc2Y+ZRI5XP95SWLtqPOnqcEGn6Twc=;
        h=Subject:From:To:Cc:Date:From;
        b=EZHfdp/83Tl+2v5aPdMqXN21ZmRGhekHO3OrwJP0Udb1KDarP3nhv1NCMjXmfjRAu
         FOsboTFQxEl5BtbNVmmxj0yTQHEDR5pt7nBtGUbVHggImhv39p+Bu9a+IQaAfLxy5N
         FKoKXUGamcTEbr82mVnP1pLgy3RBVNMXIgDDLcc+V+dWydguh+Av2XdPTqyaG7xqrM
         lhmjka3Yb7OdCMFqIRsFBa+cmuOohG6H7nJAqcU2WKmmbCFl5ay4dnYYVZDDRaLo1s
         5fNcO+Npz4rtAPBTLTfrP4dhyYe3xTEOTFUOaSRBddp6BL5fCyUrJbbpI2kpBbi//c
         X1e8vn1pbUFNA==
Subject: [PATCHSET RFC v2 chandan 0/4] xfs: separate btree cursor slab zones
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com,
        chandanrlinux@gmail.com, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:37 -0700
Message-ID: <163244685787.2701674.13029851795897591378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Following the review discussions about the dynamic btree cursor height
patches, I've throw together another series to reduce the size of the
btree cursor, compute the absolute maximum possible btree heights for
each btree type, and now each btree cursor has its own slab zone:

$ grep xfs.*cur /proc/slabinfo
xfs_refc_btree_cur      0      0    192   21    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_ialloc_btree_cur      0      0    208   19    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_bmap_btree_cur      0      0    240   17    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_rmap_btree_cur      0      0    240   17    1 : tunables    0    0    0 : slabdata      0      0      0
xfs_alloc_btree_cur      0      0    208   19    1 : tunables    0    0    0 : slabdata      0      0      0

I've also rigged up the debugger to make it easier to extract the actual
height information:

$ xfs_db /dev/sda -c 'btheight -w absmax all'
bnobt: 7
cntbt: 7
inobt: 7
finobt: 7
bmapbt: 9
refcountbt: 6
rmapbt: 9

As you can see from the slabinfo output, this no longer means that we're
allocating 224-byte cursors for all five btree types.  Even with the
extra overhead of supporting dynamic cursor sizes, we still come out
ahead in terms of cursor size for three of the five btree types.

This series also includes a couple of patches to reduce holes and
unnecessary fields in the btree cursor.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-cursor-zones-5.16
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   12 +++++++
 fs/xfs/libxfs/xfs_alloc_btree.h    |    1 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |   13 ++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h     |    1 +
 fs/xfs/libxfs/xfs_btree.c          |   61 +++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h          |   28 +++++++++-------
 fs/xfs/libxfs/xfs_fs.h             |    3 ++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   11 ++++++
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    1 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 ++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |   25 +++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h     |    1 +
 fs/xfs/libxfs/xfs_types.h          |    3 ++
 fs/xfs/xfs_super.c                 |   62 +++++++++++++++++++++++++++++++++---
 15 files changed, 210 insertions(+), 26 deletions(-)

