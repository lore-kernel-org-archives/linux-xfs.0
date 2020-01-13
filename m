Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1F6C33CAD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 11:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B37B2081E
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 11:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YCJ7lb1L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgAMLoE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 06:44:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22679 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726277AbgAMLoE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 06:44:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578915844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Y0yd5MIejT8BdrWS1LT4QCJTRRVkf/bGT/zP8O4fLk=;
        b=YCJ7lb1LQ4lAS3ELG1xDz9EEYdTQVrul4e8BQ2TGurtjvGEZwhkPNEyiXeqoVzrEuqQZ76
        dItVX1CSU0MBYfmRway/9D3sDvnR9hKltH2HEEd7Octtbu396vUi1x62uEiP+t94uEJ8+Q
        Q1jxrRx0/rCTQg1JI5+MmNMPR7ga7L0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-fGDHdPPiMK-uDixKZGvS7w-1; Mon, 13 Jan 2020 06:44:00 -0500
X-MC-Unique: fGDHdPPiMK-uDixKZGvS7w-1
Received: by mail-wr1-f70.google.com with SMTP id j13so4846569wrr.20
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2020 03:44:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=6Y0yd5MIejT8BdrWS1LT4QCJTRRVkf/bGT/zP8O4fLk=;
        b=Ph55g4OAoH7kXaBRMqg7VAC1RtOFs2p4WIQyT7eK+d6M/XXPShhPUfToGZ1SHqgiMz
         izjYY6UzrHnETAXCVOG68qmxJoXTsBoCw4vf7QGEtzvtMdwbTVATv7ojdBHGnpxSUrR/
         CO4gJgMT7OcgyLNOdYGa730ojj1BAU8pWhSmsr77ATQfn/dA75rNCBbtGiWDDfty8X6y
         WgRp9zy0ybC6YLJ65HRP3OUtHx3GntNmgEC3bfJNWjn2kU66Fou9LbZXj3o3o05trTiJ
         4ITONZCOAseXN6WUvKwIsi8vpP7cprgBV2uWgfbaKYFA/i0xGBmd2nHS/lNs4BvLn0Zx
         cApA==
X-Gm-Message-State: APjAAAV+NCSlabmj43UCJ25hpJRlf3pZU9ZC5oMNgQg6GsBcqLYedGyw
        oSO5LRVU5VaLgLiqj/Zk3/OUwwnIaB89K0FCC6Rm57w9zS/m5Tn1DfV7mQSmHLzMKLkc7K0hpva
        5U6ZwkYmMMeJNO7mY1w0B
X-Received: by 2002:a5d:6408:: with SMTP id z8mr18170303wru.122.1578915839704;
        Mon, 13 Jan 2020 03:43:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqyOluEqNCxxB6Sy2T5ewdVPQVamv+3FJkd2Hezl/NjZ0HAyRTDcLPD3lnZcfsjIAUsPChTwHQ==
X-Received: by 2002:a5d:6408:: with SMTP id z8mr18170280wru.122.1578915839468;
        Mon, 13 Jan 2020 03:43:59 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id f16sm14482436wrm.65.2020.01.13.03.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 03:43:58 -0800 (PST)
Date:   Mon, 13 Jan 2020 12:43:56 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink vs ThinLVM
Message-ID: <20200113114356.midcgudwxpze3xfw@orion>
Mail-Followup-To: Gionatan Danti <g.danti@assyoma.it>,
        linux-xfs@vger.kernel.org
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Gionatan.

On Mon, Jan 13, 2020 at 12:25:26PM +0100, Gionatan Danti wrote:
> On 13/01/20 12:10, Carlos Maiolino wrote:
> > First of all, I think there is no 'right' answer, but instead, use what best fit
> > you and your environment. As you mentioned, there are PROs and CONS for each
> > different solution.
> > 
> > I use XFS reflink to CoW my Virtual Machines I use for testing. As I know many
> > others do the same, and it works very well, but as you said. It is file-based
> > disk images, opposed to volume-based disk images, used by DM and LVM.man.
> > 
> > About your concern regarding fragmentation... The granularity is not really 4k,
> > as it really depends on the extent sizes. Well, yes, the fundamental granularity
> > is block size, but we basically never allocate a single block...
> > 
> > Also, you can control it by using extent size hints, which will help reduce the
> > fragmentation you are concerned about.
> > Check 'extsize' and 'cowextsize' arguments for mkfs.xfs and xfs_io.
> 
> Hi Carlos, thank you for pointing me to the "cowextsize" option. From what I
> can read, it default to 32 blocks x 4 KB = 128 KB, which is a very
> reasonable granularity for CoW space/fragmentation tradeoff.
> 
> On the other hand, "extsize" seems to apply only to realtime filesystem
> section (which I don't plan to use), right?

I should have mentioned it, my apologies.

'extsize' argument for mkfs.xfs will set the size of the blocks in the RT
section.

Although, the 'extsize' command in xfs_io, will set the extent size hints on any
file of any xfs filesystem (or filesystem supporting FS_IOC_FSSETXATTR).

Notice you can use xfs_io extsize to set the extent size hint to a directory,
and all files under the directory will inherit the same extent hint.

Cheers.

> 
> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> 

-- 
Carlos

