Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A13AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 06:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLQGvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 01:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQGvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 01:51:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B6EB1FE
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 22:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671259822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gfq+BbmZ4aF/AKJ31atx8DNyYlo/ihnaWJ2FO6w9wdM=;
        b=VVL5mK5g3mvLDwRYbgTWvapTdwRCcOkXXWFsuev2cZUooCzBm+U3h45KCYU5Y0EAa4I1qj
        Jo/JfpcmUCY/wfv3oCbLFvnyVqVzBIOoQ29i5MWJszUpJZu96IEp68Tl8UDhr/vIXDjRj1
        LUbzsB0IvtG/sLGbrVcY4E41F4wqrWM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-138-LH0TaMnDMy6vQq060iuT8w-1; Sat, 17 Dec 2022 01:50:20 -0500
X-MC-Unique: LH0TaMnDMy6vQq060iuT8w-1
Received: by mail-pl1-f200.google.com with SMTP id jc4-20020a17090325c400b00189ceee4049so3153474plb.3
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 22:50:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gfq+BbmZ4aF/AKJ31atx8DNyYlo/ihnaWJ2FO6w9wdM=;
        b=ANHXQqUMJr5bfbMoLYNzMAlrDaiGc6m8+Kck06ws4ArK01Lq8SPkVdXU1TUfeppqNV
         i/Zp57gfAZTljTR3dHscgSRfUd/a05T7qMA9tbJoHFkAQnwJ7BNDnivTIVV/cAtXUPUA
         fqBaWHRqu/VJfdguVhZsQQIgNDLoaFIPN1w7PMC8juhR3SJe0jwyhH7FlXIqvxw+IiJX
         laoTPy3373B7qmNmyE/tCWJDXKlV7ZdsZ5qG4yXsMDqnSWV6Nc3IQjraCWi3pyPBTuco
         EI+pNUMHoRC4+pgITrB/EnmJpMJ4Yx2ZgS9YgBXvdBEU/mbYu7n0Q2AlLCsePmqkRDuI
         zzrw==
X-Gm-Message-State: ANoB5plmrDwPhWR2LCNQIKXlCuQNKF/qTVFAjRLzhq4jfecLCaTsD9UJ
        PfAfIjX/Ktdu3nbL2xPV9ATFM5sKEgeDYxzstHm3//RKBCz3kTXGLqwPQGBio5OS231uAm8FdcK
        WQoM1J0/OstxkckN/c0MR
X-Received: by 2002:a17:902:d18a:b0:18f:6cb:1756 with SMTP id m10-20020a170902d18a00b0018f06cb1756mr24688685plb.47.1671259819764;
        Fri, 16 Dec 2022 22:50:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4CTD1Cs6AgmnPq8JHV1E2N/pi41nFVWUN5rZ2iEzk55DxgILWuUIjAMuNGd3rjyXVojG3/Mg==
X-Received: by 2002:a17:902:d18a:b0:18f:6cb:1756 with SMTP id m10-20020a170902d18a00b0018f06cb1756mr24688670plb.47.1671259819370;
        Fri, 16 Dec 2022 22:50:19 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t6-20020a170902e84600b001871acf245csm2717623plg.37.2022.12.16.22.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 22:50:19 -0800 (PST)
Date:   Sat, 17 Dec 2022 14:50:15 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] common/populate: move decompression code to
 _{xfs,ext4}_mdrestore
Message-ID: <20221217065015.y64kcmznbv677ba2@zlang-mailbox>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096072838.1750373.11954125201906427521.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167096072838.1750373.11954125201906427521.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 11:45:28AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the metadump decompression code to the per-filesystem mdrestore
> commands so that everyone can take advantage of them.  This enables the
> XFS and ext4 _mdrestore helpers to handle metadata dumps compressed with
> their respective _metadump helpers.
> 
> In turn, this means that the xfs fuzz tests can now handle the
> compressed metadumps created by the _scratch_populate_cached helper.
> This is key to unbreaking fuzz testing for xfs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/ext4     |   13 ++++++++++++-
>  common/fuzzy    |    2 +-
>  common/populate |   15 ++-------------
>  common/xfs      |   15 +++++++++++++--
>  4 files changed, 28 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/common/ext4 b/common/ext4
> index dc2e4e59cc..cadf1a7974 100644
> --- a/common/ext4
> +++ b/common/ext4
> @@ -129,9 +129,20 @@ _ext4_mdrestore()
>  {
>  	local metadump="$1"
>  	local device="$2"
> -	shift; shift
> +	local compressopt="$3"

I didn't see this variable is used in this function, do I missed something?

> +	shift; shift; shift
>  	local options="$@"
>  
> +	# If we're configured for compressed dumps and there isn't already an
> +	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
> +	# something.
> +	if [ ! -e "$metadump" ] && [ -n "$DUMP_COMPRESSOR" ]; then
> +		for compr in "$metadump".*; do
> +			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
> +		done
> +	fi
> +	test -r "$metadump" || return 1
> +
>  	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
>  }
>  
> diff --git a/common/fuzzy b/common/fuzzy
> index fad79124e5..e634815eec 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -159,7 +159,7 @@ __scratch_xfs_fuzz_mdrestore()
>  	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
>  
>  	__scratch_xfs_fuzz_unmount
> -	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
> +	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" compress
>  }
>  
>  __fuzz_notify() {
> diff --git a/common/populate b/common/populate
> index f382c40aca..96866ee4cf 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -848,20 +848,9 @@ _scratch_populate_cache_tag() {
>  _scratch_populate_restore_cached() {
>  	local metadump="$1"
>  
> -	# If we're configured for compressed dumps and there isn't already an
> -	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
> -	# something.
> -	if [ -n "$DUMP_COMPRESSOR" ]; then
> -		for compr in "$metadump".*; do
> -			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
> -		done
> -	fi
> -
> -	test -r "$metadump" || return 1
> -
>  	case "${FSTYP}" in
>  	"xfs")
> -		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
> +		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}" compress
>  		res=$?
>  		test $res -ne 0 && return $res
>  
> @@ -876,7 +865,7 @@ _scratch_populate_restore_cached() {
>  		return $res
>  		;;
>  	"ext2"|"ext3"|"ext4")
> -		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
> +		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}" compress
>  		ret=$?
>  		test $ret -ne 0 && return $ret
>  
> diff --git a/common/xfs b/common/xfs
> index 216dab3bcd..833c2f4368 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -641,9 +641,20 @@ _xfs_metadump() {
>  _xfs_mdrestore() {
>  	local metadump="$1"
>  	local device="$2"
> -	shift; shift
> +	local compressopt="$3"

I didn't see this variable is used in this function either.

> +	shift; shift; shift
>  	local options="$@"
>  
> +	# If we're configured for compressed dumps and there isn't already an
> +	# uncompressed dump, see if we can use DUMP_COMPRESSOR to decompress
> +	# something.
> +	if [ ! -e "$metadump" ] && [ -n "$DUMP_COMPRESSOR" ]; then
> +		for compr in "$metadump".*; do
> +			[ -e "$compr" ] && $DUMP_COMPRESSOR -d -f -k "$compr" && break
> +		done
> +	fi
> +	test -r "$metadump" || return 1
> +
>  	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
>  }
>  
> @@ -666,7 +677,7 @@ _scratch_xfs_mdrestore()
>  	local metadump=$1
>  	shift
>  
> -	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
> +	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" nocompress "$@"
>  }
>  
>  # run xfs_check and friends on a FS.
> 

