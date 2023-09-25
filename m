Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0ABACE7A95
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 15:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjIYPjM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjIYPjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 11:39:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F71101
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 08:39:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B4BC433CB;
        Mon, 25 Sep 2023 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695656345;
        bh=ITtLkQ3VMv0+oqyoo8tOzA3VahM7AxkhGl/pImVOxOw=;
        h=Date:From:To:Cc:Subject:From;
        b=BTmsFhMvncreY0/bJrFDtOANHgUe1hQKeOd1AhcF/9+nlCf/CqqCb/bT+3BLalOJD
         53z8MH2yKvKlyHxGmoI/93XNc+JP5GH9dn81DVFHIpl1bE0mcWERiwyKuZ37oZyV4A
         eOflPi5tux7Q3sjIStCY4PanTM05IutVtgrRX0Wzdymg0PJ4bcy9mZ0eOY0qxFaa5L
         V/1uwlq4qhKwJW5D5mzqHhf6LQrBPkPWYZ/ahJKrL653NNiAbFCoNm9bpk0rFdF2d/
         PtORmqTLWNVUE48XT3JZZS/O8R9tAdmuvn52ZnjkxmRp2KH5qca9lh/Lzd9OCAt2wi
         CmeWx7t2/4Zyw==
Date:   Mon, 25 Sep 2023 08:39:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: fix reloading the last iunlink item
Message-ID: <169565625185.1980111.13370011821352297018.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc3.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6465e260f48790807eef06b583b38ca9789b6072:

Linux 6.6-rc3 (2023-09-24 14:31:13 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-fix-iunlink-6.6_2023-09-25

for you to fetch changes up to 537c013b140d373d1ffe6290b841dc00e67effaa:

xfs: fix reloading entire unlinked bucket lists (2023-09-24 18:12:13 -0700)

----------------------------------------------------------------
xfs: fix reloading the last iunlink item
It's not a good idea to be trying to send bug fixes to the mailing list
while also trying to take a vacation.  Dave sent some review comments
about the iunlink reloading patches, I changed them in djwong-dev, and
forgot to backport those changes to my -fixes tree.

As a result, the patch is missing some important pieces.  Perhaps
manually copying code diffs between email and two separate git trees
is archaic and stupid^W^W^W^Wisn't really a good idea?

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: fix reloading entire unlinked bucket lists

fs/xfs/xfs_export.c | 16 ++++++++++++----
fs/xfs/xfs_inode.c  | 48 +++++++++++++++++++++++++++++++++++-------------
fs/xfs/xfs_itable.c |  2 ++
fs/xfs/xfs_qm.c     | 15 ++++++++++++---
4 files changed, 61 insertions(+), 20 deletions(-)
