Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266E1C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2BFB64F59
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhCRWd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231886AbhCRWdk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0896464F40;
        Thu, 18 Mar 2021 22:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106820;
        bh=xZqW1YeGrQ8FNBUgikUy5PgzdR/Gwn3C/h8C+m+EWkA=;
        h=Subject:From:To:Cc:Date:From;
        b=McJ5b7KgkrOzHiDI6tyPwgHQbfrXfLK2+zLHBp5vARKEB59dIpH/I/LFk2CdWcVWA
         cElkt1/rKbOqCY01X9khj74PszAM9EBiHwV8CyYGwejKw9zVAiNqpLr9OJ5xyt19Cy
         kMTl/MqPOiiF2IYT0QcX0WcbQa13JlyJ5LYwsEfD3v13o5t0zwRPNoFFvePwTdQVoL
         gK6Kgr+klraWC1OBPhckmMmzVfl3F/FCFLLlJXsgfNv/lRhmSHgvx0VCEWFX2MJIx/
         F1rrZgTZW6C5DgHV10FQtKaRCMBdd/U1MNzru+BSiMxf3AAcdP/cr+xAP7yKyaQYcK
         OcBlv2nLICqkw==
Subject: [PATCHSET 0/3] xfs: reduce indirect function calls in inode walk
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:33:39 -0700
Message-ID: <161610681966.1887634.12780057277967410395.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This short series reduces the number of indirect function calls when we
want to iterate the incore inode radix tree, and reduces the number of
arguments that must be passed to the walk function.

I made a few observations about incore inode radix tree walks -- the one
caller (blockgc) that cares about radix tree tags is internal to
xfs_icache.c, and there's a 1:1 mapping between that tag and the
iterator function.  Furthermore, the only other caller (quotaoff) is the
only caller to supply a nonzero flags argument, and it never specifies a
radix tree tag.

On those grounds, we can remove both the flags and tag arguments to
xfs_inode_walk; and for the internal caller, we can replace the indirect
call with direct calls to the blockgc functions.  This makes for less
ugly code and gives us a (negligible) performance bump.

This series is a prerequisite for the next patchset, since deferred
inode inactivation will add another inode radix tree tag and iterator
function to go with it.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=iwalk-remove-indirect-calls-5.13
---
 fs/xfs/xfs_icache.c      |   57 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_icache.h      |    9 ++-----
 fs/xfs/xfs_qm_syscalls.c |    3 +-
 3 files changed, 40 insertions(+), 29 deletions(-)

