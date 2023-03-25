Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC47C6FD1F
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 18:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjCYSUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 14:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYSUx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 14:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99988D310
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 11:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D437B80765
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 18:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF55AC433EF;
        Sat, 25 Mar 2023 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679768447;
        bh=Bt7Zubslxqq650Nxgjcs5YitxV11mGDlEYpbtbIiEb8=;
        h=Date:From:To:Cc:Subject:From;
        b=SnucUot5ET85z+R2VGA/HCdMXLvvOEHPAnXmI9ftS1pfmbkEmvBi5UZmolPDUXLkA
         PVeM/n4jMqSXgqJw4paHxJ2I0k7ECx2SNjeZAh6mHloCHDqbbDqRWn9wnkRiigfWwD
         IdeKcG17SBooMu8PfG2aOVYZvEUDGymPqwGeilRrSVj3KeOX5NwkbEuTP4imjvbqP1
         dGM7nwZvNQz0D70fEqu1+AeU9CIy8IiayjLgOZ3QAsFKPyBva3ntaGL5WWsmYxXdmt
         O87JBr2AwKQgqRCJmoWCo5XdgqvOoMArRFPvZVCWs6997qsiawaRuqDViPGYGWPRh1
         zew2yUjzIaz2g==
Date:   Sat, 25 Mar 2023 11:20:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 1/3] xfs: bug fixes for 6.3-rc2
Message-ID: <167976583114.986322.11327553276111503462.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for 6.3-rc2.  I've gotten well
behind on sending bugfixes, due to ongoing distractions, alas.  This
batch started with some debugging enhancements to the new allocator
refactoring that we put in 6.3-rc1 to assist developers in rebasing
their dev branches.

As for more serious code changes -- there's a bug fix to make the
lockless allocator scan the whole filesystem before resorting to the
locking allocator.  We're also adding a selftest for the venerable
directory/xattr hash function to make sure that it produces consistent
results so that we can address any fallout as soon as possible.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 8ac5b996bf5199f15b7687ceae989f8b2a410dda:

xfs: fix off-by-one-block in xfs_discard_folio() (2023-03-05 15:13:23 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-3

for you to fetch changes up to 3cfb9290da3d87a5877b03bda96c3d5d3ed9fcb0:

xfs: test dir/attr hash when loading module (2023-03-19 09:55:49 -0700)

----------------------------------------------------------------
Fixes for 6.3-rc2:

* Add a few debugging assertions so that people (me) trying to port
code to the new allocator functions don't mess up the caller
requirements.
* Relax some overly cautious lock ordering enforcement in the new
allocator code, which means that file allocations will locklessly
scan for the best space they can get before backing off to the
traditional lock-and-really-get-it behavior.
* Add tracepoints to make it easier to trace the xfs allocator
behavior.
* Actually test the dir/xattr hash algorithm to make sure it produces
consistent results across all the platforms XFS supports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: try to idiot-proof the allocators
xfs: walk all AGs if TRYLOCK passed to xfs_alloc_vextent_iterate_ags
xfs: add tracepoints for each of the externally visible allocators
xfs: test dir/attr hash when loading module

fs/xfs/Makefile           |   1 +
fs/xfs/libxfs/xfs_alloc.c |  36 ++-
fs/xfs/xfs_dahash_test.c  | 662 ++++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/xfs_dahash_test.h  |  12 +
fs/xfs/xfs_super.c        |   5 +
fs/xfs/xfs_trace.h        |   7 +
6 files changed, 722 insertions(+), 1 deletion(-)
create mode 100644 fs/xfs/xfs_dahash_test.c
create mode 100644 fs/xfs/xfs_dahash_test.h
