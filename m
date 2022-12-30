Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16172C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiL3XKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:10:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CBE2DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:10:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3184361AF3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCBBC433D2;
        Fri, 30 Dec 2022 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441805;
        bh=+66/QNvlc2iOXciKfVjd5WHCU+ojXaQJEB7MLafI+xY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CW6QOdZwz8tD211A8wmDhi9YjAm67XWyisGMs74qkmXPIhmY6NAaH0wA0mK8uxSTQ
         tEggye6rWa47t7KNU6qZLgRykKfDfQkTzJbuZTFqjh7tl71iQs5X3PLfy8ismv4Tdn
         PrgPoyEu7wSSjUxpQowMw9CwD622DQtMiltCw6FerumrzFlmY2LhRqvEx2ztHSwvyr
         RDkIqd0Y5VJfV0Q4kB1ss8H4BbgY9F07+zduwvRoOpIkkIOkJGOV1gAdQ4uRdAVJCV
         Imilrgd+/KEnJ4GlzAPH+E25OsnMaZr2KDF4f9XUu/QiiHPI09q6/RAFGvICc79t/p
         VvBK+rzw68VrQ==
Subject: [PATCHSET v24.0 0/2] xfs_repair: rebuild inode fork mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:31 -0800
Message-ID: <167243865191.709165.12894699968646341429.stgit@magnolia>
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

Add the ability to regenerate inode fork mappings if the rmapbt
otherwise looks ok.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rebuild-forks
---
 include/xfs_trans.h      |    2 
 libxfs/libxfs_api_defs.h |   13 +
 libxfs/trans.c           |   48 +++
 repair/Makefile          |    2 
 repair/agbtree.c         |    2 
 repair/bmap_repair.c     |  741 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bmap_repair.h     |   13 +
 repair/bulkload.c        |  175 +++++++++++
 repair/bulkload.h        |   19 +
 repair/dino_chunks.c     |    5 
 repair/dinode.c          |  142 ++++++---
 repair/dinode.h          |    7 
 repair/rmap.c            |    2 
 repair/rmap.h            |    1 
 14 files changed, 1123 insertions(+), 49 deletions(-)
 create mode 100644 repair/bmap_repair.c
 create mode 100644 repair/bmap_repair.h

