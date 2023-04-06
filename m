Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEF0C7619A
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjDFAEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjDFAEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:04:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E010C7AA0
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD6F664230
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A35DC433D2;
        Thu,  6 Apr 2023 00:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739374;
        bh=yj12B8O/0fRMGgy53F7lOAYt0cmsD2ElPQxs+3JwGRQ=;
        h=Subject:From:To:Cc:Date:From;
        b=YfsaxHsJASNJUNTwoETDB0oZKq0tOa8lJ51rdfalZ5x+5CqAs8uizgs8G16frxz9d
         jUHWS+DKS5/u1InLufMagrsIzCp/hULBniHPpih8fSxtTSmzGx9Jy6Z1rsC0VzGZRQ
         t/zTKdojNHN25m+kc4cM5zPRf1Jvc6NnPlP42oBM+S8EkzPQqWO1KMNo4DvHatSIdR
         Wt/sAbDU6F8rT/TsajmyduGsCkBjLAlw+FJ8zte/bi6Vg6/0bo7MLtwbmpkAh6BNN8
         4Xml37oUSYc10pAKH6UDwqFkzY++LODP3Tl6G0lzvXseCenGwUTsry82XSNnuUA4Uw
         B78aw8fNGxdMw==
Subject: [PATCHSET v2 0/4] xfs: fix ascii-ci problems, then kill it
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:02:53 -0700
Message-ID: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
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

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-asciici-bugs-6.3
---
 Documentation/admin-guide/xfs.rst |    1 
 fs/xfs/Kconfig                    |   27 +++++
 fs/xfs/libxfs/xfs_dir2.c          |    4 -
 fs/xfs/libxfs/xfs_dir2.h          |   31 +++++
 fs/xfs/scrub/dir.c                |    7 +
 fs/xfs/xfs_dahash_test.c          |  211 +++++++++++++++++++------------------
 fs/xfs/xfs_super.c                |   13 ++
 7 files changed, 191 insertions(+), 103 deletions(-)

