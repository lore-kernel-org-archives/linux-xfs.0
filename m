Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B67C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 04:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiFUE2J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 00:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243751AbiFUE2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 00:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 253F3B11
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 21:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655785676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AX0MakS0IcTWBTzGIycUIcpbWwDZXgDpWGfkwzQQevk=;
        b=gmBI1SjEsPo3S4N/e6ji4YoILQDCEw0rehqG4fFBHmGkdrRqvX8l6gk60UUvFhChOefqZ1
        QFCxDDoi8M/9Yax3HgqKXi+yA1dcwSLZY6EItVaQD0eLLp9ybuG88/l6Ei5rs23qAyPt6t
        hN+oG6jcAFsexVn1o8vygo2O8hagdFU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-T2RYBnB6MZCjtlS-RmvEXg-1; Tue, 21 Jun 2022 00:27:53 -0400
X-MC-Unique: T2RYBnB6MZCjtlS-RmvEXg-1
Received: by mail-qk1-f200.google.com with SMTP id bk10-20020a05620a1a0a00b006a6b1d676ebso15216958qkb.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 21:27:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AX0MakS0IcTWBTzGIycUIcpbWwDZXgDpWGfkwzQQevk=;
        b=Hscm3hkDVziWt3hUiIhO88MURwmAF4D/n+t0PtMwXlp7T/E2BEONcvsu+2ln4jQtmh
         4tvSv0dhHsuf62Sq6Hy+BFi2E7YIgCBz634evNKJliPESXlAVeJV7HacKwZXTTFb3pnB
         oGX4SuntJfZl4UCyInSmxfv0Bv3rU9Fblo54KCY5ei5/+egIUk/399hvdSlCZprc++Bi
         3EfQp8FQWP27lc/zEhs7H0IA+Xermd+wAjvwc1ngwsNL31Xu+ZAqPzEqgMYdBRKNTWN+
         6PVlROst/uMFd3xTyYStlD/x/AVTwhjX1/6OS5Y0UwK1xlg0/BQdCaZb8GKT9vLxpcwf
         uXTw==
X-Gm-Message-State: AJIora8BL+mFaotdshF0xNzoH5c43gGZODmw7BKtRPB5X/QWdApSPeof
        XxlRyZjNXr60RhfJpOePcPmrVEXPLPxzATKN1V+YFGi8xLKO8szraWnC2H9HBdm+tjDJRPRFLs8
        FZBRMaVp0zbhqBOQYE8W7
X-Received: by 2002:ac8:5783:0:b0:305:32:700d with SMTP id v3-20020ac85783000000b003050032700dmr22415865qta.31.1655785673179;
        Mon, 20 Jun 2022 21:27:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tAvwYEsrRM8EqSfCE79iV16z4OO+cMwGaJylBEc5Zw0TVhWlT+GG3UYc7BhQMwnLoXugUN2w==
X-Received: by 2002:ac8:5783:0:b0:305:32:700d with SMTP id v3-20020ac85783000000b003050032700dmr22415860qta.31.1655785672909;
        Mon, 20 Jun 2022 21:27:52 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j5-20020a05620a000500b006a74458410csm13621270qki.123.2022.06.20.21.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 21:27:52 -0700 (PDT)
Date:   Tue, 21 Jun 2022 12:27:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/122: escape %zu in printf with %% not \\%
Message-ID: <20220621042747.2i3gu7rlazfw6xud@zlang-mailbox>
References: <1655761411-11698-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655761411-11698-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 20, 2022 at 04:43:31PM -0500, Eric Sandeen wrote:
> The standard way to escape % in a printf is with %%; although \\%zu
> seems to have worked in awk until recently, an upgrade on Fedora 36
> has started failing:
> 
> awk: cmd. line:1: (FILENAME=- FNR=1) fatal: not enough arguments to satisfy format string
>         'printf("sizeof(%s) = \%zu\n", sizeof(%s));
>     '
>                                               ^ ran out for this one
> Switching the escape to "%%" fixes this for me, and also works
> on my very old RHEL7 mcahine.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Make sense, thanks for fixing this.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/122 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 5200615..18748e6 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -186,7 +186,7 @@ egrep '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
>  egrep -v -f $tmp.ignore |\
>  sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
>  sort | uniq |\
> -awk '{printf("printf(\"sizeof(%s) = \\%zu\\n\", sizeof(%s));\n", $0, $0);}' |\
> +awk '{printf("printf(\"sizeof(%s) = %%zu\\n\", sizeof(%s));\n", $0, $0);}' |\
>  cat >> $cprog
>  
>  #
> @@ -199,7 +199,7 @@ awk '
>     /typedef struct xfs_sb/ { structon = 1; next }
>     structon && $2 ~ /^sb_/ { sub(/[;,]/,"",$2)
>                               sub(/XFSLABEL_MAX/,"12",$2)
> -                             printf("printf(\"offsetof(xfs_sb_t, %s) = \\%zu\\n\", offsetof(xfs_sb_t, %s));", $2, $2); next}
> +                             printf("printf(\"offsetof(xfs_sb_t, %s) = %%zu\\n\", offsetof(xfs_sb_t, %s));", $2, $2); next}
>     structon && /}/ { structon = 0; next}
>  '>>$cprog
>  
> -- 
> 1.8.3.1
> 

