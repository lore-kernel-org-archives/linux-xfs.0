Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34B2C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59D760F23
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhIPFx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 01:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhIPFx1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 01:53:27 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED544C061574;
        Wed, 15 Sep 2021 22:52:06 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b8so5466377ilh.12;
        Wed, 15 Sep 2021 22:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TzAX54/kp7hfkYK0sr/5ozRSnTu11qrO1o2uWozKvPw=;
        b=TOu+7T3RmeqY0k8atVR67ZZH9kHXHQY9NRBgK9RlhETj7xws2Q7qsr9huiSmgy2Idf
         r59tv02BunVZOee/J7x3kouixfXrQsRDAI/InJ4/qCYR5jzI9ZUbJZoFBCUWgYFlmOHl
         S2K/tuOg/Z9io8CSiMaw724eT9QQ3ISR5ayL+xMjl3RwZSYtMspciQPsqrfGp8kD1Oqm
         AHm0vHBMZ0C2bAim3OXItx9zDPycMxIOFZE06YdfTeNIOkBVjYGn1ncue7h7JROuWwu1
         sxlLSUQIY+mJoHJkzpxVb28uB/yEpAI5ZvH7dscSAI55zWaCpCRleAttXD79HJ8inJYB
         AXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TzAX54/kp7hfkYK0sr/5ozRSnTu11qrO1o2uWozKvPw=;
        b=FXWYG2mBF1m+aAjZoi9EAeRwNz8Lzfqu6oKq1d/RiHffJ7PNN/p9BT/Uyq319hW5kt
         tjczSNvL6U6chWJxfRHl5bo+sHzIVsamCb+59u0HwVCs8CwAlvVNsTdTLU7va6ffgUfr
         h7p7w92bgIdzwbcAQGWQTw0mO1TXnVgKqlbOcWeac+AGgaZ6hFrWOwMo0XSJ7O1HZ1LQ
         LVcx5ZAWUHG2oTF5htKfAl2bhpxNi7x6sJpUsvcF8ubt5Ok6eKlI1QFOZBqXvrwDtl0W
         QO65qTNqsBZXiHryXitMrtwpPti27zYpFOi/5ehcWtR2K3PXeLe6imlZA8Qep0FiBXLa
         uh9A==
X-Gm-Message-State: AOAM532t/hGGvkbJIW2S2Dw0qjQrnELkC/glEEw+e6k4ciIjQZDB32/U
        qUAErfUO0Ve6RoSM7v5WgUFq1MyLrLjIRKQV+74=
X-Google-Smtp-Source: ABdhPJwrzJeEsvRuvH893NFhfGyVJSNltjjuau6+drt1qlxwHTTCyeNVJ51LbTSwNAytxowWxG4uEg+7lQC5yZdzxXw=
X-Received: by 2002:a05:6e02:1a67:: with SMTP id w7mr2740145ilv.24.1631771526439;
 Wed, 15 Sep 2021 22:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174936843.380880.4944637627844574386.stgit@magnolia>
In-Reply-To: <163174936843.380880.4944637627844574386.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 08:51:55 +0300
Message-ID: <CAOQ4uxi5K_KWv4f1kNsPoXYo7QBqr7_Ksd+JAJpCB901aY2mSg@mail.gmail.com>
Subject: Re: [PATCH 2/9] xfs: move reflink tests into the clone group
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 2:42 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> "clone" is the group for tests that exercise FICLONERANGE, so move these
> tests.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/xfs/519 |    2 +-
>  tests/xfs/520 |    2 +-
>  tests/xfs/535 |    2 +-
>  tests/xfs/536 |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>
>
> diff --git a/tests/xfs/519 b/tests/xfs/519
> index 675ec07e..49c62b56 100755
> --- a/tests/xfs/519
> +++ b/tests/xfs/519
> @@ -9,7 +9,7 @@
>  # flushing the log and then remounting to check file contents.
>
>  . ./common/preamble
> -_begin_fstest auto quick reflink
> +_begin_fstest auto quick clone
>
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/520 b/tests/xfs/520
> index 8410f2ba..2fceb07c 100755
> --- a/tests/xfs/520
> +++ b/tests/xfs/520
> @@ -12,7 +12,7 @@
>  # is included in the current kernel.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick reflink
> +_begin_fstest auto quick clone
>
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/xfs/535 b/tests/xfs/535
> index 4c883675..1a5da61b 100755
> --- a/tests/xfs/535
> +++ b/tests/xfs/535
> @@ -7,7 +7,7 @@
>  # Verify that XFS does not cause inode fork's extent count to overflow when
>  # writing to a shared extent.
>  . ./common/preamble
> -_begin_fstest auto quick reflink
> +_begin_fstest auto quick clone
>
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/536 b/tests/xfs/536
> index e5f904f5..64fa4fbf 100755
> --- a/tests/xfs/536
> +++ b/tests/xfs/536
> @@ -7,7 +7,7 @@
>  # Verify that XFS does not cause inode fork's extent count to overflow when
>  # remapping extents from one file's inode fork to another.
>  . ./common/preamble
> -_begin_fstest auto quick reflink
> +_begin_fstest auto quick clone
>
>  # Import common functions.
>  . ./common/filter
>
