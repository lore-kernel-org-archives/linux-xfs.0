Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B359C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 10:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 246F1610C8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 10:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbhJGKrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 06:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241030AbhJGKrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 06:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633603523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FDjAZy0o0cxNZIR+OmfLcOHAknshOPeLmRYeFyi+lAA=;
        b=atGZ0N5udU9BLZV2sFRc2+OJTTvwLr9B54HYlAbj+CTsBMrgdbPIUr7VT3iDmkz7jf9NBH
        nygvMYx820nAvtMcoB2KbCL9gj1c6Qo9j3St9DvDhcPPV9AX664FvVRFQPE5XtpxwmP2sb
        cZ4AhE8ItZoT/hXfEO6QudrqjY7kr7U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-r5-fIim5NiCwGKss5my6Yg-1; Thu, 07 Oct 2021 06:45:22 -0400
X-MC-Unique: r5-fIim5NiCwGKss5my6Yg-1
Received: by mail-wr1-f70.google.com with SMTP id j19-20020adfb313000000b00160a9de13b3so4342368wrd.8
        for <linux-xfs@vger.kernel.org>; Thu, 07 Oct 2021 03:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=FDjAZy0o0cxNZIR+OmfLcOHAknshOPeLmRYeFyi+lAA=;
        b=b53uk0kK2bRVzPOuoZZ0alz76V8zynMOGBV1ajkiJuL1Ze2bFPNUyms47sj0KlKRu1
         jxY18mEQ1zSYQ+KsjXbS9xnFLs2cfkz4ewH205uF/hgWVCXTJsT2WqdcoHPNntuJBUYf
         QiQxfpd9vXNDGKHwFDodAiohf3n9Rzrm2pGL3tHO/xq7XPG9OIdORu+x9rZpTV3Plbr9
         C1ZgykHA/XbS1OAW9DxqV+MczX/EP41+tgP9B8+rYro9RUNI/HN959di3ta/2LHQF1so
         DiFfjAGi0pJuIewzJj8v5MfWsASvBiHB6Zu15EObcn59nwehdEs2kOkrS0W6aQEeCkDS
         7lYg==
X-Gm-Message-State: AOAM531Ofsbc5z6jFSTnyCKIk9H7hVruImfFQC+7rUd0KiZu2irTDKoa
        OWKbpv0Oyu0Th2fbqybW9tURgmS9EtbXX7wwPUuRd+6qHRBK9sk3bwU8LSAWCw0o/S9Cn2S+aDn
        8H1lU40bs9Y3ujFnRiM8Z
X-Received: by 2002:adf:e390:: with SMTP id e16mr4365361wrm.217.1633603521081;
        Thu, 07 Oct 2021 03:45:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGJ7j4YYp+k1+F6gRIRkOd25pX1zY1sEKxcTR+kd3yglGXyZBW+0zxZNg/tkvObbamZi9GXA==
X-Received: by 2002:adf:e390:: with SMTP id e16mr4365331wrm.217.1633603520786;
        Thu, 07 Oct 2021 03:45:20 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id z20sm4372180wmi.42.2021.10.07.03.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 03:45:19 -0700 (PDT)
Date:   Thu, 7 Oct 2021 12:45:18 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Prevent mmap command to map beyond EOF
Message-ID: <20211007104518.obsjrafsojryin7b@andromeda.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org
References: <20211004141140.53607-1-cmaiolino@redhat.com>
 <20211005223653.GG24307@magnolia>
 <20211006113400.lcwukggcqwkrftkz@andromeda.lan>
 <20211006155419.GI24307@magnolia>
 <20211006165407.bplbdyfb66hbumk5@andromeda.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006165407.bplbdyfb66hbumk5@andromeda.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 06, 2021 at 06:54:07PM +0200, Carlos Maiolino wrote:
> > > My biggest motivation was actually seeing xfs_io crashing due a sigbus
> > > while running generic/172 and generic/173. And personally, I'd rather see an
> > > error message like "attempt to mmap/mwrite beyond EOF" than seeing it crash.
> > > Also, as you mentioned, programs are allowed to set up such kind of
> > > configuration (IIUC what you mean, mixing mmap, extend, truncate, etc), so, I
> > > believe such userspace programs should also ensure they are not attempting to
> > > write to invalid memory.
> > 
> > This patch would /also/ prevent us from writing an fstest to check that
> > a process /does/ get SIGBUS when writing to a mapping beyond EOF.  Huh,
> > we don't have a test for that...

After looking closer into g/173, I see what you mean now.
> 
> The whole command that ends up receiving a SIGBUS is:
> 
> xfs_io -i -f -c 'mmap -rw 0 41943040' -c 'mwrite -S 0x62 0 41943040'

And...

> At a later point, I just did some tests using an empty, 0
> sized file.

And playing around with a 0 sized file without coming back to look closer into
g/173 was what had been blinding me.
Please just disregard this patch and my apologies for the noise.

-- 
Carlos

