Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB425C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 16:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A7B64E6B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 16:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCRQFs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231225AbhCRQFq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 12:05:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3B4964DCE;
        Thu, 18 Mar 2021 16:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616083545;
        bh=sbaxlwQT2TIpNdemJxeA20XDIaIb1kgC++pGvNYbDVQ=;
        h=Date:From:To:Cc:Subject:From;
        b=GkUnhjqIhO5huIa4lX/HHbHt63j/+LKQ3AjXR9G0nwmqA4EDjGTQjuRp7w+qfICRt
         0dP3VIszX39ryrII0HN8txcTjTAXnR2sesgTYBhJ6j+iErnytge+vddHdYdnru+aal
         v/5UlTmMqVyOaRTmlV9AdpsmDVixWwvl6bbWHXYWon9EYktixfPyAIpMMIM7GXO8l0
         2iNGSZY6zr0b6MCSjLsKQ0R4WntyL2d0RvGfFR7/rCZzx8z2DL3/UaqvcHVPHeAvJx
         8+uqb9/3QCQgbG6SOWN82kVbOkdld70w5KNb5s0UHEaB4RquKOZfsnDrW3p4L4AQAt
         BinXv2bRubcvQ==
Date:   Thu, 18 Mar 2021 09:05:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de, linux-btrfs@vger.kernel.org,
        naohiro.aota@wdc.com, riteshh@linux.ibm.com
Subject: [GIT PULL] iomap: fixes for 5.12-rc4
Message-ID: <20210318160545.GK22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this single fix to the iomap code for 5.12-rc4, which fixes
some drama when someone gives us a {de,ma}liciously fragmented swap
file.

The branch merges cleanly with upstream as of a few minutes ago and has
been soaking in for-next for a week without complaints.  Please let me
know if there are any strange problems.

--D

The following changes since commit a38fd8748464831584a19438cbb3082b5a2dab15:

  Linux 5.12-rc2 (2021-03-05 17:33:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git iomap-5.12-fixes

for you to fetch changes up to 5808fecc572391867fcd929662b29c12e6d08d81:

  iomap: Fix negative assignment to unsigned sis->pages in iomap_swapfile_activate (2021-03-09 09:29:11 -0800)

----------------------------------------------------------------
Ritesh Harjani (1):
      iomap: Fix negative assignment to unsigned sis->pages in iomap_swapfile_activate

 fs/iomap/swapfile.c | 10 ++++++++++
 1 file changed, 10 insertions(+)
