Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21377C47082
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0895361183
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhFHPBr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:01:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233590AbhFHPBq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jun 2021 11:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623164393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XnLQUzF4ZfGzkFVVXEzG32PP21g1rqExmgOdwuMs+T4=;
        b=UYLFnsvN534VCx6UGkNsrOlKH/90zvRGrebas0ogTae2hQce9ZYe/LtLHGI98UollRCuuH
        k0wdkmFPcZzCV52kM9D7aimpgweAPzXd5ZHzXUW9KA/KgPKaEchkz0L9CZ0PzX1XJ3eh1a
        w8d8vGe8UIqrffM8tK7CaGs8nJFM4CE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-OVxTSYKqN1-zOkBARsFbyQ-1; Tue, 08 Jun 2021 10:59:51 -0400
X-MC-Unique: OVxTSYKqN1-zOkBARsFbyQ-1
Received: by mail-wr1-f72.google.com with SMTP id v15-20020a5d4a4f0000b0290118dc518878so9598747wrs.6
        for <linux-xfs@vger.kernel.org>; Tue, 08 Jun 2021 07:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=XnLQUzF4ZfGzkFVVXEzG32PP21g1rqExmgOdwuMs+T4=;
        b=k9ku1xa84Gcr/YOYbv0Shkm7uWpt/pxqh2va6M8H5D6GX72yF+AaPNO4DNs1RSeUAu
         LH1cEf/ygEPkyi4ZMwZd89867oUfQkmHvX8ZFikBJ1FoWmo+WRXx7JSxc3EY1BB2lNQp
         BNA7eQrZfK9uiYHF0bduCKL4T0oZTBgBQBAnKFovUQmy7+qr/gq2/609nLmQ4ezLIa5h
         cahqKoKPlLwQFm+jIcQtjmzTRtsTteIUErJbj/Glstih4y+NCHxPPX9rVWwn8jpS2lMp
         HtXSZpkSetDt11HlB9EmpQGouG+tOZcTncw7eoiTjoE2qwF+Lieh4WfVpTUjP+CkfSt3
         uzbQ==
X-Gm-Message-State: AOAM5303NKG8yhMM6j1jhL/51GTc744l4TsPcN7qyui7wE+/96C4ltcI
        uw5ztN7MVIyKxpleXzBrqfJI7erX6vMdxZ1HP5XnaPC4GftHAeMzZIcHBP+338xqs/1UMTtXBZS
        RLA0TF40gIwNRLMDYIMVK
X-Received: by 2002:adf:a45d:: with SMTP id e29mr23513743wra.161.1623164390245;
        Tue, 08 Jun 2021 07:59:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWg6pFzAcuovrreUrpGq0yVTGkazX5sYyZFEpyNmFJZrXjwfgZ7lAb8IwDIxt+LodJZ3dOwg==
X-Received: by 2002:adf:a45d:: with SMTP id e29mr23513724wra.161.1623164389991;
        Tue, 08 Jun 2021 07:59:49 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id g10sm20171038wrq.12.2021.06.08.07.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 07:59:49 -0700 (PDT)
Date:   Tue, 8 Jun 2021 16:59:48 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <20210608145948.b25ejxdfbm33uz42@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
References: <162300204472.1202529.17352653046483745148.stgit@locust>
 <162300205695.1202529.8468586379242468573.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162300205695.1202529.8468586379242468573.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Sun, Jun 06, 2021 at 10:54:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we decide to mark an inode sick, clear the DONTCACHE flag so that
> the incore inode will be kept around until memory pressure forces it out
> of memory.  This increases the chances that the sick status will be
> caught by someone compiling a health report later on.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

The patch looks ok, so you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


Now, I have a probably dumb question about this.

by removing the I_DONTCACHE flag, as you said, we are increasing the chances
that the sick status will be caught, so, in either case, it seems not reliable.
So, my dumb question is, is there reason having these inodes around will benefit
us somehow? I haven't read the whole code, but I assume, it can be used as a
fast path while scrubbing the FS?

Cheers.

> ---
>  fs/xfs/xfs_health.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 8e0cb05a7142..806be8a93ea3 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -231,6 +231,15 @@ xfs_inode_mark_sick(
>  	ip->i_sick |= mask;
>  	ip->i_checked |= mask;
>  	spin_unlock(&ip->i_flags_lock);
> +
> +	/*
> +	 * Keep this inode around so we don't lose the sickness report.  Scrub
> +	 * grabs inodes with DONTCACHE assuming that most inode are ok, which
> +	 * is not the case here.
> +	 */
> +	spin_lock(&VFS_I(ip)->i_lock);
> +	VFS_I(ip)->i_state &= ~I_DONTCACHE;
> +	spin_unlock(&VFS_I(ip)->i_lock);
>  }
>  
>  /* Mark parts of an inode healed. */
> 

-- 
Carlos

