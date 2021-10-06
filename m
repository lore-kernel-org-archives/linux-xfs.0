Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3126C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 11:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B93CE61151
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 11:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbhJFLf6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 07:35:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230471AbhJFLf6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 07:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633520045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/nLtYAAp6eAdEnX0ULhw7bXlxiyx2tBmTVq306nuVY=;
        b=AiKeaL7IjtmIdxGgiLXYSof7HFSoInIccvLLaEdTLdpeYlB9kkxwXe/782LFX1+TgtoRku
        rOy5Ry7+LWxJreYcIo8K6jCcenMRUmm0JZvlQFL2OpsV7C4TBU8WlUJ5u69VYTW800ppZ5
        bNji4RaWkrAUHBZPBVJdmu0uqtCjbyI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-BBleK6vCMcemOCtFHVyeMw-1; Wed, 06 Oct 2021 07:34:04 -0400
X-MC-Unique: BBleK6vCMcemOCtFHVyeMw-1
Received: by mail-wr1-f72.google.com with SMTP id r25-20020adfab59000000b001609ddd5579so1772912wrc.21
        for <linux-xfs@vger.kernel.org>; Wed, 06 Oct 2021 04:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=J/nLtYAAp6eAdEnX0ULhw7bXlxiyx2tBmTVq306nuVY=;
        b=2ldnV0Y/ZLzcUStIaiH7eCxTMAWiohchA/vkK/Dq6u7MO+LRSilcTRnoLh34q3+EsV
         FRhL0SihK1FE1c8c55H3Eou5j9qeh+LIZyDv/Cw5hQ1ZkNJfNiIrhP37GLGkI6Q1Vl++
         AjfypStNQffJAda3yPVCUVrw/FJhBunXinGcmTFmG39P+CSpUAMPc5UewUIfFbRjBz6U
         SdMdoiCNij/3GG9pzK+eZ4PbHJ0YwIQWpmFx15cQShHYnm1deV/awSadvyuJkXfSbnJk
         aBoGkObNSVmh6JZMiXM/0L1ltf0vcYI5BjbuhYedwXZm8xINkyyWAHe4Jy/Aav1yIxLC
         CvtQ==
X-Gm-Message-State: AOAM533zFUoefK4VNqC41wgx91vK3QklOCKx4n3XajxYmR5q2F3q03US
        lGMFuVD4ASHNAU8CT5u4WcaoTu8kxWAh0bf2zTMbPAp+Ts4vx/1pvOiqgGJ57uOFnlpyys15Mf4
        KKVZuL86+PlGpUG2qirH1
X-Received: by 2002:a1c:7f11:: with SMTP id a17mr9174457wmd.166.1633520043317;
        Wed, 06 Oct 2021 04:34:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiZXbAKRMyRo2nGsNVnbnAvtYxagu2f7a9wTQ2JAE3MMpzPnq6G5J52Lw4am94ZhF+U8XUhA==
X-Received: by 2002:a1c:7f11:: with SMTP id a17mr9174435wmd.166.1633520043081;
        Wed, 06 Oct 2021 04:34:03 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id w7sm8546236wrm.54.2021.10.06.04.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:34:02 -0700 (PDT)
Date:   Wed, 6 Oct 2021 13:34:00 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Prevent mmap command to map beyond EOF
Message-ID: <20211006113400.lcwukggcqwkrftkz@andromeda.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20211004141140.53607-1-cmaiolino@redhat.com>
 <20211005223653.GG24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005223653.GG24307@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 05, 2021 at 03:36:53PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 04, 2021 at 04:11:40PM +0200, Carlos Maiolino wrote:
> > Attempting to access a mmapp'ed region that does not correspond to the
> > file results in a SIGBUS, so prevent xfs_io to even attempt to mmap() a
> > region beyond EOF.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > There is a caveat about this patch though. It is possible to mmap() a
> > non-existent file region, extent the file to go beyond such region, and run
> > operations in this mmapped region without such operations triggering a SIGBUS
> > (excluding the file corruption factor here :). So, I'm not quite sure if it
> > would be ok to check for this in mmap_f() as this patch does, or create a helper
> > to check for such condition, and use it on the other operations (mread_f,
> > mwrite_f, etc). What you folks think?
> 
> What's the motivation for checking this in userspace?  Programs are
> allowed to set up this (admittedly minimally functional) configuration,
> or even set it up after the mmap by truncating the file.

My biggest motivation was actually seeing xfs_io crashing due a sigbus
while running generic/172 and generic/173. And personally, I'd rather see an
error message like "attempt to mmap/mwrite beyond EOF" than seeing it crash.
Also, as you mentioned, programs are allowed to set up such kind of
configuration (IIUC what you mean, mixing mmap, extend, truncate, etc), so, I
believe such userspace programs should also ensure they are not attempting to
write to invalid memory.

> 
> OTOH if your goal is to write a test to check the SIGBUS functionality,
> you could install a sigbus handler to report the signal to stderr, which
> would avoid bash writing junk about the sigbus to the terminal.

No, I'm just trying to avoid xfs_io crashing if we point it to invalid memory :)

Cheers.

> 
> --D
> 
> > 
> >  io/mmap.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/io/mmap.c b/io/mmap.c
> > index 9816cf68..77c5f2b6 100644
> > --- a/io/mmap.c
> > +++ b/io/mmap.c
> > @@ -242,6 +242,13 @@ mmap_f(
> >  		return 0;
> >  	}
> >  
> > +	/* Check if we are mmapping beyond EOF */
> > +	if ((offset + length) > filesize()) {
> > +		printf(_("Attempting to mmap() beyond EOF\n"));
> > +		exitcode = 1;
> > +		return 0;
> > +	}
> > +
> >  	/*
> >  	 * mmap and munmap memory area of length2 region is helpful to
> >  	 * make a region of extendible free memory. It's generally used
> > -- 
> > 2.31.1
> > 
> 

-- 
Carlos

