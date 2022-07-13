Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DC7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 17:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGMRRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGMRRI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 13:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE0642CE07
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657732627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rLhkNjsTRfqGJh2Nb8MEzmrcUy3t2fKC9MngQwvWI6g=;
        b=eTCYaJK7nO3Vkda5jyyRWXjpNfVbfvqL3r2eaeRSovDcxE0f/x6xoapTUVzIYBJ6lTcps7
        +RKE4NCM4Hh/mNFKiEemRmzZ/rJ6bSGZ9SjgokGvfgxMZB7hEuPikh6bW7A4O6yJge3PnH
        msiGloRd873yDbLsiciVd4/nV77kdbI=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-LTD-xymQNeqgXXmW75aWnQ-1; Wed, 13 Jul 2022 13:17:05 -0400
X-MC-Unique: LTD-xymQNeqgXXmW75aWnQ-1
Received: by mail-ot1-f70.google.com with SMTP id f95-20020a9d03e8000000b0061c75d3deaaso173620otf.12
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rLhkNjsTRfqGJh2Nb8MEzmrcUy3t2fKC9MngQwvWI6g=;
        b=TnkI8aRuJB/qUlS7FRAb9F13JJTLlpUl2AT2fXWflZPe1MCk48106/og4woJnS9ywc
         m864K85hYy2jdzYJ/2bPx9A+MHRQwQYUZfK+KWXmyj8xDTKu+Sulex/VuYFlr/S0xS8B
         H1wiDpqZA9A/rDa3WVvM/wtoGBGoPNNfCD8ZOOJy/UMbSUHRwZaNoLxfWIgENU3iUmhM
         4QCelueEQoG88wbgSfxzPNhHXZbHJsWY1eIUPf9koRAlSKcxLDAqZ7cAYTSAK/AVb5PZ
         8jsG2P4JmsbneeQ6vrYfbdxRsAt0ELyf7vV/lF+kk1WWLaHeffhPekD/0yXhti+hfdjP
         1wpg==
X-Gm-Message-State: AJIora+wPrx0armOOvOVBw4ib1fXDhskFGcGeWk3GhtputyrdME9A/a5
        lYlaBdICFAFvPEdN5NAOfgVuzkA6mJVXN4ErKR8ON5d10jutaUS8mDimlLVn6Z96pMu02r1000o
        ta5l3QyGE4LCbE/x8NQUy
X-Received: by 2002:a05:6870:7a5:b0:101:5bb9:780 with SMTP id en37-20020a05687007a500b001015bb90780mr2382593oab.192.1657732624906;
        Wed, 13 Jul 2022 10:17:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vv1jJtU8jDgGkmR/9A3nwNxi0dCq5Y/DrYLTwtkuFTj29bq0EQiMLfmTcXMiE+DbSTTVWFqg==
X-Received: by 2002:a05:6870:7a5:b0:101:5bb9:780 with SMTP id en37-20020a05687007a500b001015bb90780mr2382576oab.192.1657732624649;
        Wed, 13 Jul 2022 10:17:04 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3-20020aca5c03000000b003356be620e3sm5488652oib.49.2022.07.13.10.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 10:17:04 -0700 (PDT)
Date:   Thu, 14 Jul 2022 01:16:57 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 7/8] filter: report data block mappings and od offsets in
 multiples of allocation units
Message-ID: <20220713171657.ee2vsdvedohwkce3@zlang-mailbox>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
 <165767383332.869123.15665387460779572064.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165767383332.869123.15665387460779572064.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 12, 2022 at 05:57:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> All the tests that use these two filter functions also make all of their
> fallocate calls in units of file allocation units, not filesystem
> blocks.  Make them transform the file offsets to multiples of file
> allocation units (via _get_file_block_size) so that xfs/242 and xfs/252
> will work with XFS with a rt extent size set.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/filter |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/filter b/common/filter
> index 14f6a027..28dea646 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -221,7 +221,7 @@ _filter_xfs_io_units_modified()
>  
>  _filter_xfs_io_blocks_modified()
>  {
> -	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
> +	BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
>  
>  	_filter_xfs_io_units_modified "Block" $BLOCK_SIZE
>  }
> @@ -457,7 +457,7 @@ _filter_busy_mount()
>  
>  _filter_od()
>  {
> -	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
> +	BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
>  	$AWK_PROG -v block_size=$BLOCK_SIZE '
>  		/^[0-9]+/ {
>  			offset = strtonum("0"$1);
> 

