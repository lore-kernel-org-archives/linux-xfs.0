Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FE0C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbjEZAfu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbjEZAft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF5C1A6
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBB8164C0C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B4FC433EF;
        Fri, 26 May 2023 00:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061342;
        bh=slHeVVfctOGSPpf9+rrd0eRvr/juQYDRiSPmaY3DKdI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Ok8Z9p0cqN9e3SJPe6fLgITZSBNU/EiwkCy0vDXXJ7rkt3ox+KVnRYgd6zYxzKLnz
         IlEnotRC6RW7oCw1pDJj4zBtZ7sD+TVq2L+UI95yuY8OoXUaZFKoKdEURuWohKMgTV
         zgatXJOqr1TawtPdllB2+KJESIqm65nlgq6PKYONFFHvm5YP2SVFuEU5ncjdj3BFpT
         pHp+9GjTISJ8T5eku2ASunIJVRI4sWx3W8XAaR9NcDQkd0yi1w+X7KtiYLJCCr0OcO
         ChVKFS+iFrLHl7EUZ+qHZZyG8Fpa68cSEPRvvG4mNCx0dzUNMRpkXJnP4cdJwiE1I7
         mqjbTmONgoGyA==
Date:   Thu, 25 May 2023 17:35:41 -0700
Subject: [PATCHSET v25.0 0/5] xfs: online repair of extended attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <168506066818.3737146.14391441616329630322.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
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
 fs/xfs/scrub/attr_repair.c    | 1190 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/attr_repair.h    |   11 
 fs/xfs/scrub/dabtree.c        |   16 +
 fs/xfs/scrub/dabtree.h        |    3 
 fs/xfs/scrub/repair.c         |   46 ++
 fs/xfs/scrub/repair.h         |    6 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/tempfile.c       |  195 +++++++
 fs/xfs/scrub/tempfile.h       |    3 
 fs/xfs/scrub/tempswap.h       |    2 
 fs/xfs/scrub/trace.h          |   84 +++
 fs/xfs/scrub/xfarray.c        |   17 +
 fs/xfs/scrub/xfarray.h        |    2 
 fs/xfs/scrub/xfblob.c         |  169 ++++++
 fs/xfs/scrub/xfblob.h         |   27 +
 fs/xfs/scrub/xfile.h          |   12 
 fs/xfs/xfs_buf.c              |    3 
 fs/xfs/xfs_trace.h            |    2 
 26 files changed, 1839 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/attr_repair.h
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h

