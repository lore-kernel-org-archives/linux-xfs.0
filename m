Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7E6C727A0
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbjHXXWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244048AbjHXXVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:21:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8B5CEE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6628D646AB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22F6C433CA;
        Thu, 24 Aug 2023 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919295;
        bh=KffEizG+8hkqPxQ2eo7XJ6ILQb0JlXvd+WEnFa7xF70=;
        h=Subject:From:To:Cc:Date:From;
        b=nckLAYY0cpgMkmXZIu43DA9g69vcXPT424yJm3qNs3YgX3yEtPapxl+rZMvXSmAuR
         dCRmeFCaC1B3eZxlT8YbiaeXkt32+Mh6EnBRVSCpBlze80DvQ48gh2j+Bn6seANjRE
         YvYhTeCxVd31xBBFNbwufPX2zUG5hb57jKH7TGGsFSn1xbuOG2u97DY1BynROgAYOA
         Nb4Lngw6smXK30SF/21V/ZPjr/cdp1mTIu/n6spcvkci03x8elblF99xeX4CVDo6Wj
         rMdf8Z8fu64K1qPX4uRH3F5qS1kJNlL5A5mokO+UyXyOSyhy1INE79p4wKAN3DjRDK
         sgkyYeZ+A7/Rw==
Subject: [PATCHSET 0/3] xfs: fix ro mounting with unknown rocompat features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Date:   Thu, 24 Aug 2023 16:21:35 -0700
Message-ID: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave pointed out some failures in xfs/270 when he upgraded Debian
unstable and util-linux started using the new mount apis.  Upon further
inquiry I noticed that XFS is quite a hot mess when it encounters a
filesystem with unrecognized rocompat bits set in the superblock.

Whereas we used to allow readonly mounts under these conditions, a
change to the sb write verifier several years ago resulted in the
filesystem going down immediately because the post-mount log cleaning
writes the superblock, which trips the sb write verifier on the
unrecognized rocompat bit.  I made the observation that the ROCOMPAT
features RMAPBT and REFLINK both protect new log intent item types,
which means that we actually cannot support recovering the log if we
don't recognize all the rocompat bits.

Therefore -- fix inode inactivation to work when we're recovering the
log, disallow recovery when there's unrecognized rocompat bits, and
don't clean the log if doing so would trip the rocompat checks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-ro-mounts-6.6
---
 fs/xfs/xfs_inode.c       |   14 ++++++++++----
 fs/xfs/xfs_log.c         |   23 ++++++-----------------
 fs/xfs/xfs_log_priv.h    |    7 +++++++
 fs/xfs/xfs_log_recover.c |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 21 deletions(-)

