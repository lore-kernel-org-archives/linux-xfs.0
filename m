Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CD0C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 10:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FDB123A3B
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 10:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbhANKqB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 05:46:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50201 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbhANKqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 05:46:01 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l007v-00065N-2G; Thu, 14 Jan 2021 10:45:19 +0000
Date:   Thu, 14 Jan 2021 11:45:11 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
Message-ID: <20210114104511.kekdiqumjvo2lo7v@wittgenstein>
References: <20210113184630.2285768-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210113184630.2285768-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 07:46:30PM +0100, Christoph Hellwig wrote:
> XFS always inherits the SGID bit if it is set on the parent inode, while
> the generic inode_init_owner does not do this in a few cases where it can
> create a possible security problem, see commit 0fa3ecd87848
> ("Fix up non-directory creation in SGID directories") for details.
> 
> Switch XFS to use the generic helper for the normal path to fix this,
> just keeping the simple field inheritance open coded for the case of the
> non-sgid case with the bsdgrpid mount option.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

I ran the idmapped mounts xfstests on this patchset. With this patch
applied I was able to remove the special casing for xfs (apart from the
irix compatibility check) and got clean test runs:


1. with regular setgid inheritance rules
root@f2-vm:/xfstests# ./check generic/622
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 f2-vm 5.11.0-rc3-brauner-idmapped-mounts-xfs #311 SMP Thu Jan 14 09:55:14 UTC 2021
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop7
MOUNT_OPTIONS -- /dev/loop7 /mnt/scratch

generic/622 1s ...  2s
Ran: generic/622
Passed all 1 tests

2. with irix_sgid_inherit setgid inheritance rules
root@f2-vm:/xfstests# echo 1 > /proc/sys/fs/xfs/irix_sgid_inherit
root@f2-vm:/xfstests# ./check generic/622
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 f2-vm 5.11.0-rc3-brauner-idmapped-mounts-xfs #311 SMP Thu Jan 14 09:55:14 UTC 2021
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop7
MOUNT_OPTIONS -- /dev/loop7 /mnt/scratch

generic/622 2s ...  1s
Ran: generic/622
Passed all 1 tests

Thanks!
Christian
