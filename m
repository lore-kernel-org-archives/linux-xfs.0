Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB926C54E76
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 17:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345351AbjKPRfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345347AbjKPRfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 12:35:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EE1D49
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 09:35:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545FCC433C7;
        Thu, 16 Nov 2023 17:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700156133;
        bh=sae3T8fTm7bGIlBN4+hIM9ppP7jdM4GaqK2tKSXoviM=;
        h=Date:Subject:From:To:Cc:From;
        b=ltEwIhywT9IZjVvZNGceNz37VZRNMM4F7eoOEZ7dzdbizsMptqTkn12gTphGAHUJL
         +yajkrmm2YC8nHLixJ7rjjTffiy6CFeYUarH/7qAl5YxVRi0yvw2RoLwbhHqLKh7S6
         7seKRo8wPbOXPWsx/k9dqIifB4c3t8jKWvPJvAE6qVOx6IdRqQd6PkNs6VoACvdOVM
         DtJRwidR4biogIMmAwDWnsVuaTIbpRsMizleRgCGnXYEIN6bd7tM5x8S/kSuIzp/vW
         v757LGz0uKFUji5ZB5K2Ww0IgywugjKtg9kqhhO7vy4rqNUmGJC+DYHDdkn8yg8Aom
         2BsQTJvR5t2Jw==
Date:   Thu, 16 Nov 2023 09:35:32 -0800
Subject: [GIT PULL 3/3] fstests: FIEXCHANGE is now an XFS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     fstests@vger.kernel.org, guan@eryu.me, hch@lst.de,
        linux-xfs@vger.kernel.org
Message-ID: <170015608757.3373797.8063458881541595889.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit dfaf19dd09b31088d5adfcdd888479301450a8c9:

generic: test reads racing with slow reflink operations (2023-11-16 09:11:57 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/private-fiexchange_2023-11-16

for you to fetch changes up to 7053833541bd48b3260f2e6e208fe4d7daab5955:

misc: update xfs_io swapext usage (2023-11-16 09:11:57 -0800)

----------------------------------------------------------------
fstests: FIEXCHANGE is now an XFS ioctl [v27.1]

Minor amendments to the fstests code now that we've taken FIEXCHANGE
private to XFS.

v27.1: add hch review tags; rebase and maybe fix merge problems?

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
misc: privatize the FIEXCHANGE ioctl for now
misc: update xfs_io swapext usage

common/xfs            |  2 +-
configure.ac          |  2 +-
doc/group-names.txt   |  2 +-
include/builddefs.in  |  2 +-
ltp/Makefile          |  4 ++--
ltp/fsstress.c        | 10 +++++-----
ltp/fsx.c             | 20 ++++++++++----------
m4/package_libcdev.m4 | 20 --------------------
m4/package_xfslibs.m4 | 14 ++++++++++++++
src/Makefile          |  4 ++++
src/fiexchange.h      | 44 ++++++++++++++++++++++----------------------
src/global.h          |  4 +---
src/vfs/Makefile      |  4 ++++
tests/generic/709     |  2 +-
tests/generic/710     |  2 +-
tests/generic/711     |  2 +-
tests/generic/712     |  2 +-
tests/generic/713     |  4 ++--
tests/generic/714     |  4 ++--
tests/generic/715     |  4 ++--
tests/generic/716     |  2 +-
tests/generic/717     |  2 +-
tests/generic/718     |  2 +-
tests/generic/719     |  2 +-
tests/generic/720     |  2 +-
tests/generic/722     |  4 ++--
tests/generic/723     |  6 +++---
tests/generic/724     |  6 +++---
tests/generic/725     |  2 +-
tests/generic/726     |  2 +-
tests/generic/727     |  2 +-
tests/xfs/122.out     |  1 +
tests/xfs/789         |  2 +-
tests/xfs/790         |  2 +-
tests/xfs/791         |  6 +++---
tests/xfs/792         |  2 +-
36 files changed, 99 insertions(+), 98 deletions(-)

