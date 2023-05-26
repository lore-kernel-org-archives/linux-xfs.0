Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0972BC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbjEZAjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjEZAji (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755FDEE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1225261705
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73967C433D2;
        Fri, 26 May 2023 00:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061576;
        bh=TPbHOS3a1xbVb2NOebhTatRoBfIzvl9Wh0z3sP6VZkk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hc+qiXoL9goW04KnB07RsY71wds1ZTWoOYeA98ov2T9PV4DyBhumTLmQpmAXmY7zD
         6eHC/vrCSBPURYDvYlGu/SOR9+BiIQxJkqbkOtF2lLkc4FgHHk5du3JJq6C/E8u1YW
         UE0ccpcS4kRhk5OpMekVZINJO16iPaKFKPKTmu3AbVMvxs1Tpr8+i+Pr78ouOyE2SD
         r/mLyCeBZ4WaXk888QJGCR0/Ea8+E454T5UvM8vhbZqQ77T+aSpf/oL69uI6iXo9vX
         OJCEebn5gTyAiQa3/cDnW2iGsIBJUbGGu7vwaB9b4+YtBDI/pI/yiAZT1+Wcc/5gYN
         7+SSRo2UBtE1A==
Date:   Thu, 25 May 2023 17:39:36 -0700
Subject: [PATCHSET v25.0 0/7] xfs_scrub: use free space histograms to reduce
 fstrim runtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
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

This patchset dramatically reduces the runtime of the FITRIM calls made
during phase 8 of xfs_scrub.  It turns out that phase 8 can really get
bogged down if the free space contains a large number of very small
extents.  In these cases, the runtime can increase by an order of
magnitude to free less than 1% of the free space.  This is not worth the
time, since we're spending a lot of time to do very little work.  The
FITRIM ioctl allows us to specify a minimum extent length, so we can use
statistical methods to compute a minlen parameter.

It turns out xfs_db/spaceman already have the code needed to create
histograms of free space extent lengths.  We add the ability to compute
a CDF of the extent lengths, which make it easy to pick a minimum length
corresponding to 99% of the free space.  In most cases, this results in
dramatic reductions in phase 8 runtime.  Hence, move the histogram code
to libfrog, and wire up xfs_scrub, since phase 7 already walks the
fsmap.

We also add a new -o suboption to xfs_scrub so that people who /do/ want
to examine every free extent can do so.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram
---
 db/freesp.c          |   83 +++-------------
 libfrog/Makefile     |    2 
 libfrog/histogram.c  |  252 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h  |   54 +++++++++++
 man/man8/xfs_scrub.8 |   31 ++++++
 scrub/phase7.c       |   47 +++++++++
 scrub/phase8.c       |   75 ++++++++++++++-
 scrub/spacemap.c     |   11 +-
 scrub/vfs.c          |    4 +
 scrub/vfs.h          |    2 
 scrub/xfs_scrub.c    |   77 +++++++++++++++
 scrub/xfs_scrub.h    |   16 +++
 spaceman/freesp.c    |   93 +++++-------------
 13 files changed, 590 insertions(+), 157 deletions(-)
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h

