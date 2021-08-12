Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90603C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7110A60FE6
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhHLA7B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhHLA7B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01EB9601FD;
        Thu, 12 Aug 2021 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628729917;
        bh=tbx6nNxu4zUYY+Uk7hMEy68Dd5vKc8lRtUz6NhgdyGc=;
        h=Subject:From:To:Cc:Date:From;
        b=TzFlIlrN+JIkG7aozjemA+Z/YMLFKnjuT1wCPOPIv+oC1yhDvMcd+xUzjx+LKr2Xw
         G+TktDo8uuCQZVydXYmg2MlQEiWsrENtzwWqUQEsx1gNIX/puooIhSmqjbQhBPUhtT
         IwnZCpXeOkGdFCILA9k0vqyj1cjBcuGZoQhcpL0ChKnuH+NIFm0kZnweB8d86gCk0w
         56ktAl3iKh+5lBF+aJX03zGWtDt0kDU9S3QNx+bS02TJf4UQihDMDYSdjZTJLaFi6Y
         DaCkXMZBlMac6rahXqxJmjDHFnGUzaC3P9Fj8yAC83P6H/LsWBJjVXYYKe60SrJb7X
         IGn94Pyb8Yvfw==
Subject: [PATCHSET 0/3] xfs: fix various bugs in fsmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 11 Aug 2021 17:58:36 -0700
Message-ID: <162872991654.1220643.136984377220187940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While performing some code audits of the fsmap code, I noticed some off
by one errors in the realtime bitmap query code that provides the rt
fsmap implementation.

The first problem I found is that while the rtbitmap range query
function will constrain the starting and ending rtextent parameters to
match the actual rt volume, it does so by changing the struct passed in
by the caller.  This is a no-no, since query functions themselves are
not supposed to change the global state.

The second problem is an off-by-one error in the rtbitmap fsmap function
itself.  The fsmap record emitter function has the neat property that it
can detect gaps between the fsmap record we're about to emit and the
last one it emitted.  When this happens, it first emits an fsmap record
to fill the gap and then emits the one it was called about.

When the last block of the queried range is in use, we synthesize a
fsmap record just outside the query range, which has the effect of
emitting an "unknown owner" fsmap record for the inuse space.
Unfortunately, we don't range check the last block value, with the
result that the "unknown owner" fsmap can claim to extend beyond the end
of the rt volume!  So range check that.

The third problem is similar to the first: each fsmap backend is passed
the keys of the range to query and some scratch space.  The backend can
change anything it wants in the scratch space, but it's not supposed to
change the keys.  Unfortunately, range checking in the backend functions
/did/ change the keys, which causes subsequent backends to be called
with incorrect keys.  Fix this.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fsmap-fixes-5.15
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   14 ++++++-----
 fs/xfs/xfs_fsmap.c           |   52 ++++++++++++++++++++++++------------------
 fs/xfs/xfs_rtalloc.h         |    7 ++----
 3 files changed, 40 insertions(+), 33 deletions(-)

