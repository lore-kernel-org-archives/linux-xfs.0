Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184BAEEAA71
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 21:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjINVpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 17:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjINVpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 17:45:19 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4F9270A
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 14:45:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1bf6ea270b2so11370025ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 14:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694727915; x=1695332715; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KNr5LZqrKJaCxDxRI6wTl7l9bDeKXSWduwdptj2eWBc=;
        b=kfrv7XLpaA72h3J1km9tzk5TOJGcUM0WC2fOKMshyaDgB/JmAexC7gtFgg5G+IQf2a
         5XWVfcvPJ034ZmCwpYfIKru/ruXW8T8DdcYLeVbRAqPZCT87gFqQc/isYZl7V+Wyy2c9
         Xjby6tDYZAkF8yqPcPOg2MvaeevilG3h6wnbcF4Aiwuss5UzDlR4G5O9LbI1yq1LHsbR
         T8KLtfoTuA7iNFZRcw/oAa/L1hjaV2Lg6TrASafx7JQJxaeGxt//95YXQ7MOU+NHXoQR
         UdFRs2yiH011pFSjqusYK5FA3u0oQC62j+ZM6stnBVoTndLQR8/dLBG+GW+o1ZbTdwu7
         rX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694727915; x=1695332715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNr5LZqrKJaCxDxRI6wTl7l9bDeKXSWduwdptj2eWBc=;
        b=wvDyv3uxSljb6t+V/L3yY8cq0sspQvnfei9Hn5gw/FpNh7NfC2bbELog/uDUjjBnyN
         o3jnyg+T2/4XDwk8R/T2BWcM2ELWKNR6os7lJo8U2yNJA92f/r4nlnje7hw7gIuPoiHg
         yO5NC4SjtXkJ9JgjnMGYRsdhtT3Gl107cb7MDSe6oN2baFl+nUwsKAtl/kXz+5ps+Akx
         u3C16EW0BXOrLlKoRz6tbVv5vLlbOiYWYL9vJVa+bNOz9VKgp/pGyyUHiERJQR0+rD8t
         dZvuX11Ua5wq1MoNbrdZjEr4Z5KBqhz7htnaLt876wksY1xkcf9gsGnNEEqIuN/+7O0n
         xxSA==
X-Gm-Message-State: AOJu0YydY6wzkpVeeVKprE3dORqsaY/fSAayntImLfqpwB/hPcgLT37F
        QQi/KZ6Kkii31arpzAT8RRH9DyqApO2+CjCWIfo=
X-Google-Smtp-Source: AGHT+IHw/0TUOAUCySngDneKknU7OX9YxUbieopgaotF4FCJ8gyUOBShTgc+yBgv1gRfUfQJnbt5Sw==
X-Received: by 2002:a17:903:188:b0:1c0:e472:5412 with SMTP id z8-20020a170903018800b001c0e4725412mr8748987plg.18.1694727914952;
        Thu, 14 Sep 2023 14:45:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id jn3-20020a170903050300b001c0ce518e98sm2024411plb.224.2023.09.14.14.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 14:45:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qgu99-000mS9-1U;
        Fri, 15 Sep 2023 07:45:11 +1000
Date:   Fri, 15 Sep 2023 07:45:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: Improve warning when AG size is a multiple of
 stripe width
Message-ID: <ZQN+5/2Ajc+/UtjW@dread.disaster.area>
References: <20230914123640.79682-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914123640.79682-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 14, 2023 at 02:36:40PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> The current output message prints out a suggestion of an AG size to be
> used in lieu of the user-defined one.
> The problem is this suggestion is printed in filesystem blocks, while
> agsize= option receives a size in bytes (or m, g).

Hmmm. The actual definition of the parameter in mkfs.xfs has
".convert = true", which means it will take a value in filesystem
blocks by appending "b" to the number.

i.e. anything that is defined as a "value" with that supports a
suffix like "m" or "g" requires conversion via cvtnum() to turn it
into a byte-based units will also support suffixes for block and
sector size units.

Hence "-d agsize=10000b" will make an AG of 10000 filesystem blocks
in size, or 40000kB in size if the block size 4kB.... 

# mkfs.xfs -f -dagsize=100000b /dev/vdb
meta-data=/dev/vdb               isize=512    agcount=42, agsize=100000 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=4194304, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
#

> This patch tries to make user's life easier by outputing the suggesting
> in bytes directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d3a15cf44..827d5b656 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3179,9 +3179,11 @@ _("agsize rounded to %lld, sunit = %d\n"),
>  		if (cli_opt_set(&dopts, D_AGCOUNT) ||
>  		    cli_opt_set(&dopts, D_AGSIZE)) {
>  			printf(_(
> -"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
> -problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
> -an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
> +"Warning: AG size is a multiple of stripe width. This can cause performance\n\
> +problems by aligning all AGs on the same disk. To avoid this, run mkfs with\n\
> +an AG size that is one stripe unit smaller or larger,\n\
> +for example: agsize=%llu (%llu blks).\n"),
> +				(unsigned long long)((cfg->agsize - dsunit) * cfg->blocksize),
>  				(unsigned long long)cfg->agsize - dsunit);
>  			fflush(stdout);
>  			goto validate;

I have no problem with the change, though I think the man page needs
updating to remove the "takes a value in bytes" because it has taken
a value that supports all the suffix types the man page defines
for quite a long time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
