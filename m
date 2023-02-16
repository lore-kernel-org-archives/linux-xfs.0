Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009DFC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBPUaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPUaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB1B196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D02560A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2FFC433D2;
        Thu, 16 Feb 2023 20:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579420;
        bh=zQxm5nNy/NtN2ZMx1HN+ce+DZvcY+aT9RI7CuqaeJC4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h4HZ+XKwHIoDPMVk/BaYFSCgSC7nHTZgfHEGpxJybTWb0HeN7SvQD/xsH7WNZg5eb
         kmBQzJPFlqiw38J+WhyXkgxYZ00FSHKhkv6xOi/Au5pwy7e2tWRWAD6bZ6WNwK5G9F
         0rS03RD9Ns3vtU1LxSDn/zx6eTwSu/kXbYAJfx1hN3MRDSm11VKg0omPZ70l3CyZF+
         1xpNmLHB0huBXfqTd5VziaKPXqxc3ACaAiQJfmT1ir798ZB4zeHuK2bWN2Q2gbLncA
         0cqkyYWe7srZMTOUvtUPLSQCdulejPmeOZJ+Sq40Xg0A8AtcjLtjuRcGI/JSQI3BST
         7BGluszqiaNSw==
Date:   Thu, 16 Feb 2023 12:30:19 -0800
Subject: [PATCHSET v9r2d1 0/3] xfsprogs: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881025.3477513.15490690754847111370.stgit@magnolia>
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

With this patchset, we implement online reconstruction of directories by
scanning the entire filesystem looking for parent pointer data.  This
mostly works, except for the part where we need to resync the diroffset
field of the parent pointers to match the new directory structure.

Fixing that is left as an open research question, with a few possible
solutions:

1. As part of committing the new directory, queue a bunch of parent
pointer updates to make those changes.

2. Leave them inconsistent and let the parent pointer repair fix it.

3. Change the ondisk format of parent pointers (and xattrs) so that we
can encode the full dirent name in the xattr name.

4. Change the ondisk format of parent pointers to encode a sha256 hash
of the dirent name in the xattr name.  This will work as long as nobody
breaks sha256.

Thoughts?  Note that the atomic swapext and block reaping code is NOT
ported for this PoC, so we do not commit any repairs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-repair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-dir-repair
---
 libxfs/libxfs_api_defs.h |    3 +--
 libxfs/xfs_da_format.h   |   11 +++++++++++
 libxfs/xfs_dir2.c        |    2 +-
 libxfs/xfs_dir2.h        |    2 +-
 libxfs/xfs_parent.c      |   47 +++++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_parent.h      |   24 +++++++++++------------
 mkfs/proto.c             |   12 ++++++------
 7 files changed, 71 insertions(+), 30 deletions(-)

