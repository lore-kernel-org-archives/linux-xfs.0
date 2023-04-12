Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B41C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDLDtc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLDtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FC440C1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C6D62D91
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E52FC433EF;
        Wed, 12 Apr 2023 03:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271369;
        bh=ogJWvQIKL0uYE3EJ8MYU4KLD/z1maE7uiyQ2o92oOuU=;
        h=Date:Subject:From:To:Cc:From;
        b=jkpI+UB5etu2dV5pKJZXke8NiL4xDw3CThHDsm98trdmL5YhwOoDUmndDyLZlGyWu
         WSsbEDwPwxJV8PuN8ZqAE9ORz6kxBtQKu5/CiiX6iAPSFsahfXRrxwTLs49HdHaqGc
         Dcr33NdMD8Z67k1WoarPraxFONIZbE2HTAkIibjtGXdoR2gBYt3zlzXf5ONO5sjdi0
         EB49gFEx5D12JYAy9u/FFOKIkoVhR2NVHgJV4VuTZhfGMeUyJiESc94BLgXN6Cf5p7
         GQpuxl35zcBZZux+lVTyt7QPQROVoV4kc6LZK2WqhsR5d8B84PxFtQ5n4yqgtovZhd
         eK13saFN6gi1w==
Date:   Tue, 11 Apr 2023 20:49:29 -0700
Subject: [GIT PULL 18/22] xfs: clean up memory management in xattr scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127095443.417736.15033228784686723319.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 1c1646afc96783702f92356846d6e47e0bbd6b11:

xfs: check for reverse mapping records that could be merged (2023-04-11 19:00:28 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-fix-xattr-memory-mgmt-6.4_2023-04-11

for you to fetch changes up to 44af6c7e59b12d740809cf25a60c9f90f03e6d20:

xfs: don't load local xattr values during scrub (2023-04-11 19:00:35 -0700)

----------------------------------------------------------------
xfs: clean up memory management in xattr scrub [v24.5]

Currently, the extended attribute scrubber uses a single VLA to store
all the context information needed in various parts of the scrubber
code.  This includes xattr leaf block space usage bitmaps, and the value
buffer used to check the correctness of remote xattr value block
headers.  We try to minimize the insanity through the use of helper
functions, but this is a memory management nightmare.  Clean this up by
making the bitmap and value pointers explicit members of struct
xchk_xattr_buf.

Second, strengthen the xattr checking by teaching it to look for overlapping
data structures in the shortform attr data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (12):
xfs: xattr scrub should ensure one namespace bit per name
xfs: don't shadow @leaf in xchk_xattr_block
xfs: remove unnecessary dstmap in xattr scrubber
xfs: split freemap from xchk_xattr_buf.buf
xfs: split usedmap from xchk_xattr_buf.buf
xfs: split valuebuf from xchk_xattr_buf.buf
xfs: remove flags argument from xchk_setup_xattr_buf
xfs: move xattr scrub buffer allocation to top level function
xfs: check used space of shortform xattr structures
xfs: clean up xattr scrub initialization
xfs: only allocate free space bitmap for xattr scrub if needed
xfs: don't load local xattr values during scrub

fs/xfs/scrub/attr.c  | 306 ++++++++++++++++++++++++++++++++++++---------------
fs/xfs/scrub/attr.h  |  60 ++--------
fs/xfs/scrub/scrub.c |   3 +
fs/xfs/scrub/scrub.h |  10 ++
4 files changed, 239 insertions(+), 140 deletions(-)

