Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2002C61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 04:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjBVEgj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Feb 2023 23:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjBVEgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2023 23:36:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DA830B2F
        for <linux-xfs@vger.kernel.org>; Tue, 21 Feb 2023 20:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ECF9B811D3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 04:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC358C433EF;
        Wed, 22 Feb 2023 04:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677040594;
        bh=ABmKeLUkMhABo9Qddty8vZKTNHjVzeamJuHgExrr9Ig=;
        h=Date:From:To:Cc:Subject:From;
        b=AMPW4MpzvuLcwQ78+IlC0gJ2hNWrl6xokGbuPHGJoj8jXpibuhvssB2PBKe5aP7H2
         MD+89FQZM+9ZJrMlvQEpzkDqBoNFrl9R6ws1RTq86txadyZwqpCJ2uG0K/h8AYo2i1
         bb6yqbdnu5aOu6MQcPQYaM9cslAIGIIJojnDcRqBUhhcHRM8JsXgppOhSrLLQp5tRX
         HzoFcCLICN2/CnR+sydoIkv8Qc+a+U5MZTdLcy6nHXby9Z5jVUY7LwcJx60HVmYHV/
         qHAZ+qo4ZiGmdtQ+DAOFql5/62T06u5BQcTw8fHkFWO7D5VTGgB9Pn5sU6Da5YfStW
         fo7+mKgx3XkLg==
Date:   Tue, 21 Feb 2023 20:36:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     dchinner@redhat.com, ddouwsma@redhat.com,
        linux-xfs@vger.kernel.org, linux@weissschuh.net,
        syzbot+898115bc6d7140437215@syzkaller.appspotmail.com,
        xu.panda@zte.com.cn, yang.yang29@zte.com.cn
Subject: [GIT PULL] xfs: new code for 6.3, part 1
Message-ID: <167703988328.1924095.8788731347369739159.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for xfs for 6.3-rc1.  For this
first pr there's a couple of bug fixes, some cleanups for inconsistent
variable names and reduction of struct boxing and unboxing in the
logging code.  The real fun is coming in a pull request next week, which
will begin reworking allocation group lifetimes and finally replace
confusing indirect calls to the allocator with actual ... function
calls.  I want to let that part experience another week of testing.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6d796c50f84ca79f1722bb131799e5a5710c4700:

Linux 6.2-rc6 (2023-01-29 13:59:43 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-merge-2

for you to fetch changes up to dd07bb8b6baf2389caff221f043d9188ce6bab8c:

xfs: revert commit 8954c44ff477 (2023-02-10 09:06:06 -0800)

----------------------------------------------------------------
New code for 6.3-rc1:

* Eliminate repeated boxing and unboxing of log item parameters.
* Clean up some confusing variable names in the log item code.
* Fix a deadlock when doing unwritten extent conversion that causes a
bmbt split when there are sustained memory shortages and the worker
pool runs out of worker threads.
* Fix the panic_mask debug knob not being able to trigger on verifier
errors.
* Constify kobj_type objects.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
xfs: pass the xfs_bmbt_irec directly through the log intent code
xfs: fix confusing variable names in xfs_bmap_item.c
xfs: pass xfs_extent_free_item directly through the log intent code
xfs: fix confusing xfs_extent_item variable names
xfs: pass rmap space mapping directly through the log intent code
xfs: fix confusing variable names in xfs_rmap_item.c
xfs: pass refcount intent directly through the log intent code
xfs: fix confusing variable names in xfs_refcount_item.c
xfs: revert commit 8954c44ff477

Dave Chinner (1):
xfs: don't use BMBT btree split workers for IO completion

Donald Douwsma (1):
xfs: allow setting full range of panic tags

Thomas Weiﬂschuh (1):
xfs: make kobj_type structures constant

Xu Panda (1):
xfs: use strscpy() to instead of strncpy()

Documentation/admin-guide/xfs.rst |   2 +-
fs/xfs/libxfs/xfs_alloc.c         |  32 ++++-----
fs/xfs/libxfs/xfs_bmap.c          |  32 ++++-----
fs/xfs/libxfs/xfs_bmap.h          |   5 +-
fs/xfs/libxfs/xfs_btree.c         |  18 ++++-
fs/xfs/libxfs/xfs_refcount.c      |  96 ++++++++++++--------------
fs/xfs/libxfs/xfs_refcount.h      |   4 +-
fs/xfs/libxfs/xfs_rmap.c          |  52 +++++++-------
fs/xfs/libxfs/xfs_rmap.h          |   6 +-
fs/xfs/xfs_bmap_item.c            | 137 ++++++++++++++++--------------------
fs/xfs/xfs_error.c                |   2 +-
fs/xfs/xfs_error.h                |  12 +++-
fs/xfs/xfs_extfree_item.c         |  99 +++++++++++++-------------
fs/xfs/xfs_globals.c              |   3 +-
fs/xfs/xfs_refcount_item.c        | 110 ++++++++++++++---------------
fs/xfs/xfs_rmap_item.c            | 142 ++++++++++++++++++--------------------
fs/xfs/xfs_sysfs.c                |  12 ++--
fs/xfs/xfs_sysfs.h                |  10 +--
fs/xfs/xfs_trace.h                |  15 ++--
19 files changed, 377 insertions(+), 412 deletions(-)
