Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AD8C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 17:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjCPRS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 13:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCPRSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 13:18:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A08F59D4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 10:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3487620A6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 17:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A61C433D2;
        Thu, 16 Mar 2023 17:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678987125;
        bh=LZ8q9WpHTEj92FXepK8KrSgSG6uE4eV36CiiSbZxaYw=;
        h=Date:From:To:Cc:Subject:From;
        b=Jcmiu9KbFuLYkuEdmmaU3K4BpQmqB2hT6VulIeidV+hDesfVcOatUMNPEAwRjRaNy
         D2mj2R3Oi81VE20z10hyieBWNrYBHiT1jziI568rjHvPldMWz0o0YgneJ4bgkf2Xkw
         6IFCwAnYiC/56COLzBP7EbZS0tizCoEC7NXFxCZypPcsmP6wZg55IRMC2l7G8BhfuF
         +B13JJk/6bFzwhqPR8mJse5UtG4UrZ3nXMiHZ+6U0RXNpw2WsXVBfn1PwV4Qd6ULZx
         9841kT6t129IVX6HOpXXRW9dPhEQ2M/rAMq//f+pqvAZkAruUIUU41HWmDUmUdcE/I
         gODpBkn2t0YSA==
Date:   Thu, 16 Mar 2023 10:18:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6de4b1ab470f
Message-ID: <167898709210.4066220.16318379148286823888.stg-ugh@magnolia>
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

6de4b1ab470f xfs: try to idiot-proof the allocators

1 new commit:

Darrick J. Wong (1):
[6de4b1ab470f] xfs: try to idiot-proof the allocators

Code Diffstat:

fs/xfs/libxfs/xfs_alloc.c | 13 +++++++++++++
1 file changed, 13 insertions(+)
