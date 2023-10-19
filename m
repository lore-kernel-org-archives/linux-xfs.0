Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C201ECDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjJSQVF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbjJSQVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:21:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8262F126
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:21:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2444DC433C8;
        Thu, 19 Oct 2023 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732461;
        bh=Y59dzlIBkVNifONC5B7vmeIDqIVJFRa50ouodx1sg8w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Xkt4O+3vs7B1Yhl4dcfs9Dd6vI+vD5T18AHyVjOlxet4I3AJ4Sk0/rneYVKMlioK/
         6gN+6WAMSRE8g/E80+e9+JV2WPsy5wNcJWqwvbqfkkBf0Mpi/nH28oqfhvGYZQbMyE
         YAAf4MFkzorUF6n+7BsHkPHti40NcnPx9WFFVasrvMeMKdwGYGTVwTAqaGUBjn8GBj
         o8hIyz3PEoHc8rrxOuJWWM35DlWXvqBPAslUXgloAKJKMZkKgkHQJF0vkFfXJir10F
         e/eDkaQ9fpJhQCbfOUufDVE0x5bbFRuANSCuM/HW/q+9N5KRn1HFk20GScOLHRG3JE
         GW7n8KdHu72VA==
Date:   Thu, 19 Oct 2023 09:21:00 -0700
Subject: [PATCHSET v1.2 0/4] xfs: refactor rtbitmap/summary accessors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs>
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

Since the rtbitmap and rtsummary accessor functions have proven more
controversial than the rest of the macro refactoring, split the patchset
into two to make review easier.

v1.1: various cleanups suggested by hch
v1.2: rework the accessor functions to reduce the amount of cursor
      tracking required, and create explicit bitmap/summary logging
      functions

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rtbitmap-accessors-6.7
---
 fs/xfs/libxfs/xfs_format.h   |   16 +++
 fs/xfs/libxfs/xfs_rtbitmap.c |  206 ++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   62 ++++++++++++-
 fs/xfs/scrub/rtsummary.c     |   32 ++++---
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   10 +-
 fs/xfs/xfs_ondisk.h          |    4 +
 fs/xfs/xfs_rtalloc.c         |   17 +--
 8 files changed, 223 insertions(+), 125 deletions(-)

