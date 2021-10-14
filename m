Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FE5C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2613F611B0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhJNUTD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231475AbhJNUTA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4653F60E0B;
        Thu, 14 Oct 2021 20:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242615;
        bh=i0H3TRtM7XaOFVBk1Y5xYERMRdbGkxYywmWBi3EjBnw=;
        h=Subject:From:To:Cc:Date:From;
        b=qLsw7/50XG064PUWXlsgQYmLSXgPI/k91YuU0ARBoz/T8n6pNOgrqLsUqKaCrf8wW
         i1bCMB/RTGPn2CIzC9LuXL/3nYv6R3ygBjF1KcUSwa739RMhzhK0bnNzh/+mWMhyBk
         rBnfZhLVBm3Jsydvwd0KmlM8+CP5NbZRuwmthT+JTRRr3kVUjBWAPVoELX/MQpxFSx
         SOLu6kxs3UbgbgR6qZulq7JCE+xPhW8PORC3CK6iaHAes+toN1x2kpIe2ARYm1stD6
         ndJ4VQSDWPmtzwnQL6eow1KHdGHbQntjXf1hknkq7ssqhBJX3MYJagJplCWpBEa6sK
         yBccpj7MStdmQ==
Subject: [PATCHSET v4 00/17] xfs: support dynamic btree cursor height
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:16:54 -0700
Message-ID: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In what's left of this series, we rearrange the incore btree cursor so
that we can support btrees of any height.  This will become necessary
for realtime rmap and reflink since we'd like to handle tall trees
without bloating the AG btree cursors.

Chandan Babu pointed out that his large extent counters series depends
on the ability to have btree cursors of arbitrary heights, so I've
ported this to 5.15-rc4 so his patchsets won't have to depend on
djwong-dev for submission.

Following the review discussions about the dynamic btree cursor height
patches, I've throw together another series to reduce the size of the
btree cursor, compute the absolute maximum possible btree heights for
each btree type, and now each btree cursor has its own slab cache:

$ grep xfs.*cur /proc/slabinfo
xfs_refcbt_cur 0 0 200 20 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_rmapbt_cur 0 0 248 16 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_bmbt_cur   0 0 248 16 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_inobt_cur  0 0 216 18 1 : tunables 0 0 0 : slabdata 4 4 0
xfs_bnobt_cur  0 0 216 18 1 : tunables 0 0 0 : slabdata 4 4 0

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
extra overhead of supporting dynamic cursor sizes and per-btree caches,
we still come out ahead in terms of cursor size for three of the five
btree types.

This series now also includes a couple of patches to reduce holes and
unnecessary fields in the btree cursor.

Patches 1, 5, 11, 12, 13, 16, and 17 still need review.

v2: reduce scrub btree checker memory footprint even more, put the one
    fixpatch first, use struct_size, fix 80col problems, move all the
    btree cache work to a separate series
v3: rebase to 5.15-rc4, fold in the per-btree cursor cache patches,
    remove all the references to "zones" since they're called "caches"
    in Linux
v4: improve documentation, clean up some geometry functions, simplify
    the max possible height computation code

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-dynamic-depth-5.16
---
 fs/xfs/libxfs/xfs_ag_resv.c        |    3 
 fs/xfs/libxfs/xfs_alloc.c          |   26 ++-
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   63 ++++++-
 fs/xfs/libxfs/xfs_alloc_btree.h    |    5 +
 fs/xfs/libxfs/xfs_bmap.c           |   13 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |   60 ++++++-
 fs/xfs/libxfs/xfs_bmap_btree.h     |    5 +
 fs/xfs/libxfs/xfs_btree.c          |  320 ++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_btree.h          |   87 +++++++---
 fs/xfs/libxfs/xfs_btree_staging.c  |   10 +
 fs/xfs/libxfs/xfs_fs.h             |    2 
 fs/xfs/libxfs/xfs_ialloc.c         |    1 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   90 +++++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    5 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   73 +++++++-
 fs/xfs/libxfs/xfs_refcount_btree.h |    5 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |  116 ++++++++++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |    5 +
 fs/xfs/libxfs/xfs_trans_resv.c     |   18 ++
 fs/xfs/libxfs/xfs_trans_space.h    |    9 +
 fs/xfs/scrub/agheader.c            |    4 
 fs/xfs/scrub/agheader_repair.c     |    4 
 fs/xfs/scrub/bitmap.c              |   22 +-
 fs/xfs/scrub/bmap.c                |    2 
 fs/xfs/scrub/btree.c               |   77 ++++-----
 fs/xfs/scrub/btree.h               |   17 ++
 fs/xfs/scrub/trace.c               |   11 +
 fs/xfs/scrub/trace.h               |   10 +
 fs/xfs/xfs_mount.c                 |   14 ++
 fs/xfs/xfs_mount.h                 |    5 -
 fs/xfs/xfs_super.c                 |   13 +
 fs/xfs/xfs_trace.h                 |    2 
 33 files changed, 783 insertions(+), 316 deletions(-)

