Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D76C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 05:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbiCVFPg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 01:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbiCVFPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 01:15:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 961A3DF95
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 22:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647926044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hYTlbXTjgH3vKFtj13uZH7n+ak7Y8QVfZ3xE+Nn/wfI=;
        b=P3mJzg/f+R61/vcoZEerAVgVzNkaq2E644XgwvnuZNPhLmTtaD7xUJHP9UNastcIwSzc7e
        aIcU58xz9HCdEeytIgDx4bbutI25QNiUgkVq9Pn8FkNUEkBaXcWdLz1T5H9N5+8M7BHb9g
        ymiUsXWXaUvt/uUWZZK9LaZgLlibcA8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-orM5JLBbNAaeWcmUTDjcow-1; Tue, 22 Mar 2022 01:14:02 -0400
X-MC-Unique: orM5JLBbNAaeWcmUTDjcow-1
Received: by mail-wr1-f69.google.com with SMTP id i64-20020adf90c6000000b00203f2b5e090so1943551wri.9
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 22:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=hYTlbXTjgH3vKFtj13uZH7n+ak7Y8QVfZ3xE+Nn/wfI=;
        b=Z3tC1d9sL84Ra4nF5FTxTnIePW014HrfSlKB8BlnQv3nOGsyGB2nZ8MPVYm1uyAJsd
         iGtyxPJ83/roi94diZWBa69Q9PZSZkACnvBQ1f8aCzbjGYLzxa/ld3CsBcslUuXJZYr/
         VOC2uzSAdODvEej3D6t04H6ziInKTN3ODLdnC5zYDTV3luhWlGbU3vqGCq3YUY+R0X0h
         Y90nrwtEsVgqtLX9x/GMH7BJkkWKhB3dXwjY4qCx0675bIZ5Dio84Pp2+X7kqRKELxgQ
         S3jbc3JM9CszEZAmO2jNQ9msA3eepw90qxAD/z6PVtKBOUBsYqTMtFpyOYZFv7lkmiKS
         0xyA==
X-Gm-Message-State: AOAM532g5Rr7WQc1Ugud987FefZ5n/+o7fjzrdqQ7qkH2o+99yshq5UD
        G8XE1xsC3wIH0yrYR4JXwA/ChOJEU9Kuhx6qRxS9MEGJBXl8bFCAh+BGfuZs8QMw8e4dVbE6NJM
        +361rallcM4R3tFiY6q5r
X-Received: by 2002:a5d:47a7:0:b0:203:d1b4:8f6 with SMTP id 7-20020a5d47a7000000b00203d1b408f6mr21554667wrb.36.1647926041316;
        Mon, 21 Mar 2022 22:14:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXV1kV4RPyUpZoIjm1rybY94jMsV/9CqdxkTOfpNay7noAAgkcxisQu42cyIUrdnGAu6+uPg==
X-Received: by 2002:a5d:47a7:0:b0:203:d1b4:8f6 with SMTP id 7-20020a5d47a7000000b00203d1b408f6mr21554654wrb.36.1647926041002;
        Mon, 21 Mar 2022 22:14:01 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k35-20020a05600c1ca300b0038ca38626c0sm1026796wms.16.2022.03.21.22.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 22:14:00 -0700 (PDT)
Date:   Tue, 22 Mar 2022 13:13:54 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/420: fix occasional test failures due to
 pagecache readahead
Message-ID: <20220322051354.yys6zipuxjfvkkgn@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
 <164740142033.3371628.11850774504699213977.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164740142033.3371628.11850774504699213977.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 08:30:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then, this test fails with this golden output:
> 
> --- xfs/420.out
> +++ xfs/420.out.bad
> @@ -29,7 +29,7 @@
>  Whence Result
>  DATA   0
>  HOLE   131072
> -DATA   196608
> +DATA   192512
>  HOLE   262144
>  Compare files
>  c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file1

Looks like this part easy to cause `git am` misunderstanding[1], Hmm...
any method to deal with that?

[1]
Applying: xfs/420: fix occasional test failures due to pagecache readahead
error: 420.out: does not exist in index
Patch failed at 0001 xfs/420: fix occasional test failures due to pagecache readahead
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

> 
> Curiously, the file checksums always match, and it's not *forbidden* for
> the page cache to have a page backing an unwritten extent that hasn't
> been written.
> 
> The condition that this test cares about is that block 3 (192k-256k) are
> reported by SEEK_DATA as data even if the data fork has a hole and the
> COW fork has an unwritten extent.  Matthew Wilcox thinks this is a side
> effect of readahead.
> 
> To fix this occasional false failure, call SEEK_DATA and SEEK_HOLE only
> on the offsets that we care about.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/420 |   33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/tests/xfs/420 b/tests/xfs/420
> index 12b17588..d38772c9 100755
> --- a/tests/xfs/420
> +++ b/tests/xfs/420
> @@ -50,6 +50,24 @@ _scratch_mount >> $seqres.full 2>&1
>  testdir=$SCRATCH_MNT/test-$seq
>  mkdir $testdir
>  
> +# pagecache readahead can sometimes cause extra pages to be inserted into the
> +# file mapping where we have an unwritten extent in the COW fork.  Call lseek
> +# on each $blksz offset that interests us (as opposed to the whole file) so
> +# that these extra pages are not disclosed.
> +#
> +# The important thing we're testing is that SEEK_DATA reports block 3 as data
> +# when the COW fork has an unwritten mapping and the data fork has a hole.
> +exercise_lseek() {
> +	echo "Seek holes and data in file1"
> +	$XFS_IO_PROG -c "seek -d 0" $testdir/file1
> +	$XFS_IO_PROG -c "seek -h $((2 * blksz))" $testdir/file1 | sed -e '/Whence/d'
> +	echo "Seek holes and data in file2"
> +	$XFS_IO_PROG -c "seek -d 0" $testdir/file2
> +	$XFS_IO_PROG -c "seek -h $((2 * blksz))" $testdir/file2 | sed -e '/Whence/d'
> +	$XFS_IO_PROG -c "seek -d $((3 * blksz))" $testdir/file2 | sed -e '/Whence/d'
> +	$XFS_IO_PROG -c "seek -h $((4 * blksz))" $testdir/file2 | sed -e '/Whence/d'
> +}
> +
>  blksz=65536
>  nr=8
>  filesize=$((blksz * nr))
> @@ -83,10 +101,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
>  
> -echo "Seek holes and data in file1"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> -echo "Seek holes and data in file2"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> +exercise_lseek
>  
>  echo "Compare files"
>  md5sum $testdir/file1 | _filter_scratch
> @@ -102,10 +117,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
>  
> -echo "Seek holes and data in file1"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> -echo "Seek holes and data in file2"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> +exercise_lseek
>  
>  echo "Compare files"
>  md5sum $testdir/file1 | _filter_scratch
> @@ -121,10 +133,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
>  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
>  
> -echo "Seek holes and data in file1"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> -echo "Seek holes and data in file2"
> -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> +exercise_lseek
>  
>  echo "Compare files"
>  md5sum $testdir/file1 | _filter_scratch
> 

