Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7452C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 06:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLQGcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 01:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiLQGcs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 01:32:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B8A23174
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 22:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671258728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OX63/uVwyxJsIkn1b8ugDl4smCldx7j6ZQKlTptqwI0=;
        b=G0GxHZdJjKcr9DhqyyvG9ab3tUsfOcxONTvsk7RM1qxqsG98DFLvoVuzAAPfxJVgiSkqkj
        kaZb9Y82Hd+p335LR1vNxStM7wRKWzu1q1r0cTC4e8vJGSka2okW8W+DUmvbVeMgHgFYK9
        zVGPUUEgCbAd/Ys8IkMMjQ2XCeBfqvc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-jcGi3YeMN7Kr5-oJ8d2xng-1; Sat, 17 Dec 2022 01:32:07 -0500
X-MC-Unique: jcGi3YeMN7Kr5-oJ8d2xng-1
Received: by mail-pj1-f71.google.com with SMTP id f6-20020a17090a700600b00219d2137efeso2161762pjk.3
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 22:32:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OX63/uVwyxJsIkn1b8ugDl4smCldx7j6ZQKlTptqwI0=;
        b=Y9wXX3zjhoYe4erUctFopDESqE+ARXQOEi3eGB3r9E61SCctM6H77Gdr5PD3xH0aA6
         Uu5Hre0WwF2F/fQBJ6pHCUmedtDB7Ub1g6A7ZBELwWVZqSXFBjG8//MMiuwCwejnsUwD
         Yx3+sPb7ZGMcdqyrMe42Bj6yiYilTIqV/1O0liMv4fVO4P3ljbkA7L9T51DBlLLPLuqZ
         K9j7enDcWpDPQQqWabBC3ETk/RP3u03+w6o4R3ndifpFWTC8XiBLUcgCRi/Z/iMP5kC8
         LnKZRtoy2EJQr+DvPFFcDSEYbx4Q9IrbW5pze+m1xRHZP4Q79KzxZZYplaak9piauB7b
         BZRw==
X-Gm-Message-State: AFqh2kovBNwNyG+bPKROLvtMlbo4VX1qKMOd8yded3eWZIz2NBSQiASK
        RiQqN1c5YVIjh0k1eAXON8tIXmSY9fy7QonHzXLDKGlfr1nGZ8QU4S5yd6AzgFXVps+us+/UcAT
        w+mRzfydzEDy38zhzsh6Q
X-Received: by 2002:a17:902:e5ca:b0:190:ee85:b25f with SMTP id u10-20020a170902e5ca00b00190ee85b25fmr19856366plf.48.1671258725511;
        Fri, 16 Dec 2022 22:32:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsAsaIrQrNRRR/6o/MZu3s6FGCn122hgykjj1FM2nQWtCj0QumMVWS1HRMBNTsNKZMMmMDUHA==
X-Received: by 2002:a17:902:e5ca:b0:190:ee85:b25f with SMTP id u10-20020a170902e5ca00b00190ee85b25fmr19856345plf.48.1671258725201;
        Fri, 16 Dec 2022 22:32:05 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b00188fce6e8absm2621313plf.280.2022.12.16.22.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 22:32:04 -0800 (PST)
Date:   Sat, 17 Dec 2022 14:32:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] common/xfs: create a helper for restoring metadumps
 to the scratch devs
Message-ID: <20221217063200.hfplsxtwful7ehlg@zlang-mailbox>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096072069.1750373.18446461395763381324.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167096072069.1750373.18446461395763381324.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 11:45:20AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor the open-coded $XFS_MDRESTORE_PROG calls into a proper
> _scratch_xfs_mdrestore helper.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/xfs    |    9 +++++++++
>  tests/xfs/129 |    2 +-
>  tests/xfs/234 |    2 +-
>  tests/xfs/253 |    2 +-
>  tests/xfs/284 |    2 +-
>  tests/xfs/291 |    2 +-
>  tests/xfs/336 |    2 +-
>  tests/xfs/432 |    2 +-
>  tests/xfs/503 |    8 ++++----
>  9 files changed, 20 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 27d6ac84e3..216dab3bcd 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -660,6 +660,15 @@ _scratch_xfs_metadump()
>  	_xfs_metadump "$metadump" "$SCRATCH_DEV" "$logdev" nocompress "$@"
>  }
>  
> +# Restore snapshotted metadata on the scratch device
> +_scratch_xfs_mdrestore()
> +{
> +	local metadump=$1
> +	shift
> +
> +	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
> +}
> +
>  # run xfs_check and friends on a FS.
>  _check_xfs_filesystem()
>  {
> diff --git a/tests/xfs/129 b/tests/xfs/129
> index 09d40630d0..6f2ef5640d 100755
> --- a/tests/xfs/129
> +++ b/tests/xfs/129
> @@ -53,7 +53,7 @@ _scratch_xfs_metadump $metadump_file
>  
>  # Now restore the obfuscated one back and take a look around
>  echo "Restore metadump"
> -$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
> +SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
>  SCRATCH_DEV=$TEST_DIR/image _scratch_mount
>  SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
>  
> diff --git a/tests/xfs/234 b/tests/xfs/234
> index cc1ee9a8ca..57d447c056 100755
> --- a/tests/xfs/234
> +++ b/tests/xfs/234
> @@ -53,7 +53,7 @@ _scratch_xfs_metadump $metadump_file
>  
>  # Now restore the obfuscated one back and take a look around
>  echo "Restore metadump"
> -$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
> +SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
>  SCRATCH_DEV=$TEST_DIR/image _scratch_mount
>  SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
>  
> diff --git a/tests/xfs/253 b/tests/xfs/253
> index 1cfc218088..ce90247777 100755
> --- a/tests/xfs/253
> +++ b/tests/xfs/253
> @@ -152,7 +152,7 @@ _scratch_unmount
>  _scratch_xfs_metadump $METADUMP_FILE
>  
>  # Now restore the obfuscated one back and take a look around
> -$XFS_MDRESTORE_PROG "${METADUMP_FILE}" "${SCRATCH_DEV}"
> +_scratch_xfs_mdrestore "$METADUMP_FILE"
>  
>  _scratch_mount
>  
> diff --git a/tests/xfs/284 b/tests/xfs/284
> index e2bd05d4c7..58f330035e 100755
> --- a/tests/xfs/284
> +++ b/tests/xfs/284
> @@ -49,7 +49,7 @@ _scratch_unmount
>  # xfs_mdrestore should refuse to restore to a mounted device
>  _scratch_xfs_metadump $METADUMP_FILE
>  _scratch_mount
> -$XFS_MDRESTORE_PROG $METADUMP_FILE $SCRATCH_DEV 2>&1 | filter_mounted
> +_scratch_xfs_mdrestore $METADUMP_FILE 2>&1 | filter_mounted
>  _scratch_unmount
>  
>  # Test xfs_copy to a mounted device
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index f5fea7f9a5..600dcb2eba 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -93,7 +93,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
>  # Yes they can!  Now...
>  # Can xfs_metadump cope with this monster?
>  _scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
> -$XFS_MDRESTORE_PROG $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
> +SCRATCH_DEV=$tmp.img _scratch_xfs_mdrestore $tmp.metadump || _fail "xfs_mdrestore failed"
>  SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
>  	_fail "xfs_repair of metadump failed"
>  
> diff --git a/tests/xfs/336 b/tests/xfs/336
> index ee8ec649cb..5bcac976e4 100755
> --- a/tests/xfs/336
> +++ b/tests/xfs/336
> @@ -65,7 +65,7 @@ _scratch_xfs_metadump $metadump_file
>  
>  # Now restore the obfuscated one back and take a look around
>  echo "Restore metadump"
> -$XFS_MDRESTORE_PROG $metadump_file $TEST_DIR/image
> +SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
>  SCRATCH_DEV=$TEST_DIR/image _scratch_mount
>  SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
>  
> diff --git a/tests/xfs/432 b/tests/xfs/432
> index 676be9bd8a..66315b0398 100755
> --- a/tests/xfs/432
> +++ b/tests/xfs/432
> @@ -87,7 +87,7 @@ test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
>  
>  echo "Try to metadump"
>  _scratch_xfs_metadump $metadump_file -w
> -$XFS_MDRESTORE_PROG $metadump_file $metadump_img
> +SCRATCH_DEV=$metadump_img _scratch_xfs_mdrestore $metadump_file
>  
>  echo "Check restored metadump image"
>  SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> diff --git a/tests/xfs/503 b/tests/xfs/503
> index 18bd8694c8..c786b04ccd 100755
> --- a/tests/xfs/503
> +++ b/tests/xfs/503
> @@ -66,25 +66,25 @@ _check_scratch_fs
>  _scratch_unmount
>  
>  echo mdrestore
> -$XFS_MDRESTORE_PROG $metadump_file $SCRATCH_DEV
> +_scratch_xfs_mdrestore $metadump_file
>  _scratch_mount
>  _check_scratch_fs
>  _scratch_unmount
>  
>  echo mdrestore a
> -$XFS_MDRESTORE_PROG $metadump_file_a $SCRATCH_DEV
> +_scratch_xfs_mdrestore $metadump_file_a
>  _scratch_mount
>  _check_scratch_fs
>  _scratch_unmount
>  
>  echo mdrestore g
> -$XFS_MDRESTORE_PROG $metadump_file_g $SCRATCH_DEV
> +_scratch_xfs_mdrestore $metadump_file_g
>  _scratch_mount
>  _check_scratch_fs
>  _scratch_unmount
>  
>  echo mdrestore ag
> -$XFS_MDRESTORE_PROG $metadump_file_ag $SCRATCH_DEV
> +_scratch_xfs_mdrestore $metadump_file_ag
>  _scratch_mount
>  _check_scratch_fs
>  _scratch_unmount
> 

