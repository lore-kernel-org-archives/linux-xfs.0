Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCBFC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiL3XHA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbiL3XG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:06:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44A61D0E9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6362D61BB9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC93EC433EF;
        Fri, 30 Dec 2022 23:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441617;
        bh=UUcZ97Ej3MmlUixyuGRXlVfKg0ozF7LDXw8yKJjo3dQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VRgJnocAvGFMMePydRQzgdnlmhlYPuh0E3DzTZvXecms9AhsdP0qMED1pTsZyEeKO
         AeQOcpIVIkya0t3RyaL1bVMtovlGplkMEad3sXRIRAjCF+Xr0Dtyxs3TeH0yVGnpQo
         MRQnpVFLWQerx376yfqgf6i2XcoFE5kgfaAluGnRmq63PcxH/0w8MjWDBKPoX+wgaD
         NSYFUAmsGzZvmhpnZ89z7AHV5BELcW8AwUhs5GXik7dgqmDqiFT+tXs5jXyObFA91Y
         taN4Ta5r/X8W73tC/epp9nGGVba8qoTYtAmJ9/VrfksWZxvmW2OKqfMCV+p3jspMYk
         BCDv9ofID3syg==
Subject: [PATCHSET v24.0 0/9] xfs: set and validate dir/attr block owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:08 -0800
Message-ID: <167243844821.700244.10251762547708755105.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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

