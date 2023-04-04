Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E54C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 17:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbjDDRHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 13:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbjDDRHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 13:07:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4658F4C06
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 10:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F8E6304E
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 17:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAB6C433D2;
        Tue,  4 Apr 2023 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680628021;
        bh=GtFfnA0+Ipg9E/PH8n+CB0YcP5yMYqWSGkNZPeBVmj0=;
        h=Subject:From:To:Cc:Date:From;
        b=HRZE7wVM6OxgSV84nDhimt5zljwcQxPuh6SHQaLZZfjigJPuuQg07pAYdXwDK8kQX
         2JsWCNlLCTpGLcdA1fvIuiWDtgGpffeVieGFyW2Rqxq5GNx2IxlSIyQ31zuv97ARCF
         d6efvKzEqoz6sEd3L2tVacxBg4RXQuWhRrnhAgxQnJZ33QsCGD+QTY5SNLTZHgOU0v
         6KgWg3bVVmuN3EhWojiDYep6vcR7m21g+EgbyGKUy6cQdHQVpxXety6GWAm1CDk+ug
         TC+D5juksCMnf+cE46gOX+GsRChET9MaQLvFkXv5VTBXpkPkdzIXEXcOSCuGnkaOqW
         vj5BY6zWpMubg==
Subject: [PATCHSET 0/3] xfs: fix ascii-ci problems with userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     torvalds@linux-foundation.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 04 Apr 2023 10:07:00 -0700
Message-ID: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Last week, I was fiddling around with the metadump name obfuscation code
while writing a debugger command to generate directories full of names
that all have the same hash name.  I had a few questions about how well
all that worked with ascii-ci mode, and discovered a nasty discrepancy
between the kernel and glibc's implementations of the tolower()
function.

I discovered that I could create a directory that is large enough to
require separate leaf index blocks.  The hashes stored in the dabtree
use the ascii-ci specific hash function, which uses a library function
to convert the name to lowercase before hashing.  If the kernel and C
library's versions of tolower do not behave exactly identically,
xfs_ascii_ci_hashname will not produce the same results for the same
inputs.  xfs_repair will deem the leaf information corrupt and rebuild
the directory.  After that, lookups in the kernel will fail because the
hash index doesn't work.

The kernel's tolower function will convert extended ascii uppercase
letters (e.g. A-with-umlaut) to extended ascii lowercase letters (e.g.
a-with-umlaut), whereas glibc's will only do that if you force LANG to
ascii.  Tiny embedded libc implementations just plain won't do it at
all, and the result is a mess.  Stabilize the behavior of the hash
function by encoding the kernel's tolower function in libxfs, add it to
the selftest, and fix xfs_scrub not handling this correctly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-asciici-tolower-6.3
---
 fs/xfs/libxfs/xfs_dir2.c |    4 -
 fs/xfs/libxfs/xfs_dir2.h |   20 ++++
 fs/xfs/scrub/dir.c       |    7 +-
 fs/xfs/xfs_dahash_test.c |  211 ++++++++++++++++++++++++----------------------
 4 files changed, 139 insertions(+), 103 deletions(-)

