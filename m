Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04D5E7F144
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Sep 2023 23:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjIZX4H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjIZXyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 19:54:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A887868B;
        Tue, 26 Sep 2023 16:14:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4D5C433CB;
        Tue, 26 Sep 2023 23:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695770051;
        bh=JA7dODnNnvpGsFsGHoncrEhUbP6FKju74UyWTimKiY8=;
        h=Date:From:To:Cc:Subject:From;
        b=XsBHY2R/I8RXUW9gBbC9SK8ThTVru8ESw0FKG8hUfczgVIMyAdVHgroKHWoSPFdMW
         2iayz2dN6Gb/UBAcRCTkfzb/rSfogSR42VrS1FaTtQVzwWRgglcuzvCpYwCKPiBsoK
         W56Vn6esNqEKggpSH3r3tiBiF6XyvQ1+0jTmQmP/GzljfeQeaD+n1sXy+0LokdH6z1
         SfVWQoNaAAFYCQwDMnpxnILGDf5InK+lQfadLM/9/+qr2rJ/iOIp7Be8ZF2Y5nr6Zi
         Dz2AmTxJTUJl07RecoVOyEYpfSLCv5hoOgXBMWakEyJUaSszw/U0zAI7xPGzi8y+V0
         pbhl6VB0RgxDQ==
Date:   Tue, 26 Sep 2023 16:14:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Subject: [MEGAPATCHSET v27] xfs: online repair, second part of part 1
Message-ID: <20230926231410.GF11439@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

I've rebased the online fsck development branches atop 6.6, applied the
changes requested during the review of v26, and reworked the automatic
space reaping code to avoid open-coding EFI log item handling.

In other words, I'm formally submitting part 1 for inclusion in 6.7.

Just like the last review, I would like people to focus the following:

- Are the major subsystems sufficiently documented that you could figure
  out what the code does?

- Do you see any problems that are severe enough to cause long term
  support hassles? (e.g. bad API design, writing weird metadata to disk)

- Can you spot mis-interactions between the subsystems?

- What were my blind spots in devising this feature?

- Are there missing pieces that you'd like to help build?

- Can I just merge all of this?

The one thing that is /not/ in scope for this review are requests for
more refactoring of existing subsystems.  I'm still running QA round the
clock.  To spare vger, I'm only sending ~38 patches in this batch.

--D
