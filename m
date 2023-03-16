Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AF0C7618A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCPTS3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjCPTSX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:18:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDFE8693
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1600620EB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B6BC43443;
        Thu, 16 Mar 2023 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994287;
        bh=cmuhbCj6c1f8zGvtl3IJ3gk92vtccx7Gi8ZUpT39hQM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WXpM0UwXk3wCJXi5N3v90QcXFRO4VytIirRCosBdT07A55F9pFQ75Lub22jQ7gHRF
         R6LvfOZpDnw4GhmmnnMADYkmxjPbinze2hYOpNZarSLpLVi8TN2oGN7RnnU0i5k1ay
         eEbWMavviN+QCiRry52vA7LA9dW6M6g6b5FSnlvYi+HHedjF5GSDx7MkpF8Ls8tu6B
         JtBN9gEixtSHaOKvAGd5RAZGETAVEKvTrXG/opmjp3zX2v9j3l/rmmUdckx/JcJcST
         c8UEIwGeUxY0stCaT/KlpOgH8jzlHk0YRHqDSdldqDVvSw6i6e9P8K0w1QoCu2WcbB
         8UxrERXo/DOXQ==
Date:   Thu, 16 Mar 2023 12:18:06 -0700
Subject: [PATCHSET v10r1d2 0/2] xfsprogs: actually use getparent ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415768.16530.9685924832572537457.stgit@frogsfrogsfrogs>
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

Yikes.  The userspace parent pointers support code dates from 2017 and
is very very moldy.  This patchset moves the xfs_io filtering stuff back
to xfs_io.  It also moves the parent pointer support code to libfrog
because we don't want to expose things via libhandle until we're
absolutely sure that we want to do that.

(We probably want to do that some day.)

Finally, adapt xfs_scrub to use parent pointer information whenever it
has something to say about a file handle that it has open.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-use-getparents
---
 scrub/common.c |   21 +++++++++++++++++++++
 scrub/inodes.c |   26 --------------------------
 scrub/inodes.h |    2 --
 3 files changed, 21 insertions(+), 28 deletions(-)

