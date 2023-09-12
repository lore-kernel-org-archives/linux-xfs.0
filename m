Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F81EE3F10
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbjILTjl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbjILTjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:39:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FA5115
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:39:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5954AC433C9;
        Tue, 12 Sep 2023 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694547576;
        bh=REqwFzOrpbLZj2Hi+vAmMt6xFCXwWUcS2Y0IWfp+HK4=;
        h=Subject:From:To:Cc:Date:From;
        b=mJoeDynkinhYU2E1MEhRLk6ZdFeSChvdgSEUWQHfTci1LiADue9dwrRFvqbLW5aU8
         dgoOZfDVfLP2CULobvMfwjSt11P+xKGLLRIz4Hv+A4BwcIkyzREYJp10HTsQIGhiSP
         vFAFA4OsAblhTlY5CHDx3HhL5Xh8T7398mNIpWANVVNgPbBw5KzlLd+rkAXE8KkKe7
         jYV4uCo+hsQZrJNKsxCsF3oaQF6zx1ghFF8XWtGOo9blwFLMEYa1YNKYjel8x0ksWi
         m3oYmSTA8Vq7fWlIB1kcyM/ULkPBiuDQOU4sMXXhaZaZdUaMUeLyAR6/FtWMZyvXhu
         hRFiH9G3SQh0A==
Subject: [PATCHSET 0/6] xfsprogs: minor fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Date:   Tue, 12 Sep 2023 12:39:35 -0700
Message-ID: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes some bugs that I and others have found in the
userspace tools.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 libfrog/bulkstat.c  |    2 +-
 libfrog/workqueue.c |   34 ++++++++++++++++++++++++----------
 libfrog/workqueue.h |    1 +
 libxfs/util.c       |    2 +-
 m4/package_urcu.m4  |    9 ++++++++-
 repair/dinode.c     |    2 --
 scrub/phase5.c      |    1 +
 7 files changed, 36 insertions(+), 15 deletions(-)

