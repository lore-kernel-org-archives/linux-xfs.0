Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259B4C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 16:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKGQlx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 11:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiKGQlv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 11:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D283110F9;
        Mon,  7 Nov 2022 08:41:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E7BDB812A9;
        Mon,  7 Nov 2022 16:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDB7C433D6;
        Mon,  7 Nov 2022 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667839308;
        bh=gClJIx7gtOIaMRKiUYCd7JlDSBfzTS0UeIcZsg9HgSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GoaTpHink8UJMA45vIb2/bjYYyOUItY0UbK2NK5ZtuoTSYbQeuv5rsNv55YQXqbor
         u34xhyr4ylGRYAtH8lWtTwA3DtxBJDqJXvUPl7zdO1oIA4Byqld9LqpgHxmUbEb+Ym
         3czrZ6+/Y2vijsO8CkH0n3PVUz2mKm+I4nN3qZ2b9DkIP88OhFR4bm7PV92/nPEiKW
         53jvXDdh8hLh/IUtmpMj1dc6VzGggnfonhqf/jH3VrPbcI53XUojSo6OKwLvlwP+VF
         68+E69b+ihj9Qisp75oCRqHLEBKVbaZJMQg3h0kbOSOVXbantffBcKfyR8Ceqej0Gy
         JP4P7EPF684fg==
Date:   Mon, 7 Nov 2022 08:41:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: shutdown might leave NULL files with nonzero
 di_size
Message-ID: <Y2k1SzblcYRsSvzK@magnolia>
References: <20221105152324.2233310-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105152324.2233310-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 05, 2022 at 11:23:24PM +0800, Zorro Lang wrote:
> An old issue might cause on-disk inode sizes are logged prematurely
> via the free eofblocks path on file close. Then fs shutdown might
> leave NULL files but their di_size > 0.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> V2 replace "fiemap" with "stat" command, to check if a file has extents.
> That helps this case more common.
> 
> Thanks,
> Zorro
> 
>  tests/generic/999     | 42 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  5 +++++
>  2 files changed, 47 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..8b4596e0
> --- /dev/null
> +++ b/tests/generic/999

Ugh sorry     ^^^^^^^ I didn't notice this part and wrote my previous
response thinking this was an xfs-only test...

> @@ -0,0 +1,42 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 999
> +#
> +# Test an issue in the truncate codepath where on-disk inode sizes are logged
> +# prematurely via the free eofblocks path on file close.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick shutdown
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_shutdown
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Create many small files with one extent at least"
> +for ((i=0; i<10000; i++));do
> +	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
> +done
> +
> +echo "Shutdown the fs suddently"
> +_scratch_shutdown
> +
> +echo "Cycle mount"
> +_scratch_cycle_mount
> +
> +echo "Check file's (di_size > 0) extents"
> +for f in $(find $SCRATCH_MNT -type f -size +0);do
> +	# Check if the file has any extent
> +	if [ "$(stat -c "%b" $f)" = "0" ];then
> +		echo " - $f get no extents, but its di_size > 0"
> +		break
> +	fi
> +done

...so whereas I was trying to suggest that you could use the GETFSXATTR
ioctl to return the extent count:

$XFS_IO_PROG -c stat $f | grep fsxattr.nextents | awk '{print $3}'

But that won't work outside of XFS.  To make this generic, I think you
have to do something like:

$FILEFRAG_PROG -v $f | wc -l

to see if there are any extents.

--D

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..50008783
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,5 @@
> +QA output created by 999
> +Create many small files with one extent at least
> +Shutdown the fs suddently
> +Cycle mount
> +Check file's (di_size > 0) extents
> -- 
> 2.31.1
> 
