Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5538C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 20:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241336AbiEXUG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 16:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241433AbiEXUGY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 16:06:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC6720BE4;
        Tue, 24 May 2022 13:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78CD7CE1D1E;
        Tue, 24 May 2022 20:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC17C34100;
        Tue, 24 May 2022 20:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653422776;
        bh=DJcj/Ms9n82tm2p+fi143c/whYeefmc3dPnhMgtFVX8=;
        h=Date:From:To:Cc:Subject:From;
        b=SGbu7qQqoHZQ0dhRSjok++5KTJC1xudsUyveKR1jTYM+8V3dASm2P7JOHEY6zVfHy
         pRscfULAQNo8ChY1WFEVb7qfSG/S/9IBvwlHNigtospW1Ie6cqV+wYV0HIdJ3S56qM
         JWpcZJu1p+8GEdehTm17Cw05BPAybZHddoMuEXd4gdGK6OS4Zevlh9u1HDwc8NfJ84
         9IcdQlvZUZURw9vwspdLCb+QbkQtRCOSzgm/VgbqrKPMeGSuAkJREphs0mPe2vXlCm
         P9s+ojBuF7P8ag0nskWKOLDiDmI5cSRVm7JYhED8QdLsRNS6w+84kMBVF2gqsAC134
         uR4b50XiQIBSQ==
Date:   Tue, 24 May 2022 13:06:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] iomap: new code for 5.19
Message-ID: <Yo06uCPonxSkD0Md@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch containing all the new code for iomap for
5.19.  There's a couple of corrections sent in by Andreas for some
accounting errors.

The biggest change this time around is that writeback errors longer
clear pageuptodate nor does XFS invalidate the page cache anymore.  This
brings XFS (and gfs2/zonefs) behavior in line with every other Linux
filesystem driver, and fixes some UAF bugs that only cropped up after
willy turned on multipage folios for XFS in 5.18-rc1.  Regrettably, it
took all the way to the end of the 5.18 cycle to find the source of
these bugs and reach a consensus that XFS' writeback failure behavior
from 20 years ago is no longer necessary.

As usual, I did a test-merge with upstream master as of a few minutes
ago, and didn't see any conflicts.  Please let me know if you encounter
any problems.

--D

The following changes since commit c5eb0a61238dd6faf37f58c9ce61c9980aaffd7a:

  Linux 5.18-rc6 (2022-05-08 13:54:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.19-merge-2

for you to fetch changes up to e9c3a8e820ed0eeb2be05072f29f80d1b79f053b:

  iomap: don't invalidate folios after writeback errors (2022-05-16 15:27:38 -0700)

----------------------------------------------------------------
New code for 5.19:
- Fix a couple of accounting errors in the buffered io code.
- Discontinue the practice of marking folios !uptodate and invalidating
  them when writeback fails.  This fixes some UAF bugs when multipage
  folios are enabled, and brings the behavior of XFS/gfs/zonefs into
  alignment with the behavior of all the other Linux filesystems.

----------------------------------------------------------------
Andreas Gruenbacher (2):
      iomap: iomap_write_failed fix
      iomap: iomap_write_end cleanup

Darrick J. Wong (1):
      iomap: don't invalidate folios after writeback errors

 fs/iomap/buffered-io.c | 6 +++---
 fs/xfs/xfs_aops.c      | 4 +---
 2 files changed, 4 insertions(+), 6 deletions(-)
