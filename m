Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F04C197A0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 17:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjKPRfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjKPRfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 12:35:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F6A182
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 09:35:18 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE24C433C8;
        Thu, 16 Nov 2023 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700156117;
        bh=DY9ChXBzWdhYjolB0FQNnJHQMMzI4pc1fhrdy1CsUb0=;
        h=Date:Subject:From:To:Cc:From;
        b=LlFf1hPZQSbqaqv7EV44i9na89NcgXrmUzAXo+Byp2EUiQiX9j8Rca+yeQAo+v3X/
         +6B1GRYxugbC0ea+JRL7YMiV/0q2OidIf/n/KyWC+HUDt3abbJAQDG/I5+zrII8S/V
         Q9dsQoWvgA4662+ZsZ8fkO1dxqY3qnTEB/LokV6/uxXYPsArNl/0E8cgCwu9hSFv14
         rp7iYWsen/+9O8139bSnWvAV4ZZLTPGn13MeGnQY/XFgzA7RptBzc+zXuJWLlYb3eC
         hqV9A2tpIFeP9gKttIoEUHYjm8lBYAWP3KiAF0+L1TEGOEqhQYDfKIzyXSuA4WYbsw
         M9QrwEl71Pbpg==
Date:   Thu, 16 Nov 2023 09:35:17 -0800
Subject: [GIT PULL 2/3] fstests: updates for Linux 6.7
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     catherine.hoang@oracle.com, fstests@vger.kernel.org, guan@eryu.me,
        hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170015608670.3373797.18160156746457381399.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 22ee90ae2da798d7462579aeb4b17d8b44671e9d:

xfs: test unlinked inode list repair on demand (2023-11-16 09:11:57 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/xfs-merge-6.7_2023-11-16

for you to fetch changes up to dfaf19dd09b31088d5adfcdd888479301450a8c9:

generic: test reads racing with slow reflink operations (2023-11-16 09:11:57 -0800)

----------------------------------------------------------------
fstests: updates for Linux 6.7 [v3]

This is pending fixes for things that are going to get merged in 6.7.
This time around it's merely a functional test for a locking relaxation
in the xfs FICLONE implementation.

v2: implement review suggestions
v3: add more review tags

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
generic: test reads racing with slow reflink operations

configure.ac              |   1 +
include/builddefs.in      |   1 +
m4/package_libcdev.m4     |  13 ++
src/Makefile              |   4 +
src/t_reflink_read_race.c | 339 ++++++++++++++++++++++++++++++++++++++++++++++
tests/generic/1953        |  75 ++++++++++
tests/generic/1953.out    |   6 +
7 files changed, 439 insertions(+)
create mode 100644 src/t_reflink_read_race.c
create mode 100755 tests/generic/1953
create mode 100644 tests/generic/1953.out

