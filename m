Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF0A3C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 847FB604AC
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhHQXmq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhHQXmq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62CAB604AC;
        Tue, 17 Aug 2021 23:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243732;
        bh=DRLZgSwSXpTJlnHggKNDOp+X7mdfKtaCryCY9bGRoRQ=;
        h=Subject:From:To:Cc:Date:From;
        b=Mo3YJthG4UvJqOFkRY2RN9KzgX24Zqs8rFGD0lGMmQk5AUIWMXA1sfRvV6P2g48XX
         vKgfq4/dqar2fWagK5XRPh9804QaCDhCCGLyr4HiWdfT71kkenACxmBgvZCchZtXYL
         3O/uGSAz0AubKG9aI/oieGXek3wj8SmfnzBNVbW4FH/u3kvHucIW/wpPUmdYpIdOrN
         MsfZ5wbMHOsdELKCG5BcTOetXDxcQUO4NeyezFPtAw2dPnPM2CebIg3XRDBbAmyrMF
         JQ3afidRh9LHJ9yKhd4IuoAltB9rrJkjFadP/rzyvbTQdvrcISuT5o6ZYpuGU8aSKB
         XriXtHEqc0+gg==
Subject: [PATCHSET 00/15] xfs: clean up ftrace field tags and formats
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:12 -0700
Message-ID: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave has periodically complained on IRC about inconsistencies in the
printk format strings for XFS tracepoints.  He's right -- inodes and
block numbers are sometimes printed in decimal and other times in hex.
Worse yet, the tags associated with the names are also inconsistent and
aren't clear about the units of the numbers reported.  Most "blocks" and
"length" fields are fs blocks, but some are daddrs, some are byte
counts, etc.

Sooo... here's a disruptive bikeshed-attractor patchset that changes all
those numbers to hexadecimal and tries to make the naming consistent.
Or at least more consistent than they are now.

Here's the cleaned up nomenclature, starting with the ones that were
already in use:

ino: filesystem inode number
agino: per-AG inode number
agno: allocation group number
agbno: per-AG block number in fs blocks
owner: reverse-mapping owner, usually inodes
daddr: physical block number in 512b blocks
startblock: physical block number for file mappings.  This is either a
            segmented fsblock for data device mappings, or a rfsblock
	    for realtime device mappings
fileoff: file offset, in fs blocks
pos: file offset, in bytes
forkoff: inode fork offset, in bytes
icount: number of inode records
disize: ondisk file size, in bytes
isize: incore file size, in bytes

And here are three new tags:

blockcount: number of blocks in an extent, in fs blocks
daddrcount: number of blocks in a physical extent, in 512b blocks
bytecount: number of bytes

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=standardize-tracepoints-5.15
---
 fs/xfs/libxfs/xfs_types.h |    5 +
 fs/xfs/scrub/trace.h      |   74 ++++++++++----------
 fs/xfs/xfs_trace.h        |  169 ++++++++++++++++++++++-----------------------
 3 files changed, 127 insertions(+), 121 deletions(-)

