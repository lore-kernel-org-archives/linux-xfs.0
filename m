Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A958FC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiL3XTs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:19:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583701D0C6;
        Fri, 30 Dec 2022 15:19:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E9D61C32;
        Fri, 30 Dec 2022 23:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53265C433D2;
        Fri, 30 Dec 2022 23:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442386;
        bh=allJqtUqh7DOdeavI8o1d+EZ6pIsbLqzNiS2/WwDfw4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aK0blZ2kvSDNKNHWmoPSk9lRKBivdf5JJFQAJ/JmffFeWmoKjTMN10IleolCVfh+A
         7862kE4D+SMvQHDI4FNTmjJQqgNv2PvGwkWlqq4RkZJw/TCDUBSQgmi5NNCWwWVUx5
         R/auy8z7c4OfjDRx/xeuOZtmw5vdTtfC6eKAAmyQTYaF3W/4muvUGDAq6GSqDpYdwJ
         0CICElc6F31gw8w74hMUcdcF+FwQt0zWHaMkg++pQndo4BpL7Khq3Gi3Wo1funGpJo
         Cf3Htqt/SjdR+kV9bPpS873um+uX3D4o7OyNmSAYg//QWmCrZJB6S3oQbkITL+KzfA
         C/Hgq9UV9YP8Q==
Subject: [PATCHSET v24.0 0/2] fstests: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879781.733381.1441585366549762189.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series employs atomic extent swapping to enable safe reconstruction
of directory data.  For now, XFS does not support reverse directory
links (aka parent pointers), so we can only salvage the dirents of a
directory and construct a new structure.

Directory repair therefore consists of five main parts:

First, we walk the existing directory to salvage as many entries as we
can, by adding them as new directory entries to the repair temp dir.

Second, we validate the parent pointer found in the directory.  If one
was not found, we scan the entire filesystem looking for a potential
parent.

Third, we use atomic extent swaps to exchange the entire data fork
between the two directories.

Fourth, we reap the old directory blocks as carefully as we can.

To wrap up the directory repair code, we need to add to the regular
filesystem the ability to free all the data fork blocks in a directory.
This does not change anything with normal directories, since they must
still unlink and shrink one entry at a time.  However, this will
facilitate freeing of partially-inactivated temporary directories during
log recovery.

The second half of this patchset implements repairs for the dotdot
entries of directories.  For now there is only rudimentary support for
this, because there are no directory parent pointers, so the best we can
do is scanning the filesystem and the VFS dcache for answers.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-dirs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-dirs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-dirs
---
 tests/xfs/815     |   37 +++++++++++++++++++++++++
 tests/xfs/815.out |    2 +
 tests/xfs/816     |   38 ++++++++++++++++++++++++++
 tests/xfs/816.out |    2 +
 tests/xfs/841     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |    3 ++
 6 files changed, 159 insertions(+)
 create mode 100755 tests/xfs/815
 create mode 100644 tests/xfs/815.out
 create mode 100755 tests/xfs/816
 create mode 100644 tests/xfs/816.out
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out

