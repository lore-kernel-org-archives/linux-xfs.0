Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A204EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiL3XOW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiL3XOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:14:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AD81DDC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55DFAB81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B804C433D2;
        Fri, 30 Dec 2022 23:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442058;
        bh=/G+0qutX0riAWiJAUH3DWnpqsxPqii4rypYc8l7coG8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=treng/Ll5DiYLldU1Bc/PwHe6H2jFIi9OQu/BuUOHTLupRwes6VtKEuz9Khgr3tHD
         c1YlyHovV151gJNUTkrKsW9sHXA/w6GmiyLZMjRrxSmUIRxu/ABhawDymEq/+RFwBX
         C9BJnAOmyn254XOM2tK2wLwtG0ideZPYaFwAtg/ytyh1xnHoffTp2vVmm7cpj7O5rT
         oA7y7mXzAcTOfqRAx7rDvFPgJ758LIZJiMU+tyipqsQWUNBSK28nxQYZ5WszAwn8S5
         3OHpIdssgGbvsH+GkiBudkUjAJ5MbO/FXrGTCVExRG/+HWy2N5Yfcdm0Sk7ws9fYVa
         vcC3kj0ArcTcw==
Subject: [PATCHSET v24.0 0/7] xfs_scrub: move fstrim to a separate phase
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:27 -0800
Message-ID: <167243870748.716924.8460607901853339412.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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
there are no unfixed corruptiosn and no other runtime errors have
occurred.

Finally, parallelize the fstrim calls by making them per-AG instead of
per-filesystem.  This cuts down the trimming time considerably on more
modern hardware that can handle (or at least combine) concurrent discard
requests.

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
 scrub/phase8.c    |  150 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/vfs.c       |   22 +++++---
 scrub/vfs.h       |    2 -
 scrub/xfs_scrub.c |   11 ++++
 scrub/xfs_scrub.h |    3 +
 7 files changed, 182 insertions(+), 37 deletions(-)
 create mode 100644 scrub/phase8.c

