Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA639C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 18:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357170AbiDSS0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358138AbiDSSYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:24:10 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3CE3FBEB;
        Tue, 19 Apr 2022 11:17:55 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d14so4959229qtw.5;
        Tue, 19 Apr 2022 11:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=00deVnNM39D80dvE24oUzB5jmNj/UYKM5ibGugzLeoQ=;
        b=R3xnyLz3ImpVmQyMkGxkO5yw2z2cN7z8DudQfd04Ajx/zdZk58FC3GtEODAnLALsWs
         mkZ14mCc6vqstI3JypoSCncEJLlfi2jzZ900VIHoCK2JX8aSgMJVowDUyeKYSeGpTBTl
         dj+MYU/xfU9+CrZ/lOYQz+Kq8o9zKsgwyMnKyyDkeZruMEATJlbSOq49Qfmms6pT8nf0
         lC8OjexQTAm5yB6n7vmZ/4ZCx3BYYcAPGM6BQ5O4a6y+bHWiHoz0umdjLebiEqo/0A1i
         f/cNpUscsx6WEYJ13BoFamF6aseUDp172elwjyOhD3H67GtN1/Y0r6krbb7Xx9eBNQsJ
         GURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=00deVnNM39D80dvE24oUzB5jmNj/UYKM5ibGugzLeoQ=;
        b=p6Becx5OBXDVfnhwUO/70JJzpxSVFQSP785C4yO8ZtoY3oaNhMhY2vVzuJocypD0Tv
         teRPs2eAzg+FBVkVxpDe6YHTfTRdgo42iQmBCGiC2BTaQjvcBolkAPa5dbIwVvoQ7GF2
         aeUUSYchyxslKq6tsczyepxMT1TuBIylNXg2rQikgUIcysDvuNytsvW03Ov9Uh12WQMw
         O4haQwHwJ3tDL1IkD86PKK0pfYJRVoTwLrhKi3ysRJ5bVai1SLBKkxiwSk1c62GvsAVf
         4lZoGhJNpVl3opcneoA0SLjsZsx//SNHPRJaeHbVxU0FgkT7n9LJ7RJIvREcw/CxuRxG
         i8Qw==
X-Gm-Message-State: AOAM5319A+HLxAd6ioxJqFbuh5QNJ2O8RJcXqfkfirhiE9ye3Y4l3YbC
        DLiVQC4GWUujxoUML0B3YJunsnZJfr7tL7wY24M=
X-Google-Smtp-Source: ABdhPJz3EzdvxdcAmafnCxp1fGtyDKH96vuBXzHPr0wwxis6A7Jt53zWcw6+HDksISrnsDuqQbgopx4oMDjXaUIV7jY=
X-Received: by 2002:ac8:5fc4:0:b0:2f1:e898:2973 with SMTP id
 k4-20020ac85fc4000000b002f1e8982973mr11115532qta.157.1650392274551; Tue, 19
 Apr 2022 11:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <165038952992.1677711.6313258860719066297.stgit@magnolia> <165038953550.1677711.12931148474635467556.stgit@magnolia>
In-Reply-To: <165038953550.1677711.12931148474635467556.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 19 Apr 2022 21:17:43 +0300
Message-ID: <CAOQ4uxhze7YVAcHbL=fjH+YT9geuujgNt4VjUV9haXdkW9ieSA@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 8:32 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> This is a regression test to make sure that nonzero error returns from
> a filesystem's ->sync_fs implementation are actually passed back to
> userspace when the call stack involves syncfs(2).
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/xfs/839     |   42 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/839.out |    2 ++
>  2 files changed, 44 insertions(+)
>  create mode 100755 tests/xfs/839
>  create mode 100644 tests/xfs/839.out
>
>
> diff --git a/tests/xfs/839 b/tests/xfs/839
> new file mode 100755
> index 00000000..9bfe93ef
> --- /dev/null
> +++ b/tests/xfs/839
> @@ -0,0 +1,42 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 839
> +#
> +# Regression test for kernel commits:
> +#
> +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> +#
> +# During a code inspection, I noticed that sync_filesystem ignores the return
> +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> +# that syncfs(2) does not capture internal filesystem errors that are neither
> +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> +# so that had to be corrected as well.
> +#
> +# The kernel commits above fix this problem, so this test tries to trigger the
> +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> +# hope that the EIO generated as a result of the filesystem being shut down is
> +# only visible via ->sync_fs.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick shutdown
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_require_xfs_io_command syncfs
> +_require_scratch_nocheck
> +_require_scratch_shutdown
> +

From all the commotion around generic vs. xfs, you forgot:

_supported_fs xfs

Otherwise,

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
