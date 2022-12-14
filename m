Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D508AC001B2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 18:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbiLNSlv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 13:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbiLNSls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 13:41:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E51755B5
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 10:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671043257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LTDcKqysoJsS1IFGNutz6UdMJGnvNSrJ858y5VWuguE=;
        b=Q9kFzQ/3gU9GhDcN6ITy/oIUQVkdgfgleiWC5PsmYN6WLcV1EfamEQx9ihzdtGsS+iL0P4
        KxxNn5B9LzX4wfd7Px+CabJfT48lVqz4RaR7Og9h0Rk3bneEFOSjsgrnDi4eNcDqZF2JOy
        Er4AoMOa6qBeoq8GXEqTWUJOOBV7368=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-240-gjGycf5VN0micvhIi5yZMA-1; Wed, 14 Dec 2022 13:40:53 -0500
X-MC-Unique: gjGycf5VN0micvhIi5yZMA-1
Received: by mail-pl1-f200.google.com with SMTP id u10-20020a17090341ca00b001897a151311so3134573ple.8
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 10:40:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTDcKqysoJsS1IFGNutz6UdMJGnvNSrJ858y5VWuguE=;
        b=RNsEXsVNyuCTGj9sX5kGl4CZ+2YaMyCsmMnwd3ejOtDvpCEpzZ+ZHpflhSklmGSOhH
         75j+KZ8LUCa8eQ3ndpRlYOa5jUZXsbzG9g2fgGtEIP1zQgCPIY2NyQc3QFZtmP4nbTAR
         k1RmH5iuv6vfFTjk/JJZzUUM1OKMQJZyFDGoFRPz2UQGf2trVoZXu8cirqRdLNJcnVoj
         HdTlix/VXyiuzoMSi4sTem43THgfThFmc1qTlZE0gqh6V8yvEXMXZOM9S9JXeu8BI3pu
         Wfq7ZISL9qekZVb5XptcGLZh2tS/OhomsQ8qsObiQKiF1Of+Aaq6vyvV0rpGXAmd5+ha
         ZyzQ==
X-Gm-Message-State: ANoB5pkcNFs/+rCDrYQZMoxY0AEpCEWqKOcSg18eDz7VDs0AOWBb2KX1
        3FPhpf+Lv2hC6KWMfHvCNGtHTSosVyEykXPf7Hcyw/XP7uMcHhcBv1yvHKfENl1QoM0u1ZKTAxx
        f4Lkr26/j/6QYZrHqt+4U
X-Received: by 2002:a17:902:7845:b0:186:971c:297e with SMTP id e5-20020a170902784500b00186971c297emr21555459pln.20.1671043252405;
        Wed, 14 Dec 2022 10:40:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5iR1wrQqQRxW0bqEfeL/rXr2uPe4/LiVucxwt/FboDDX1zdQN+lnMB3swZHVacI9usvJj+yw==
X-Received: by 2002:a17:902:7845:b0:186:971c:297e with SMTP id e5-20020a170902784500b00186971c297emr21555441pln.20.1671043252066;
        Wed, 14 Dec 2022 10:40:52 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z1-20020a1709027e8100b00188f7ad561asm2171488pla.249.2022.12.14.10.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 10:40:51 -0800 (PST)
Date:   Thu, 15 Dec 2022 02:40:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after
 flex array conversion
Message-ID: <20221214184047.k3iaxggotcli4423@zlang-mailbox>
References: <167096073708.1750519.5668846655153278713.stgit@magnolia>
 <167096074260.1750519.311637326793150150.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167096074260.1750519.311637326793150150.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 11:45:42AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adjust this test since made EFI/EFD log item format structs proper flex
> arrays instead of array[1].
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

So we let this case fail on all older system/kernel? Is the kernel patch
recommended to be merged on downstream kernel?

Thanks,
Zorro

>  tests/xfs/122.out |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index a56cbee84f..95e53c5081 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -161,10 +161,10 @@ sizeof(xfs_disk_dquot_t) = 104
>  sizeof(xfs_dq_logformat_t) = 24
>  sizeof(xfs_dqblk_t) = 136
>  sizeof(xfs_dsb_t) = 264
> -sizeof(xfs_efd_log_format_32_t) = 28
> -sizeof(xfs_efd_log_format_64_t) = 32
> -sizeof(xfs_efi_log_format_32_t) = 28
> -sizeof(xfs_efi_log_format_64_t) = 32
> +sizeof(xfs_efd_log_format_32_t) = 16
> +sizeof(xfs_efd_log_format_64_t) = 16
> +sizeof(xfs_efi_log_format_32_t) = 16
> +sizeof(xfs_efi_log_format_64_t) = 16
>  sizeof(xfs_error_injection_t) = 8
>  sizeof(xfs_exntfmt_t) = 4
>  sizeof(xfs_exntst_t) = 4
> 

