Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA5BCD611E
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377773AbjJISTB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377544AbjJISTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:19:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51639C;
        Mon,  9 Oct 2023 11:18:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE52C433C8;
        Mon,  9 Oct 2023 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875538;
        bh=QQi37pzKn2DJ0q6IjY+7UyEpGneHtPEjfmf9xjg1zb8=;
        h=Subject:From:To:Cc:Date:From;
        b=rQLknOztsRxy/hpvZ6dk2byxebhpauaZYp5CdyXu1lPTJXWtENWFB7RSsGf7V35mA
         5jGjRI1F+1XrcWC2aqXlYysd44o48SCQN1qUdZ9dE49xv+US+W5/ejTnO6pXiyZlT9
         3CxUJ2SoAnKiAKiX6/5V0AEj2AZAgjpracR35E7zJOmud9kh5lrHYgPrh54malPFIB
         nCU47fLD2L96k9r0Dr/DgPUcB19PUPYKSmweFt1hZgaDM9p5bqG4KRulre1cnFdnvT
         4apdsu29ah+Lx5it9l1iAnML+VmEgNM8mXgcxkDWl8QnEvs+nVSZashNXwjnDAxv1G
         t8kUPvbKNWn+Q==
Subject: [PATCHSET v3 0/1] fstests: fix unshare data corruption bug
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        ritesh.list@gmail.com, willy@infradead.org
Date:   Mon, 09 Oct 2023 11:18:58 -0700
Message-ID: <169687553806.3949152.10461541168914314461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I rebased djwong-dev atop 6.6-rc1, and discovered that the iomap unshare
code writes garbage into the unshared file if the unshared range covers
at least one base page's worth of file range and there weren't any
folios in the pagecache for that region.

The root cause is an optimization applied to __iomap_write_begin for 6.6
that caused it to ignore !uptodate folios.  This is fine for the
write/zeroing cases since they're going to write to the folio anyway,
but unshare merely marks the folio dirty and lets writeback handle the
unsharing.

While I was rooting around in there, I also noticed that the unshare
operation wasn't ported to use large folios.  This leads to suboptimal
performance if userspace funshares a file and continues using the page
cache, since the cache is now using base pages.

v2: reduce redundant variable access
v3: add rvb tags

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=iomap-fix-unshare

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=iomap-fix-unshare
---
 tests/xfs/1936     |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1936.out |    4 ++
 2 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/1936
 create mode 100644 tests/xfs/1936.out

