Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0726C001E0
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Oct 2023 06:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjJUG1r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Oct 2023 02:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjJUG1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Oct 2023 02:27:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372D3D52
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 23:27:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFACEC433C7;
        Sat, 21 Oct 2023 06:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697869664;
        bh=a8DE6UK4DP5vgQrAGmOW66RQUqEFOYmULPq9SLYXDB0=;
        h=Date:From:To:Cc:Subject:From;
        b=NU4mGNdW9XJUCNRCiojALB8XVqg9Eh3+gUggRjHHAT0zlP9FiQuIlmbMBnREqAI0V
         Zl3j6Nwm0OzklL8DRmd4UlxEFL9hBqo2LrwOs51QmD/M97/je4IjB/mAJ1ldxWjufW
         OyIbwbi6G83X5PVyI93oFDVlVm8MEYYJ6RIHl8IjgjtPO7rRK5FyxbpgxInS03rgNs
         Co0GXIJOaJnb5Ah3Mg06ams+IkJ/sO4SJfurtVFBdp0NtMtP1yZtCFsDC+8jPuKvlH
         +vxaEqkVkUUD3AIuRgV6bLuoCPSSxyjA+203lOCGp7Nx/RiVIj2+majYaElmjgwQip
         U7UUefiEf5zMA==
Date:   Fri, 20 Oct 2023 23:27:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     hch@lst.de, jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [GIT PULL] iomap: bug fixes for 6.6-rc7
Message-ID: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for iomap for 6.6-rc7.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 684f7e6d28e8087502fc8efdb6c9fe82400479dd:

iomap: Spelling s/preceeding/preceding/g (2023-09-28 09:26:58 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5

for you to fetch changes up to 3ac974796e5d94509b85a403449132ea660127c2:

iomap: fix short copy in iomap_write_iter() (2023-10-19 09:41:36 -0700)

----------------------------------------------------------------
Bug fixes for 6.6-rc6:

* Fix a bug where a writev consisting of a bunch of sub-fsblock writes
where the last buffer address is invalid could lead to an infinite
loop.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Jan Stancek (1):
iomap: fix short copy in iomap_write_iter()

fs/iomap/buffered-io.c | 10 +++++++---
1 file changed, 7 insertions(+), 3 deletions(-)
