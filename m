Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3D3C43381
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C11964E33
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBACG2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhBACGH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:06:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F287264E33;
        Mon,  1 Feb 2021 02:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145127;
        bh=gyjQW/aBApBOje/uSgxepJ2kIywtrIOrn9Esjh7aDc0=;
        h=Subject:From:To:Cc:Date:From;
        b=RknyS2cACKw9HREPs/XaqUuRYlF1Mo++Wn85NrjQn80EbgeoGN2KOr5JPYy7CIl1G
         FA7CA22EuxMCSAo5LlC27jufWd5IHEGXoQEK5IB2a9p7mBeJ2xhVJGebNgCFpZtP71
         pCcXYtzGPA4ApEGtIx/xGd+LQnzRSFdo6+ix/oVu02n3XFnPVLIuEoz4G/d/SO9wUz
         NBhCznOBccaB0wNT3h/NXNwBHdHd9/Xwk++C+KgNRKn45QrGrTVZnRMiVNBRZK5LWt
         MQEGCzkdFrLewF8UascBCiJFVsYTm1E92zZIiOkEjuodFaivHzEprXd04dwF0CwuSc
         CBcheZJwlNLSA==
Subject: [PATCHSET v7 00/12] xfs: try harder to reclaim space when we run out
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:05:26 -0800
Message-ID: <161214512641.140945.11651856181122264773.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Historically, when users ran out of space or quota when trying to write
to the filesystem, XFS didn't try very hard to reclaim space that it
might have speculatively allocated for the purpose of speeding up
front-end filesystem operations (appending writes, cow staging).  The
upcoming deferred inactivation series will greatly increase the amount
of allocated space that isn't actively being used to store user data.

Therefore, try to reduce the circumstances where we return EDQUOT or
ENOSPC to userspace by teaching the write paths to try to clear space
and retry the operation one time before giving up.

Previous iterations of this patchset made massive changes to the
codebase, but thanks to the transaction allocation helpers that Brian
pushed for (in the previous patchset) this is mostly no longer
necessary. :)

v2: clean up and rebase against 5.11.
v3: restructure the retry loops per dchinner suggestion
v4: simplify the calling convention of xfs_trans_reserve_quota_nblks
v5: constrain the open-coded 'goto retry' loops to the helpers created
    in the previous patchset
v6: move "xfs: try worst case space reservation upfront in
    xfs_reflink_remap_extent" to this series, open-code the qretry
    helpers in the (now very few) places they are used
v7: rebase chown stuff to use new helpers introduced in quota cleanups

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reclaim-space-harder-5.12
---
 fs/xfs/xfs_file.c    |   24 +++----
 fs/xfs/xfs_icache.c  |  184 +++++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_icache.h  |    7 +-
 fs/xfs/xfs_ioctl.c   |    2 +
 fs/xfs/xfs_reflink.c |   28 +++++++-
 fs/xfs/xfs_trace.c   |    1 
 fs/xfs/xfs_trace.h   |   42 +++++++++++
 fs/xfs/xfs_trans.c   |   38 ++++++++++
 8 files changed, 244 insertions(+), 82 deletions(-)

