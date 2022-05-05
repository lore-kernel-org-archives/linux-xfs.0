Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02196C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiEEQJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381689AbiEEQIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E497E56F95
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4C2CB82DEE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6D3C385A8;
        Thu,  5 May 2022 16:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766709;
        bh=7YLdkT8eIGANwvu4TCO8FaZkQYJItGpmNjIR2aVGGm4=;
        h=Subject:From:To:Cc:Date:From;
        b=IJStMvZwmfYzCrFO2PaO4ZNJC9c9mmNJ4GNRazNSIBksOreX/7QQKfQeGq2LY8jBQ
         93Zz3MU6vBQww9upunwUmx+FlaIdBO9cYrSZNVsZWhsqBmIssbZGKFCbpWfL2RWMCb
         NPnrZLFtPxfSWBQQaB8BOPrFxuQWzlpYzeCxlaMHnHb6vLBidfVLcug+ya3K1SkBsF
         IdFOOaL123ER4DBy8oRuDB3a0a3i03Nx/5gj8RSChN8NMfdigSFHZ418aQIWlrP8pT
         wHMENM1TG56zvhg1Fxd/ohZK3mzKOgR02bPvjf9488s7AZKnG6iJHlGX3XoJwg0nNF
         +tbXWNeOUaOwQ==
Subject: [PATCHSET 0/6] mkfs: various bug fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:08 -0700
Message-ID: <165176670883.248587.2509972137741301804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes numerous bugs in mkfs with the validation and stripe
aligning behavior of internal log size computations.  After this, we
don't allow overly large logs to bump the root inode chunk into AG 1,
nor do we allow stripe unit roundup to cause the format to fail.
There's also a fix for mkfs ignoring the gid in the user's protofile
when the parent is setgid.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-fixes
---
 include/xfs_inode.h      |   11 +++-
 libxfs/libxfs_api_defs.h |    1 
 libxfs/util.c            |    3 +
 mkfs/proto.c             |    3 +
 mkfs/xfs_mkfs.c          |  121 +++++++++++++++++++++++++++++++++++-----------
 5 files changed, 105 insertions(+), 34 deletions(-)

