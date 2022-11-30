Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD2FC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 17:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiK3RWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 12:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiK3RWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 12:22:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119A72667
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 09:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A59F961D1F
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 17:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1357EC433C1;
        Wed, 30 Nov 2022 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669828962;
        bh=g5XFhh7NSZEww4dPobhLa6LQgCs7WzDTqZAcHv+r8+c=;
        h=Date:From:To:Cc:Subject:From;
        b=elw+xLeVE1mozLf7JQyeUI7PW28/9EwpbnDySnnZa+4nWn/nV4FDLT3QCRcJh1x0I
         KZHk4/vXfrDu8b5NS4KvC57bSopX/7vTctIeul8epqsAq4iV0gNwrfU4WPgOXf0Is8
         OMlsjjMJ60Z53/UjivfQtCSiU3khOLNDvTAkK+bnDRuDMJlmdIFjr2jc3MbpPKcDas
         ottvXOJE1GmV8l8WAHg4jFxsrGj1RDWzpevALVBmlwxp0+DIqmT9EKEHqivBjDSo9/
         TEr6yPYCJfu00ukK4VZumjtyOkixJnGt4L68RXgexPeyUXPXs6cxt0PVzD6aqoShlK
         6cRgrbhJyUiVg==
Date:   Wed, 30 Nov 2022 09:22:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, hsiangkao@linux.alibaba.com,
        linux-xfs@vger.kernel.org
Subject: [GIT PULL 2/2] xfs: various fixes for 6.2
Message-ID: <166982875191.4097590.4367526229585431291.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Please pull this branch with changes for xfs for 6.2-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 254e3459285cbf2174350bbc0051e475e1bc5196:

xfs: add debug knob to slow down write for fun (2022-11-28 17:54:49 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/random-fixes-6.2_2022-11-30

for you to fetch changes up to 4c6dbfd2756bd83a0085ed804e2bb7be9cc16bc5:

xfs: attach dquots to inode before reading data/cow fork mappings (2022-11-30 08:55:18 -0800)

----------------------------------------------------------------
xfs: various fixes for 6.2

This is an assorted collection of bug fixes that have been bundled
together.  The first patch fixes a metadump corruption vector resulting
from a three-way race between a slow-running blkid process, the kernel
mounting, changing, and unmounting the fs, and xfs_db reading stale
block device pagecache contents.

The middle two patches address gcc warnings.

The final patch fixes a subtle corruption bug wherein making a delalloc
reservation on a filesystem with quotas enabled would sample the data
mapping, try to attach dquots, unlock the inode to attach the dquots,
relock the inode, and fail to reverify the sampled data.  If another
process updated the data mapping while the inode was unlocked, the
reservation would proceed with stale data and corrupt the data fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: invalidate block device page cache during unmount
xfs: use memcpy, not strncpy, to format the attr prefix during listxattr
xfs: shut up -Wuninitialized in xfsaild_push
xfs: attach dquots to inode before reading data/cow fork mappings

fs/xfs/xfs_buf.c       | 1 +
fs/xfs/xfs_iomap.c     | 8 ++++----
fs/xfs/xfs_trans_ail.c | 4 +++-
fs/xfs/xfs_xattr.c     | 2 +-
4 files changed, 9 insertions(+), 6 deletions(-)
