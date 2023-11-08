Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A981EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 21:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjKHV3L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHV3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 16:29:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FE41BE2
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 13:29:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFF3C433C7;
        Wed,  8 Nov 2023 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699478948;
        bh=Sq/aYzPT6j+i7p6ITsCC14O95GyOxmkIEUJwxuTT67g=;
        h=Subject:From:To:Cc:Date:From;
        b=sHRrHcx6cfL7slhOKEZ55FwWPttRbgHCMemzWn8p/HeaEF9HxYhQlRtI8rAv2VDeI
         m0DBUwo9GcTsa+HWEF3UoWOQUpS18hXurMKj63GXyogBXuYtsZnsRVCOJJtwCp2Zid
         FZf9NpCFa8n8FYZx1YgMbLmMjGCqxNpWSDLqaztJX0Y/fNZshx61B4lpXdaI/sJjf1
         JZRLHvneK5JWc8eZc2ZyEwvHPmOOYy36DAmHgX7a4FJdgTZd8tgYg8NtGEGZgiZVBl
         xZk9b/dG+rT1RzEiVyXMVWzCHRoyTM12ogUhimUX0gKf8OXoBntXX7dDzaz6z8B84y
         b3NdNtuPIz6TQ==
Subject: [PATCHSET v3 0/2] fstests: reload entire iunlink lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     guan@eryu.me, david@fromorbit.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Date:   Wed, 08 Nov 2023 13:29:08 -0800
Message-ID: <169947894813.203694.3337426306300447087.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the second part of correcting XFS to reload the incore unlinked
inode list from the ondisk contents.  Whereas part one tackled failures
from regular filesystem calls, this part takes on the problem of needing
to reload the entire incore unlinked inode list on account of somebody
loading an inode that's in the /middle/ of an unlinked list.  This
happens during quotacheck, bulkstat, or even opening a file by handle.

In this case we don't know the length of the list that we're reloading,
so we don't want to create a new unbounded memory load while holding
resources locked.  Instead, we'll target UNTRUSTED iget calls to reload
the entire bucket.

Note that this changes the definition of the incore unlinked inode list
slightly -- i_prev_unlinked == 0 now means "not on the incore list".

v2: rebase to for-next, resend without changes
v3: add necessary prerequisites

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-iunlink-list

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-iunlink-list
---
 common/fuzzy       |    4 -
 common/rc          |   36 ++++++++-
 tests/xfs/1872     |  113 +++++++++++++++++++++++++++
 tests/xfs/1872.out |    5 +
 tests/xfs/1873     |  217 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1873.out |    6 +
 tests/xfs/329      |    4 -
 tests/xfs/434      |    2 
 tests/xfs/435      |    2 
 tests/xfs/436      |    2 
 tests/xfs/444      |    2 
 tests/xfs/516      |    2 
 12 files changed, 385 insertions(+), 10 deletions(-)
 create mode 100755 tests/xfs/1872
 create mode 100644 tests/xfs/1872.out
 create mode 100755 tests/xfs/1873
 create mode 100644 tests/xfs/1873.out

