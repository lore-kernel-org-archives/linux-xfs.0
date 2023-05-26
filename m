Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121D6C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbjEZAfb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbjEZAfa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:35:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD5F199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47E1C60B6C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46F1C433D2;
        Fri, 26 May 2023 00:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061326;
        bh=UUcZ97Ej3MmlUixyuGRXlVfKg0ozF7LDXw8yKJjo3dQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MOmDGSRGpW5lWEbusMbgKAdCdn1+NdwCudcCDf8he92PDXZO0ZyF3Xm7G1AqBGLAL
         DcgLV44M92aICC/4oRIbYA13kauzmxd139+8GZguXwqGa2iIjsMMmpltsdve9gkQb2
         fCzB+JAUEv4o1G+1HSIxeUdLEFKjtGT7NnDhET1tfKxKkktO1hsSJY5yyxZbH9c6UO
         4XnA3PhPni2aIkg643Z449nHKzZ4qAe+OaCyMEvV//6FrAnuex7SmPWcp+JKiDxMKU
         OUltWPDt0zRouVKMS45GPNdxqP78fcFjksvRw0bWATElUirrsVbgULHxf5eL1iuItl
         lSBncU33WAS7g==
Date:   Thu, 25 May 2023 17:35:26 -0700
Subject: [PATCHSET v25.0 0/9] xfs: set and validate dir/attr block owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
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

There are a couple of significant changes that need to be made to the
directory and xattr code before we can support online repairs of those
data structures.

The first change is because online repair is designed to use libxfs to
create a replacement dir/xattr structure in a temporary file, and use
atomic extent swapping to commit the corrected structure.  To avoid the
performance hit of walking every block of the new structure to rewrite
the owner number before the swap, we instead change libxfs to allow
callers of the dir and xattr code the ability to set an explicit owner
number to be written into the header fields of any new blocks that are
created.  For regular operation this will be the directory inode number.

The second change is to update the dir/xattr code to actually *check*
the owner number in each block that is read off the disk, since we don't
currently do that.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=dirattr-validate-owners

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=dirattr-validate-owners
---
 fs/xfs/libxfs/xfs_attr.c        |   10 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   59 +++++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   13 +--
 fs/xfs/libxfs/xfs_bmap.c        |    1 
 fs/xfs/libxfs/xfs_da_btree.c    |  168 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h    |    3 +
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2.h        |    4 +
 fs/xfs/libxfs/xfs_dir2_block.c  |   44 ++++++----
 fs/xfs/libxfs/xfs_dir2_data.c   |   17 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   99 ++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c   |   44 ++++++----
 fs/xfs/libxfs/xfs_dir2_priv.h   |   11 +--
 fs/xfs/libxfs/xfs_swapext.c     |    7 +-
 fs/xfs/scrub/attr.c             |    1 
 fs/xfs/scrub/dabtree.c          |    8 ++
 fs/xfs/scrub/dir.c              |   23 +++--
 fs/xfs/scrub/readdir.c          |    6 +
 fs/xfs/xfs_acl.c                |    2 
 fs/xfs/xfs_attr_item.c          |    1 
 fs/xfs/xfs_attr_list.c          |   35 +++++++-
 fs/xfs/xfs_dir2_readdir.c       |    6 +
 fs/xfs/xfs_ioctl.c              |    2 
 fs/xfs/xfs_iops.c               |    1 
 fs/xfs/xfs_trace.h              |    7 +-
 fs/xfs/xfs_xattr.c              |    2 
 27 files changed, 464 insertions(+), 119 deletions(-)

