Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02454C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCPTTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCPTTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:19:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCA7A54D0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F49FB82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5931EC433EF;
        Thu, 16 Mar 2023 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994318;
        bh=haDAEHewDro+bwTv0uEoZCOMac2rD1pMZaNVmq2nkK4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XlOfAcxCBh2/x6WIr6bSrhzS862NHrGtEGaldyQFl5Erury7+POkETgLC4xlobe51
         Iid7715R98aDWy8PYbbKZ5w+spCYYr+gIE+cv9dQRryd1YhWg75K+gSNNjnr1wOHZz
         fOFQs4uRWPfV57pw/eo4GpfGr7YgTMPTnkzr/CBmT+hRyavIYvgmW0Nc51gRRUggS+
         clrU1/KvUkh9GtF1/leh6HH/SbWkDz2tZCZZ6rtogDU0Y7YyqW+c6gxA/kyNv2E2EI
         OMVWIhsq5LPEAn/eBxU80XDAnv1rV0YDuOcm6/mF1fFYy92FbfVLfxecFE1E2fyDN+
         1ik4xEqFiQwGw==
Date:   Thu, 16 Mar 2023 12:18:38 -0700
Subject: [PATCHSET v10r1d2 0/5] xfsprogs: bug fixes for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416457.16836.2981078472584318439.stgit@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains the accumulated bug fixes from Darrick to make
fstests pass and online repair work.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-bugfixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-bugfixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-bugfixes
---
 io/parent.c              |   22 +++++++--------
 libfrog/pptrs.c          |   36 ++++++++++++------------
 libfrog/pptrs.h          |    4 +--
 libxfs/libxfs_api_defs.h |    3 +-
 libxfs/xfs_da_format.h   |   11 +++++++
 libxfs/xfs_fs.h          |   69 +++++++++++++++++++++-------------------------
 libxfs/xfs_parent.c      |   47 +++++++++++++++++++++++++++----
 libxfs/xfs_parent.h      |   24 +++++++---------
 mkfs/proto.c             |   12 ++++----
 9 files changed, 131 insertions(+), 97 deletions(-)

