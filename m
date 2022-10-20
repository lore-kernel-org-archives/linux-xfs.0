Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CFBC43217
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Oct 2022 04:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJTEgF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 00:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJTEf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2022 00:35:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FBF15B13A
        for <linux-xfs@vger.kernel.org>; Wed, 19 Oct 2022 21:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666240555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PoSU4QfrDZLHjSl79CPIVHBB/t37XEv37IiEVOzSgdU=;
        b=OZpf2wvcejud290vLHRjbF7tflsg0U7pgXlxunbLySHgkdeSO4+G+cHB72kBa8p+/cJ6gL
        azVgZz2yhn++XeM30Y/fuAYYkB7/9gZQe1q7Y96uT9ZKkaeWkxk7u9h1wwu+FueVAJ0G3A
        CQglWyVeczx6282Pxr2Poy3jlLLgNG0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-Ca4AG-MGPmuiWqLad1nyfQ-1; Thu, 20 Oct 2022 00:35:53 -0400
X-MC-Unique: Ca4AG-MGPmuiWqLad1nyfQ-1
Received: by mail-pl1-f199.google.com with SMTP id q12-20020a170902dacc00b00184ba4faf1cso13296671plx.23
        for <linux-xfs@vger.kernel.org>; Wed, 19 Oct 2022 21:35:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PoSU4QfrDZLHjSl79CPIVHBB/t37XEv37IiEVOzSgdU=;
        b=FyZr1Hl4y2YR0vkBxNj5mR+g5shKEj+eGR1fQ10ayY4pg3YjXStEbcwHbCPuaI70GV
         5e2mAQUU6/hrbjONgS/oBqs5++eXHez080w/E05B7PEU/1vLUTAOslZDhYWsP0k0qF/S
         9+HABoOj3lAU6UvPItfLuAX8n8kUDnt5TAa1XXyU3L2uztPAHg+LBbxisBg4k1iUpuBg
         HnHudEb9dwlYv5DGj8L5tfdi2y75IToePLvrQ1FUrbikIJr2rgFdopiJBkFmnb3gj/nx
         ajpXVAoN66i65pYgWqYJt1Qo03e0N8L7TQTjK8EuQue1BQMfyBq1EftBxF1dQxAP7P/p
         dWCQ==
X-Gm-Message-State: ACrzQf3Jt/LhE+nQ7N8pfkjkWzyTHpQ8iqiikMZMgLnWC7+LhWzNMqlY
        j8vdfS7dl/O78PD6oQ7Vt+z1lg4rEpFDxtjEU1aZ/PeUXBHMNRipXaKGxJnlw83Rgm+U0AAPpOa
        aIxLO/IeVRdkMKt9dIMrb
X-Received: by 2002:a63:dc42:0:b0:46a:de10:384f with SMTP id f2-20020a63dc42000000b0046ade10384fmr9921035pgj.585.1666240552680;
        Wed, 19 Oct 2022 21:35:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7SZIXI2IfM8Jahyb1if2TBJNYRPfnBY4ij0sT6GfQJowe71UoXNa2atu/ErBoF9bEPPcjcIA==
X-Received: by 2002:a63:dc42:0:b0:46a:de10:384f with SMTP id f2-20020a63dc42000000b0046ade10384fmr9921021pgj.585.1666240552408;
        Wed, 19 Oct 2022 21:35:52 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y12-20020a63fa0c000000b0045dc85c4a5fsm10850414pgh.44.2022.10.19.21.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 21:35:51 -0700 (PDT)
Date:   Thu, 20 Oct 2022 12:35:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] populate: unexport the metadump description text
Message-ID: <20221020043547.rcojqbhxihkcaszi@zlang-mailbox>
References: <166613310432.868003.6099082434184908563.stgit@magnolia>
 <166613311003.868003.9672066347833155217.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166613311003.868003.9672066347833155217.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2022 at 03:45:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make the variable that holds the contents of the metadump description
> file a local variable since we don't need it outside of that function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> ---

OK, will merge this one in next release.

>  common/populate |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index b2d37b47d8..58b07e33be 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -901,15 +901,15 @@ _scratch_populate_cached() {
>  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
>  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
>  
> -	# These variables are shared outside this function
> +	# This variable is shared outside this function
>  	POPULATE_METADUMP="${metadump_stem}.metadump"
> -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> +	local populate_metadump_descr="${metadump_stem}.txt"
>  
>  	# Don't keep metadata images cached for more 48 hours...
>  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
>  
>  	# Throw away cached image if it doesn't match our spec.
> -	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
> +	cmp -s "${populate_metadump_descr}" <(echo "${meta_descr}") || \
>  		rm -rf "${POPULATE_METADUMP}"
>  
>  	# Try to restore from the metadump
> @@ -918,7 +918,7 @@ _scratch_populate_cached() {
>  
>  	# Oh well, just create one from scratch
>  	_scratch_mkfs
> -	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
> +	echo "${meta_descr}" > "${populate_metadump_descr}"
>  	case "${FSTYP}" in
>  	"xfs")
>  		_scratch_xfs_populate $@
> 

