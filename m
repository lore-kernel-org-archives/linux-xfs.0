Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6A2C83F1C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbjH2XJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbjH2XJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:09:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AACDB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B97F861E8C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281DBC433C8;
        Tue, 29 Aug 2023 23:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350564;
        bh=iRdvLn7OiHTcNFpcs09kATaYsTteIPVmpUVF6mtpNEw=;
        h=Subject:From:To:Cc:Date:From;
        b=q9GEaAx1zQ5Ka01n9wTDuKv9dpQhsyAQAQe18jeeU6FGIGTDOlAPzvuR8oK7WE+Qp
         rqFcvBGcO91dFyDMIo6aGWprBeWSjaLxAr50T71D8b/yjv+TMQ8gk9Ph0NEkTxSiQb
         VEkgYmU8pkjHlhOMBmR0bIgdFFwv/SjZERQsprRtU+ho22xSEqm0jwL4VMr7OQZpn9
         plwAgnZJCxuzcZ8I/nAE5Cx777y6LlnbydBlGumSjaDtr0ohrgHKpKE+r8r++AtoVY
         o2AhnVmbVgaEaLFC+IrzRDN2UF+7ZM2kGlcJuBR1oq3VDVuQpsa/iAUTiaqjvAcyj5
         PMZTyHbEod9DQ==
Subject: [PATCHSET v2 0/2] xfs: fix ro mounting with unknown rocompat features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:09:23 -0700
Message-ID: <169335056369.3525521.1326787329447266634.stgit@frogsfrogsfrogs>
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

v2: change direction of series to allow log recovery on ro mounts

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-ro-mounts-6.6
---
 fs/xfs/libxfs/xfs_sb.c |    3 ++-
 fs/xfs/xfs_inode.c     |   14 ++++++++++----
 fs/xfs/xfs_log.c       |   17 -----------------
 3 files changed, 12 insertions(+), 22 deletions(-)

