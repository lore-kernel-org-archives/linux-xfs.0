Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F99C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 13:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76A061153
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 13:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbhHSN17 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:27:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230136AbhHSN16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 09:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629379641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cklhZ3dIpsOM3gLMM1YpFDpH+lznRT21uCtnYKuyiDM=;
        b=TecR2yFPoONd2ykNB/5kW3U+wh0AyN/iNxUm4w50gVaeBHrGrV3mbl1yKFB2S4iUWwiLOA
        R0j4pgtLXvAark6IERzvda2hxyBseQPRauhT171OA+e802jZCgAJotDiaQfnNB0sn2QTdc
        cYpEzJu75Q1sbD88agy+4QTE+kWvavU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-zVDL92kgPVqZYN5HMoMEbQ-1; Thu, 19 Aug 2021 09:27:20 -0400
X-MC-Unique: zVDL92kgPVqZYN5HMoMEbQ-1
Received: by mail-ej1-f69.google.com with SMTP id e1-20020a170906c001b02905b53c2f6542so2252330ejz.7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 06:27:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=cklhZ3dIpsOM3gLMM1YpFDpH+lznRT21uCtnYKuyiDM=;
        b=maHymOHbA4V+SNTw2jP5LXHgWMPcgrkVifSablEEdfysyb0gSdvnO3BmooZLEXgbPk
         tQpzM2NC70ki4XJkvhlHs/8B9VVcmfUl/nm7WJH3KS/Nd+SUKweHj0FdmeuxtSxPGNmk
         NPbn6HT2BUBRv00NPsprc973o9ZLwBbfZwh9c2IC3ok9ii+YR0Oa/PZJNTCROD4X5rAa
         INA6Fj8K+DVryHj4gqhJdbOoRNnLz/glWfYNFEf3irKtdi6IiFeyj3ejgRpbUIcjlU0Y
         MwgwhtPbHPiKqX0Xpx1jwNteIRCIIJFYtgNGMX2rff0wIsYVemOzx0Swc7z3OhbRgzZU
         S4zg==
X-Gm-Message-State: AOAM532WmS/M7avI3a77r78su2rrFnO/95jOS7tz+5yB1doU6FP7eDO0
        OcxrtGYxV766U0XmllltyXfSnJPkM6ZXQ71v8uBoa2GshiVux8rf+yPNm1u+wCKokvJehw7Pb+3
        vbtxw8lFYDbcaeHlXnvpH
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr16269481edz.135.1629379639463;
        Thu, 19 Aug 2021 06:27:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGdf2yKd+RpfYf3lqcDHnyzwzsuaL3RyGHjMROM+H5nD8DA1/zageqQZUDHdX1wj6VjZz8UA==
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr16269466edz.135.1629379639221;
        Thu, 19 Aug 2021 06:27:19 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id n16sm1735669edv.73.2021.08.19.06.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:27:18 -0700 (PDT)
Date:   Thu, 19 Aug 2021 15:27:17 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 16/15] xfs: start documenting common units and tags
 used in tracepoints
Message-ID: <20210819132717.cacejau2jtaqme5h@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <20210819030728.GN12640@magnolia>
 <20210819034647.GR12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819034647.GR12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 08:46:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Because there are a lot of tracepoints that express numeric data with
> an associated unit and tag, document what they are to help everyone else
> keep these thigns straight.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: update unit names, say that we want hex, and put related tag names together
> ---
...
> + * daddr: physical block number in 512b blocks
> + * daddrcount: number of blocks in a physical extent, in 512b blocks

Shouldn't this be bbcount?

Other than that, it looks good:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

