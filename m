Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:39701 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933905AbeFVChl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 22:37:41 -0400
Date: Fri, 22 Jun 2018 10:37:35 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] xfstests: Test root inode parent pointer repairing
Message-ID: <20180622023735.GN2780@desktop>
References: <20180618174433.3069-1-mbenatto@redhat.com>
 <20180618174433.3069-2-mbenatto@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618174433.3069-2-mbenatto@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marco Benatto <mbenatto@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, sandeen@redhat.com

On Mon, Jun 18, 2018 at 02:44:33PM -0300, Marco Benatto wrote:
> Recently we found out xfs_repair were not repairing
> root inode parent pointer when root inode is on short-form
> and parent points to an invalid inode number (refer to:
> "xfs_repair: Fix root inode's parent when it's bogus for sf
> directory" on xfs-devel list).
> 
> This test checks if xfs_repair successfully repair the
> filesystem in the scenario mentioned before.
> 
> Signed-off-by: Marco Benatto <mbenatto@redhat.com>
> ---
>  tests/xfs/450     | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/450.out |  1 +
>  tests/xfs/group   |  1 +
>  3 files changed, 55 insertions(+)
>  create mode 100755 tests/xfs/450
>  create mode 100644 tests/xfs/450.out
> 
> diff --git a/tests/xfs/450 b/tests/xfs/450
> new file mode 100755
> index 0000000..dc7f244
> --- /dev/null
> +++ b/tests/xfs/450
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 450
> +#
> +# Make sure xfs_repair can repair root inode parent's pointer
> +# when it contains a bogus ino when it's using shot form directory
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +
> +status=1	# failure is the default!

Apart from Dave's comments, there're some common definitions missing
too, e.g. 'tmp' and 'here', please use './new xfs' to generate new test
template.

BTW, I've applied the first patch, no need to resend it in v2.

Thanks,
Eryu
