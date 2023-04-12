Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB35C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDLDuU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDLDuS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678FF40C1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02D6762D89
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B835C433D2;
        Wed, 12 Apr 2023 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271416;
        bh=HVD7RK79pZ3fAGWRmAXOZEsi1ZPbB7HRN8nEYVoB600=;
        h=Date:Subject:From:To:Cc:From;
        b=aeYIl9VOMj3xK5XKQYsUTwOFayI+X62UxDNYdzNzK4RZzFYIrbiVSAtTAAAFS3/ni
         7m6L/qJhBVYdJkhV6heFVDGoaRJdrazGYpxGtTVoKDrnZXALOwOdwftjq2pqW0OSBh
         VDsrxRMLfIUIqcBfqDF5iIql4WLjXsMCBj43FAAxE4b4wgog12ELJZlHOehg+HF30F
         NGuaIEiSPOUJfzEzGb6D0jCJgICQZ220tTIVtU9r5vXjlF0PTSxBabb8QSwJnwM/uy
         Zy61mx5G4ya1O78aK3H8Z+i/9R3oLjKX6isU7lledJgEaXqetEpI3DBas7WIcc6Zwr
         5YOefHBjPzcTA==
Date:   Tue, 11 Apr 2023 20:50:15 -0700
Subject: [GIT PULL 21/22] xfs: fix ascii-ci problems, then kill it
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     david@fromorbit.com, hch@infradead.org, hch@lst.de,
        linux-xfs@vger.kernel.org
Message-ID: <168127095745.417736.210471032478306085.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4f5e304248ab4939e9aef58244041c194f01f0b5:

xfs: cross-reference rmap records with refcount btrees (2023-04-11 19:00:39 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-asciici-bugs-6.4_2023-04-11

for you to fetch changes up to 7ba83850ca2691865713b307ed001bde5fddb084:

xfs: deprecate the ascii-ci feature (2023-04-11 19:05:19 -0700)

----------------------------------------------------------------
xfs: fix ascii-ci problems, then kill it [v2]

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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation
xfs: test the ascii case-insensitive hash
xfs: deprecate the ascii-ci feature

Documentation/admin-guide/xfs.rst |   1 +
fs/xfs/Kconfig                    |  27 +++++
fs/xfs/libxfs/xfs_dir2.c          |   5 +-
fs/xfs/libxfs/xfs_dir2.h          |  31 ++++++
fs/xfs/xfs_dahash_test.c          | 211 ++++++++++++++++++++------------------
fs/xfs/xfs_super.c                |  13 +++
6 files changed, 186 insertions(+), 102 deletions(-)

