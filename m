Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DEFC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBPU3f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBPU3e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:29:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3795F196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:29:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C887660C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B38C433D2;
        Thu, 16 Feb 2023 20:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579373;
        bh=EkT0fv/MR9/8rKRsN7K9WrdQN4hA1v22w++7ayHwWio=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=X3+jOR66eFJ5KuQl36eFUEYQAJB+wKzV8Lk/uhNmxnMtJ1hdfo+qafTDmTL2zzWjN
         LxEqGgvjs+Qbv626utfLHe5utLxKDkSSSSVEuvQQyJ4zHIGsNU1JCuUbmWNzJ7t6To
         u0dwDE2kH3opbejWVvKe0cRL/Nt2/XLCzXt4VxAWMr/sEdrIHdtk9Mle2j9wb4cMa0
         8aJVYVHxJ1f0Q93PK8n+G4stheR1XafsHKWIun70/EIs1BPNuZWtzY+h/ZX4R8l6IU
         8VZkSfpuKgT8wp0HarF67/QbJ0z0bHrumIN4OK3vOeCyADfH6wYIbbz9h5EfD4p+P3
         l+x/pZqL2bPaA==
Date:   Thu, 16 Feb 2023 12:29:32 -0800
Subject: [PATCHSET v9r2d1 0/6] xfsprogs: tool fixes for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879895.3476911.2211427543938389071.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a bunch of tooling changes for the parent pointers code.  The
only new feature here is to decode the parent pointer xattr name in
xfs_db so that we can interpret (and someday fuzz) them.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-toolfixes
---
 db/attr.c                |   31 ++++++++++++++++++++++
 db/attrshort.c           |   25 ++++++++++++++++++
 db/metadump.c            |   34 +++++++++++++++++-------
 libxfs/init.c            |    4 +++
 libxfs/libxfs_api_defs.h |    4 +++
 libxfs/util.c            |   14 ++++++++++
 mkfs/proto.c             |   65 +++++++++++++++++++++++++++++++++-------------
 scrub/phase6.c           |   13 ++++++++-
 8 files changed, 161 insertions(+), 29 deletions(-)

