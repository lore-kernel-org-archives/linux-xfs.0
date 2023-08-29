Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE294C83F19
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbjH2XJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239389AbjH2XJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7904E9;
        Tue, 29 Aug 2023 16:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45B5A61208;
        Tue, 29 Aug 2023 23:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC5DC433C7;
        Tue, 29 Aug 2023 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350588;
        bh=zbh/KIpXaqSHN3iY1UDPombtM5lSUPOKKyjLLqYfAcU=;
        h=Subject:From:To:Cc:Date:From;
        b=l7YEYG9ghVKGUmyqzmZwGVEg9MN8BGGywB6hB8m6CXyYq/2fr1PPVaf/pJn7kxBFc
         IFjEPyf8uFF/Xg5VMaQs0JqruMeuHGEMxJs2IX4ET7VPWMmIQqr6Z/tUf0toRw4+dP
         08cU24w/CKPoUIRc0KxPTC+U7Q7mrxFALVWkraUkU6wAbMtA0sH8FzkB0djVwwP6+8
         y4NykfVImf22OFUK8GKP+tGD6luk4lGkEbG2w4O3ZHV3dYTylNobnhdzWmaLni38UF
         SVp1yp0U7FKy4of6kqMEvqk4P7OcXR9x9tdpR1v+NH2D5aC5IofECgFBIieZyGop8p
         4mQ9RJ3mQmXYQ==
Subject: [PATCHSET v2 0/2] fstests: fix ro mounting with unknown rocompat
 features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, david@fromorbit.com,
        sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:09:48 -0700
Message-ID: <169335058807.3526409.15604604578540143202.stgit@frogsfrogsfrogs>
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

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-ro-mounts
---
 tests/xfs/270     |   80 ++++++++++++++++++++++++++++++++++++++---------------
 tests/xfs/270.out |    2 +
 2 files changed, 59 insertions(+), 23 deletions(-)

