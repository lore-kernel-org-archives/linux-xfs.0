Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B07C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 16:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488A260232
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 16:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245281AbhDGQMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234072AbhDGQMy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 12:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44AF2610E8;
        Wed,  7 Apr 2021 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617811964;
        bh=TPhFvUcoNoF9ZE/ZIvqo/LH2zVCYuKU+1ItVgYx6vyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VqxlMmmNvG43BRUNmIwhKSPfcK2PLKbuYBeeEVtVsudIECNsJlqWIxwLjsOWS7S+/
         r6B1ChRGKlqYlNuYG+NZmToq2b+/FaNM9R21dnC6C7sPGOVpnwR+bRxY2Y6s7dwDk+
         EV7E1a2vsZ2i792PrJgtvi0oWU7d7qubHvmD+ua+8L6oHsPtrR6rG5OFlNlpEVmWlZ
         Qh7SI5RC5TT0uMjkyczcbFrPNc++UwqUCAHZEoKuYR8P1vVixoVyneiJautkKjoqks
         cDqY0/v0/hxElsQBTCW2s9If7egRwcCHnXO/g4scjRb42E4VFcvC3f7KvG4tbdkltl
         ECTRWT7hwiZTw==
Date:   Wed, 7 Apr 2021 09:12:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fstests: Do not execute xfs/{532,533,538} when realtime
 feature is enabled
Message-ID: <20210407161243.GZ1670408@magnolia>
References: <20210405074447.22222-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405074447.22222-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 01:14:47PM +0530, Chandan Babu R wrote:
> The minimum length space allocator (i.e. xfs_bmap_exact_minlen_extent_alloc())
> depends on the underlying filesystem to be fragmented so that there are enough
> one block sized extents available to satify space allocation requests.
> 
> xfs/{532,533,538} tests issue space allocation requests for metadata (e.g. for
> blocks holding directory and xattr information). With realtime filesystem
> instances, these tests would end up fragmenting the space on realtime
> device. Hence minimum length space allocator fails since the regular
> filesystem space is not fragmented and hence there are no one block sized
> extents available.
> 
> Thus, this commit disables execution of xfs/{532,533,538} when realtime
> feature is enabled on the filesystem instance.
> 
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/532 | 1 +
>  tests/xfs/533 | 1 +
>  tests/xfs/538 | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/tests/xfs/532 b/tests/xfs/532
> index 2bed574a..5359add5 100755
> --- a/tests/xfs/532
> +++ b/tests/xfs/532
> @@ -37,6 +37,7 @@ _supported_fs xfs
>  _require_scratch
>  _require_attrs
>  _require_xfs_debug
> +_require_no_realtime

Alternately, you could do:

	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT

and not reduce test coverage.

--D

>  _require_test_program "punch-alternating"
>  _require_xfs_io_error_injection "reduce_max_iextents"
>  _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> diff --git a/tests/xfs/533 b/tests/xfs/533
> index be909fcc..4826cccc 100755
> --- a/tests/xfs/533
> +++ b/tests/xfs/533
> @@ -35,6 +35,7 @@ rm -f $seqres.full
>  _supported_fs xfs
>  _require_scratch
>  _require_xfs_debug
> +_require_no_realtime
>  _require_test_program "punch-alternating"
>  _require_xfs_io_error_injection "reduce_max_iextents"
>  _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> diff --git a/tests/xfs/538 b/tests/xfs/538
> index 90eb1637..53a2c060 100755
> --- a/tests/xfs/538
> +++ b/tests/xfs/538
> @@ -35,6 +35,7 @@ rm -f $seqres.full
>  _supported_fs xfs
>  _require_scratch
>  _require_xfs_debug
> +_require_no_realtime
>  _require_test_program "punch-alternating"
>  _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>  
> -- 
> 2.29.2
> 
