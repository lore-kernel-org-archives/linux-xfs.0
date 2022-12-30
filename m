Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87BEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiLaA5z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:57:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A18F03A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A905C61D5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FB5C433EF;
        Sat, 31 Dec 2022 00:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448273;
        bh=zwBlOezOeVRqP1rq/dgqYiwcZ6xyIEwOIiNCwTZ82/k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cF2cx3VbxkHJXZVzA+oFPsvPMwuqmIp83T/MxMt4C2AweEndu15Ctf7A+VDa2tC4p
         nPnmXjBcFbeLH2Kz2LRte6UA7PW0wvtclx4QyT8P/zlL2t+fvs66eGrb09rT8Fivih
         7FgO/VbgXk/CUVvDan8Q3U1t9/3Zvo5/xaItfC+FwisC6k+OXdAkBI4G3qca1n1sl7
         EbuwEGlt3N3+l/4Zf2vhansZg6KD6cAIL0qXXojD94dbwmxqz61xavMvlZrwtHw72c
         aa0fn/SEQQVQF+hsV8E9lfiHdzNhWPwHCL6SfHoa9wvznoDdpG/Y2mVPn3yInCmedn
         NcUcbf+s3HiZw==
Subject: [PATCHSET v1.0 0/2] xfs: widen EFI format to support rt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:08 -0800
Message-ID: <167243868836.714671.1578924317888085757.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Realtime reverse mapping (and beyond that, realtime reflink) needs to be
able to defer file mapping and extent freeing work in much the same
manner as is required on the data volume.  Make the extent freeing log
items operate on rt extents in preparation for realtime rmap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-extfree-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-extfree-intents
---
 fs/xfs/libxfs/xfs_alloc.c      |   35 ++++++++++++++++----
 fs/xfs/libxfs/xfs_alloc.h      |   17 ++++++++--
 fs/xfs/libxfs/xfs_defer.c      |    1 +
 fs/xfs/libxfs/xfs_defer.h      |    1 +
 fs/xfs/libxfs/xfs_log_format.h |    7 ++++
 fs/xfs/libxfs/xfs_rtbitmap.c   |    4 ++
 fs/xfs/xfs_extfree_item.c      |   71 ++++++++++++++++++++++++++++++++++++++--
 7 files changed, 123 insertions(+), 13 deletions(-)

