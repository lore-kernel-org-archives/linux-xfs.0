Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58D5C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiL3XHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiL3XHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:07:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292BE2DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:07:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8D83B81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8074FC433EF;
        Fri, 30 Dec 2022 23:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441633;
        bh=lOxDUQfQURXDet2nkjfjvllqNuagRGaMgRUxeMLecEE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rrnVWSwmoTRwLiJMuWSGtqwPQ+Znc4TBo9Xe0c7sSZVi+TlyPu5LPQegPxeUhh6TC
         EGel44Khj9fdi/liaJh7gixhJz3nNd5Uot0uJCKBd3z8y+dbNaeKlp8hq2+0+B2BJR
         u8JDWT98z66VZdJJc+eXhqQKkqpWrlTdZVhlH2GiXbmvgqRVFOVfLys3911k70bPQ8
         yF5IfHZ2PVZ6uYlLH89J9ZmbA4xRZCVMBMnKLFeDx4+NiIrDG7iT4HZHS68nP9egA/
         Q0EEZX2xu1b8oHtQrupk1Sc6IUKtpPn4gEmEYhMCMZt2ZFWY9hgVwGVEgS1okLQj81
         2Kr5DYsBrWnIg==
Subject: [PATCHSET v24.0 0/5] xfs: online repair of extended attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:12 -0800
Message-ID: <167243845264.700496.9115810454468711427.stgit@magnolia>
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
of extended attribute data attached to a file.  Because xattrs do not
have any redundant information to draw off of, we can at best salvage
as much data as we can and build a new structure.

Rebuilding an extended attribute structure consists of these three
steps:

First, we walk the existing attributes to salvage as many of them as we
can, by adding them as new attributes attached to the repair tempfile.
We need to add a new xfile-based data structure to hold blobs of
arbitrary length to stage the xattr names and values.

Second, we write the salvaged attributes to a temporary file, and use
atomic extent swaps to exchange the entire attribute fork between the
two files.

Finally, we reap the old xattr blocks (which are now in the temporary
file) as carefully as we can.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-xattrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-xattrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-xattrs
---
 fs/xfs/Makefile               |    2 
 fs/xfs/libxfs/xfs_attr.c      |    2 
 fs/xfs/libxfs/xfs_attr.h      |    2 
 fs/xfs/libxfs/xfs_da_format.h |    5 
 fs/xfs/libxfs/xfs_swapext.c   |    2 
 fs/xfs/libxfs/xfs_swapext.h   |    1 
 fs/xfs/scrub/attr.c           |   33 +
 fs/xfs/scrub/attr.h           |    7 
 fs/xfs/scrub/attr_repair.c    | 1158 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dabtree.c        |   16 +
 fs/xfs/scrub/dabtree.h        |    3 
 fs/xfs/scrub/repair.c         |   45 ++
 fs/xfs/scrub/repair.h         |    8 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/tempfile.c       |  176 ++++++
 fs/xfs/scrub/tempfile.h       |    2 
 fs/xfs/scrub/tempswap.h       |    2 
 fs/xfs/scrub/trace.h          |  106 ++++
 fs/xfs/scrub/xfarray.c        |   24 +
 fs/xfs/scrub/xfarray.h        |    2 
 fs/xfs/scrub/xfblob.c         |  176 ++++++
 fs/xfs/scrub/xfblob.h         |   27 +
 fs/xfs/xfs_buf.c              |    3 
 fs/xfs/xfs_trace.h            |    2 
 24 files changed, 1801 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h

