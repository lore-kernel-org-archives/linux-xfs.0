Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45551C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiJBSYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiJBSYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F303225295
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914B960EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAED1C433D7;
        Sun,  2 Oct 2022 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735053;
        bh=DWAY6lGQzQUManYdZP2As76QURCljrFG46SHdcL6ops=;
        h=Subject:From:To:Cc:Date:From;
        b=hE0bA/21ATN85gZL6tZwNTdMsEzJpnYh/+OqQ59hBbstdCSY26OCa4o/smmXBRE3P
         LYcvffhMVJb9aTsleVLP1caOnFGDtMnRxtoFmDDtbpulo7wH+ADa7fPB2wUKYqZcYv
         G2DC6kHNYcxo7dVU1P7JGhRaHFAA2tItmp0vrKbYIYGg4sY1IVPMykSlOKaRzMfywL
         vPolpKugo6gj3xZKnkiaHRiZiIVcgIpqsow15lTngzePhwpLi28kWd4GMObAZjPYBT
         GvsxY3cF8gStudTnEpH1UuoetjEF1CLFHcp9XdZuYkrlzNTAN41nYyZdXaW1Tv6WwB
         3+vZtzWis79cQ==
Subject: [PATCHSET v23.1 0/5] xfs: detect incorrect gaps in refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:15 -0700
Message-ID: <166473481572.1084209.5434516873607335909.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The next few patchsets address a deficiency in scrub that I found while
QAing the refcount btree scrubber.  If there's a gap between refcount
records, we need to cross-reference that gap with the reverse mappings
to ensure that there are no overlapping records in the rmap btree.  If
we find any, then the refcount btree is not consistent.  This is not a
property that is specific to the refcount btree; they all need to have
this sort of keyspace scanning logic to detect inconsistencies.

To do this accurately, we need to be able to scan the keyspace of a
btree (which we already do) to be able to tell the caller if the
keyspace is empty, sparse, or fully covered by records.  The first few
patches add the keyspace scanner to the generic btree code, along with
the ability to mask off parts of btree keys because when we scan the
rmapbt, we only care about space usage, not the owners.

The final patch closes the scanning gap in the refcountbt scanner.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-detect-refcount-gaps

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-refcount-gaps
---
 fs/xfs/libxfs/xfs_alloc.c          |   11 ++-
 fs/xfs/libxfs/xfs_alloc.h          |    4 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   16 ++++
 fs/xfs/libxfs/xfs_bmap_btree.c     |   16 ++++
 fs/xfs/libxfs/xfs_btree.c          |  140 +++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_btree.h          |   23 +++++-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   17 ++++
 fs/xfs/libxfs/xfs_refcount.c       |   11 ++-
 fs/xfs/libxfs/xfs_refcount.h       |    5 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   16 ++++
 fs/xfs/libxfs/xfs_rmap.c           |   17 +++-
 fs/xfs/libxfs/xfs_rmap.h           |    4 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |   53 ++++++++++++++
 fs/xfs/libxfs/xfs_types.h          |   12 +++
 fs/xfs/scrub/agheader.c            |    5 +
 fs/xfs/scrub/alloc.c               |    7 +-
 fs/xfs/scrub/bmap.c                |   11 ++-
 fs/xfs/scrub/ialloc.c              |    2 -
 fs/xfs/scrub/inode.c               |    1 
 fs/xfs/scrub/refcount.c            |  112 +++++++++++++++++++++++++++--
 fs/xfs/scrub/rmap.c                |    6 +-
 fs/xfs/scrub/scrub.h               |    2 +
 22 files changed, 432 insertions(+), 59 deletions(-)

