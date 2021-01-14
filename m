Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A12FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 16:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 149E223B28
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 16:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbhANQHM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 11:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbhANQHM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 11:07:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1687223B27;
        Thu, 14 Jan 2021 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610640404;
        bh=loQbUafl9WauR4qJqYIS4xpIGA8lROJ8Lt1vtJmd8qE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KgG5UpR32XGL6mhfeG0SmjQ6QoTlLVTO7FLpOe0ijuEzV7tK33tjTgrt8sekKFj7e
         /T/VzfmzLpHHRhASF+k5eKGjHzZRARLHKO9wN+XdPVAD8JE4aeDj6gpSEEEnEElPWx
         mFsonXDVfb7WhfGQzxN08lyX8OUsqBZvxR1A9gLMF8sXFOcFRaV1sKvJpmE0wg1Wm8
         iCVz0wBXIyn0yv8d7M54+HOz9ZHPBENQfMvusoKPdzb3VdLuVKKN4rfiPT7YXwuWbV
         4AqwBR1yhFnG6j43pQ6Yf+9QgqfpcVUYymPaNmC5cp1UU+W6ieur93C+Zd4Ot9nixZ
         uYyTiKoWJXarw==
Date:   Thu, 14 Jan 2021 08:06:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
Message-ID: <20210114160644.GY1164246@magnolia>
References: <20210113184630.2285768-1-hch@lst.de>
 <20210114104511.kekdiqumjvo2lo7v@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114104511.kekdiqumjvo2lo7v@wittgenstein>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 11:45:11AM +0100, Christian Brauner wrote:
> On Wed, Jan 13, 2021 at 07:46:30PM +0100, Christoph Hellwig wrote:
> > XFS always inherits the SGID bit if it is set on the parent inode, while
> > the generic inode_init_owner does not do this in a few cases where it can
> > create a possible security problem, see commit 0fa3ecd87848
> > ("Fix up non-directory creation in SGID directories") for details.
> > 
> > Switch XFS to use the generic helper for the normal path to fix this,
> > just keeping the simple field inheritance open coded for the case of the
> > non-sgid case with the bsdgrpid mount option.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
> 
> I ran the idmapped mounts xfstests on this patchset. With this patch
> applied I was able to remove the special casing for xfs (apart from the
> irix compatibility check) and got clean test runs:
> 
> 
> 1. with regular setgid inheritance rules
> root@f2-vm:/xfstests# ./check generic/622

Is this test posted to fstests somewhere?

FWIW the code change looks reasonable to me, but I wanted to see the
functionality exercise test first. :)

--D

> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 f2-vm 5.11.0-rc3-brauner-idmapped-mounts-xfs #311 SMP Thu Jan 14 09:55:14 UTC 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop7
> MOUNT_OPTIONS -- /dev/loop7 /mnt/scratch
> 
> generic/622 1s ...  2s
> Ran: generic/622
> Passed all 1 tests
> 
> 2. with irix_sgid_inherit setgid inheritance rules
> root@f2-vm:/xfstests# echo 1 > /proc/sys/fs/xfs/irix_sgid_inherit
> root@f2-vm:/xfstests# ./check generic/622
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 f2-vm 5.11.0-rc3-brauner-idmapped-mounts-xfs #311 SMP Thu Jan 14 09:55:14 UTC 2021
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop7
> MOUNT_OPTIONS -- /dev/loop7 /mnt/scratch
> 
> generic/622 2s ...  1s
> Ran: generic/622
> Passed all 1 tests
> 
> Thanks!
> Christian
