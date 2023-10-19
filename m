Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9873DCDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjJSQUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbjJSQUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:20:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521759B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:20:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F6C433C7;
        Thu, 19 Oct 2023 16:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732430;
        bh=dckdaI0QpJs/cDyZZhuQCpBKmYKjtPtDVxldmIj5BEY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GpxOwYEBL6pqZn1muAJivz5zSdl7vo5RaU8DPKfbgnmqhwrL7JgRVV1LKWeh7ySYh
         ZIXVGhNXknXmEGdFtcmVXJWzaDpvjUVj67bCg2+khRXCHrXz5BYccFX7mTGOHXefSG
         oBhe3jOvC7sTUfDZGODzdcMSCdiINU13s4ePZboMJPEj6Gwd+Was2REQjmoR1l6A6m
         cVBfDrQtBGD7mcgRjoTCFsrHM8lpsaRlI50LrZBZ9p2JXcMiKvR2MiPSMIksrin/CX
         kuThXGJB3xEntsdt6xhiSHLP7gIH//kIJlMhbwcgAxhi6W4ix5b+DrlcXy2BD+OmFH
         iTXX7fFXc4CFg==
Date:   Thu, 19 Oct 2023 09:20:28 -0700
Subject: [PATCHSET v1.1 0/7] xfs: refactor rt extent unit conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210547.225313.10976140314084989407.stgit@frogsfrogsfrogs>
In-Reply-To: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
References: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series replaces all the open-coded integer division and
multiplication conversions between rt blocks and rt extents with calls
to static inline helpers.  Having cleaned all that up, the helpers are
augmented to skip the expensive operations in favor of bit shifts and
masking if the rt extent size is a power of two.

v1.1: various cleanups suggested by hch

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-unit-conversions-6.7
---
 fs/xfs/libxfs/xfs_bmap.c       |   20 +++---
 fs/xfs/libxfs/xfs_rtbitmap.c   |    4 +
 fs/xfs/libxfs/xfs_rtbitmap.h   |  125 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c         |    2 +
 fs/xfs/libxfs/xfs_trans_resv.c |    3 +
 fs/xfs/scrub/inode.c           |    3 +
 fs/xfs/scrub/rtbitmap.c        |   18 ++----
 fs/xfs/scrub/rtsummary.c       |    4 +
 fs/xfs/xfs_bmap_util.c         |   38 +++++-------
 fs/xfs/xfs_fsmap.c             |   13 ++--
 fs/xfs/xfs_inode_item.c        |    3 +
 fs/xfs/xfs_ioctl.c             |    5 +-
 fs/xfs/xfs_linux.h             |   12 ++++
 fs/xfs/xfs_mount.h             |    2 +
 fs/xfs/xfs_rtalloc.c           |    4 +
 fs/xfs/xfs_super.c             |    3 +
 fs/xfs/xfs_trans.c             |    7 ++
 17 files changed, 200 insertions(+), 66 deletions(-)

