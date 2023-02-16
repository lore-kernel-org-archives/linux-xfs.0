Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65345C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBPU1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPU1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:27:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C964139BBC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:27:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F2ABB82992
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4727BC433D2;
        Thu, 16 Feb 2023 20:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579232;
        bh=btBCrGhgHeRX/IWwlD6vf9f/gYQ5MDCh8JpKcjxftnA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=t1XRXk4it0RivoZdACvGXdvnKbEZjsNX5X1MnxNMAWAIHcI0ZCLAknF6Rc6NNB9uU
         +9Ef6CJ6Nrv7xytbIPYdTIRYF15WnQEI6pNvY8OmsM+tjhU5swqmkIAhGUGZ0w6BnS
         jiAQIUYotcl/2EGB7Js9TcGHxi64QsbxoTGlM0iGlP8uIZUA0zQuJ+kgD0ucpjOYl1
         Wbl6Xts35Kqm8HT0cgg9w/EOWyuMU+PhD6tqd9wfXBD6qfIPoYO4VOwR4S9vPhLIj3
         gGy6o5TIGueHGzJyFOEcTVPzkkHkw1yrUxZKsuOEspH7wIQyo049sFnry/8URngffz
         v04uEbDDl4U9g==
Date:   Thu, 16 Feb 2023 12:27:11 -0800
Subject: [PATCHSET v9r2d1 00/23] xfs: online fsck support patches
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873813.3474338.3118516275923112371.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are all the patches that I needed to backport from the online fsck
patchset to start writing online fsck for parent pointers and
directories.

IOWS, we're blatantly copying things from the online repair part 1
megaseries; this is what online repair part 2 requires.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-fsck-backports

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-fsck-backports
---
 fs/xfs/Kconfig                 |   38 +++
 fs/xfs/Makefile                |   11 +
 fs/xfs/libxfs/xfs_dir2.c       |    6 
 fs/xfs/libxfs/xfs_dir2.h       |    1 
 fs/xfs/scrub/agheader_repair.c |   99 +++++---
 fs/xfs/scrub/bitmap.c          |  389 ++++++++++++++++++++------------
 fs/xfs/scrub/bitmap.h          |   35 ++-
 fs/xfs/scrub/bmap.c            |    6 
 fs/xfs/scrub/common.c          |  133 ++++++++---
 fs/xfs/scrub/common.h          |   10 +
 fs/xfs/scrub/dir.c             |  233 ++++++-------------
 fs/xfs/scrub/inode.c           |    6 
 fs/xfs/scrub/iscan.c           |  483 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h           |   65 +++++
 fs/xfs/scrub/listxattr.c       |  314 ++++++++++++++++++++++++++
 fs/xfs/scrub/listxattr.h       |   17 +
 fs/xfs/scrub/parent.c          |  290 ++++++++++--------------
 fs/xfs/scrub/quota.c           |    9 -
 fs/xfs/scrub/readdir.c         |  375 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/readdir.h         |   19 ++
 fs/xfs/scrub/repair.c          |  102 +++++---
 fs/xfs/scrub/rtbitmap.c        |   11 -
 fs/xfs/scrub/scrub.c           |   23 ++
 fs/xfs/scrub/scrub.h           |    7 +
 fs/xfs/scrub/tempfile.c        |  243 ++++++++++++++++++++
 fs/xfs/scrub/tempfile.h        |   29 ++
 fs/xfs/scrub/trace.c           |    5 
 fs/xfs/scrub/trace.h           |  272 +++++++++++++++++++++++
 fs/xfs/scrub/xfarray.c         |  394 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfarray.h         |   60 +++++
 fs/xfs/scrub/xfblob.c          |  176 +++++++++++++++
 fs/xfs/scrub/xfblob.h          |   27 ++
 fs/xfs/scrub/xfile.c           |  329 +++++++++++++++++++++++++++
 fs/xfs/scrub/xfile.h           |   60 +++++
 fs/xfs/xfs_buf.c               |    5 
 fs/xfs/xfs_buf.h               |   10 +
 fs/xfs/xfs_export.c            |    2 
 fs/xfs/xfs_hooks.c             |   94 ++++++++
 fs/xfs/xfs_hooks.h             |   72 ++++++
 fs/xfs/xfs_icache.c            |    3 
 fs/xfs/xfs_icache.h            |   11 +
 fs/xfs/xfs_inode.c             |  229 +++++++++++++++++++
 fs/xfs/xfs_inode.h             |   37 +++
 fs/xfs/xfs_itable.c            |    8 +
 fs/xfs/xfs_linux.h             |    1 
 fs/xfs/xfs_mount.h             |    2 
 fs/xfs/xfs_super.c             |    2 
 fs/xfs/xfs_symlink.c           |    1 
 48 files changed, 4112 insertions(+), 642 deletions(-)
 create mode 100644 fs/xfs/scrub/iscan.c
 create mode 100644 fs/xfs/scrub/iscan.h
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h
 create mode 100644 fs/xfs/scrub/readdir.c
 create mode 100644 fs/xfs/scrub/readdir.h
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h
 create mode 100644 fs/xfs/scrub/xfarray.c
 create mode 100644 fs/xfs/scrub/xfarray.h
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h
 create mode 100644 fs/xfs/scrub/xfile.c
 create mode 100644 fs/xfs/scrub/xfile.h
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h

