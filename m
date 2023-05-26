Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E3FC7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjEZAe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZAe5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB8F19A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2113E64C01
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C80DC4339B;
        Fri, 26 May 2023 00:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061295;
        bh=cPbXAlWCBP4Siuq314k3CJPz2wd5A1yLpfbRd7uAYQk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jan++OdjsT56+tGis6EtyKvg8wQtZjqv22XXRl2/VOEc8+cFCL8Qtx4OdzZUys1gQ
         ZGTY6H4qA5ZEZ4SR2WhIRJX1rUUnmJOVeXsXthxo/oZ2D8LOCU8/YuOwMRBYWL+g4v
         KL0Kor45nnXA20WPP72qKx7Npi1gmWTZiiqpAqTbcvFVt1U8mNMZVjBiXWPnYrEBuY
         AlL71Uf1mWwXruE/foD7FGSpXNBGS6bvQdkLHIH9IVXRfrhNaTmkEk5T8mwQH2aWMu
         533E74CeMFNdIZQjpP1WUtww1yf5hlKhXJ3hBc3QUw5sYxSFCVAIu6VA1Fw6x46tyT
         +rUx93h9fgPeA==
Date:   Thu, 25 May 2023 17:34:55 -0700
Subject: [PATCHSET v25.0 0/4] xfs: create temporary files for online repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506065638.3735098.13625967488642973015.stgit@frogsfrogsfrogs>
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

As mentioned earlier, the repair strategy for file-based metadata is to
build a new copy in a temporary file and swap the file fork mappings
with the metadata inode.  We've built the atomic extent swap facility,
so now we need to build a facility for handling private temporary files.

The first step is to teach the filesystem to ignore the temporary files.
We'll mark them as PRIVATE in the VFS so that the kernel security
modules will leave it alone.  The second step is to add the online
repair code the ability to create a temporary file and reap extents from
the temporary file after the extent swap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-tempfiles
---
 fs/xfs/Makefile         |    1 
 fs/xfs/scrub/parent.c   |    2 
 fs/xfs/scrub/reap.c     |  427 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/reap.h     |   21 ++
 fs/xfs/scrub/scrub.c    |    3 
 fs/xfs/scrub/scrub.h    |    4 
 fs/xfs/scrub/tempfile.c |  251 ++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |   28 +++
 fs/xfs/scrub/trace.h    |   96 +++++++++++
 fs/xfs/xfs_export.c     |    2 
 fs/xfs/xfs_inode.c      |    3 
 fs/xfs/xfs_inode.h      |    2 
 fs/xfs/xfs_itable.c     |    8 +
 13 files changed, 822 insertions(+), 26 deletions(-)
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h

