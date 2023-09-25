Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDECCE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjIYV7r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjIYV7r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DA3AF
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518C0C433C7;
        Mon, 25 Sep 2023 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679180;
        bh=zNsBTV1CfMoxDOCW3NvnnO+3jHU/F5OQj7QDVnyB6PQ=;
        h=Subject:From:To:Cc:Date:From;
        b=dHhIaLk+y0r6I4nznuwARAOkAp936M1v+H4Y+hLOcJDOUua8I/e+gaFIrkucsEiEB
         IojomfyMi0OY9zHnJqJWwU7w11FgOTAJwbRVDWUl90oCTp94vt8ttV1Q2C2bRKKphI
         9xsOV5tTrxUtx+1bbRBPW5qADt8NtchGUM4lYnpONaY3BJZ9jSZq0Mh7qlv3Y0ghMP
         6C8hE4aM1dfmEspnfBkburbie1TZa1IE1d5tk1BbpzKRhTvl17E4qGKyNE0A5uTYAb
         sXzDPuG5k2jlbEgTyY42h1ist66JqiMt8txZLshmx94zxWpdcCAWiei2G1f+P6jqJv
         enTAkCXyVSoMQ==
Subject: [PATCHSET 0/2] xfsprogs: reload the last iunlink item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:39 -0700
Message-ID: <169567917992.2320475.10415003566794205537.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

It turns out that there are some serious bugs in how xfs handles the
unlinked inode lists.  Way back before 4.14, there was a bug where a ro
mount of a dirty filesystem would recover the log bug neglect to purge
the unlinked list.  This leads to clean unmounted filesystems with
unlinked inodes.  Starting around 5.15, we also converted the codebase
to maintain a doubly-linked incore unlinked list.  However, we never
provided the ability to load the incore list from disk.  If someone
tries to allocate an O_TMPFILE file on a clean fs with a pre-existing
unlinked list or even deletes a file, the code will fail and the fs
shuts down.

This first part of the correction effort adds the ability to load the
first inode in the bucket when unlinking a file; and to load the next
inode in the list when inactivating (freeing) an inode.

In userspace, we'll add a xfs_db command to create unlinked inodes on a
(presumably) clean filesystem so that we can finally write some
regression and functional testing of iunlink recovery to ensure that
this all works properly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-iunlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fix-iunlink
---
 db/Makefile              |    2 
 db/command.c             |    1 
 db/command.h             |    1 
 db/iunlink.c             |  400 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    2 
 man/man8/xfs_db.8        |   30 +++
 6 files changed, 435 insertions(+), 1 deletion(-)
 create mode 100644 db/iunlink.c

