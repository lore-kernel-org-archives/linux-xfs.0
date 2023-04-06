Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0D6C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbjDFTQS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDFTQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:16:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A7FC1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB7F644B0
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DC6C433D2;
        Thu,  6 Apr 2023 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808575;
        bh=8HmJ05qbtoJnYddPMbuFwAmj+rlh0IqQICOFcWcOuaM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Fi/hT3s1/wnx0/aUV2bRRMiKy2bgyP4vzQagButzeuJFlak2bCAHPSDNfZZF/BgBE
         IAin99A8JJAfoI1xZqbYIiLQKzRzwTkB8Qq/Vo4QAiSOCjwh3n1pWJpxSgvfqJh8ue
         fCxI4jetFeCa4iwWYkAJwpPDQIR5NY38IB1XdduMo9XrJaIBMVSpKqVnuj2ZcdjdCv
         C8wBce7RVjTI1LeNOSo0Bn3lr/zhB0QAQCdSgn/a0NxUw8XSnurSW9vcTjGlNyK9z+
         bzZPi9frqkOv16TWJ9KYg947QSplK4zppjtqnIN69L4dSwmhEoUcdm89aeRM5/nMi6
         iP6xx8g+bVDLw==
Date:   Thu, 06 Apr 2023 12:16:15 -0700
Subject: [PATCHSET v11 0/7] xfs_repair: support parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset implements offline checking and repair for parent
pointers.  We do this rather expensively by constructing a (per-AG)
master list of parent pointers for inodes rooted in that AG.  Next, we
walk each inode of that AG, construct an index of that file's parent
pointers, and then compare the file index against the relevant part of
the master index.  From there we can sync the parent pointers as needed.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-offline-repair
---
 libxfs/libxfs_api_defs.h |    7 
 libxfs/xfblob.c          |    9 
 libxfs/xfblob.h          |    2 
 repair/Makefile          |    6 
 repair/listxattr.c       |  271 ++++++++++
 repair/listxattr.h       |   15 +
 repair/phase6.c          |   41 +
 repair/pptr.c            | 1271 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h            |   17 +
 repair/strblobs.c        |  212 ++++++++
 repair/strblobs.h        |   24 +
 11 files changed, 1873 insertions(+), 2 deletions(-)
 create mode 100644 repair/listxattr.c
 create mode 100644 repair/listxattr.h
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h

