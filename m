Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110EDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7EA26120D
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 05:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhIPFyl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 01:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhIPFyk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 01:54:40 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDF8C061574;
        Wed, 15 Sep 2021 22:53:20 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id a15so6537251iot.2;
        Wed, 15 Sep 2021 22:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TC5Jcbwfd/bqW3ZTiFMPP1Ixm6heoG73P87JPs2H9z0=;
        b=MsImjFNQX85f7akx6Sph3GXPLzZnMWQZzgEuUIIFj5YTkMB397RMk7Hycm+At/ULPL
         EAFOB0hFpfGOcT/Gws8oSOKp0OACSlJc/q7rm1utoW2QqceEUXOnDVb1XbpFc1wjMmjo
         xy9s0W4aIrevdrZ4m4E16XN1wq9v/mfKl4QeMbft94mI61fZ54mc++8rl+T76YQIoS9R
         MXRYu7gYbK2BGfGAGiUKMCMTlOk8mXY5wqO6DiGFze9kVUm+k4vv7jHcMcwVjoyKkwMS
         /Z8pckwNj5Or80b5DEiZLB/vNalHNCbCT+uOtRAGjhe9XJyQMKwKWICSHJpuJpVrF/cr
         a83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TC5Jcbwfd/bqW3ZTiFMPP1Ixm6heoG73P87JPs2H9z0=;
        b=rDfzExaJbpjNVPnvjnc8nY6Nc1O1ZxMn7MmLa3G+jlrYAXwcV77D7rGtivrNWG4I3y
         Us8Kf9x1Yt9ZRKaGG2z12p1sFnY2rfr+Ym6wGBdhciungsCnBf5szs6yuSp/tXc8XXAD
         Hzg638IgikD4qDgoQO7SPZ5WD0L8bVSDgrjoqHzZs6cRTpTmRp5EL1954a8yFej2cdJz
         ColZLCk8yoO/yNA0qGwNlEZ9gEF7/eKZSWC3HXoaLnzYeMc9bGMdfSwWAI51o5Ou0ZbY
         Bybk5gh3gC4j2BfFTShCs8h7vzHkHCm4HtzrslHpS2t6dwSbujEQAnViNXIyO6YDdfRb
         RFow==
X-Gm-Message-State: AOAM532M97xcG7+3faPpnUUF6ExPy2D1Upw7ROppewureqjL8U2UiAHW
        exNWGwki7Ff9b9CqyUKzR1/YG3GrtaDXcXmlvLg=
X-Google-Smtp-Source: ABdhPJwgX9h9UQWsS0qROaJWW5ratDwzRu/DrnqB+AKSDcvknSOw5tQtK1MjRj5r3o49AvY31b+8t1mAWQ7WJXi5hXo=
X-Received: by 2002:a6b:6f18:: with SMTP id k24mr3033830ioc.196.1631771599735;
 Wed, 15 Sep 2021 22:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174938478.380880.9077916198891395416.stgit@magnolia>
In-Reply-To: <163174938478.380880.9077916198891395416.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 08:53:09 +0300
Message-ID: <CAOQ4uxgSqidojpEERK=Vo0NqYhdo5Eu0x_LCbo058U1Cg0Z_VQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] generic/631: change this test to use the 'whiteout' group
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 2:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> This test isn't really an overlay test; it's a regression test for a bug
> that someone found in xfs handling of whiteout files.  Since the
> 'overlay' group has one member, let's move it to 'whiteout'.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/generic/631 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> diff --git a/tests/generic/631 b/tests/generic/631
> index a1acdedb..aae181dd 100755
> --- a/tests/generic/631
> +++ b/tests/generic/631
> @@ -22,7 +22,7 @@
>  # in xfs_rename").
>
>  . ./common/preamble
> -_begin_fstest auto rw overlay rename
> +_begin_fstest auto rw whiteout rename
>
>  # Override the default cleanup function.
>  _cleanup()
>
