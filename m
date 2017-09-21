Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57317 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbdIUNmn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 09:42:43 -0400
Date: Thu, 21 Sep 2017 06:42:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: Add test for CVE-2017-14340
Message-ID: <20170921134242.GA26627@infradead.org>
References: <20170920004650.36174-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920004650.36174-1-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

> +_require_xfs_io_command "chattr"
> +_require_xfs_io_command "fsync"
> +_require_xfs_io_command "pwrite"

I think we expect these always to be there in general.  But then
again these checks won't hurt either.

> +_require_test

I can't see the test using the test device, so this should not be
needed.

> +# Set realtime inherit flag on scratch mount, suppress output
> +# as this may simply error out on future kernels, we will check
> +# exit code instead.
> +$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
> +chattr_ret=$?
> +
> +# Erroring out here is fine, this would be desired behavior for
> +# FSes without realtime devices present.
> +if (( chattr_ret == 0)); then

Don't want to be nitpicky, but the way we usuall write this would be:

$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null

if [ $? -eq 0 ]; then

> +rm -f $SCRATCH_MNT/testfile

We probably don't need to beother with this, as the scratch device
gets reinitialized on every test that uses it.

Otherwise the test looks great, thanks a lot!

Reviewed-by: Christoph Hellwig <hch@lst.de>
