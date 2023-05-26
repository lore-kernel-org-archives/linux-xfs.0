Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42120C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjEZAj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbjEZAjX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:39:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC71194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D1E5616EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAB7C433EF;
        Fri, 26 May 2023 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061560;
        bh=ZECieDECYUGcsGH1tVvwz94a8vARPx1Xuie5pwz06QI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=T5R5Guvm0v8ON/xp1vtfwLhQkNV60Bp6Wq44LkblG8cQn38y7X8Mu7foyIYmcSjNF
         qtO+bLWcRDu8S4d3CKxO7npK0gkDNorgy5TzSQ/u9oOl1jyfe23x199eyG4/9NtbQg
         mC7sQrDVl3vwnZo+ykc8dKH5FRp5evWrcoF/5OTVIKGQ/ipcJtNrJ1I8SVEnNJruz+
         dHAxkx8Dh9M14Vp5d6PInnoRvIshVdaIzRHFvXOBhsHezubXCycKXREJYnlQa4NqRK
         CMZNONjJk/lvtYvEckWMzVUlVnIbtw2VuyyUBJ7u2toeAxcBX3Nml3DJXy2qwQ2hED
         02kO1ZQyFAovQ==
Date:   Thu, 25 May 2023 17:39:20 -0700
Subject: [PATCHSET v25.0 0/8] xfs_scrub: move fstrim to a separate phase
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Back when I originally designed xfs_scrub, all filesystem metadata
checks were complete by the end of phase 3, and phase 4 was where all
the metadata repairs occurred.  On the grounds that the filesystem
should be fully consistent by then, I made a call to FITRIM at the end
of phase 4 to discard empty space in the filesystem.

Unfortunately, that's no longer the case -- summary counters, link
counts, and quota counters are not checked until phase 7.  It's not safe
to instruct the storage to unmap "empty" areas if we don't know where
those empty areas are, so we need to create a phase 8 to trim the fs.
While we're at it, make it more obvious that fstrim only gets to run if
there are no unfixed corruptions and no other runtime errors have
occurred.

Finally, reduce the latency impacts on the rest of the system by
breaking up the fstrim work into a loop that targets only 16GB per call.
This enables better progress reporting for interactive runs and cgroup
based resource constraints for background runs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-phase
---
 scrub/Makefile    |    1 
 scrub/phase4.c    |   30 +----------
 scrub/phase8.c    |  151 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c       |   22 +++++---
 scrub/vfs.h       |    2 -
 scrub/xfs_scrub.c |   11 ++++
 scrub/xfs_scrub.h |    3 +
 7 files changed, 183 insertions(+), 37 deletions(-)
 create mode 100644 scrub/phase8.c

