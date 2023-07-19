Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169B4C001B0
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 15:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjGSPLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 11:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjGSPLR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 11:11:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3512118
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 08:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689779433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqLgOin0rTu0lyr4k1Vp2As3stiP9oBLCev9u0lmfXM=;
        b=S4IdNarDYP4CAPYN31AqZjp8E7emdlBm1a66mkeJQQj8GD9zv2gisp069rXEerpetn31pN
        zIh8sbh9Cs8G9etHYY65jCNORuGo1obZITCvpgLT5XRA53XFc02JvAlfSxbWbwnyp7AsD9
        tLlNTYz/b8fhssxYvM3KsgJrAXcODcU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-F7yD3VY5OImx39LGnGJPLQ-1; Wed, 19 Jul 2023 11:10:29 -0400
X-MC-Unique: F7yD3VY5OImx39LGnGJPLQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-55c04f5827eso3254987a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 08:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689779428; x=1690384228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqLgOin0rTu0lyr4k1Vp2As3stiP9oBLCev9u0lmfXM=;
        b=PjlemQOQrgcq8mpH1IlSz42COyTqZVvrJIrJ3DNd+BsFM5id/GMlU6V64vxdDHS8Gn
         q+1P39b3WAApeIQFEnjwPooBvfcjdgysjC5426w6IETQGntJQZvB5OK/rgfGArOiEiRY
         ObDfRI4+7CMTAgcCRDeEPXOgSRYzWJn5DqpgxqEU0g8JWSbL0HxkMg+ibJ1EhQFiWo2n
         INrn9NExpULPCoeK5Wdk2i/5SxkpIQ9QE9glDb864PqzgsFMxozWMiImi15nHWlfYL7N
         yjLd4E5VHMCZJn7Way3y9VbXcbwVcjdnJHaVTBvvzs/VaF+jbSuoHjTPeAwkjqoIIfLs
         B/yg==
X-Gm-Message-State: ABy/qLbLIvJeNZLwd1eeEQcASXLOZxbZQnA0jK0xdae1QaLY6oH14TJW
        TkYVT2dAdhCQE/Xrxk/Eg39DioKRFNTFUBLCUOvMWlmUkLIle1Ic6VLvyPLrV8wMPptwe4somQ+
        hrvzK3N8K+wbT0+kbpEQQiMvdDatismQ=
X-Received: by 2002:a17:902:d2c1:b0:1b8:6dea:e270 with SMTP id n1-20020a170902d2c100b001b86deae270mr5887895plc.16.1689779428683;
        Wed, 19 Jul 2023 08:10:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFoWWreDNQFuOmX5nY9Hc8O178gMvQ/ZvFiz9f6DelSNDjuhjje6uU5ZMTv6jeNAntJFLS0nQ==
X-Received: by 2002:a17:902:d2c1:b0:1b8:6dea:e270 with SMTP id n1-20020a170902d2c100b001b86deae270mr5887873plc.16.1689779428366;
        Wed, 19 Jul 2023 08:10:28 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902ec0400b001b81a97860asm4124015pld.27.2023.07.19.08.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 08:10:27 -0700 (PDT)
Date:   Wed, 19 Jul 2023 23:10:24 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     tytso@mit.edu, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2023 at 06:10:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a "-smoketest" parameter to check that will run generic
> filesystem smoke testing for five minutes apiece.  Since there are only
> five smoke tests, this is effectively a 16min super-quick test.
> 
> With gcov enabled, running these tests yields about ~75% coverage for
> iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45% for
> btrfs.  Coverage was about ~65% for the pagecache.
> 
> Cc: tytso@mit.edu
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  check               |    6 +++++-
>  doc/group-names.txt |    1 +
>  tests/generic/475   |    2 +-
>  tests/generic/476   |    2 +-
>  tests/generic/521   |    2 +-
>  tests/generic/522   |    2 +-
>  tests/generic/642   |    2 +-
>  7 files changed, 11 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/check b/check
> index 89e7e7bf20..97c7c4c7d1 100755
> --- a/check
> +++ b/check
> @@ -68,6 +68,7 @@ check options
>      -pvfs2		test PVFS2
>      -tmpfs		test TMPFS
>      -ubifs		test ubifs
> +    -smoketest		run smoke tests for 4min each

We have both "smoketest" and "smoke", that's a bit confused :)

>      -l			line mode diff
>      -udiff		show unified diff (default)
>      -n			show me, do not run tests
> @@ -290,7 +291,10 @@ while [ $# -gt 0 ]; do
>  		FSTYP=overlay
>  		export OVERLAY=true
>  		;;
> -
> +	-smoketest)

Hmm... I'm wondering if it's worth having a specific running option for
someone test group. If each "meaningful" testing way need a specific check
option, the ./check file will be too complicated.

If we need some recommended test ways, how about make some separated wrappers
of ./check? For example:

# mkdir fstests/runtest/
# cat > fstests/runtest/smoketest <<EOF
export SOAK_DURATION="4m"
./check -g smoketest
EOF

Of course you can write more codes in it.

Thanks,
Zorro

> +		SOAK_DURATION="4m"
> +		GROUP_LIST="smoketest"
> +		;;
>  	-g)	group=$2 ; shift ;
>  		GROUP_LIST="$GROUP_LIST ${group//,/ }"
>  		;;
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index 1c35a39432..c3dcca3755 100644
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
> index 0cbf5131c2..ce7fe013b1 100755
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
> index 8e93b73457..b1ae4df4d4 100755
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
> index 22dd31a8ec..0956e50171 100755
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
> index f0cbcb245c..0e4e6009ed 100755
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
> index eba90903a3..e6a475a8b5 100755
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
> 

