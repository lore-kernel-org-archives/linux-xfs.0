Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE616C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B9E61107
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242720AbhD1Rs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242688AbhD1RsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 13:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619632058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xsm9710tChEjTnTrqZpp7d0m9iuGUqir//97XvAR7qk=;
        b=H5yyzMfXZ20yntVRckEHj8QLjZtuN3o4isvzVV+YB+3SbyrT1hD4NsotkO34rHG7OyOXGb
        GSn/W3Febu4XfMS3SM5afpnsp5fMQJbxICTxxZ+yxhu9x2uam2qxl17oPlJ9d1oo8YLwVW
        NLYLSptdT7pusZgAjChcwDGAciSY8Ho=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-5DlKs8cwPaKQZyRENOZzog-1; Wed, 28 Apr 2021 13:47:25 -0400
X-MC-Unique: 5DlKs8cwPaKQZyRENOZzog-1
Received: by mail-qk1-f198.google.com with SMTP id s143-20020a3745950000b029028274263008so26025022qka.9
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 10:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xsm9710tChEjTnTrqZpp7d0m9iuGUqir//97XvAR7qk=;
        b=r5SU7pnPLW+rvjPpuuSzdgbNTWg9RWdQfymggOLUxlsMAX5A+z40fBy+EWZVqqx++o
         8Q5sgscOmeQh72QjQ3/BVN5bIZv3vqfCClxMMrn+XamK0lJ4w8+0t4iT+CXDtScnVP7X
         rHYcCt72tYtVrKZV7k3fFptLmNfvTplSiSlZcx5H8gpzhekTW6NU2FqrdfX9HArLe6wm
         B3M20huD+ppPutA6Fj0/w0E2IybW9p3bKC+FKMXavRnwsjycbOZp2PzZ9KJmOByZK2IH
         gGINW2dyJUbFgTrb3Wfl0vC3NmWi6eo9QrzxsiYLfezVX6sVpt6cWBIA2sfR7ULiesZb
         F/9Q==
X-Gm-Message-State: AOAM532gsbDOMLHYtOrFXzH1RaV7wagpMOGjYCSEygHxTGhvKsTcOmjz
        jAHmX418juhZynvu5/juECtB9Mci/x7ZC6tf7h9V96xdrL/cU9ANM/SARLUdI0mpWj/lSryTjH0
        hCfuqnVYbBNGja62x5oUp
X-Received: by 2002:a37:744:: with SMTP id 65mr8265806qkh.393.1619632045065;
        Wed, 28 Apr 2021 10:47:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPJVYcBv5rfVuXmdQr+vTTcH6DJR6MZqatlIoqYZw/50g9y9ZATmQ7BhtwkktRkSuIRp6Cdg==
X-Received: by 2002:a37:744:: with SMTP id 65mr8265792qkh.393.1619632044911;
        Wed, 28 Apr 2021 10:47:24 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id o125sm301937qkf.87.2021.04.28.10.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 10:47:24 -0700 (PDT)
Date:   Wed, 28 Apr 2021 13:47:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/5] generic/{094,225}: fix argument to
 _require_file_block_size_equals_fs_block_size
Message-ID: <YImfqrYhBRHe53Az@bfoster>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958294676.3452351.8192861960078318002.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958294676.3452351.8192861960078318002.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the incorrect parameter being passed to this new predicate.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/rc         |    3 ++-
>  tests/generic/094 |    2 +-
>  tests/generic/225 |    2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 2cf550ec..6752c92d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4174,7 +4174,8 @@ _get_block_size()
>  }
>  
>  # Require that the fundamental allocation unit of a file is the same as the
> -# filesystem block size.
> +# filesystem block size.  The sole parameter must be the root dir of a
> +# filesystem.
>  _require_file_block_size_equals_fs_block_size()
>  {
>  	local file_alloc_unit="$(_get_file_block_size $1)"
> diff --git a/tests/generic/094 b/tests/generic/094
> index 8c292473..20ef158e 100755
> --- a/tests/generic/094
> +++ b/tests/generic/094
> @@ -43,7 +43,7 @@ _require_test_program "fiemap-tester"
>  # FIEMAP test doesn't like finding unwritten blocks after it punches out
>  # a partial rt extent.
>  test "$FSTYP" = "xfs" && \
> -	_require_file_block_size_equals_fs_block_size $fiemapfile
> +	_require_file_block_size_equals_fs_block_size $SCRATCH_MNT
>  
>  seed=`date +%s`
>  
> diff --git a/tests/generic/225 b/tests/generic/225
> index fac688df..1a7963e8 100755
> --- a/tests/generic/225
> +++ b/tests/generic/225
> @@ -43,7 +43,7 @@ _require_test_program "fiemap-tester"
>  # FIEMAP test doesn't like finding unwritten blocks after it punches out
>  # a partial rt extent.
>  test "$FSTYP" = "xfs" && \
> -	_require_file_block_size_equals_fs_block_size $fiemapfile
> +	_require_file_block_size_equals_fs_block_size $SCRATCH_MNT
>  
>  seed=`date +%s`
>  
> 

