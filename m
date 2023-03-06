Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5552C61DA4
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Mar 2023 16:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjCFQrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Mar 2023 11:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCFQqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2023 11:46:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D3437B64
        for <linux-xfs@vger.kernel.org>; Mon,  6 Mar 2023 08:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678121067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g+QXZCoFj9PSEKx/s7bTkNnGi1dZf/uUlUIAqA5k+0I=;
        b=hFD34sMkmfalVYZMREDV0j2iU5viPPoB+XhR1qh9FqoBCdq5mS2paNWHq2WDO//IPVg85I
        t0neJEtwlLXSRn9LW1es5ZzmN23k2t5E9ul/RzRzYCeyVwR1KWcOoo3anjJg8t8b4FK1Rd
        SBawK25uEV22QiOY+U78wvY/Uq5MgNY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-GWgP6wJqN1-0Ja-GfFsAfQ-1; Mon, 06 Mar 2023 11:41:17 -0500
X-MC-Unique: GWgP6wJqN1-0Ja-GfFsAfQ-1
Received: by mail-pj1-f69.google.com with SMTP id ip3-20020a17090b314300b00237c16adf30so6687360pjb.5
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2023 08:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678120876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+QXZCoFj9PSEKx/s7bTkNnGi1dZf/uUlUIAqA5k+0I=;
        b=H4Fw7VDXCgVPgcyCa0IeMv/dcDUWvnedbevVYah+IO0NMBBzbfH2GhMdShi8JKURRB
         uhSnk5Taf03yjUK78vJmUDEiIzV3ucm0oafl1bfY7fgsnXR7qwAyMKKNAN4fTEPqhrht
         tg38qQbX6kCAIzIWQ9DzdG7ySv9OgvH8XZIYZtNLuffKoscJMjXJWXgIfyqijkQUhfyK
         l/RRCJ0W5Bh//aovHfV1r6S7NIUUCM0K8YSz8jmdWHObBJOYKNUwlipdzWXUyuFWPlAB
         ZI85y7/Nmat6qabqaE/jB2sNaMn2goxf0Z8CzrG+KDuBodO02Pop+cRdHvFCiCarvWqD
         rQSQ==
X-Gm-Message-State: AO0yUKX1DSwjzTe1EjbaM895iG6lRE7Fboe+tlbr3r4QWSYku4VasJy7
        wtOKSZGutLAFXZrpvCPCw5rfTSFqFw7klPeTWl9Dy4iz69hZtWLfhN2aQV5d4IAEXEBT2EZxjO8
        7b3pLHCpuok+utVaXjJQ0
X-Received: by 2002:a05:6a20:1a9d:b0:be:a3b2:cc7d with SMTP id ci29-20020a056a201a9d00b000bea3b2cc7dmr10028219pzb.6.1678120876191;
        Mon, 06 Mar 2023 08:41:16 -0800 (PST)
X-Google-Smtp-Source: AK7set+oOGoliNWjZQZ6n1fL/3x1yMDoG5TEgY+xpagwvlHzJrjOrlOst8XpUsyBWziSmlRnmbOIww==
X-Received: by 2002:a05:6a20:1a9d:b0:be:a3b2:cc7d with SMTP id ci29-20020a056a201a9d00b000bea3b2cc7dmr10028192pzb.6.1678120875578;
        Mon, 06 Mar 2023 08:41:15 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y19-20020a62b513000000b0058ba2ebee1bsm6494084pfe.213.2023.03.06.08.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:41:14 -0800 (PST)
Date:   Tue, 7 Mar 2023 00:41:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/9] various: fix finding metadata inode numbers when
 metadir is enabled
Message-ID: <20230306164110.rhpv2jywmcmpe63e@zlang-mailbox>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
 <167243883271.736753.35967461928530874.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243883271.736753.35967461928530874.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:20:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a number of tests that use xfs_db to examine the contents of
> metadata inodes to check correct functioning.  The logic is scattered
> everywhere and won't work with metadata directory trees, so make a
> shared helper to find these inodes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs     |   32 ++++++++++++++++++++++++++++++--
>  tests/xfs/007  |   16 +++++++++-------
>  tests/xfs/1562 |    9 ++-------
>  tests/xfs/1563 |    9 ++-------
>  tests/xfs/1564 |    9 ++-------
>  tests/xfs/1565 |    9 ++-------
>  tests/xfs/1566 |    9 ++-------
>  tests/xfs/1567 |    9 ++-------
>  tests/xfs/1568 |    9 ++-------
>  tests/xfs/1569 |    9 ++-------

These case names are temporary names, I've renamed them when I merged them,
so this patch need to rebase. Sorry for this trouble :)

Thanks,
Zorro

>  tests/xfs/529  |    5 ++---
>  tests/xfs/530  |    6 ++----
>  12 files changed, 59 insertions(+), 72 deletions(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 8b365ad18b..dafbd1b874 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1396,7 +1396,7 @@ _scratch_get_bmx_prefix() {
>  
>  _scratch_get_iext_count()
>  {
> -	local ino=$1
> +	local selector=$1
>  	local whichfork=$2
>  	local field=""
>  
> @@ -1411,7 +1411,7 @@ _scratch_get_iext_count()
>  			return 1
>  	esac
>  
> -	_scratch_xfs_get_metadata_field $field "inode $ino"
> +	_scratch_xfs_get_metadata_field $field "$selector"
>  }
>  
>  #
> @@ -1742,3 +1742,31 @@ _require_xfs_scratch_atomicswap()
>  		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
>  	_scratch_unmount
>  }
> +
> +# Find a metadata file within an xfs filesystem.  The sole argument is the
> +# name of the field within the superblock.
> +_scratch_xfs_find_metafile()
> +{
> +	local metafile="$1"
> +	local selector=
> +
> +	if ! _check_scratch_xfs_features METADIR > /dev/null; then
> +		sb_field="$(_scratch_xfs_get_sb_field "$metafile")"
> +		if echo "$sb_field" | grep -q -w 'not found'; then
> +			return 1
> +		fi
> +		selector="inode $sb_field"
> +	else
> +		case "${metafile}" in
> +		"rootino")	selector="path /";;
> +		"uquotino")	selector="path -m /quota/user";;
> +		"gquotino")	selector="path -m /quota/group";;
> +		"pquotino")	selector="path -m /quota/project";;
> +		"rbmino")	selector="path -m /realtime/bitmap";;
> +		"rsumino")	selector="path -m /realtime/summary";;
> +		esac
> +	fi
> +
> +	echo "${selector}"
> +	return 0
> +}
> diff --git a/tests/xfs/007 b/tests/xfs/007
> index 4f864100fd..6d6d828b13 100755
> --- a/tests/xfs/007
> +++ b/tests/xfs/007
> @@ -22,6 +22,11 @@ _require_xfs_quota
>  _scratch_mkfs_xfs | _filter_mkfs > /dev/null 2> $tmp.mkfs
>  . $tmp.mkfs
>  
> +get_qfile_nblocks() {
> +	local selector="$(_scratch_xfs_find_metafile "$1")"
> +	_scratch_xfs_db -c "$selector" -c "p core.nblocks"
> +}
> +
>  do_test()
>  {
>  	qino_1=$1
> @@ -31,12 +36,9 @@ do_test()
>  	echo "*** umount"
>  	_scratch_unmount
>  
> -	QINO_1=`_scratch_xfs_get_sb_field $qino_1`
> -	QINO_2=`_scratch_xfs_get_sb_field $qino_2`
> -
>  	echo "*** Usage before quotarm ***"
> -	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks"
> -	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks"
> +	get_qfile_nblocks $qino_1
> +	get_qfile_nblocks $qino_2
>  
>  	_qmount
>  	echo "*** turn off $off_opts quotas"
> @@ -66,8 +68,8 @@ do_test()
>  	_scratch_unmount
>  
>  	echo "*** Usage after quotarm ***"
> -	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks"
> -	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks"
> +	get_qfile_nblocks $qino_1
> +	get_qfile_nblocks $qino_2
>  }
>  
>  # Test user and group first
> diff --git a/tests/xfs/1562 b/tests/xfs/1562
> index 015209eeb2..1e5b6881ee 100755
> --- a/tests/xfs/1562
> +++ b/tests/xfs/1562
> @@ -27,13 +27,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtbitmap"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.bitmap')
> -else
> -	path=('sb' 'addr rbmino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'online' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rbmino)"
> +_scratch_xfs_fuzz_metadata '' 'online' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtbitmap"
>  
>  # success, all done
> diff --git a/tests/xfs/1563 b/tests/xfs/1563
> index 2be0870a3d..a9da78106d 100755
> --- a/tests/xfs/1563
> +++ b/tests/xfs/1563
> @@ -27,13 +27,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtsummary"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.summary')
> -else
> -	path=('sb' 'addr rsumino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'online' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rsumino)"
> +_scratch_xfs_fuzz_metadata '' 'online' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtsummary"
>  
>  # success, all done
> diff --git a/tests/xfs/1564 b/tests/xfs/1564
> index c0d10ff0e9..4482861d50 100755
> --- a/tests/xfs/1564
> +++ b/tests/xfs/1564
> @@ -27,13 +27,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtbitmap"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.bitmap')
> -else
> -	path=('sb' 'addr rbmino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'offline' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rbmino)"
> +_scratch_xfs_fuzz_metadata '' 'offline' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtbitmap"
>  
>  # success, all done
> diff --git a/tests/xfs/1565 b/tests/xfs/1565
> index 6b4186fb3c..c43ccd848e 100755
> --- a/tests/xfs/1565
> +++ b/tests/xfs/1565
> @@ -27,13 +27,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtsummary"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.summary')
> -else
> -	path=('sb' 'addr rsumino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'offline' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rsumino)"
> +_scratch_xfs_fuzz_metadata '' 'offline' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtsummary"
>  
>  # success, all done
> diff --git a/tests/xfs/1566 b/tests/xfs/1566
> index 8d0f61ae10..aad4fafb15 100755
> --- a/tests/xfs/1566
> +++ b/tests/xfs/1566
> @@ -28,13 +28,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtbitmap"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.bitmap')
> -else
> -	path=('sb' 'addr rbmino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'both' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rbmino)"
> +_scratch_xfs_fuzz_metadata '' 'both' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtbitmap"
>  
>  # success, all done
> diff --git a/tests/xfs/1567 b/tests/xfs/1567
> index 7dc2012b67..ff782fc239 100755
> --- a/tests/xfs/1567
> +++ b/tests/xfs/1567
> @@ -28,13 +28,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtsummary"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.summary')
> -else
> -	path=('sb' 'addr rsumino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'both' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rsumino)"
> +_scratch_xfs_fuzz_metadata '' 'both' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtsummary"
>  
>  # success, all done
> diff --git a/tests/xfs/1568 b/tests/xfs/1568
> index c80640ef97..e2a28df58a 100755
> --- a/tests/xfs/1568
> +++ b/tests/xfs/1568
> @@ -27,13 +27,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtbitmap"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.bitmap')
> -else
> -	path=('sb' 'addr rbmino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'none' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rbmino)"
> +_scratch_xfs_fuzz_metadata '' 'none' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtbitmap"
>  
>  # success, all done
> diff --git a/tests/xfs/1569 b/tests/xfs/1569
> index e303f08ff5..dcb07440e8 100755
> --- a/tests/xfs/1569
> +++ b/tests/xfs/1569
> @@ -27,13 +27,8 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz rtsummary"
> -is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
> -if [ -n "$is_metadir" ]; then
> -	path=('path -m /realtime/0.summary')
> -else
> -	path=('sb' 'addr rsumino')
> -fi
> -_scratch_xfs_fuzz_metadata '' 'none' "${path[@]}" 'dblock 0' >> $seqres.full
> +path="$(_scratch_xfs_find_metafile rsumino)"
> +_scratch_xfs_fuzz_metadata '' 'none' "$path" 'dblock 0' >> $seqres.full
>  echo "Done fuzzing rtsummary"
>  
>  # success, all done
> diff --git a/tests/xfs/529 b/tests/xfs/529
> index 83d24da0ac..e10af6753b 100755
> --- a/tests/xfs/529
> +++ b/tests/xfs/529
> @@ -159,9 +159,8 @@ done
>  _scratch_unmount >> $seqres.full
>  
>  echo "Verify uquota inode's extent count"
> -uquotino=$(_scratch_xfs_get_metadata_field 'uquotino' 'sb 0')
> -
> -nextents=$(_scratch_get_iext_count $uquotino data || \
> +selector="$(_scratch_xfs_find_metafile uquotino)"
> +nextents=$(_scratch_get_iext_count "$selector" data || \
>  		   _fail "Unable to obtain inode fork's extent count")
>  if (( $nextents > 10 )); then
>  	echo "Extent count overflow check failed: nextents = $nextents"
> diff --git a/tests/xfs/530 b/tests/xfs/530
> index 56f5e7ebdb..cb8c2e3978 100755
> --- a/tests/xfs/530
> +++ b/tests/xfs/530
> @@ -104,10 +104,8 @@ _scratch_unmount >> $seqres.full
>  
>  echo "Verify rbmino's and rsumino's extent count"
>  for rtino in rbmino rsumino; do
> -	ino=$(_scratch_xfs_get_metadata_field $rtino "sb 0")
> -	echo "$rtino = $ino" >> $seqres.full
> -
> -	nextents=$(_scratch_get_iext_count $ino data || \
> +	selector="$(_scratch_xfs_find_metafile "$rtino")"
> +	nextents=$(_scratch_get_iext_count "$selector" data || \
>  			_fail "Unable to obtain inode fork's extent count")
>  	if (( $nextents > 10 )); then
>  		echo "Extent count overflow check failed: nextents = $nextents"
> 

