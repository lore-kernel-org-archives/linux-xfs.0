Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33721C76196
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Mar 2023 15:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjCXPsa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Mar 2023 11:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbjCXPsa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2023 11:48:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC5A3C0B
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 08:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA1E0B82548
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 15:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE3FC433D2;
        Fri, 24 Mar 2023 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679672906;
        bh=nU2ia5wj8s1bLvU2YWT6qgbNswJWKEdcWRuxYew8e6Y=;
        h=Date:From:To:Cc:Subject:From;
        b=NVhvVCc2NIrZSg8mOJNB1BJhgMWLLEsSmDPQaDkqbSLN1sbEzWNvUv2qNzhNmjmVo
         4aztFzv/n9UwM/w4+Bzga0NmfqN03JUH2StM/vvxwEw4QvaUY0z3uFaLBmqA0grFeW
         1MkFBQN8TrLQHpSkWjS6nje6tDB1k+7v7dLryh8WW2zUBUN81kxffw72KmpURJCMz1
         8TAshk3YtzopRF8mk0oRld2eFST+QNtRG/RIJAoMPwVMQ4hLhQygmqy8nqiZFcnkzS
         c5QMkxO9ZK03qXWwnpKlEC7FGiXlfJoYC4ff8gGtfc0tnPcEnif8uEzpDF27Zew8ts
         duVOdSLdGHf8Q==
Date:   Fri, 24 Mar 2023 08:48:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e2e63b071b2d
Message-ID: <167967277369.30655.2150948828807964193.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

e2e63b071b2d xfs: clear incore AGFL_RESET state if it's not needed

2 new commits:

Darrick J. Wong (2):
[fcde88af6a78] xfs: pass the correct cursor to xfs_iomap_prealloc_size
[e2e63b071b2d] xfs: clear incore AGFL_RESET state if it's not needed

Code Diffstat:

fs/xfs/libxfs/xfs_alloc.c | 2 ++
fs/xfs/xfs_iomap.c        | 5 ++++-
2 files changed, 6 insertions(+), 1 deletion(-)
