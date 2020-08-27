Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C89C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 202BD22CB1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uDbHUAs7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0G6V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0G6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:58:21 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC15FC061264;
        Wed, 26 Aug 2020 23:58:20 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c6so3983172ilo.13;
        Wed, 26 Aug 2020 23:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=umXYkWphpijjeghdwFU5ZWoU2/HsPMaTEPL14+6DbZ0=;
        b=uDbHUAs7Ku9OZNTfklnf42MnyA2DgTl7NVJbP3mxSQzwG2BeWLeLMdHLJSbJ85d0Rq
         6cCIX8NZuz4OOrPo48vrCRBjeWO5s6XG9yWk5TogbfEE9cLuJMnmDVOWSoicBR9AMHhc
         /PK5FC/nDZp/jEa3BPzWL2KsJJ6pU1IL7lzKXwD7OR5halo6BctcZvE/vGtS+Kf0/DhP
         tVwNiFv2hqmw8F4iFcyghbey/itIJqguY4H8HKVUJMEdDjDt/fwSsnXbjAGSbrHXSbAl
         X0PTBnME5zRy4wGdHdfti5erFDworUoAAnmSwTEmTvAcHx19R9Ha+cOPEUpmzPCPWsUZ
         sLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=umXYkWphpijjeghdwFU5ZWoU2/HsPMaTEPL14+6DbZ0=;
        b=OSMf8RwiF9MTTgkOTJU6X9U/rY/0n6jWXBGVk8cIaYKgCJQxHK4NJAE5V7hDiFo4X8
         uZWxoZ7Np0m8MX6+umPWS8S96sxCyBSn3Hd4nsG5XIPSM/u4mIsNw2lDA1anwrqrMb90
         wGR1zPo12WxlBxyWxxy1Qr5C8bJFqAo3nAdAExdKNyPeVhmYlXmo4KOgUJvggy4ANABI
         966iEvD0G10LE244eeMCdMyv/fiqhc1SXEBkHeuAPXtaOMQL/VkK7Wpd/eujo9fuTgT/
         E//dDOAVi4azOA56uki9w9a5feb7pJKIlGZEovpL4b/UinlY1MTVzrvR2YQnQcw4GZXW
         NJNA==
X-Gm-Message-State: AOAM530okO7g68AYd5Ec6x/w6otXRVqk/pUZiXLdokVN7Uw5Gr11k/XC
        6sXslrhrp7Vb9WqKBd3VPpttACmFao3+v6cBgTAvlik3
X-Google-Smtp-Source: ABdhPJxSGGRw/M8Q4dCQmp7i/tNFsXBNg8QutPs/3qHq2iE6CPXKY1nXIKFlm7yyXuc515sIYlpZ7GU5z1ikXz3cZgo=
X-Received: by 2002:a92:da0a:: with SMTP id z10mr16004358ilm.275.1598511500164;
 Wed, 26 Aug 2020 23:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200826143815.360002-1-bfoster@redhat.com> <20200826143815.360002-2-bfoster@redhat.com>
In-Reply-To: <20200826143815.360002-2-bfoster@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Aug 2020 09:58:09 +0300
Message-ID: <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 5:38 PM Brian Foster <bfoster@redhat.com> wrote:
>
> Several generic fstests use dm-log-writes to test the filesystem for
> consistency at various crash recovery points. dm-log-writes and the
> associated replay mechanism rely on zeroing via discard to clear
> stale blocks when moving to various points in time of the fs. If the
> storage doesn't provide zeroing or the discard requests exceed the
> hardcoded maximum (128MB) of the fallback solution to physically
> write zeroes, stale blocks are left around in the target fs. This
> scheme is known to cause issues on XFS v5 superblocks if recovery
> observes metadata from a future variant of an fs that has been
> replayed to an older point in time. This corrupts the filesystem and
> leads to false test failures.
>
> generic/482 already works around this problem by using a thin volume
> as the target device, which provides consistent and efficient
> discard zeroing behavior, but other tests have seen similar issues
> on XFS. Add an XFS specific check to the dmlogwrites init time code
> that requires discard zeroing support and otherwise skips the test
> to avoid false positive failures.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  common/dmlogwrites | 10 ++++++++--
>  common/rc          | 14 ++++++++++++++
>  tests/generic/470  |  2 +-
>  3 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index 573f4b8a..92cc6ce2 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -43,9 +43,10 @@ _require_log_writes_dax_mountopt()
>         _require_test_program "log-writes/replay-log"
>
>         local ret=0
> -       local mountopt=$1
> +       local dev=$1
> +       local mountopt=$2
>
> -       _log_writes_init $SCRATCH_DEV
> +       _log_writes_init $dev
>         _log_writes_mkfs > /dev/null 2>&1
>         _log_writes_mount "-o $mountopt" > /dev/null 2>&1
>         # Check options to be sure.
> @@ -66,6 +67,11 @@ _log_writes_init()
>         [ -z "$blkdev" ] && _fail \
>         "block dev must be specified for _log_writes_init"
>
> +       # XFS requires discard zeroing support on the target device to work
> +       # reliably with dm-log-writes. Use dm-thin devices in tests that want
> +       # to provide reliable discard zeroing support.
> +       [ $FSTYP == "xfs" ] && _require_discard_zeroes $blkdev
> +

I imagine that ext4 could also be burned by this.
Do we have a reason to limit this requirement to xfs?
I prefer to make it generic.

>         local BLK_DEV_SIZE=`blockdev --getsz $blkdev`
>         LOGWRITES_NAME=logwrites-test
>         LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
> diff --git a/common/rc b/common/rc
> index aa5a7409..fedb5221 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4313,6 +4313,20 @@ _require_mknod()
>         rm -f $TEST_DIR/$seq.null
>  }
>
> +# check that discard is supported and subsequent reads return zeroes
> +_require_discard_zeroes()
> +{
> +       local dev=$1
> +
> +       _require_command "$BLKDISCARD_PROG" blkdiscard
> +
> +       $XFS_IO_PROG -c "pwrite -S 0xcd 0 4k" $dev > /dev/null 2>&1 ||
> +               _fail "write error"
> +       $BLKDISCARD_PROG -o 0 -l 1m $dev || _notrun "no discard support"
> +       hexdump -n 4096 $dev | head -n 1 | grep cdcd &&
> +               _notrun "no discard zeroing support"
> +}
> +

I am fine with your solution, but if there was a discussion on the best way to
solve the problem, I missed it, so would like to hear what Chritoph has to say.

Thanks,
Amir.
