Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E894C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDLDqk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLDqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:46:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED69430E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8863562D90
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E149AC433EF;
        Wed, 12 Apr 2023 03:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271198;
        bh=IjfYu1hDRFq38E8hyDr0r1vIcoFFiKjhU16MlSGiocs=;
        h=Date:Subject:From:To:Cc:From;
        b=MwdooraNgh/nPUoZlxLGjwFLlRorAONCo8SbRZE/Gb39sOgWeo5zj3dbOyR+7hTHa
         /iux00rgxCT0hXvGfakpMygYRIjBeVMxIEnJU6esvJ2twx9DH3QuU9OSSrZ6wd/PZE
         hgxFjcp1NsYVtaLJELXWlFbNADKKIqP2ZzX5baIwzLgv0r8GlS9WLnxsHX54Ssa1EZ
         qc3OKC86QpLZ9sV3ViK0NYm+u2e2G44nYNCpjLhrkzsohW/LtJX216MOpn4sR9IWS1
         FBWNBMhJJPy3YgcKbBUNZ8JIdKgli6h3zrhnA5AKGAlwpQYDZxaSq1LRjUqAZG8pEA
         qYBM32/QvGS4w==
Date:   Tue, 11 Apr 2023 20:46:37 -0700
Subject: [GIT PULL 7/22] xfs: hoist scrub record checks into libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094360.417736.3162133789025574725.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 6a3bd8fcf9afb47c703cb268f30f60aa2e7af86a:

xfs: complain about bad file mapping records in the ondisk bmbt (2023-04-11 19:00:05 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-hoist-scrub-checks-6.4_2023-04-11

for you to fetch changes up to de1a9ce225e93b22d189f8ffbce20074bc803121:

xfs: hoist inode record alignment checks from scrub (2023-04-11 19:00:06 -0700)

----------------------------------------------------------------
xfs: hoist scrub record checks into libxfs [v24.5]

There are a few things about btree records that scrub checked but the
libxfs _get_rec functions didn't.  Move these bits into libxfs so that
everyone can benefit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: hoist rmap record flag checks from scrub
xfs: hoist rmap record flag checks from scrub
xfs: hoist inode record alignment checks from scrub

fs/xfs/libxfs/xfs_ialloc.c |  4 ++++
fs/xfs/libxfs/xfs_rmap.c   | 27 +++++++++++++++++++++++++++
fs/xfs/scrub/ialloc.c      |  6 ------
fs/xfs/scrub/rmap.c        | 22 ----------------------
4 files changed, 31 insertions(+), 28 deletions(-)

