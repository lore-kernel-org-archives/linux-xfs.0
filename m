Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F4CC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 20:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiJZUH6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiJZUHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 16:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE8212FF9B
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B9366209E
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 20:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B31AC433C1;
        Wed, 26 Oct 2022 20:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666814853;
        bh=MobDQ/x0PowD2IHYsdvqQPjISiqVY9Jgek59gYh7cvs=;
        h=Subject:From:To:Cc:Date:From;
        b=uCiLx7CIYDlQyqCcT0zC8+4FLvcMUNsL5d+HxHwVOh3pDSAXOljg/amGQs06YYGf9
         qGpDH5pz9MCi8L9RUMsQCjuSBb4GIoYiiMuFm3ZsdoVZGQrD6FsRJjPOLjX9vsbWGQ
         UWv2Vc+HnxLrsjfpCDj850saBa7fJQDcP9Vt0z4tzWo4/7LI4kz0+GdksUZ1PkbEmY
         f6XvKOAbhDDTdNy+3BwR/DIghJtk66BQ0R7jtMoKL8W4JVbZl8ZJr3TWTso44CYvQZ
         JhoULiwzirX1fy9vA0ovf1v2Ka+cT7jSwKOtKxa0kX/1bSdUB2oXRedpzo1Ks7vkOE
         sUqCYnrgyaHOA==
Subject: [PATCHSET v2 0/8] xfs: fix various problems with log intent item
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Wed, 26 Oct 2022 13:07:32 -0700
Message-ID: <166681485271.3447519.6520343630713202644.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Starting with 6.1-rc1, CONFIG_FORTIFY_SOURCE checks became smart enough
to detect memcpy() callers that copy beyond what seems to be the end of
a struct.  Unfortunately, gcc has a bug wherein it cannot reliably
compute the size of a struct containing another struct containing a flex
array at the end.  This is the case with the xfs log item format
structures, which means that -rc1 starts complaining all over the place.

Fix these problems by memcpying the struct head and the flex arrays
separately.  Although it's tempting to use the FLEX_ARRAY macros, the
structs involved are part of the ondisk log format.  Some day we're
going to want to make the ondisk log contents endian-safe, which means
that we will have to stop using memcpy entirely.

While we're at it, fix some deficiencies in the validation of recovered
log intent items -- if the size of the recovery buffer is not even large
enough to cover the flex array record count in the head, we should abort
the recovery of that item immediately.

The last patch of this series changes the EFI/EFD sizeof functions names
and behaviors to be consistent with the similarly named sizeof helpers
for other log intent items.

v2: fix more inadequate log intent done recovery validation and dump
    corrupt recovered items

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-log-recovery-misuse-6.1
---
 fs/xfs/libxfs/xfs_log_format.h |   60 +++++++++++++++++++++++---
 fs/xfs/xfs_attr_item.c         |   65 +++++++++++++---------------
 fs/xfs/xfs_bmap_item.c         |   54 ++++++++++++-----------
 fs/xfs/xfs_extfree_item.c      |   94 +++++++++++++++++++---------------------
 fs/xfs/xfs_extfree_item.h      |   16 +++++++
 fs/xfs/xfs_ondisk.h            |   23 ++++++++--
 fs/xfs/xfs_refcount_item.c     |   57 +++++++++++++-----------
 fs/xfs/xfs_rmap_item.c         |   70 ++++++++++++++++--------------
 fs/xfs/xfs_super.c             |   12 ++---
 9 files changed, 264 insertions(+), 187 deletions(-)

