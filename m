Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36EAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Oct 2022 11:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJHLLN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Oct 2022 07:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJHLLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Oct 2022 07:11:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6086E10567
        for <linux-xfs@vger.kernel.org>; Sat,  8 Oct 2022 04:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665227470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2uzPhe7+sVhPn7+Ulqv8cTg9LAxTrz0NGR5Cpg5L4vw=;
        b=cuMwWdP7iazadhnFuanThIEj28gXdDammDsk2zcObnYECNjprz2PUhfwb/v+GqjnQqlBSk
        lsan2uUAh/u05UBytDkz+ZL8O6EkXDixi4uxRDezaFFqdZmV3l90vdLlLaOyzfXUJLXboi
        PGRbGI2lCDNoB0NlYo9kdZECoCJl80c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-636-JWr57FAsPgqKty-IUzJzMA-1; Sat, 08 Oct 2022 07:11:09 -0400
X-MC-Unique: JWr57FAsPgqKty-IUzJzMA-1
Received: by mail-qv1-f71.google.com with SMTP id dn14-20020a056214094e00b004b1a231394eso4229498qvb.13
        for <linux-xfs@vger.kernel.org>; Sat, 08 Oct 2022 04:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2uzPhe7+sVhPn7+Ulqv8cTg9LAxTrz0NGR5Cpg5L4vw=;
        b=Fnf3iuHqURwW/JFN8yqMavvSyaChIN1xpOtGI3ny9zklgvXDUrXt7ZuQscrUeAjwgP
         il8ATWoQPja/oZgoyZzPgu9hz37WXnC6pc4a7RQ6eK4QMk1N2J+28WACU7GEltvNhEq5
         pl+hqRrrnh5bft+1dr49qBZuVW7SiFGtu79np11jmkAeSgk4WBlzVrDwivvtOg4xz5lR
         PdWKVQFjP2/m7UoyjKmXDJZzLadHMjHa91/TrGOUeV8EyuX+i5XFnZ23Ujao8l2ftxmd
         Qgnzs3NWxztodVukIVhl+l4Z2TvFoJppwNYoVKReVXghfUjV1ZOz3fIpx7ZCUtL3D7Qi
         9uJw==
X-Gm-Message-State: ACrzQf0JFtLMl9s+8pa1+01y9bOgo/WXdG4e2HTgKyXt+rCIJ1D/wueS
        qU4tKfvv5ayCvWY+sNbnzzJ9UP1qvu9dFT/G2l5fq/S23JPlaub0lNKfO6OmI7A/OrDVr/TyXx+
        0rDREi0P14FUV70x/iIKN
X-Received: by 2002:a05:620a:4250:b0:6cf:a822:7c7e with SMTP id w16-20020a05620a425000b006cfa8227c7emr6820408qko.503.1665227468434;
        Sat, 08 Oct 2022 04:11:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7lhYgAMC8XELDZ5ZddtHdWK9ny7hLruZeFRy4xp/tlPQ8BKL3SPB5nOhIzlWJfyzlwbchCVQ==
X-Received: by 2002:a05:620a:4250:b0:6cf:a822:7c7e with SMTP id w16-20020a05620a425000b006cfa8227c7emr6820388qko.503.1665227468134;
        Sat, 08 Oct 2022 04:11:08 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i13-20020a05620a248d00b006b5e296452csm4706330qkn.54.2022.10.08.04.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 04:11:07 -0700 (PDT)
Date:   Sat, 8 Oct 2022 19:11:02 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs/128: try to force file allocation behavior
Message-ID: <20221008111102.mb25fytm5yilkefr@zlang-mailbox>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
 <166500905541.886939.4232929527218167462.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166500905541.886939.4232929527218167462.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 05, 2022 at 03:30:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Over the years, I've noticed that this test occasionally fails when I've
> programmed the allocator to hand out the minimum amount of space with
> each allocation or if extent size hints are enabled:
> 
> --- /tmp/fstests/tests/xfs/128.out      2022-09-01 15:09:11.506679341 -0700
> +++ /var/tmp/fstests/xfs/128.out.bad    2022-10-04 17:32:50.992000000 -0700
> @@ -20,7 +21,9 @@
>  56ed2f712c91e035adeeb26ed105a982  SCRATCH_MNT/test-128/file3
>  b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file4
>  Check files
>  free blocks after creating some reflink copies is in range
>  free blocks after CoW some reflink copies is in range
> -free blocks after defragging all reflink copies is in range
> -free blocks after all tests is in range
> +free blocks after defragging all reflink copies has value of 8620027
> +free blocks after defragging all reflink copies is NOT in range 8651819 .. 8652139
> +free blocks after all tests has value of 8620027
> +free blocks after all tests is NOT in range 8651867 .. 8652187
> 
> It turns out that under the right circumstances, the _pwrite_byte at the
> start of this test will end up allocating two extents to file1.  This
> almost never happens when delalloc is enabled or when the extent size is
> large, and is more prone to happening if the extent size is > 1FSB but
> small, the allocator hands out small allocations, or if writeback shoots
> down pages in random order.
> 
> When file1 gets more than 1 extent, problems start to happen.  The free
> space accounting checks at the end of the test assume that file1 and
> file4 still share the same space at the end of the test.  This
> definitely happens if file1 gets one extent (since fsr ignores
> single-extent files), but if there's more than 1, fsr will try to
> defragment it.  If fsr succeeds in copying the file contents to a temp
> file with fewer extents than the source file, it will switch the
> contents, but unsharing the contents in the process.  This cause the
> free space to be lower than expected, and the test fails.
> 
> Resolve this situation by preallocating space beforehand to try to set
> up file1 with a single space extent.  If the test fails and we got more
> than one extent, note that in the output.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/128 |   34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/tests/xfs/128 b/tests/xfs/128
> index db5d9a60db..2d2975115e 100755
> --- a/tests/xfs/128
> +++ b/tests/xfs/128
> @@ -34,7 +34,20 @@ margin=160
>  blksz=65536
>  real_blksz="$(_get_block_size $testdir)"
>  blksz_factor=$((blksz / real_blksz))
> +
> +# The expected free space numbers in this test require file1 and file4 to share
> +# the same blocks at the end of the test.  Therefore, we need the allocator to
> +# give file1 a single extent at the start of the test so that fsr will not be
> +# tempted to "defragment" a multi-extent file1 or file4.  Defragmenting really
> +# means rewriting the file, and if that succeeds on either file, we'll have
> +# unshared the space and there will be too little free space.  Therefore,
> +# preallocate space to try to produce a single extent.
> +$XFS_IO_PROG -f -c "falloc 0 $((blks * blksz))" $testdir/file1 >> $seqres.full
>  _pwrite_byte 0x61 0 $((blks * blksz)) $testdir/file1 >> $seqres.full
> +sync
> +
> +nextents=$($XFS_IO_PROG -c 'stat' $testdir/file1 | grep 'fsxattr.nextents' | awk '{print $3}')
> +
>  _cp_reflink $testdir/file1 $testdir/file2
>  _cp_reflink $testdir/file2 $testdir/file3
>  _cp_reflink $testdir/file3 $testdir/file4
> @@ -106,10 +119,23 @@ test $c14 = $c24 || echo "File4 changed by defrag"
>  
>  #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
>  
> -_within_tolerance "free blocks after creating some reflink copies" $free_blocks1 $((free_blocks0 - (blks * blksz_factor) )) $margin -v
> -_within_tolerance "free blocks after CoW some reflink copies" $free_blocks2 $((free_blocks1 - 2)) $margin -v
> -_within_tolerance "free blocks after defragging all reflink copies" $free_blocks3 $((free_blocks2 - (blks * 2 * blksz_factor))) $margin -v
> -_within_tolerance "free blocks after all tests" $free_blocks3 $((free_blocks0 - (blks * 3 * blksz_factor))) $margin -v
> +freesp_bad=0
> +
> +_within_tolerance "free blocks after creating some reflink copies" \
> +	$free_blocks1 $((free_blocks0 - (blks * blksz_factor) )) $margin -v || freesp_bad=1
> +
> +_within_tolerance "free blocks after CoW some reflink copies" \
> +	$free_blocks2 $((free_blocks1 - 2)) $margin -v || freesp_bad=1
> +
> +_within_tolerance "free blocks after defragging all reflink copies" \
> +	$free_blocks3 $((free_blocks2 - (blks * 2 * blksz_factor))) $margin -v || freesp_bad=1
> +
> +_within_tolerance "free blocks after all tests" \
> +	$free_blocks3 $((free_blocks0 - (blks * 3 * blksz_factor))) $margin -v || freesp_bad=1
> +
> +if [ $freesp_bad -ne 0 ] && [ $nextents -gt 0 ]; then
> +	echo "free space checks probably failed because file1 nextents was $nextents"
> +fi
>  
>  # success, all done
>  status=0
> 

