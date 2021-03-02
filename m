Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C24C43381
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A4A64DEE
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Mar 2021 08:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344690AbhCBGlz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 01:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1574967AbhCBDwF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 22:52:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DD0B61601;
        Tue,  2 Mar 2021 03:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614655964;
        bh=fBTTRycpEqDMY530KgFM0faLEhz7cqnXeERkwGA1YI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tebFDnvWOkaomqYSq4U0wr9aHPv7z2SucpZUuMA78KKSVYSBtZ0B4VStiNmn69jzd
         07DHVQQZSOoFTQFkxrHFwcD25QrEZMQr1HfGfhJorz5k0eUySUCPnr9CqeyC12wTP8
         o9hIKlJXYW83SaPnezvjTHuok3nE3KPSwCb4ZhEWlSSOnFltTHOwuNeC5a+ShxoIZw
         1c5r+FCGgxzWk2lnvFNWG8wyqwjS41Ntg0bHQKTVwy9Z+Qs1p1R6IleoWxzf8QMRFC
         aP0ncfse1YRhloRRl1B3US1GVgH0gN6YGQdpy7BXAisMU+PiEcTqSTrX0vHkhinIqF
         sl97Gh+mj+rjg==
Date:   Mon, 1 Mar 2021 19:32:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: test mapped write after shutdown and failed
 writeback
Message-ID: <20210302033243.GN7272@magnolia>
References: <20210210170628.173200-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210170628.173200-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 10, 2021 at 12:06:28PM -0500, Brian Foster wrote:
> XFS has a regression where it failed to check shutdown status in the
> write fault path. This produced an iomap warning if the page
> happened to recently fail a writeback attempt because writeback
> failure can clear Uptodate status on the page. Add a test for this
> scenario to help ensure mapped write failures are handled as
> expected in the event of filesystem shutdown.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Note that this test currently fails on XFS. The fix is posted for review
> on linux-xfs:
> 
> https://lore.kernel.org/linux-xfs/20210210170112.172734-1-bfoster@redhat.com/
> 
> Brian
> 
>  tests/generic/999     | 45 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  4 ++++
>  tests/generic/group   |  1 +
>  3 files changed, 50 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..5e5408e7
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,45 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-only
> +# Copyright 2021 Red Hat, Inc.
> +#
> +# FS QA Test No. 999
> +#
> +# Test a write fault scenario on a shutdown fs.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	rm -f $tmp.*
> +}
> +
> +. ./common/rc
> +. ./common/filter
> +
> +rm -f $seqres.full
> +
> +_supported_fs generic
> +_require_scratch_nocheck
> +_require_scratch_shutdown
> +
> +_scratch_mkfs &>> $seqres.full
> +_scratch_mount
> +
> +# XFS had a regression where it failed to check shutdown status in the fault
> +# path. This produced an iomap warning because writeback failure clears Uptodate
> +# status on the page.
> +file=$SCRATCH_MNT/file
> +$XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> +	-c "mwrite 0 4k" $file | _filter_xfs_io

On my fstests (which sets unlimited core dumps) this test generates a
false negative because ./check trips on the core dump that the dying
xfs_io creates.  Assuming that we're /supposed/ to segfault here, I'll
send a patch to ulimit -c0.

--D

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..f55569ff
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,4 @@
> +QA output created by 999
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +fsync: Input/output error
> diff --git a/tests/generic/group b/tests/generic/group
> index b10fdea4..edd54ce5 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -625,3 +625,4 @@
>  620 auto mount quick
>  621 auto quick encrypt
>  622 auto shutdown metadata atime
> +999 auto quick shutdown
> -- 
> 2.26.2
> 
