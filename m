Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B99C07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E969D61CE2
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhGHHeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 03:34:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229861AbhGHHeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jul 2021 03:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625729501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ycebk7ZWmE/2tblDVHmlRZor5fdILUU+rHiyFLQZNDk=;
        b=CXefTsc4PpPwgc9pAy2NzmFjOpRUyoya5AQjjutgesLS6dOOnf411o6Wr2Z7kkHFr4nPDd
        Nvn8CMiiPkqib9qT0X1dtEYlGFaS+cUvC/f4v6w/rCepvUS9iIVLk3N976iSLKF/aP/y9D
        lytWPF0fS/JNBl1SokgI5ru2NH9Pe7M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-S29lJv4IO5-vUR_2yhOwIA-1; Thu, 08 Jul 2021 03:31:40 -0400
X-MC-Unique: S29lJv4IO5-vUR_2yhOwIA-1
Received: by mail-ed1-f70.google.com with SMTP id w1-20020a0564022681b0290394cedd8a6aso2807679edd.14
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jul 2021 00:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ycebk7ZWmE/2tblDVHmlRZor5fdILUU+rHiyFLQZNDk=;
        b=CzginRcU01uk43L+KUz4EZeGrjPAt8vaYXnDe/6jI11hfHS5/nTyz4kXkdth6A3+SH
         n3mZgfjhl2LKlF9kkqvZumRN6biuKRzcUrEcKvwuCVjSW0R1P6gAAqF7+1+C45w23fMt
         gXj1Xt19G5Vko2FKrBhSHniBtCqHdUZESPPbA0ksHzlRWF2LKO2Y5kjR63CV0FNr1Om7
         yqhE+FwlRSR0h1e6/dUquxBhQ/5zRk4R6DSyUDGmoPuyc4vpePkDEhraVCn9mgZekiXP
         bW2iLWdAteaqg4K3QkM7uJTI/ZyCffjVRSRJBu4ljftq7febusVLtvWZnomCIONjXGDT
         3dCw==
X-Gm-Message-State: AOAM532p5lXuTRYZRMMtCgegvjhLZ/pgPBNILmnqXBkROFMKY/lwt35h
        DLXNBQKewF9RLxJamaSVtuL52/lT5wVaz99n46bTTqJo2zz3RvfGSEm3uQFVQey4LLKhGE72b8m
        arb17IERbJJKE33TmjDVg
X-Received: by 2002:a17:906:8252:: with SMTP id f18mr6131593ejx.261.1625729499209;
        Thu, 08 Jul 2021 00:31:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2bdhwqzpkbuBWJ2qRdbHKwcCLT/NuuJM6zWQm2PLbsxIH/Hj+MvySEyAV6nnR/FjJ/Kpqng==
X-Received: by 2002:a17:906:8252:: with SMTP id f18mr6131580ejx.261.1625729499038;
        Thu, 08 Jul 2021 00:31:39 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id e16sm727572eds.96.2021.07.08.00.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 00:31:38 -0700 (PDT)
Date:   Thu, 8 Jul 2021 09:31:36 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_io: clean up the funshare command a bit
Message-ID: <20210708073136.tpwyppo3a6vskkfp@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162528107717.36401.11135745343336506049.stgit@locust>
 <162528108811.36401.13142861358282476701.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528108811.36401.13142861358282476701.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:58:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add proper argument parsing to the funshare command so that when you
> pass it nonexistent --help it will print the help instead of complaining
> that it can't convert that to a number.

Looks ok to me despite the space/tab thing already mentioned by hch.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  io/prealloc.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/io/prealloc.c b/io/prealloc.c
> index 2ae8afe9..94cf326f 100644
> --- a/io/prealloc.c
> +++ b/io/prealloc.c
> @@ -346,16 +346,24 @@ funshare_f(
>  	char		**argv)
>  {
>  	xfs_flock64_t	segment;
> +	int		c;
>  	int		mode = FALLOC_FL_UNSHARE_RANGE;
> -	int		index = 1;
>  
> -	if (!offset_length(argv[index], argv[index + 1], &segment)) {
> +	while ((c = getopt(argc, argv, "")) != EOF) {
> +		switch (c) {
> +		default:
> +			command_usage(&funshare_cmd);
> +		}
> +	}
> +        if (optind != argc - 2)
> +                return command_usage(&funshare_cmd);
> +
> +	if (!offset_length(argv[optind], argv[optind + 1], &segment)) {
>  		exitcode = 1;
>  		return 0;
>  	}
>  
> -	if (fallocate(file->fd, mode,
> -			segment.l_start, segment.l_len)) {
> +	if (fallocate(file->fd, mode, segment.l_start, segment.l_len)) {
>  		perror("fallocate");
>  		exitcode = 1;
>  		return 0;
> 

-- 
Carlos

