Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397B9C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 21:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjG0VYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 17:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjG0VYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 17:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C30D4220;
        Thu, 27 Jul 2023 14:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9187661F3C;
        Thu, 27 Jul 2023 21:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A3EC433C7;
        Thu, 27 Jul 2023 21:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690493036;
        bh=USI9e9KT6MOYKuPlMt//BD0ugBb5+AjE87OXuTIB68E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZN81gHycm0s/S46NkxSdWddSjNcTtPSJdLUY7f8cPiyloK3KfuYgYxSV8D8RylIpS
         QymzDQo1TfqZupC/UT0VDUrB4KGcxxTqbH9KufeRRhGbkkZHUAghnRNnI04WdB/eCh
         r4raibokSjMkC5jUbUYkpkU2etSd17kwiTDuuYJkGq1wEar2zfANkv1eT3r62r6Nq4
         ArFPqHrYMQkR5KoZcITTWMP7NpVcoAnWpZ6Wz0QPSDzAK95QKQF7kvZ2AG8TOZyl0I
         eUUR3YjRVR1nzp7BKQTkGjMJeNjfDaH0+L7+I0xR4aJekMr6xa6pJrs5CdcoPmt2eG
         phmi7YXD/jKzw==
Date:   Thu, 27 Jul 2023 14:23:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fstests: add smoketest group
Message-ID: <20230727212355.GD11352@frogsfrogsfrogs>
References: <20230727185315.530134-1-zlang@kernel.org>
 <20230727185315.530134-2-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727185315.530134-2-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 28, 2023 at 02:53:14AM +0800, Zorro Lang wrote:
> Darrick suggests that fstests can provide a simple smoketest, by
> running several generic filesystem smoke testing for five minutes
> apiece (SOAK_DURATION="5m"). Since there are only five smoke tests,
> this is effectively a 20min super-quick test.
> 
> With gcov enabled, running these tests yields about ~75% coverage for
> iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45%
> for btrfs.  Coverage was about ~65% for the pagecache.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Zorro Lang <zlang@kernel.org>

Er... this excerpt looks good to me! :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

(is that even allowed??)

--D

> ---
>  doc/group-names.txt | 1 +
>  tests/generic/475   | 2 +-
>  tests/generic/476   | 2 +-
>  tests/generic/521   | 2 +-
>  tests/generic/522   | 2 +-
>  tests/generic/642   | 2 +-
>  6 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index 1c35a394..c3dcca37 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -118,6 +118,7 @@ selftest		tests with fixed results, used to validate testing setup
>  send			btrfs send/receive
>  shrinkfs		decreasing the size of a filesystem
>  shutdown		FS_IOC_SHUTDOWN ioctl
> +smoketest		Simple smoke tests
>  snapshot		btrfs snapshots
>  soak			long running soak tests whose runtime can be controlled
>                          directly by setting the SOAK_DURATION variable
> diff --git a/tests/generic/475 b/tests/generic/475
> index 0cbf5131..ce7fe013 100755
> --- a/tests/generic/475
> +++ b/tests/generic/475
> @@ -12,7 +12,7 @@
>  # testing efforts.
>  #
>  . ./common/preamble
> -_begin_fstest shutdown auto log metadata eio recoveryloop
> +_begin_fstest shutdown auto log metadata eio recoveryloop smoketest
>  
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/generic/476 b/tests/generic/476
> index 8e93b734..b1ae4df4 100755
> --- a/tests/generic/476
> +++ b/tests/generic/476
> @@ -8,7 +8,7 @@
>  # bugs in the write path.
>  #
>  . ./common/preamble
> -_begin_fstest auto rw long_rw stress soak
> +_begin_fstest auto rw long_rw stress soak smoketest
>  
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/generic/521 b/tests/generic/521
> index 22dd31a8..0956e501 100755
> --- a/tests/generic/521
> +++ b/tests/generic/521
> @@ -7,7 +7,7 @@
>  # Long-soak directio fsx test
>  #
>  . ./common/preamble
> -_begin_fstest soak long_rw
> +_begin_fstest soak long_rw smoketest
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/generic/522 b/tests/generic/522
> index f0cbcb24..0e4e6009 100755
> --- a/tests/generic/522
> +++ b/tests/generic/522
> @@ -7,7 +7,7 @@
>  # Long-soak buffered fsx test
>  #
>  . ./common/preamble
> -_begin_fstest soak long_rw
> +_begin_fstest soak long_rw smoketest
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/generic/642 b/tests/generic/642
> index eba90903..e6a475a8 100755
> --- a/tests/generic/642
> +++ b/tests/generic/642
> @@ -8,7 +8,7 @@
>  # bugs in the xattr code.
>  #
>  . ./common/preamble
> -_begin_fstest auto soak attr long_rw stress
> +_begin_fstest auto soak attr long_rw stress smoketest
>  
>  _cleanup()
>  {
> -- 
> 2.40.1
> 
