Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A8BE7F14B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 01:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbjI0ByD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 21:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbjI0BwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 21:52:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD591F2B0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:30:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDC7C433C8;
        Tue, 26 Sep 2023 23:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771036;
        bh=BJE396fiXuVVYkeuIXzJlpdUYssh4svkQinIEH5wyG0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Gs48dpr0xguSM0Q7DCjbZd9MpMBDgCK0oSIQ6u8+7o3b6pamm44mVQY823bDDyLdd
         EPNu9Ob6SPvxSUbF9X+uOYuriyIKXc3o3PWAFnkHN5o19HBUZhOtcH/8TDFw7pQMfP
         unvmSBxjzQgLm4hD4lD4+ujT8A6tDIIWjRgD38SSXknbap7/zWlsf0Gu7wcXYmCcxO
         cV9rtkTy6VODIGBb8HVojyN3kiMewNts8Bhszs8dg9bsY2gFEp6EkFQ3qmo/5cV0US
         bpTAUeqRNhy4Yv6njsnudutUCIRkIXeSEMyTsC9um4GjSpOnXD5hoKCE1w34gFl7/N
         eNyXxqNn46jBg==
Date:   Tue, 26 Sep 2023 16:30:36 -0700
Subject: [PATCHSET v27.0 0/4] xfs: online repair of rt bitmap file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061183.3315493.6171012860982301231.stgit@frogsfrogsfrogs>
In-Reply-To: <20230926231410.GF11439@frogsfrogsfrogs>
References: <20230926231410.GF11439@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add in the necessary infrastructure to check the inode and data forks of
metadata files, then apply that to the realtime bitmap file.  We won't
be able to reconstruct the contents of the rtbitmap file until rmapbt is
added for realtime volumes, but we can at least get the basics started.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtbitmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtbitmap
---
 fs/xfs/Makefile                |    4 +
 fs/xfs/libxfs/xfs_bmap.c       |   39 ++++++++++
 fs/xfs/libxfs/xfs_bmap.h       |    2 +
 fs/xfs/scrub/bmap_repair.c     |   17 +++--
 fs/xfs/scrub/repair.c          |  151 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |   15 ++++
 fs/xfs/scrub/rtbitmap.c        |   10 ++-
 fs/xfs/scrub/rtbitmap_repair.c |   56 +++++++++++++++
 fs/xfs/scrub/scrub.c           |    4 -
 fs/xfs/xfs_inode.c             |   24 +-----
 10 files changed, 294 insertions(+), 28 deletions(-)
 create mode 100644 fs/xfs/scrub/rtbitmap_repair.c

