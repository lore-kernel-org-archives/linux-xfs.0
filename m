Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69302C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjEZAeN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbjEZAeN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:34:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5475199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D9C164B87
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A224EC433D2;
        Fri, 26 May 2023 00:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061248;
        bh=tT8ODD3qYThvpOBEewZjxvanOcS8WBegLljrWGxTNks=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EQqynS98D+4psMpHHL2inbyxVWrUUnIaFZVacDAJOLUzUHcLW61g7gkgKD16GTmMe
         AoYofHMswsu9Tnd4QpDBZULlCR6mFmFXFOyiJwC47aKLzgu6QvX5f+Hcs8qMLuadJD
         uGiEvB98mLlL5XZRaHgWEY0/fY14qYDq8CUQMy9i/j8vHHeGC6pR/3quYDEfG0fYcV
         NLJL0cCkAzIoofxQFoLBCHWVeNYnwEFha1NEDzQqKWg7vkR51honD5iL/hMbHV6rWX
         7O9zdKRmJSrxXHNcInH3RDt0yyGrq3rgLpyqQe2ArVamWKgLLNWqBHcikSHOlPH3iM
         pXBPsf+g4DLzw==
Date:   Thu, 25 May 2023 17:34:08 -0700
Subject: [PATCHSET v25.0 0/2] xfs: support attrfork and unwritten BUIs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506064221.3734210.16655685789262733930.stgit@frogsfrogsfrogs>
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

In preparation for atomic extent swapping and the online repair
functionality that wants atomic extent swaps, enhance the BUI code so
that we can support deferred work on the extended attribute fork and on
unwritten extents.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=expand-bmap-intent-usage

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=expand-bmap-intent-usage
---
 fs/xfs/libxfs/xfs_bmap.c |   49 ++++++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++--
 fs/xfs/xfs_bmap_item.c   |    3 ++-
 fs/xfs/xfs_bmap_util.c   |    8 ++++----
 fs/xfs/xfs_reflink.c     |    8 ++++----
 5 files changed, 33 insertions(+), 39 deletions(-)

