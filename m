Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DDFC433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 03:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJ3DbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 23:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ3DbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 23:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5B8A1BF
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 20:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667100602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTfHmCM8MegwpVC1IsFznKV1yfOViiEMEjqCfINbhu0=;
        b=feyie9QyBtWeiEKjddH9E8bZJXpgFIxw5kCdhpxKVJSqnlLWGkffMS3cjQzgQbju4d1/M2
        D5x1omJD7iw+gEbG50p1C6zc2TypgLcbzI06/rMnxBt1GNSwIzqwE2CM3v5EkzoGz5uqo+
        0+an+nMXP3tRqQRnwyxvLx6BWTVKwy8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-133-PAQk3xQjMI2V-m3QFUIsiA-1; Sat, 29 Oct 2022 23:30:01 -0400
X-MC-Unique: PAQk3xQjMI2V-m3QFUIsiA-1
Received: by mail-qk1-f198.google.com with SMTP id bi38-20020a05620a31a600b006eeb2862816so6693958qkb.0
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 20:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oTfHmCM8MegwpVC1IsFznKV1yfOViiEMEjqCfINbhu0=;
        b=ztsFQGJW/8eHAUhfGjIDtiDM2eJgLB+rGkkBxtxzO1EHw8uTOMZFvSkGXLcfdI0H91
         wwzZgTA1HdnjqkTjN8qDHCJhPfiJ9iJHm/4wrB7MJEc+ESaS2XHgcip64aRSb+ONJLH/
         QRQkfWrleguUDxsiLHY83YRweeIkl+YgjP+v4DQgx3bwF8TrwiZozcyUdvuciq9tHlGl
         nSE2b1kEMb4XWGNa/5s/o4om7VxiW+ukC3K+mn+ziL5ImQ9UNQMcKlbZRh28vrEjhc62
         cBirhszk1vJrgXMj1AXJZuzxByO+TPTn/Je0LIw9bwnFXGeGpSoqQP/2Qaa1oppTUQEy
         jZYQ==
X-Gm-Message-State: ACrzQf3su3ju2InBOUj+Pd5ppxV2xTKEjv+pTatkY6DmMlcb7WZ2w5mf
        lLrVp9zBFEQffUXmIvv6iFJtqDFcm/GEDW9z3V5N5KRxLKscxG6vkiq15raDQ1LeWsDwMo8hmHt
        irgWN8lHrSrVlAXUOdYOn
X-Received: by 2002:ad4:594e:0:b0:4bb:d696:4a80 with SMTP id eo14-20020ad4594e000000b004bbd6964a80mr3087668qvb.2.1667100600056;
        Sat, 29 Oct 2022 20:30:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6M7bAYUAcVmlmB6yqgF1pMJP1BrauVPaifhOLsyyMihBzt9dRrseL//1Ytx6NTsADbvdAR5g==
X-Received: by 2002:ad4:594e:0:b0:4bb:d696:4a80 with SMTP id eo14-20020ad4594e000000b004bbd6964a80mr3087662qvb.2.1667100599790;
        Sat, 29 Oct 2022 20:29:59 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i5-20020ac860c5000000b0035d08c1da35sm1716306qtm.45.2022.10.29.20.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 20:29:59 -0700 (PDT)
Date:   Sun, 30 Oct 2022 11:29:54 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor filesystem directory block size
 extraction logic
Message-ID: <20221030032954.iawetdgn4gpqrnwi@zlang-mailbox>
References: <166697890818.4183768.10822596619783607332.stgit@magnolia>
 <166697891959.4183768.4250658285402219552.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166697891959.4183768.4250658285402219552.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 10:41:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a lot of places where we open-code determining the directory
> block size for a specific filesystem.  Refactor this into a single
> helper to clean up existing tests.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/populate |    4 ++--
>  common/xfs      |    9 +++++++++
>  tests/xfs/099   |    2 +-
>  tests/xfs/100   |    2 +-
>  tests/xfs/101   |    2 +-
>  tests/xfs/102   |    2 +-
>  tests/xfs/105   |    2 +-
>  tests/xfs/112   |    2 +-
>  tests/xfs/113   |    2 +-
>  9 files changed, 18 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 9fa1a06798..23b2fecf69 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -175,7 +175,7 @@ _scratch_xfs_populate() {
>  	_xfs_force_bdev data $SCRATCH_MNT
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
>  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
>  	if [ $crc -eq 1 ]; then
>  		leaf_hdr_size=64
> @@ -602,7 +602,7 @@ _scratch_xfs_populate_check() {
>  	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
>  
>  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
>  	leaf_lblk="$((32 * 1073741824 / blksz))"
>  	node_lblk="$((64 * 1073741824 / blksz))"
>  	umount "${SCRATCH_MNT}"
> diff --git a/common/xfs b/common/xfs
> index b2ac78de0c..9b6575b5f2 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -194,6 +194,15 @@ _xfs_get_file_block_size()
>  	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
>  }
>  
> +# Get the directory block size of a mounted filesystem.
> +_xfs_get_dir_blocksize()
> +{
> +	local fs="$1"
> +
> +	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
> +		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
> +}
> +
>  # Set or clear the realtime status of every supplied path.  The first argument
>  # is either 'data' or 'realtime'.  All other arguments should be paths to
>  # existing directories or empty regular files.
> diff --git a/tests/xfs/099 b/tests/xfs/099
> index a7eaff6e0c..82bef8ad26 100755
> --- a/tests/xfs/099
> +++ b/tests/xfs/099
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/100 b/tests/xfs/100
> index 79da8cb02c..e638b4ba17 100755
> --- a/tests/xfs/100
> +++ b/tests/xfs/100
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((dblksz / 12))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/101 b/tests/xfs/101
> index 64f4705aca..11ed329110 100755
> --- a/tests/xfs/101
> +++ b/tests/xfs/101
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((dblksz / 12))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/102 b/tests/xfs/102
> index 24dce43058..43f4539181 100755
> --- a/tests/xfs/102
> +++ b/tests/xfs/102
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((16 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/105 b/tests/xfs/105
> index 22a8bf9fb0..002a712883 100755
> --- a/tests/xfs/105
> +++ b/tests/xfs/105
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((16 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/112 b/tests/xfs/112
> index bc1ab62895..e2d5932da6 100755
> --- a/tests/xfs/112
> +++ b/tests/xfs/112
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((16 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> diff --git a/tests/xfs/113 b/tests/xfs/113
> index e820ed96da..9bb2cd304b 100755
> --- a/tests/xfs/113
> +++ b/tests/xfs/113
> @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
>  
>  echo "+ mount fs image"
>  _scratch_mount
> -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
>  nr="$((128 * dblksz / 40))"
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>  leaf_lblk="$((32 * 1073741824 / blksz))"
> 

