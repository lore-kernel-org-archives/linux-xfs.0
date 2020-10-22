Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DE9C388F9
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 22:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480EF24650
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 22:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603405441;
	bh=GEmg9HIaeQ5bKfcJYYGD6ds4B2O3J6S3lkr6Gq69238=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=ZTfoiOxJq6jlMtc09+BEDeh3/obUNiysKTaJEHDdQAetiI60nrMurOPP9qGddLy/R
	 MdZGad3fQgr1knIbnYOGCFzw8gZVcsKRwNNIdxQEU7AL6T452RWwIa2Fo9L0JlvsGu
	 Q5C/jik6xgpWcZsE5ktUt9X5qThcD+TGJbUytaN8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369618AbgJVWYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 18:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S369610AbgJVWYA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Oct 2020 18:24:00 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C8F24631;
        Thu, 22 Oct 2020 22:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603405439;
        bh=GEmg9HIaeQ5bKfcJYYGD6ds4B2O3J6S3lkr6Gq69238=;
        h=Date:From:To:Cc:Subject:From;
        b=lAefka8i/isTAxOCCGr+hmtfTRZDgtMeSX0JEE3RLqrEsPURrRh4ZCPwzb6T6HHkD
         n9K/SKWgckh+MEZQJEzsJRK51uLxc1baC56YPLobDDt0ujf2n66GoWwX3E4xFpPYXg
         ZELdMIwwVEwa2fkYGMbaPR9EIJ4wRnmcnnc1k+eg=
Date:   Thu, 22 Oct 2020 15:23:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] vfs: move the clone/dedupe/remap helpers to a single file
Message-ID: <20201022222358.GD9825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this small refactoring series that moves all the support
functions for file range remapping (aka reflink and dedupe) out of
mm/filemap.c and fs/read_write.c and into fs/remap_range.c.

It's been a full week since the initial discussion[1] on fsdevel, and in
that time, nobody has complained about breakage in for-next, and the
relevant parts of the codebase haven't changed significantly.  I was
expecting to have to rebase this branch, but aside from the trivial
merge conflict in fs/Makefile this actually still applies cleanly atop
master as of a couple hours ago.

(FWIW I took your suggestion about license headers and didn't drag the
copyright notices along from the other two files.)

So, I tagged my work branch from last week a little while ago and am now
sending this for consideration.  Please let me know if you have any
complaints about pulling this, since I can rework the branch.

--D

[1] https://lore.kernel.org/linux-fsdevel/160272187483.913987.4254237066433242737.stgit@magnolia/

The following changes since commit bbf5c979011a099af5dc76498918ed7df445635b:

  Linux 5.9 (2020-10-11 14:15:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.10-merge-1

for you to fetch changes up to 407e9c63ee571f44a2dfb0828fc30daa02abb6dc:

  vfs: move the generic write and copy checks out of mm (2020-10-15 09:50:01 -0700)

----------------------------------------------------------------
Refactored code for 5.10:
- Move the file range remap generic functions out of mm/filemap.c and
fs/read_write.c and into fs/remap_range.c to reduce clutter in the first
two files.

----------------------------------------------------------------
Darrick J. Wong (3):
      vfs: move generic_remap_checks out of mm
      vfs: move the remap range helpers to remap_range.c
      vfs: move the generic write and copy checks out of mm

 fs/Makefile        |   3 +-
 fs/read_write.c    | 562 +++++++++++-----------------------------------------
 fs/remap_range.c   | 571 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   8 +-
 mm/filemap.c       | 222 ---------------------
 5 files changed, 691 insertions(+), 675 deletions(-)
 create mode 100644 fs/remap_range.c
