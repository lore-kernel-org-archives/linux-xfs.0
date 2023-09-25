Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43018CE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjIYV7M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjIYV7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9377811C
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31002C433C8;
        Mon, 25 Sep 2023 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679145;
        bh=LPXuR5jCR7WxuLM4NWA0zKv/2i8RD9nOWNrcXHtet60=;
        h=Subject:From:To:Cc:Date:From;
        b=P+66P1B2S0o1Fs6rSwV2IaCPC/hjB1Xn2xpbtGMZ5OxZf+TOvAWmLcMXhLqr9Mzgx
         m2TjQyRtyLMT6ZkmbRbLcb8e5HH6/Q6EAD4GWdgYkxqkZUXm/yjjnHw/Dp44PG4znr
         YjZ9emK9gbPdXzv1UtHVYwoeMn9hwpCn2iR2gw7ACShdkkQuBlTG/s1gLbulgN8AgJ
         Saw8v4wNkhFFU5LvOQeTBgmSXglhcF2kVtFU0y9eE1/vNxGmGGElSD2XEkBY6pKiih
         WJAYpoSR2xk81ptB4Yk1kOZPPAavM2WJ0Le10uwLAgc5MqgDLNrVNmHYSgEdEbPrFt
         eVHZTcc9Tkk+A==
Subject: [PATCHSET 0/2] xfs_db: use directio for filesystem access
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:04 -0700
Message-ID: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

xfs_db doesn't even try to use directio to access block devices.  This
is rather strange, since mkfs, copy, and repair use it.  Modify xfs_db
to set LIBXFS_DIRECT so that we don't have to deal with the bdev
pagecache being out of sync with what the kernel might have written
directly to the block device.

While we're at it, if we're using directio to the block device, don't
fail if we can't set the bufferhead size to the sectorsize, because
we're not using the pagecache anyway.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=db-use-directio
---
 db/init.c     |    1 +
 libxfs/init.c |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

