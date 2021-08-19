Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB68C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB226109F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 11:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbhHSLmz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 07:42:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238208AbhHSLmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 07:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629373338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XxXwzTYmAYmLVVq/OOmdRLJwf3gWVndu/THd064f2rg=;
        b=MQr+Yt/KPk3XvtGIfx+YxlXdnd8mQHHbHRBc+qvOfNfbfxwXTgubRCFuv9MKBcnQ5Qu7/l
        w1xSoU9bT42q+vEY+g9m/ruW4O7T9eyyxvrvyYfpv/uQAt5u6JKI3eeK4P612XHqZBwdDw
        kItO6rHc3SCMGbYyFZSskMAwZBP20Fs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-VPtI70P5MS-2s-8LmH9xIA-1; Thu, 19 Aug 2021 07:42:17 -0400
X-MC-Unique: VPtI70P5MS-2s-8LmH9xIA-1
Received: by mail-ed1-f72.google.com with SMTP id u4-20020a50eac40000b02903bddc52675eso2684392edp.4
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 04:42:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=XxXwzTYmAYmLVVq/OOmdRLJwf3gWVndu/THd064f2rg=;
        b=ESWs2/zuq7h3GjklHZNxQeNC0br1c2oBodDGs4UzNiBE98uhzH0vm7pnrXTnQkF50K
         /pboTgXHfl74AA4CxorquvXpSHfYHmlKnwcpZPmS6DFDejyd+xxdfF65l/mGZtxgk+1O
         JaAyeTS3okwUQMGI7s5u0n0rXPM1o3z5lRmT8ekItC9Fc2hjcgwNKRqEa/SLffvVP1dJ
         naiob/F3lexk6w5ukvsp4R/LdQv/fejGqI+HED/RoFEKwgfURbAsIPlIdEfBTeTKbJ65
         E25ShXB8wJQLpWr1BYqRkroX7oGZ/alHNeTUnJQ0VCQ4rWsly8OioD57JWQs84xq6YUa
         Tmlg==
X-Gm-Message-State: AOAM530OoQYspallBFxtlkP3WeVk+Kdty5r45MSBZlvPVIrxv3a7+HVN
        P1eJA+HeJwJbnTqzqQfZEaMWAsZq2/LqmDQ5fW23G85y+622YjiyCV4BEtwOSKOrtXQT8pTs9wg
        3ijkMNuwaH0l0D87tL9mL
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr14985097ejb.108.1629373335868;
        Thu, 19 Aug 2021 04:42:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzN0JCbqd5bw8sBS+1EpAoohbxHwvIM6Qzzo075kUSBzinPGVwY0NwrBrcgJKMFxvsB6huI2w==
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr14985082ejb.108.1629373335692;
        Thu, 19 Aug 2021 04:42:15 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id h8sm1584788edv.30.2021.08.19.04.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:42:15 -0700 (PDT)
Date:   Thu, 19 Aug 2021 13:42:13 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs: disambiguate units for ftrace fields tagged
 "offset"
Message-ID: <20210819114213.7rji4qax2gdj5bar@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924377603.761813.4113528501236797725.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924377603.761813.4113528501236797725.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints describe fields as "offset".  That name doesn't
> describe any units, which makes the fields not very useful.  Rename the
> fields to capture units and ensure the format is hexadecimal.
> 
> "fileoff" means file offset, in units of fs blocks
> "pos" means file offset, in bytes
> "forkoff" means inode fork offset, in bytes
> 
> The one remaining "offset" value is for iclogs, since that's the byte
> offset of the end of where we've written into the current iclog.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
...

> @@ -2145,7 +2145,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  		__entry->fork_off = XFS_IFORK_BOFF(ip);
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
> -		  "broot size %d, fork offset %d",
> +		  "broot size %d, forkoff %d",

				forkoff 0x%x?


Other than that:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

