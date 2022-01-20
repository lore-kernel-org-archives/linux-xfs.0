Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2460EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 18:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiATSLX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jan 2022 13:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiATSLX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jan 2022 13:11:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B0FC061574
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 10:11:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE176B81D57
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 18:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EC5C340E0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642702280;
        bh=Zy1BkcOTsjr7mWZB6djXr/U3s/BgFqzBCnrQC3fAGKk=;
        h=Date:From:To:Subject:From;
        b=PQ0shFTvjkZJKRTyw16A97nvvhD93/SsZgw8hSyS0wPz9Qg8qpShhWbEOVDL3o4P4
         j052eNPxFeme+PcBDT67a6pbQDADR9niPh2KmxdReG/rnErqbUytjmJWglezcc7f9t
         tRqwn8DBio+cDJ5pwm/j7OwUTu3gfxWWsll+YpvOI2YXbadJPp7FXL+/PX8EqbRqiH
         Pg9Wte3vdZDb99rexxmZEXtwFthFnQz+AvCU1GnkDYL/IajxVgQAcvbVTQAxRxPaiH
         WVanOB9XnddIsNAVmPNtCOyjYdkOVw1zx5ycPj6mCKb1+PtHixGsMp6EXWsOMG371B
         M6kLtEnnuBjbQ==
Date:   Thu, 20 Jan 2022 10:11:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6191cf3ad59f
Message-ID: <20220120181119.GM13540@magnolia>
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

6191cf3ad59f xfs: flush inodegc workqueue tasks before cancel

2 new commits:

Brian Foster (1):
      [6191cf3ad59f] xfs: flush inodegc workqueue tasks before cancel

Darrick J. Wong (1):
      [a8e422af6961] xfs: remove unused xfs_ioctl32.h declarations

Code Diffstat:

 fs/xfs/xfs_icache.c  | 22 ++++------------------
 fs/xfs/xfs_ioctl32.h | 18 ------------------
 2 files changed, 4 insertions(+), 36 deletions(-)
