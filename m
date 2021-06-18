Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFEDC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E894B613ED
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhFRS4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 14:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhFRS4E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 14:56:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FAD561209;
        Fri, 18 Jun 2021 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624042434;
        bh=uowq1hHzpLMo6GcPsoLy3wznbnVSVA7BdOlhfvDl+yw=;
        h=Subject:From:To:Cc:Date:From;
        b=PzyHiZ76cpyzOCkxZKT3s/kaFSsWZ2mYuXOjt44FQBCETfaBztIyolrUqCWvc+XcR
         UfHRb8T1RcpIUQbNepU8Wdd96gWnu2yWTijbJgdq4ft361aujBopIV6s+ZQ9sL1jVW
         gj0AHGlGRJQ2CbzZ+TKmNGpJrKSUSPZMTFSjY/r/bgpFr3LKdamUJcM7F++l3BEHQo
         yhhPz0vZl0m0KpiaTS2kS0iKBF4LZQdXGXk0HoFlmX7GV1CnEFNfgn+Ra8IrvKU7VG
         9P/fA+JKBHIKRdqmVdwJGZlmtO+kW72m2vJi7tWn2pknmMaDOknf2Np/ukETLyKvIO
         /hj1eCZvm7ufQ==
Subject: [PATCHSET v2 0/3] xfs: various small fixes and cleanups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, chandanrlinux@gmail.com, bfoster@redhat.com
Date:   Fri, 18 Jun 2021 11:53:53 -0700
Message-ID: <162404243382.2377241.18273624393083430320.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I found a couple of small things that looked like they needed cleaning
while debugging other problems in my development tree.

v2: more cleanups for shutdown messaging

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.14
---
 fs/xfs/xfs_fsops.c  |   16 ++++++++--------
 fs/xfs/xfs_icache.c |    8 ++++----
 fs/xfs/xfs_icache.h |    6 +++---
 fs/xfs/xfs_trace.h  |    4 ++--
 4 files changed, 17 insertions(+), 17 deletions(-)

