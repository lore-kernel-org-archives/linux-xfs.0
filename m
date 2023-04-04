Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA896C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 23:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbjDDXQw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjDDXQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 19:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A1B1BB;
        Tue,  4 Apr 2023 16:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB4566393D;
        Tue,  4 Apr 2023 23:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261FCC433D2;
        Tue,  4 Apr 2023 23:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680650210;
        bh=M5Nbi1n2uBM0SRqNXlnIxySBmLUGpPN1CHjrNNUDvNg=;
        h=Subject:From:To:Cc:Date:From;
        b=Q4Kmm8mSTEkgNy0IK3B7WUOAn+O3j1dlMf/1bIfuapY8l1iEX2vsTMTKQtiqik1u6
         up9j+2T53rCoYBNTrf3roXHvmlyy9XMY5tmQQvHh7U2llqvZBegDfmJwxzMdYdfb2U
         s5+DSkY820C2Awlal6vnRE0YFKff0oKuPV0hKuXOCsKnEIB3GqZSnSt5t4wN/kILdX
         TdZ/YnPjhcfIo7UfkZFnlcF/pNjCc52y+T7v4abAerWGC6t2MolGUfbc5w2VgT2usF
         H1T6e7FHw8CLndn73E3HG+hy/U8hlxfvfCVDEkZqXzITOmwrzYJmqKE8FSVTEdzL3X
         qR4mzzbTe/zyA==
Subject: [PATCHSET v24.2 0/3] populate: tweaks to the filesystems created
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 04 Apr 2023 16:16:49 -0700
Message-ID: <168065020955.494608.9615705289123811403.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series makes a few adjustments to the code that creates a sample
XFS filesystem containing all types of metadata.  The first patch fixes
the btree-format xattr creation code to ensure that we'll actually end
up with such a structure.

The last two patches adjust the large directories that get created to
be a closer match for what people really create on production systems.
Most directories contain many more files than subdirectories, and the
deletion rates are generally not 50%.  As online fsck moves closer to
merging, we'd really like fstests to create XFS filesystems that are
representative of what people do with XFS.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=populate-tweaks
---
 common/populate |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 src/popdir.pl   |   15 +++++++++----
 2 files changed, 67 insertions(+), 11 deletions(-)

