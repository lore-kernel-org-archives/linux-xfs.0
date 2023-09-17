Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A33BCD37B4
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Sep 2023 22:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjIQWxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Sep 2023 18:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjIQWw7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2023 18:52:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCEF107
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 15:52:53 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1c0ecb9a075so29954385ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 15:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694991173; x=1695595973; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=roac4LosgX4s8S8F/sVOG7Y081vlxwQUgwpKiUp04iM=;
        b=Key3nBAkMqFlfUlrjV0loEPZ3mJ0KGQsttsYaVCNdlN1WYrJB2E8wY/GZZOQPB3IFy
         i3AlZuxAfyshcjHV9AU+o0jXIEmrn00N1HL6AZ8lF1/dMZZR5IYD/OJCw8xy8MOR3WkZ
         cZ9lRA3lcT3QkdCY+KIsxyokt5pgb8D7DbYagJPL8WZolD45U2Gvf0seqtHG2p2KGe1I
         6MFwq9MX7RXM+lOOE0w5rDmUbL0K+0Cj5D3cA2z8jGzQyZcnHGFXtZ8w4H5f24YGolLJ
         ivH4kev744oqLvOH+L+qPj00WKfhPmZoqudP7gWC4BE+KoHbh2mseOnssmRLollPoEmU
         sO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694991173; x=1695595973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=roac4LosgX4s8S8F/sVOG7Y081vlxwQUgwpKiUp04iM=;
        b=rwmeEYE7nZ5/5qOJ2ZKGYRO5lREbFj9DWAM+2qATW16g/SrsXGhTSN6HNmdWa+tsOT
         3BnVfy18wcOnuu4JYj825V9n+EoI0+OG2aqJYtzrrheI/yPb5z3gWf0tzL/UbuoO7z2A
         trrzxvGMcWBwdP6tTqfs/xJhPTxYMe5v5n3qmTDqrtEYyCBskrSqldi2nDsdiDxA+xJy
         UGpI1T1BM49AuM3MZ8Zb4mWoiZK1YoDvKPyPZTHYZ9AB6+CZcazkoCbBj1nHhCImOQO/
         8bXhNEsADIjJ4f6fTtjeSRRfNguTZZLBpvEv1rmvJcGWFEus8EwyyUnQ9omaLbeifuJ/
         J1qQ==
X-Gm-Message-State: AOJu0YxLFTE+HeFglQ/ErMrSRIBXJwBA6TpqWkJwx0IgO4NB+39CGiKo
        Kgf5wP8FkNnGcrEQv6+QtLjrFJWaGOBJNEMDCfw=
X-Google-Smtp-Source: AGHT+IExCHSud8g0Lswc5hN9szvqu5tCku+9l27nD03qPR54id1iU2HODVyR2ueP9jqeTLTL0uBs1g==
X-Received: by 2002:a17:902:c949:b0:1bb:b86e:8d60 with SMTP id i9-20020a170902c94900b001bbb86e8d60mr7708831pla.46.1694991173179;
        Sun, 17 Sep 2023 15:52:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id l21-20020a170902d35500b001ab39cd875csm7068754plk.133.2023.09.17.15.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 15:52:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qi0dF-0026DN-2F;
        Mon, 18 Sep 2023 08:52:49 +1000
Date:   Mon, 18 Sep 2023 08:52:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] mkfs: Improve warning when AG size is a multiple of
 stripe width
Message-ID: <ZQeDQW7a7eBt3vGp@dread.disaster.area>
References: <20230915102246.108709-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915102246.108709-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 12:22:46PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> The current output message prints out a suggestion of an AG size to be
> used in lieu of the user-defined one.
> The problem is this suggestion is printed in filesystem blocks, without
> specifying the suffix to be used.
> 
> This patch tries to make user's life easier by outputing the option as
> it should be used by the mkfs, so users can just copy/paste it.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

I'm fine with this but, as I said in my previous comment, a man page
update for agsize is also needed. Something like this:

	agsize=value
		This is an alternative to using the agcount
		suboption. The value is the desired size of the
-		allocation group expressed in bytes (usually using
-		the m or g suffixes).  This value must be a multiple
-		of the filesystem block size, and must be at  least
+		allocation group expressed as a multiple of the
+		filesystem block size.  It must be at  least
		16MiB, and no more than 1TiB, and may be
		automatically adjusted to properly align with the
		stripe geometry.  The agcount and agsize suboptions
		are mutually exclusive.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
