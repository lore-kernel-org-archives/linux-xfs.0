Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AA2C47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3E1611CA
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhEaWmc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhEaWmb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7417B60FDC;
        Mon, 31 May 2021 22:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500851;
        bh=P/h0OuFqupKVmH6s175PoTDWOv0SgQtKHoumN4GTM8Q=;
        h=Subject:From:To:Cc:Date:From;
        b=MRQw/GgjEL0SHECp+3xJ5o8nt3LaVlOqDvxSNYRU0a/wBv9wBU1Kniaz8HempjTq+
         ocaf51pFFmnc0dxIRA0e28UMR9Nni8iUdk23qEX0aisfYaL4OVIAxLhVCfQXRdjG07
         u2uP00mlK6PFIejSP+LiQU70JYaIvW94KQsJd6oga2NJikiqQ+q3V3b3JUxNon5RAQ
         TSQkTp+gH3I+fkbF4nVIy9rzLic+yeHUp+c/834GE99GcY6i8/2Jsmobdg+GPDKRx1
         F/Fm0LnhUqrDIh0PS9vOcgGat2GW9dHImoPcIZMjY/iUQ8aXREkhlRZhy3RxRizjuE
         JBh+5PQHM19Mw==
Subject: [PATCHSET v2 0/5] xfs: clean up quotaoff inode walks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:40:51 -0700
Message-ID: <162250085103.490412.4291071116538386696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series cleans up the inode walk that quotaoff does to detach dquots
from the current set of incore inodes.  Once we've cleared away all the
baggage that was implemented for "no tag" walks (since this is the only
caller that doesn't use tags), we can speed up quotaoff by making it
detach more aggressively.  This gets us into shape for further inode
walk cleanups in the next series.

Christoph suggested last cycle that we 'simply' change quotaoff not to
allow deactivating quota entirely, but as these cleanups are to enable
one major change in behavior (deferred inode inactivation) I do not want
to add a second behavior change (quotaoff) as a dependency.

To be blunt: Additional cleanups are not in scope for this series.

v2: rebase to 5.13-rc4

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quotaoff-cleanups-5.14
---
 fs/xfs/xfs_icache.c      |  119 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_icache.h      |   17 +++++--
 fs/xfs/xfs_inode.c       |   22 ++++-----
 fs/xfs/xfs_qm.h          |    1 
 fs/xfs/xfs_qm_syscalls.c |   54 +--------------------
 fs/xfs/xfs_super.c       |   32 +++++++++++-
 6 files changed, 167 insertions(+), 78 deletions(-)

