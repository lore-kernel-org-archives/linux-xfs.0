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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCB1C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71736611EE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhIPFxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 01:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhIPFxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 01:53:01 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808D1C061574;
        Wed, 15 Sep 2021 22:51:41 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h9so5488869ile.6;
        Wed, 15 Sep 2021 22:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EB2cvcmf/sJW7A86QaWGWU/ctLOHlfpqzgBZF330PoI=;
        b=TgWDGM2CKukc66wSM3uDJR8MO6S8YzPLnkdEhdn1vI7Qdl/84Qf3KXMzN0zFdyuJu3
         U6WA6laGYilKnUDcZ1lFk8yUOlBYH0dRz9zZ7Qdq7FYHEpAPXlft3jZHASrNrUE1mbuO
         0q/XW4tRT1lNYdY/F4EsJJdjaX71AbMic/Nh99hDjrdhZ6pUxZbTB8WdTGcC/wIHk63i
         5/nwhTwa2LPeljYK5b6w2Vylpxym3uiGxJrAyt5sgqch2wK6gpzdBV0R4RXZUKarEdZO
         WmPMahq63qzV3wqaLvPxZAihlJzneuZRSr4+Ilb3SOaSTQR+nrv+p53n19+AYS9y/XzA
         AH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EB2cvcmf/sJW7A86QaWGWU/ctLOHlfpqzgBZF330PoI=;
        b=wWW28XcYOWcsYrKsu7u2oaihyq2X3A3hOu8GVID3Vh60PuDBLVZ2Ta2qjKdoZPaIow
         aGeHEyCTDg08e3KchF/A0KnvcFHmcGMVLU0XUE2LJTxvNSZDTQdPc5q7xfwXS4dZkNXy
         TaWTSrT9HVqDEGM8gpdUC8ZCjz7OFBjuDI9f72OLcqEPqHnDr8o2bw/IRj+/qdSsPGgn
         14yw2xIkc/FnTrvgMBNn5xozO4v2EtYTwTxrZHjnQdHjyq02tvBIDieepwFex4I6glmp
         YdIybR+6ebV+vGNP148jN3ZIG/78eUQHG1bKBqcQXS7R02WK38YfrMKzuCLjdByfO//W
         W2Hg==
X-Gm-Message-State: AOAM5325Bwtzyvbs8wDYq0JEZxA1gK12m3LiyIaqAfM3paxxqaY06HvA
        ++usEeZ1/UR0gS/2eH2gMz4MeBnPDYuX5eF2aIhrO+7Qljc=
X-Google-Smtp-Source: ABdhPJyfL9e0xcEfP9rrkkKz+vlFCs1ve3TTxt8Nu8WYRNNlIBarPBo8SZCn5CVWZ52uCp4PL9dwMAVnayK8lZibi/c=
X-Received: by 2002:a92:d491:: with SMTP id p17mr2812018ilg.107.1631771500951;
 Wed, 15 Sep 2021 22:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174936296.380880.5004927987240020121.stgit@magnolia>
In-Reply-To: <163174936296.380880.5004927987240020121.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 08:51:30 +0300
Message-ID: <CAOQ4uxgg9qsJHDsHVDyBAsOJ4n9qB3kzVOwbjKKTou4-sin0AQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] ceph: re-tag copy_file_range as being in the
 copy_range group
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
> copy_range is the group name for copy_file_range tests, so reclassify
> these tests.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/ceph/001 |    2 +-
>  tests/ceph/002 |    2 +-
>  tests/ceph/003 |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
>
> diff --git a/tests/ceph/001 b/tests/ceph/001
> index aca77168..c00de308 100755
> --- a/tests/ceph/001
> +++ b/tests/ceph/001
> @@ -11,7 +11,7 @@
>  # file and 3) the middle of the dst file.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick copy
> +_begin_fstest auto quick copy_range
>
>  # get standard environment
>  . common/filter
> diff --git a/tests/ceph/002 b/tests/ceph/002
> index 428f23a9..9bc728fd 100755
> --- a/tests/ceph/002
> +++ b/tests/ceph/002
> @@ -20,7 +20,7 @@
>  #   linux kernel: 78beb0ff2fec ("ceph: use copy-from2 op in copy_file_range")
>  #
>  . ./common/preamble
> -_begin_fstest auto quick copy
> +_begin_fstest auto quick copy_range
>
>  # get standard environment
>  . common/filter
> diff --git a/tests/ceph/003 b/tests/ceph/003
> index 9f8c6068..faedb48c 100755
> --- a/tests/ceph/003
> +++ b/tests/ceph/003
> @@ -7,7 +7,7 @@
>  # Test copy_file_range with infile = outfile
>  #
>  . ./common/preamble
> -_begin_fstest auto quick copy
> +_begin_fstest auto quick copy_range
>
>  # get standard environment
>  . common/filter
>
