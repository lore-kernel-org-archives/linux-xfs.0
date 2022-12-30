Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B163C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiL3XHt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiL3XHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:07:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4221D0EC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48A7EB81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F03C433D2;
        Fri, 30 Dec 2022 23:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441664;
        bh=kWx6cjvqEr3M+cXmQE2ElQKGW3TAzku3ud0czOcKqSc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rc/QB4QZnk6LJzCvOsVeKxdCGPhtlPiuuT/fZDI5m6cYopHh4GBLzJNOzZmXgHRjp
         5CtdwI3k/BFujOcJ5lbXDrLor+mpHVJ51wTeA2ZgXdOmkJISv+xqU6nm0dtQG8xOTP
         vnQ2elWUM4Y/+6P6dj26wFKDGb2+jrF9bHS+LJbvabordF9Sf51BSgNj/kfYrX9XjF
         TpvEL1wSDc4ltl5oMiRETm/tmokY/xmUl43G2lnmj1/fWc0PqiCAE7SOoxNtwd+WnW
         +4ooWivrFtwSGbgEqCid6jHG+y+k54A8mNDFSn9z+EuZ2AFtADHIRGpuPC5XzXUmoR
         IxKX4zVPYSX4w==
Subject: [PATCHSET v24.0 0/3] xfs: move orphan files to lost and found
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:19 -0800
Message-ID: <167243845965.700780.5558696077743355523.stgit@magnolia>
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

Orphaned files are defined to be files with nonzero ondisk link count
but no observable parent directory.  This series enables online repair
to reparent orphaned files into the filesystem directory tree, and wires
up this reparenting ability into the directory, file link count, and
parent pointer repair functions.  This is how we fix files with positive
link count that are not reachable through the directory tree.

This patch will also create the orphanage directory (lost+found) if it
is not present.  In contrast to xfs_repair, we follow e2fsck in creating
the lost+found without group or other-owner access to avoid accidental
disclosure of files that were previously hidden by an 0700 directory.
That's silly security, but people have been known to do it.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-orphanage
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir_repair.c    |  101 ++++++++
 fs/xfs/scrub/nlinks.c        |   11 +
 fs/xfs/scrub/nlinks.h        |    6 +
 fs/xfs/scrub/nlinks_repair.c |  250 ++++++++++++++++++++-
 fs/xfs/scrub/orphanage.c     |  504 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.h     |   79 +++++++
 fs/xfs/scrub/parent.c        |   10 +
 fs/xfs/scrub/parent_repair.c |   92 ++++++++
 fs/xfs/scrub/repair.h        |    4 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/scrub.h         |    4 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   59 +++++
 fs/xfs/xfs_inode.c           |    6 -
 fs/xfs/xfs_inode.h           |    1 
 16 files changed, 1119 insertions(+), 12 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h

