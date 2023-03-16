Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE21CC7618A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 18:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCPSyS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 14:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCPSyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 14:54:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F83F7;
        Thu, 16 Mar 2023 11:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC30BB822BC;
        Thu, 16 Mar 2023 18:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72797C433D2;
        Thu, 16 Mar 2023 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678992854;
        bh=FJ8sng5s3kMYaDprv6CTxRHbfl3z9cYfBJ6EU93QkuY=;
        h=Date:From:To:Cc:Subject:From;
        b=qf8AyqkdGbZuS4e6rT2OwkTy1aauKl8UhSxh8c3+tgECulQ//pkY31pAvZQGeLq9u
         FiIsmQ+bfVHlS9xY5kEtH0+kOU7AXuPyoUag8yqpLW7m2Ss0gvoDla4uEUbi4OBRfo
         3q0N/ls+3hKXVLzTvW5j7oUxmd+ACJiZvNlhRCpUnpSfHD5hffIljoC07+a9nQ0Qv6
         t/tfLjalf2rH5OamwNwQoY9nCQB9LURE9h+/ZchLu9opNaJpo54E7Rd48qPyikeNWS
         +Bjd/SDzUUlzs2wJTyfdsbaUHPysE1Y7jIDppq9/tZ4KvqkenllU24Zp//sBssQ9HJ
         lGF0hiybLIV6Q==
Date:   Thu, 16 Mar 2023 11:54:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [RFC DELUGE v10r1d2] xfs: Parent Pointers
Message-ID: <20230316185414.GH11394@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

This deluge contains all of the additions to the parent pointers
patchset that I've been working since last month's deluge.  The kernel
and xfsprogs patchsets are based on Allison's v10 tag from last week;
the fstests patches are merely a part of my development tree.  To recap
Allison's cover letter:

"The goal of this patch set is to add a parent pointer attribute to each
inode.  The attribute name containing the parent inode, generation, and
directory offset, while the  attribute value contains the file name.
This feature will enable future optimizations for online scrub, shrink,
nfs handles, verity, or any other feature that could make use of quickly
deriving an inodes path from the mount point."

v10r1d2 rebases everything against 6.3-rc2.  I still want to remove the
diroffset from the ondisk parent pointer, but for v10 I've replaced the
sha512 hashing code with modifications to the xattr code to support
lookups based on name *and* value.  With that working, we can encode
parent pointers like this:

	(parent_ino, parent_gen, name[])

xattr lookups still work correctly, and repair doesn't have to deal with
keeping the diroffsets in sync if the directory gets rebuilt.  With this
change applied, I'm ready to weave my new changes into Allison's v10 and
call parent pointers done. :)

The online directory and parent pointer code are exactly the same as the
v9r2d1 release, so I'm eliding that and everything that was in Allison's
recent v10 patchset.  IOWs, this deluge includes only the bug fixes I've
made to parent pointers, the updates I've made to the ondisk format, and
the necessary changes to fstests to get everything to pass.

If you want to pull the whole thing, use these links:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-drop-unnecessary
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-drop-unnecessary
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-name-in-attr-key

Allison: Could you please resync libxfs in the following patches under
https://github.com/allisonhenderson/xfsprogs/commits/xfsprogs_new_pptrs_v10
please?

xfsprogs: add parent pointer support to attribute code
xfsprogs: extend transaction reservations for parent attributes
xfsprogs: parent pointer attribute creation
xfsprogs: remove parent pointers in unlink
xfsprogs: Add parent pointers to rename
xfsprogs: move/add parent pointer validators to xfs_parent

There are discrepancies between the two, which makes ./tools/libxfs-diff
unhappy.  Or, if you want me to merge my ondisk format changes into my
branches, I'll put out v11 with everything taken care of.

--D
