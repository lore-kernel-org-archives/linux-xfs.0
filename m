Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE73CDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjJKSBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbjJKSBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:01:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7279EAF
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:01:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BDCC433C7;
        Wed, 11 Oct 2023 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047277;
        bh=CMGl/4R462OTQLPbBQ7F4+zwrHCaY58Lbil/E0lOIiA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=b4o9RboC5aN12kmDjDTIDtiSCdcjLfw/gcgRougsADEoso/Kqbgp5F5EEoeiwst5K
         w9gfq55G6ViiwI56lfFipAL56jWRExE6f+o2vHMFJyZa3DoxMmo/rYlRsZ24mz2KZj
         +j11+wcnCe+69sIfZEHuccR4LAvY0I07KaoBRtQ4Mc67NLV/JRH82ZT1GLvEQugAJj
         pWbt7Z44J0Um0waVEPlzvPZLtd9aopGdIBlywQLx8n6sgI/wMKd2tbnbvbiEvGn50f
         v1YhWPoihdAFXbl00S3HxAgHFiXM5YSKbQTVQIH0/GrMxJHjkP/b9EEuvfqKGKgY+B
         GkuqkD+yzNTKw==
Date:   Wed, 11 Oct 2023 11:01:16 -0700
Subject: [PATCHSET RFC v1.0 0/7] xfs: clean up realtime type usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
In-Reply-To: <20231011175711.GM21298@frogsfrogsfrogs>
References: <20231011175711.GM21298@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The realtime code uses xfs_rtblock_t and xfs_fsblock_t in a lot of
places, and it's very confusing.  Clean up all the type usage so that an
xfs_rtblock_t is always a block within the realtime volume, an
xfs_fileoff_t is always a file offset within a realtime metadata file,
and an xfs_rtxnumber_t is always a rt extent within the realtime volume.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=clean-up-realtime-units

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=clean-up-realtime-units
---
 fs/xfs/libxfs/xfs_bmap.c     |    4 -
 fs/xfs/libxfs/xfs_format.h   |    2 
 fs/xfs/libxfs/xfs_rtbitmap.c |  121 +++++++++++----------
 fs/xfs/libxfs/xfs_rtbitmap.h |   79 ++++++++++++++
 fs/xfs/libxfs/xfs_types.c    |    4 -
 fs/xfs/libxfs/xfs_types.h    |    8 +
 fs/xfs/scrub/bmap.c          |    2 
 fs/xfs/scrub/fscounters.c    |    2 
 fs/xfs/scrub/rtbitmap.c      |   16 +--
 fs/xfs/scrub/rtsummary.c     |    6 +
 fs/xfs/scrub/trace.h         |    7 +
 fs/xfs/xfs_bmap_item.c       |    2 
 fs/xfs/xfs_bmap_util.c       |   18 +--
 fs/xfs/xfs_fsmap.c           |    2 
 fs/xfs/xfs_rtalloc.c         |  243 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_rtalloc.h         |   89 +--------------
 16 files changed, 315 insertions(+), 290 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h

