Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DD1C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 06:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiLQGZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 01:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQGZm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 01:25:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2339166C31
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 22:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671258294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aaoVLyrooFqUA9ptEwHLSf23jUepbV9Tz9W2IaEhD78=;
        b=UR8fNNEe4u8+Sr025dYhTDZVDCV7sR3W6MfRD+LL9PI2n+SuS1wDqps/rnrIELEbAanMpm
        61R1t8aRumS6uODZPgLs7o2pnvBQtKrjb111Fj0FR4ZU2vrUcz3CnQwHWpEXpQzqpV5vWC
        XosHlseA5xQo4pfYwBJzU8p99tTzFmU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-DbI25uSmP56ReSswOhxesQ-1; Sat, 17 Dec 2022 01:24:52 -0500
X-MC-Unique: DbI25uSmP56ReSswOhxesQ-1
Received: by mail-pj1-f69.google.com with SMTP id me18-20020a17090b17d200b00219f8dc7cb3so5299747pjb.4
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 22:24:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaoVLyrooFqUA9ptEwHLSf23jUepbV9Tz9W2IaEhD78=;
        b=SzxZ8XVGevwcs4xF3ScQiCk0ByYppn789/v0+XMrhWPOiv5kl0GLVZy/6xOVzUkwTk
         V+yzeIg0E2woyUOQphLPAQzxvgeJdYWmMHxJpyxEFxCkQ7ND/jCAb1YDu1jhesgSvOiU
         i7U/jg48nlmg2yC+PGo3x08c31bg20U2LM6+M68sEqIKABTqeMYMpFPU0My3HOVdpWle
         jCeIPuuzKeLDHh/sLYTVmMdM1jdL4U1E8BPaE6kDzhrT0+CMYXsvNGi2gRqkOfUitgh/
         8IqD1GMBq6RD5YOLwW4xm3u4GBtqb18YMzcx8AQWMaXelKgKF0CTVtbHxaNDjOb3gkIn
         R2YA==
X-Gm-Message-State: ANoB5plIIWUrD+JAkSPfABksoe7IcJb8t6xV9t1guVXsDSexw6uNl51i
        YSheocuiZasAZa+9giviXaE2NH17sDuCbjw8khQdEFljqG9zcDeDkXudQVxKzh3K6Jn/ehOH6ct
        yiivLGspc3HmjZbUKrbbi
X-Received: by 2002:a17:902:ab57:b0:189:4de5:6c7f with SMTP id ij23-20020a170902ab5700b001894de56c7fmr34250440plb.3.1671258291625;
        Fri, 16 Dec 2022 22:24:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf510Z3JBBv0OaKa+r0FRx2idT7SvO8VvPZzjQg5TZEysXVGvCm1zxHBYBipQxRLgc9WgdSyxw==
X-Received: by 2002:a17:902:ab57:b0:189:4de5:6c7f with SMTP id ij23-20020a170902ab5700b001894de56c7fmr34250428plb.3.1671258291242;
        Fri, 16 Dec 2022 22:24:51 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ik22-20020a170902ab1600b0018703bf3ec9sm2663462plb.61.2022.12.16.22.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 22:24:50 -0800 (PST)
Date:   Sat, 17 Dec 2022 14:24:46 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] common/populate: create helpers to handle restoring
 metadumps
Message-ID: <20221217062446.4laur23et6xtduka@zlang-mailbox>
References: <167096070957.1750373.5715692265711468248.stgit@magnolia>
 <167096071510.1750373.2221240504175764288.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167096071510.1750373.2221240504175764288.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 11:45:15AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor _scratch_populate_restore_cached so that the actual commands
> for restoring metadumps are filesystem-specific helpers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/ext4     |   10 ++++++++++
>  common/fuzzy    |    2 +-
>  common/populate |    4 ++--
>  common/xfs      |    9 +++++++++
>  4 files changed, 22 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/ext4 b/common/ext4
> index 4a2eaa157f..dc2e4e59cc 100644
> --- a/common/ext4
> +++ b/common/ext4
> @@ -125,6 +125,16 @@ _ext4_metadump()
>  		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
>  }
>  
> +_ext4_mdrestore()
> +{
> +	local metadump="$1"
> +	local device="$2"
> +	shift; shift
> +	local options="$@"
> +
> +	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
> +}
> +
>  # this test requires the ext4 kernel support crc feature on scratch device
>  #
>  _require_scratch_ext4_crc()
> diff --git a/common/fuzzy b/common/fuzzy
> index 2d688fd27b..fad79124e5 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -159,7 +159,7 @@ __scratch_xfs_fuzz_mdrestore()
>  	test -e "${POPULATE_METADUMP}" || _fail "Need to set POPULATE_METADUMP"
>  
>  	__scratch_xfs_fuzz_unmount
> -	$XFS_MDRESTORE_PROG "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
> +	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}"
>  }
>  
>  __fuzz_notify() {
> diff --git a/common/populate b/common/populate
> index 6e00499734..f382c40aca 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -861,7 +861,7 @@ _scratch_populate_restore_cached() {
>  
>  	case "${FSTYP}" in
>  	"xfs")
> -		$XFS_MDRESTORE_PROG "${metadump}" "${SCRATCH_DEV}"
> +		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
>  		res=$?
>  		test $res -ne 0 && return $res
>  
> @@ -876,7 +876,7 @@ _scratch_populate_restore_cached() {
>  		return $res
>  		;;
>  	"ext2"|"ext3"|"ext4")
> -		$E2IMAGE_PROG -r "${metadump}" "${SCRATCH_DEV}"
> +		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
>  		ret=$?
>  		test $ret -ne 0 && return $ret
>  
> diff --git a/common/xfs b/common/xfs
> index f466d2c42f..27d6ac84e3 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -638,6 +638,15 @@ _xfs_metadump() {
>  	return $res
>  }
>  
> +_xfs_mdrestore() {
> +	local metadump="$1"
> +	local device="$2"
> +	shift; shift
> +	local options="$@"
> +
> +	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
> +}
> +
>  # Snapshot the metadata on the scratch device
>  _scratch_xfs_metadump()
>  {
> 

