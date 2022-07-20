Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CABC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 09:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiGTJ6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 05:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGTJ6N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 05:58:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70FAA12A84
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 02:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658311091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EQvxpPOoUaUU0AxHsyLj0LNLlrGA3fuwwOyk72E2lmo=;
        b=D/cVcFp2u6ZfnAzpIp5GeWXkKAQXg3KLmCJICp5LiiznCLqANoPkJHtVPDyCZl6OfM1duW
        e/Kc1iZIcUinhemIcEzIA+cHJUa+XTeiG2TwA5Bw9ql+fQFvK8K+LtReObgHEEjrFyqvv/
        XKFaYhLyrckiiT+E0o4ZscDaN3fCrvM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-7XaCFGqbM5Wq7gH65SvOrQ-1; Wed, 20 Jul 2022 05:58:10 -0400
X-MC-Unique: 7XaCFGqbM5Wq7gH65SvOrQ-1
Received: by mail-qt1-f199.google.com with SMTP id cf20-20020a05622a401400b0031efad5abb9so3055322qtb.10
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 02:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EQvxpPOoUaUU0AxHsyLj0LNLlrGA3fuwwOyk72E2lmo=;
        b=jFY5bEoQ4+PQDuhN5NWokvTpapV2ECX4wDb3aF+6SS4rXS90NjRwKLEbhmXnSAV8nw
         4/SZgwCydkB7uhnmPulqUbc6AWl9u6Su6hRYLYz6e8n4GqTEUh2xnVK7KXtVtP4mFF4l
         kSrDwCUp0W3PvwzV/9r3dPzgkusxjGZBXdvZ5f3TUJZMP7zZ0rHZ/oMV8VQ2X9iXjVlV
         iHX9YRpwIiXOfrZK3BbdbRYrFLW9zqoT4+8v9xKKxRKegDW0uTFxKs+pW0Eka31sqEEU
         l3NfLI2ahfX+Sg4gocHWdGR3CQq0NU9Gt+D4ngvwddKwoHMH6p49Dtu93/KyUzgQh5rn
         ZtFA==
X-Gm-Message-State: AJIora8lrEuAH4sgOknIPm8X71J4X6B0+TGyIBarf/5+f0U7qeU1H3W5
        NrLdahlExzibAXN9bSm7nfgp5o6qBevhwxLuu8itENxrocQ+BFTK79vUPxq7VeOmsUFMPkueprW
        tFZRQ3l6YBQJlkqb0a4G1
X-Received: by 2002:a05:622a:216:b0:31e:df05:8154 with SMTP id b22-20020a05622a021600b0031edf058154mr17829076qtx.669.1658311089741;
        Wed, 20 Jul 2022 02:58:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uWNoUUoBfNNv4TqX7ws1LzIz274q/JnThxzEi7FeYez8BQCm03CXA+fp1adqbn35qtaFyrgA==
X-Received: by 2002:a05:622a:216:b0:31e:df05:8154 with SMTP id b22-20020a05622a021600b0031edf058154mr17829067qtx.669.1658311089477;
        Wed, 20 Jul 2022 02:58:09 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x20-20020a05620a0b5400b006a6ab259261sm15954153qkg.29.2022.07.20.02.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 02:58:08 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:58:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] generic/275: fix premature enospc errors when fs
 block size is large
Message-ID: <20220720095803.bnvp6rqpbfwa3g2r@zlang-mailbox>
References: <165826662758.3249425.5439317033584646383.stgit@magnolia>
 <165826663321.3249425.14767713688923502274.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165826663321.3249425.14767713688923502274.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 02:37:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When running this test on an XFS filesystem with a 64k block size, I
> see this error:
> 
> generic/275       - output mismatch (see /var/tmp/fstests/generic/275.out.bad)
>     --- tests/generic/275.out   2021-05-13 11:47:55.694860280 -0700
>     +++ /var/tmp/fstests/generic/275.out.bad    2022-07-19 10:38:41.840000000 -0700
>     @@ -2,4 +2,7 @@
>      ------------------------------
>      write until ENOSPC test
>      ------------------------------
>     +du: cannot access '/opt/tmp1': No such file or directory
>     +stat: cannot statx '/opt/tmp1': No such file or directory
>     +/tmp/fstests/tests/generic/275: line 74: [: -lt: unary operator expected
>      done
>     ...
>     (Run 'diff -u /tmp/fstests/tests/generic/275.out /var/tmp/fstests/generic/275.out.bad'  to see the entire diff)
> 
> The 275.full file indicates that the test was unable to recreate the
> $SCRATCH_MNT/tmp1 file after we freed all but the last 256K of free
> space in the filesystem.  I mounted the scratch fs, and df reported
> exactly 256K of free space available, which means there are 4 blocks
> left in the filesystem for user programs to use.
> 
> Unfortunately for this test, xfs_create requires sufficient free blocks
> in the filesystem to handle full inode btree splits and the maximal
> directory expansion for a new dirent.  In other words, there must be
> enough free space to handle the worst case space consumption.  That
> quantity is 26 blocks, hence the last dd in the test fails with ENOSPC,
> which makes the test fail.
> 
> Fix all this by creating the file that we use to test the low-space file
> write *before* we drain the free space down to 256K.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/275 |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/generic/275 b/tests/generic/275
> index 6189edca..f3b05409 100755
> --- a/tests/generic/275
> +++ b/tests/generic/275
> @@ -37,6 +37,15 @@ _scratch_unmount 2>/dev/null
>  _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
> +# Certain filesystems such as XFS require sufficient free blocks to handle the
> +# worst-case directory expansion as a result of a creat() call.  If the fs
> +# block size is very large (e.g. 64k) then the number of blocks required for
> +# the creat() call can represent far more free space than the 256K left at the
> +# end of this test.  Therefore, create the file that the last dd will write to
> +# now when we know there's enough free blocks.
> +later_file=$SCRATCH_MNT/later
> +touch $later_file

Make sense to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +
>  # this file will get removed to create 256k of free space after ENOSPC
>  # conditions are created.
>  dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=256K count=1 >>$seqres.full 2>&1
> @@ -63,12 +72,12 @@ _freespace=`$DF_PROG -k $SCRATCH_MNT | tail -n 1 | awk '{print $5}'`
>  
>  # Try to write more than available space in chunks that will allow at least one
>  # full write to succeed.
> -dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=128k count=8 >>$seqres.full 2>&1
> +dd if=/dev/zero of=$later_file bs=128k count=8 >>$seqres.full 2>&1
>  echo "Bytes written until ENOSPC:" >>$seqres.full
> -du $SCRATCH_MNT/tmp1 >>$seqres.full
> +du $later_file >>$seqres.full
>  
>  # And at least some of it should succeed.
> -_filesize=`_get_filesize $SCRATCH_MNT/tmp1`
> +_filesize=`_get_filesize $later_file`
>  [ $_filesize -lt $((128 * 1024)) ] && \
>  	_fail "Partial write until enospc failed; wrote $_filesize bytes."
>  
> 

