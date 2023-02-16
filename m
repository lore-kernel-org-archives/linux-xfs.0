Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49DDC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjBPUbJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBPUbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:31:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50C5196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:31:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6102960A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC4AC433EF;
        Thu, 16 Feb 2023 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579466;
        bh=+rZg480yEumHsPko63FAzgUk6897qrfYGIwwkg0QfSM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hqtJCxBk/MscbLky+0Ll9udalR2mhzYojTLSrw9nYNWzg0pHeAQQWd0p+XPHGPF6G
         lA+/jqe5iLXUfBDrt6LqmyxkR5ZX7FdaPXKF9KrEENImvqc2pRT5bBefkgT24REy7f
         lRsUmG3x3dT20+Pb5yTSUZm6TcIjtutKmp4BtCjLkhxCoJfc8yODeUSSOeNtCd6Elo
         9Mo11nc4WAvB0N7G0RP+BBU+eI/6vVHPzE1BF5bZ2ZGKaLeAaKq8h03MTKuu1EzwtB
         BHHiVThhQdVZ+o2tyRFMZRRYNtutMXgFVHsxVccanFCYVS9mQBEgcE/lvFHbf3aWv+
         ytDpr1kcnFN0Q==
Date:   Thu, 16 Feb 2023 12:31:06 -0800
Subject: [PATCHSET v9r2d1 0/8] xfs_repair: support parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881963.3477807.5005383731904631094.stgit@magnolia>
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
 repair/listxattr.c       |  283 ++++++++++++
 repair/listxattr.h       |   15 +
 repair/phase6.c          |   57 ++
 repair/pptr.c            | 1111 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h            |   17 +
 repair/strblobs.c        |  215 +++++++++
 repair/strblobs.h        |   22 +
 11 files changed, 1737 insertions(+), 7 deletions(-)
 create mode 100644 repair/listxattr.c
 create mode 100644 repair/listxattr.h
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h

