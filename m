Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4EFC3DA6E
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 09:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiLQJvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 04:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiLQJvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 04:51:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B3C64CF
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 01:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671270648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SoPj9mC+7dZa40Zj36zf5IfoAg8z5HIfhVGxnwDD3IM=;
        b=a07ittZeRXrnAK5sXlIxo0r9ub/7Kd8NPmLXnGwgK4oKbrnTZMGSgKTsR20a5c4s9tf6AK
        7WhyfrjiFxze4vWNiVlmGSjmPYkU7/3P4lItO7gfWn7TUmFWTB++mpeHGVcYbZ1UiuE71J
        +dFA+J19UmcJX+k7Y5lK6VEl98wnF10=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-IlmvLSHCNBKnboBTn5ob2A-1; Sat, 17 Dec 2022 04:50:47 -0500
X-MC-Unique: IlmvLSHCNBKnboBTn5ob2A-1
Received: by mail-pf1-f198.google.com with SMTP id v23-20020aa78097000000b005748c087db1so2710136pff.2
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 01:50:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoPj9mC+7dZa40Zj36zf5IfoAg8z5HIfhVGxnwDD3IM=;
        b=YiH02e55ALFnGeOpsb/wS/cLdxTR5cb8kvUUkqHhdNFnYpoUrLwyFAD4OsKtwRODBf
         SnUiLEyawmew5Dh1GGAxXSfjU7gh2njOq4llAGlsh+BJdaGGQ/sLyNWJRgcKIjHqIj3f
         fVorEHEG1smZpFZqN6ZnRDdyRLatciX7ZkEi0eggDIpShd2eM0JX2vfT+1GpbOepXcDE
         Pth1ZV9YGsefrryVzOoFGoUXJQPbJBll+uu9/b+E2D51sIMZSWzp7G+R3KyNXqQ7rZRu
         /NBtdVmrHIS50Vxc+2INbgrvEkkFV2U+Dl2T7uBCFAkLAAor/ihLfGx9cRx1A0Nng/9I
         zJvA==
X-Gm-Message-State: ANoB5pml+icCJ/2Xnc+hEhwsxO4Bwex4yMSxP2GNKKtvONCFgbfWtV2R
        aoVYZ2kG6waySMqCTnbxPzOTSu7rtTF0Mmc434hdVjRG295U/eAyqPSropzllbZGZZJURLdWOXH
        Uyegaozv0DgOs7F/Y7WvU
X-Received: by 2002:a17:902:8e81:b0:186:a43b:a5 with SMTP id bg1-20020a1709028e8100b00186a43b00a5mr33301717plb.13.1671270645987;
        Sat, 17 Dec 2022 01:50:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6H8ilVd3NpvI0xW4UcQziXTarqYf8Qd60QVEDBi949xhHLm0HE3wNGxi6KhHJFDUpvEnR+AA==
X-Received: by 2002:a17:902:8e81:b0:186:a43b:a5 with SMTP id bg1-20020a1709028e8100b00186a43b00a5mr33301708plb.13.1671270645653;
        Sat, 17 Dec 2022 01:50:45 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b00189393ab02csm3101616plk.99.2022.12.17.01.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 01:50:45 -0800 (PST)
Date:   Sat, 17 Dec 2022 17:50:40 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 3/4] common/populate: move decompression code to
 _{xfs,ext4}_mdrestore
Message-ID: <20221217095040.buxwb5sfg2r36pqo@zlang-mailbox>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096072838.1750373.11954125201906427521.stgit@magnolia>
 <Y517WiHeORSpumeK@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y517WiHeORSpumeK@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 17, 2022 at 12:18:34AM -0800, Darrick J. Wong wrote:
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
> v1.1: remove unnecessary parameter

This version looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> ---
>  common/ext4     |   10 ++++++++++
>  common/populate |   11 -----------
>  common/xfs      |   10 ++++++++++
>  3 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/common/ext4 b/common/ext4
> index dc2e4e59cc..8fd6dbc682 100644
> --- a/common/ext4
> +++ b/common/ext4
> @@ -132,6 +132,16 @@ _ext4_mdrestore()
>  	shift; shift
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
> diff --git a/common/populate b/common/populate
> index f382c40aca..0a8a6390d4 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -848,17 +848,6 @@ _scratch_populate_cache_tag() {
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
>  		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
> diff --git a/common/xfs b/common/xfs
> index 216dab3bcd..60848a5b8a 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -644,6 +644,16 @@ _xfs_mdrestore() {
>  	shift; shift
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
> 

