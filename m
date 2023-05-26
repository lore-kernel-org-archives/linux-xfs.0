Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1563C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbjEZA35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241377AbjEZA3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:29:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325D2194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCABA64B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BD9C433D2;
        Fri, 26 May 2023 00:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685060983;
        bh=fx1Y+osgK1kD1kEfnBWpvU4mwWaEjdQkpdZuiV2chJM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cVc/WKWIpJRcWKj5aTfa4QGb0xw5aNfXhp0MbICTUEK019ZbC2MFenMrS2iiK7jzR
         oW1zkCA9mJYQL6vLXf52QehFoRPPlHYt+oStdb/yItUVeY0dhlTIpuhynJBG/rJ0tG
         JQFFlRjX8xHi7Y8t8MaLDNOFsS6BcemLrxF7Fl8Yo+gTlefEPPcflDkCdDRdWTMYer
         Y1ELGpzmuzysOmujI/V/N10Ta4vQSo1ZfPadL9/SGUQvW+10i6U+IxAZX3tv7DXHE0
         6neUk5zLi/Ap/a72bYdNuPVu76wlFlKNBXXKwIh0iVux50jcBLrIKAoTQ79YqKlfCW
         sOsGU+i+l7sEw==
Date:   Thu, 25 May 2023 17:29:42 -0700
Subject: [PATCHSET v25.0 0/2] xfs: force rebuilding of metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
---
 fs/xfs/libxfs/xfs_fs.h |    6 +++++-
 fs/xfs/scrub/common.h  |   12 ++++++++++++
 fs/xfs/scrub/scrub.c   |   18 ++++++++++++------
 fs/xfs/scrub/trace.h   |    3 ++-
 4 files changed, 31 insertions(+), 8 deletions(-)

