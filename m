Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB39C77B6C
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 18:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbjDFSKl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 14:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDFSKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 14:10:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A6935B1;
        Thu,  6 Apr 2023 11:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41294617E2;
        Thu,  6 Apr 2023 18:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991CAC433D2;
        Thu,  6 Apr 2023 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680804638;
        bh=+D8dg/H/FzQ34FvNB2HlhtQ/RAIg+IxXuFgT2mmW5eA=;
        h=Date:From:To:Cc:Subject:From;
        b=DAVYyiNO8u69Lbr+vLLJPL+WpZ8RZYacH93FtQHSyfvzTKAg5nbti1Nk+6K018/gs
         MKplRIAnbYrn56Qh5pRHbXG/dZH9GVyMUxkR5Ns2mZRm8IsRUxVoFQ5Nuam3qtxkPO
         PMMgZKULUJUmPhJga2gqXiYOswUTyOOJIFGKxEpGC+wq5pku6L2D3Q/GfLja1uVt8e
         Ta8tocSPwDyplx5i9B0g6S3STuJZHESoMwybDuqKVl7h36M2MDz4CioUaKWIGx2VJZ
         M6/fzpKxla0cNlOo5BsQBZkV2MSZYxFvwop09x60+fRK4OGBnYU/ic2DEJ2ltTLXSG
         ThhvsZpA3x4xw==
Date:   Thu, 6 Apr 2023 11:10:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [PATCHSET DELUGE v11] xfs: Parent Pointers
Message-ID: <20230406181038.GA360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

This submission contains all of the changes to the parent pointers
patchset that I've been working since last month's deluge.  The kernel
and xfsprogs patchsets are based on Allison's v10 tag from some time
ago.  To recap Allison's cover letter:

"The goal of this patch set is to add a parent pointer attribute to each
inode.  The attribute name containing the parent inode, generation, and
directory offset, while the  attribute value contains the file name.
This feature will enable future optimizations for online scrub, shrink,
nfs handles, verity, or any other feature that could make use of quickly
deriving an inodes path from the mount point."

v11 rebases everything against 6.3-rc5, and weaves all the changes that
I had made against v10 into Allison's original series.  The new xattr
NVLOOKUP mode that I introduced for v10 is critical for handling parent
pointer attr name collisions with grace, so that has been retained from
v10.  With that in place, I've replaced the diroffset in the ondisk
parent pointer with the dirent hash of the name.

Parent pointers now look like this:

	(parent_ino, parent_gen, namehash) -> (name[])

I experimented with replacing the dahash with crc32c for this patchset
but left it out, having concluded that checksum operation has higher
overhead (thanks, crypto api!), would require someone to figure out crc
spoofing sufficiently well to keep metadump name obfuscation working,
and doesn't seem to improve collision resistance sufficiently to be
worth the added engineering cost.

As of this submission, I think this feature is ready to go once we've
merged the online repair code and rebased the online repair code to
actually commit the repaired directories.

If you want to pull the whole thing, use these links:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-drop-unnecessary
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs

--D
