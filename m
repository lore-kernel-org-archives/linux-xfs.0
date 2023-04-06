Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA85C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjDFAJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjDFAJm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:09:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE56E61AE
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CE9762B09
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC66CC433D2;
        Thu,  6 Apr 2023 00:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739773;
        bh=ANfXlCyk4qjr8ztMPcG2sWkLfVHgpfKohc6VhCK7i0g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gRVeRrRnPJrjlUx740GLpo9fzj2QWNehs0Hk7iEhqd/01RMK0DRQJq4cAkH0LQzFS
         P78xwSWOD4AW4G0M/sEsNJmiOx8BLQg7PIkyFIYjlVH1UsvScxUyULDvjpNKpqMAUH
         qUJ7SC2Q0rIwFHe6rJS6pNgBXcGUfAkyL+9xYAPEx8wxkCaZ2dIAaWiiRWaYIR0NcV
         UhVXAwxK73+cinUNYQ+X7FPNyk4tdx/6j9FmM/jViNyaIJQ4o3d2qkB2pah6KISKQm
         wbK3LqmkXbZf4meRprHgzD957Z9UmOrnGbV/bXzfxGo17k0Ys1XDvP1c2qcvoy414o
         ektmT2PTF9bQw==
Subject: [PATCHSET v2 0/6] xfsprogs: fix ascii-ci problems, then kill it
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:09:33 -0700
Message-ID: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
In-Reply-To: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
References: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
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
function by encoding the name transformation function in libxfs, add it
to the selftest, and fix all the userspace tools, none of which handle
this transformation correctly.

The v1 series generated a /lot/ of discussion, in which several things
became very clear: (1) Linus is not enamored of case folding of any
kind; (2) Dave and Christoph don't seem to agree on whether the feature
is supposed to work for 7-bit ascii or latin1; (3) it trashes UTF8
encoded names if those happen to show up; and (4) I don't want to
maintain this mess any longer than I have to.  Kill it in 2030.

v2: rename the functions to make it clear we're moving away from the
letters t, o, l, o, w, e, and r; and deprecate the whole feature once
we've fixed the bugs and added tests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-asciici-bugs-6.3

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fix-asciici-bugs-6.3
---
 db/metadump.c            |   79 +++++++++++++++--
 libfrog/dahashselftest.h |  208 ++++++++++++++++++++++++----------------------
 libxfs/libxfs_api_defs.h |    2 
 libxfs/xfs_dir2.c        |    4 -
 libxfs/xfs_dir2.h        |   31 +++++++
 man/man8/mkfs.xfs.8.in   |   23 ++++-
 mkfs/xfs_mkfs.c          |   11 ++
 7 files changed, 243 insertions(+), 115 deletions(-)

