Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75291C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6161A60FC0
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhG1Jkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhG1Jkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:40:42 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64879C061757;
        Wed, 28 Jul 2021 02:40:41 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id m11so895757qtx.7;
        Wed, 28 Jul 2021 02:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=dktCwlTObwFG+2Ta9NrZzHxiFTXSIiqKgkliRATZihc=;
        b=hC6HIDzS/kMo8HwBoSMfkwBNNGFafrPcaYrK2m1Z7hs6tWPj80j44IDEKRAScQRPdg
         QysyxqmtA3x/jBjk9/It1kxIpqMjyloTxk0S3WV7NZyJ/a63xGTYf5/RptV+56rQZ6va
         kh6hscbuIAcxaKzlGScjpNa2Ylf67Sm+Drxn54E0YVj7iFg7pqorUhwJY8S1Cel0KcNB
         xGWvymH/q+Mn1cWM0kLt7WJyzSIWlrDC4T9XzBDkAmiMtk+789smcOXgDxdBKUqeAeGo
         5G6T6p5eiQlJe9v8sAFNLKbxz1uilgBqtrnx3aREdn7pSF0cq2A0IfBuZSN3T/VMU1Wp
         OrLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=dktCwlTObwFG+2Ta9NrZzHxiFTXSIiqKgkliRATZihc=;
        b=tFuGL86R3pcc8OOWgyT2Yai5x78QSwfEERyz2LM/eB82NebhTuiGVhmnsy6oYtDSxb
         N+UDYezTFW39Ey+By7UFgZm1qlc6JZiBC8sWD2Uw8u88PZYRV4kbGkt8tYxLKNL7WEqZ
         w+4PAlc5eERB72ruNO2Sc6+ej/OTzu2VJI01ZgXN12b1FbTRS1sHFtBs3gFMHq4WmTk3
         Mz8PwxoXDOiGFmGHITgOXsxe9CDj5OcWPy8SA+ckx5mZKSyhQURVzO2ojaFiNJHIFLRm
         mX52LaAkWiR6GmQKSFKTHvs1eXYwNqUnkI8XV+Z+LxBWk9u5ZiikVXVNwrMN40G0LHv3
         8tRQ==
X-Gm-Message-State: AOAM530hSycqHL5soVOkXB/yYf9yIsXJ+fGnfbEsfaJzImvENFBCt6LQ
        SVnP8jqrgTn05jsaSSaOG8ov0GXImEGMFZ5lfZs=
X-Google-Smtp-Source: ABdhPJxL/VOD6efZw6khhVS5q84iFPfNWK1p0FKu/+OfqLi9cqQsC9bbLugROe4FWdhLYdOCRHCJFK6s/g69hTMC9G8=
X-Received: by 2002:ac8:76da:: with SMTP id q26mr23074954qtr.183.1627465240571;
 Wed, 28 Jul 2021 02:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <162743103739.3429001.16912087881683869606.stgit@magnolia> <162743104288.3429001.18145781236429703996.stgit@magnolia>
In-Reply-To: <162743104288.3429001.18145781236429703996.stgit@magnolia>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 28 Jul 2021 10:40:29 +0100
Message-ID: <CAL3q7H511wY0nHvTuqfnp0ttvvGuFt9Eke2B6cXy_4+JDyJVRw@mail.gmail.com>
Subject: Re: [PATCH 1/1] misc: tag all tests that examine crash recovery in a loop
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 1:10 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Given all the recent problems that we've been finding with log recovery,
> I think it would be useful to create a 'recoveryloop' group so that
> developers have a convenient way to run every single test that rolls
> around in a fs shutdown loop looking for subtle errors in recovery.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/btrfs/190   |    2 +-
>  tests/generic/019 |    2 +-
>  tests/generic/388 |    2 +-
>  tests/generic/455 |    2 +-
>  tests/generic/457 |    2 +-
>  tests/generic/475 |    2 +-
>  tests/generic/482 |    2 +-
>  tests/generic/725 |    2 +-
>  tests/xfs/057     |    2 +-
>  9 files changed, 9 insertions(+), 9 deletions(-)
>
>
> diff --git a/tests/btrfs/190 b/tests/btrfs/190
> index 3aa718e2..974438c1 100755
> --- a/tests/btrfs/190
> +++ b/tests/btrfs/190
> @@ -8,7 +8,7 @@
>  # balance needs to be resumed on mount.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick replay balance qgroup
> +_begin_fstest auto quick replay balance qgroup recoveryloop

For btrfs, there are more tests like this: btrfs/172, btrfs/192 and btrfs/2=
06.

>
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/generic/019 b/tests/generic/019
> index b8d025d6..db56dac1 100755
> --- a/tests/generic/019
> +++ b/tests/generic/019
> @@ -8,7 +8,7 @@
>  # check filesystem consistency at the end.
>  #
>  . ./common/preamble
> -_begin_fstest aio dangerous enospc rw stress
> +_begin_fstest aio dangerous enospc rw stress recoveryloop
>
>  fio_config=3D$tmp.fio
>
> diff --git a/tests/generic/388 b/tests/generic/388
> index e41712af..9cd737e8 100755
> --- a/tests/generic/388
> +++ b/tests/generic/388
> @@ -15,7 +15,7 @@
>  # spurious corruption reports and/or mount failures.
>  #
>  . ./common/preamble
> -_begin_fstest shutdown auto log metadata
> +_begin_fstest shutdown auto log metadata recoveryloop
>
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/generic/455 b/tests/generic/455
> index 62788798..13d326e7 100755
> --- a/tests/generic/455
> +++ b/tests/generic/455
> @@ -7,7 +7,7 @@
>  # Run fsx with log writes to verify power fail safeness.
>  #
>  . ./common/preamble
> -_begin_fstest auto log replay
> +_begin_fstest auto log replay recoveryloop
>
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/generic/457 b/tests/generic/457
> index d9e38268..f4fdd81d 100755
> --- a/tests/generic/457
> +++ b/tests/generic/457
> @@ -7,7 +7,7 @@
>  # Run fsx with log writes on cloned files to verify power fail safeness.
>  #
>  . ./common/preamble
> -_begin_fstest auto log replay clone
> +_begin_fstest auto log replay clone recoveryloop
>
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/generic/475 b/tests/generic/475
> index 62894491..c426402e 100755
> --- a/tests/generic/475
> +++ b/tests/generic/475
> @@ -12,7 +12,7 @@
>  # testing efforts.
>  #
>  . ./common/preamble
> -_begin_fstest shutdown auto log metadata eio
> +_begin_fstest shutdown auto log metadata eio recoveryloop
>
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/generic/482 b/tests/generic/482
> index f26e6fc4..0fadf795 100755
> --- a/tests/generic/482
> +++ b/tests/generic/482
> @@ -9,7 +9,7 @@
>  # Will do log replay and check the filesystem.
>  #
>  . ./common/preamble
> -_begin_fstest auto metadata replay thin
> +_begin_fstest auto metadata replay thin recoveryloop
>
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/generic/725 b/tests/generic/725
> index f43bcb37..8bd724e3 100755
> --- a/tests/generic/725
> +++ b/tests/generic/725
> @@ -12,7 +12,7 @@
>  # in writeback on the host that cause VM guests to fail to recover.
>  #
>  . ./common/preamble
> -_begin_fstest shutdown auto log metadata eio
> +_begin_fstest shutdown auto log metadata eio recoveryloop
>
>  _cleanup()
>  {
> diff --git a/tests/xfs/057 b/tests/xfs/057
> index d4cfa8dc..9fb3f406 100755
> --- a/tests/xfs/057
> +++ b/tests/xfs/057
> @@ -21,7 +21,7 @@
>  # Note that this test requires a DEBUG mode kernel.
>  #
>  . ./common/preamble
> -_begin_fstest auto log
> +_begin_fstest auto log recoveryloop
>
>  # Override the default cleanup function.
>  _cleanup()
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
