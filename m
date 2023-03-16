Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5524CC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjCPTT1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCPTTZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:19:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB2824BEE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91986620DC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA81C433D2;
        Thu, 16 Mar 2023 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994334;
        bh=hbdpsb5Bg+sois3AwRaHZC1+x3EyM5zL81RrUu4bEZ4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=avaJDdBMIhfMtulpjT5dFUU2sq5alkFB+8Wse86h1kc0LtdMYEto81Hu5sFWFUSOs
         ew6rB209tHjGqkmF7VTca6lnOmMzhGuS3Zga9f/oCxqN4IR/kLGLo9f1GmG1shc/pc
         ibR6taFjwJqZXs3b/QeQ2AMGD1F5KdGoU9nlEAmBvifh1n4oeWpGu0stEE1hFvVZ3r
         EEz3/bgWjLDjQF9lR7FlAvAbl/b1R1+xcs1dm/ASDz9ncrDHsrFTfY4O2Ilj1PB7Kv
         vJXWFX41qk84qtzNb6cE3EA2entW5vx3qfNEb6swBmZ9R16qP1Os6N1p4INzOXOazO
         48O4Dd10hLtjg==
Date:   Thu, 16 Mar 2023 12:18:53 -0700
Subject: [PATCHSET v10r1d2 0/4] xfs_logprint: clean up attri/pptr dumping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416793.17000.8105050564560343480.stgit@frogsfrogsfrogs>
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

This series starts by reverting all the recent changes to log_redo.c
because there's a lot of duplicated code and overly complicated pointer
handling.  Next, we address a few missing pieces in the attri log item
decoding, and finish the series by adding proper decoding of parent
pointers embedded in an xattri log intent item.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-logprint-cleanups
---
 libxfs/libxfs_api_defs.h |    1 
 logprint/log_redo.c      |  266 +++++++++++++++++-----------------------------
 logprint/logprint.h      |    5 -
 3 files changed, 102 insertions(+), 170 deletions(-)

