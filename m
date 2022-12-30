Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93088C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiL3XJi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:09:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47CF2DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91677B81DA1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C94C433EF;
        Fri, 30 Dec 2022 23:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441774;
        bh=hOsfwGf0LVJRcPx+MTfHl49bQCypROwc6vcGuoTGBd4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VA9IvFaOOLuhgFQ4f6pXI6v4nY/dxXQWOeSy3b1KWosKKbMx0I44PzLQioycINvl7
         zq8mJ0mOGd13flLzw1PUbXBJBWHqVuN96BJc9uiA7eFcavp2F1V/hPtTO7BgclYzk+
         qcb7NY4494N+Usve+oaQuuDQtjXiworBc75aYkYMR6P4UV+f+JJ+tnTn7OjZc5KD9P
         vY+adWHr4mRPhk0h8oedBmWNQ4o/MMj+yt6YHdZ+OCEy5XaW3F8SQeCHLPTIkdOhg/
         4fm7RGLXUBtSEBkHN9LVYNcvxbtDBFJHmlx6C7j7CNbnzVZ1rRpR5pakPnTA1i98sl
         RBPYBNHnatWWA==
Subject: [PATCHSET v24.0 0/4] xfs_scrub: scan metadata files in parallel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864554.708428.558285078019160851.stgit@magnolia>
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

At this point, we need to clean up the libfrog and xfs_scrub code a
little bit.  First, correct some of the weird naming and organizing
choices I made in libfrog for scrub types and fs summary counter scans.
Second, break out metadata file scans as a separate group, and teach
xfs_scrub that it can ask the kernel to scan them in parallel.  On
filesystems with quota or realtime volumes, this can speed up that part
significantly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-metafile-parallel
---
 io/scrub.c      |   39 ++++++++-------
 libfrog/scrub.c |   51 +++++++++----------
 libfrog/scrub.h |   24 +++------
 scrub/phase2.c  |  146 +++++++++++++++++++++++++++++++++++++++++++------------
 scrub/phase4.c  |    2 -
 scrub/phase7.c  |    4 +-
 scrub/scrub.c   |   77 +++++++++++++++++------------
 scrub/scrub.h   |    6 ++
 8 files changed, 219 insertions(+), 130 deletions(-)

