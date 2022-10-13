Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E99FC43219
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 15:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJMPsr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 11:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJMPsp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 11:48:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E704FEA68A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 08:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665676120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6z8rf6ZYpSjKMzpItfXQF69axd1BsXH4wsuzdLosv+Y=;
        b=WBvF4D+tcIX7n6QeQ/9FZrPc6zeN6JWh/Xf6ype2fv+dP5klkHmloUzOq2cyLLcZ8cbQLZ
        iRwRf+S9moUaBNJiP8D66F9ibx/uMRhtNq/Sr8LghYMyOANF6fWNQCDQiW7WKrzSaaTz3w
        TdZf/asLdrR4BrjesTkLx+W7zZjrJDE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-548-pxNINOd8Pqqb9rdvOTNPQA-1; Thu, 13 Oct 2022 11:48:38 -0400
X-MC-Unique: pxNINOd8Pqqb9rdvOTNPQA-1
Received: by mail-qt1-f198.google.com with SMTP id a19-20020a05622a02d300b0039a3711179dso1605179qtx.12
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 08:48:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6z8rf6ZYpSjKMzpItfXQF69axd1BsXH4wsuzdLosv+Y=;
        b=VmssA+9eXxXC6/gLCIvyGsuiPx2lKtlr9jTGEpvDlfZROdYm3JjL8JXxpsroGr5dpu
         6Du0R4gRZh8dtXmoN6XFTVIJXLyGXwu8nkFWfqq0m712ROLsv9/Pz8JnzA7Dk6y1Ytje
         woO5xfdLJqEmQuuinOd8enmlmigEsobkBi8Fg0Jraicc7rM+cYlDdF/dA3OAc7d8aWZK
         8BzU71AtmdPDB2q67lBO41KY6Q8PYML118XCXwpkO9IHB+NzXg+ZNgrj0+WPI1r64Vc2
         Z+wMDZEfyefQZpluYzw9EQAX/W/l37Zr58Fle9f+wp3OK1p1LQhtmmRPX7CTqfGbmnBD
         TVtg==
X-Gm-Message-State: ACrzQf2z65yWDn5slulMXN8saXrxJjAvY7/ch3lxv7pFS4KTG28OObCT
        nkXDvghx0hommqsUTLUZwzxS8MpsuKgG1EpmPyl+wmTZB6cOJ4IUN5aAyq8W69ZxeiV5CM3Btcq
        wf+xSmMj6YMCd3xy9u7F2
X-Received: by 2002:a37:6504:0:b0:6ee:6fb:4ae2 with SMTP id z4-20020a376504000000b006ee06fb4ae2mr409934qkb.49.1665676118392;
        Thu, 13 Oct 2022 08:48:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Z1SpCyTqhN8ysHmAkbQaVD7byH61MKGW3R6faEM/yLQYTSaoHeB0GABAOKn/OkIKMvVrang==
X-Received: by 2002:a37:6504:0:b0:6ee:6fb:4ae2 with SMTP id z4-20020a376504000000b006ee06fb4ae2mr409922qkb.49.1665676118129;
        Thu, 13 Oct 2022 08:48:38 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c5-20020ac80545000000b0039913d588fbsm161524qth.48.2022.10.13.08.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:48:37 -0700 (PDT)
Date:   Thu, 13 Oct 2022 23:48:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/5] populate: require e2image before populating
Message-ID: <20221013154833.kqwygzftf7thscx7@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553914474.422450.8871747567060992809.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166553914474.422450.8871747567060992809.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 06:45:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use $E2IMAGE_PROG, not e2image, and check that it exists before
> proceeding.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Make sense,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/populate |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 66c55b682f..05bdfe33c5 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -18,6 +18,7 @@ _require_populate_commands() {
>  		;;
>  	ext*)
>  		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
> +		_require_command "$E2IMAGE_PROG" "e2image"
>  		;;
>  	esac
>  }
> @@ -874,7 +875,7 @@ _scratch_populate_restore_cached() {
>  		return $res
>  		;;
>  	"ext2"|"ext3"|"ext4")
> -		e2image -r "${metadump}" "${SCRATCH_DEV}"
> +		$E2IMAGE_PROG -r "${metadump}" "${SCRATCH_DEV}"
>  		ret=$?
>  		test $ret -ne 0 && return $ret
>  
> 

