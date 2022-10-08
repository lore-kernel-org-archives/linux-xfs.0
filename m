Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94ADEC433FE
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Oct 2022 11:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJHLM6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Oct 2022 07:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJHLM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Oct 2022 07:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5513F50F94
        for <linux-xfs@vger.kernel.org>; Sat,  8 Oct 2022 04:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665227575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijebN9vtzabsCUMkAWB1z0Voz2AmoSGlgDeLte6kJbI=;
        b=Wd7Nxc8m9EOgm033I+Gc48nXWtFLKlJjhLh/QwbgB8uC0sKCfaOqDtN8ZHe88XPdoOStyL
        vqKtncoNNNEL86EWdntXUbAcVBFw5EAqTgBwqt12SJB01JGDAY4q8G3i/7qCs604K6277X
        zFq4oIrx6mn7p8infFCgVKymdke1U+k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-359-4ZSEZ547Mx-x3uVjTvX7vg-1; Sat, 08 Oct 2022 07:12:53 -0400
X-MC-Unique: 4ZSEZ547Mx-x3uVjTvX7vg-1
Received: by mail-qv1-f70.google.com with SMTP id dn14-20020a056214094e00b004b1a231394eso4231006qvb.13
        for <linux-xfs@vger.kernel.org>; Sat, 08 Oct 2022 04:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijebN9vtzabsCUMkAWB1z0Voz2AmoSGlgDeLte6kJbI=;
        b=vlVyl+cj7PuwU+JTKBACG2SQ1UTfaboLP5I5WA/2/iYv5rYST7FtWZKQTIZqscCTIA
         gJD7N4SWKve87EbJUaP7GzgsvKIkJlY/Qu8jFnTfi2hQu/ofZnNxdOpsim0FvTSbd9Oe
         ZXaqd/2Yj9sADlhSmYvsMkc3g8bB3j9FwAV2V9ZVmQzQOEDSQgdWoLaiSBKrJKvjlrK+
         FF1EhFB89T7XZJodevq5eSmp4RToQ450+Pu7Ngv5iVLI5OI6K46DGKVYWAiQhzw4+9nE
         YcKmD5nYYzTYE3k4SG1sNjbYgNrLSF4egPr+URX4bCfq4fMMqOuxtVlqtjqevAlRGAAo
         /A0w==
X-Gm-Message-State: ACrzQf2m1EsjDIn87GDjSWu3jbbli1nV2ob0puTr6xLlEBDwYyhN2qbW
        0oIQWDk1ixXjC5aK/WkOEPObqkEs/2lijlF3TVuuEERMbpRdQaj9IgSy2hyDuoyVmSv0QaSPmJi
        6syP/Jj1vnfjCE55expu4
X-Received: by 2002:ac8:7d49:0:b0:395:968c:d113 with SMTP id h9-20020ac87d49000000b00395968cd113mr6352085qtb.639.1665227572942;
        Sat, 08 Oct 2022 04:12:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6KV0HIn9bBUFKokU3maD0LrxXCh8emB3qBDdxdhMwBVtYAmIlMWSr2Fp29q9Spk9Xf23bliQ==
X-Received: by 2002:ac8:7d49:0:b0:395:968c:d113 with SMTP id h9-20020ac87d49000000b00395968cd113mr6352073qtb.639.1665227572727;
        Sat, 08 Oct 2022 04:12:52 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b006b95b0a714esm4691388qki.17.2022.10.08.04.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 04:12:52 -0700 (PDT)
Date:   Sat, 8 Oct 2022 19:12:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/6] common/populate: fix _xfs_metadump usage in
 _scratch_populate_cached
Message-ID: <20221008111248.zn43k64bnfr6dkoy@zlang-mailbox>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
 <166500906664.886939.1596674456976768238.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166500906664.886939.1596674456976768238.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 05, 2022 at 03:31:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> _xfs_metadump requires that the caller pass in "none" for the log device
> if it doesn't have a log device, so fix this call site.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/populate |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 4eee7e8c66..cfdaf766f0 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -891,7 +891,7 @@ _scratch_populate_cached() {
>  		_scratch_xfs_populate $@
>  		_scratch_xfs_populate_check
>  
> -		local logdev=
> +		local logdev=none
>  		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
>  			logdev=$SCRATCH_LOGDEV
>  
> 

