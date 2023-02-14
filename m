Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA36C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Feb 2023 22:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBNWVK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 17:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBNWVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 17:21:09 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8BC2719
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 14:21:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w14-20020a17090a5e0e00b00233d3b9650eso183165pjf.4
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 14:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k0bFIu73fTVvR9PL7MVdOQ0zbyp7cdAUZDJOn+qJPyo=;
        b=KSwZF1TjnlMTwL3m/4kspmK7z89JCyD76z6bkIxgZuLon2AvuGmdVM9lmns/zYcnEr
         5b23wZyCzced3e/ydwe0Pwq9C6ffOi4KN+jSTpSmJyFEBqtX4EZp7FcPgrCGx6VysHZB
         GLIxysHwjAr8SSLqfGQB5Nkt25HFKpudWDI+PrD9mzLXP7CMuD17Zbp7bg2QistHinsR
         fxOES75krFrWmyI5zBtFFpqW9tBFbmwWSul3OP9IHb7eunJUHBHCVOpjndVUwHp3baGA
         8LKTJCdwmXMolsVBBjbBFwO+lD00Nu4tY9HTSilRloo9sb4qC4sgQ/z0jZuKdQhnO3EP
         AihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0bFIu73fTVvR9PL7MVdOQ0zbyp7cdAUZDJOn+qJPyo=;
        b=v6TX9h2xr1I4hFrEb+3qCOasIJd3ZU/2SelGXs7ygS3eH+2uFT/PvvbY5XX8Hj9c3R
         i++PYXjOPUwfAvOhO7J3rutPtfoHSW97OPkvFMkyg652Lps0g7B8RVoGHU/JlSITeecS
         wtd88qXCeObJrNbzc2rj8eWpxQuRo/0JkQ5nfUDYRz+XJOuXHGK+pJ8MFKp16CjfaDvI
         Y0AfT/tD1Z349voXJhEYqAm36GixS2072ySjFUk6a5TQzArGH2KqMqdRE4oAu8G9PDXp
         T5eiq58IQatsmrSuPoPuibOQIAfoF/1V/HDW+bg05diQFZQVLXTThPiAVrSLC03F4h2G
         lehA==
X-Gm-Message-State: AO0yUKXbUGTT9RNSlRqSSb/VyC4J3UxcombOaQNFoWpPKatJlowTuW03
        bceLqrm4WohJ/UA1aiJDoBeenQ==
X-Google-Smtp-Source: AK7set8KEd4xTYXFCatTliojpLWv3pNWakQRBOxdble+7NUx01Mw71QL1kYwzMGeS19YWgF3WrHN9A==
X-Received: by 2002:a05:6a20:8f0a:b0:bf:73d:485e with SMTP id b10-20020a056a208f0a00b000bf073d485emr4909371pzk.54.1676413268158;
        Tue, 14 Feb 2023 14:21:08 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id s19-20020aa78d53000000b0056b4c5dde61sm10527918pfe.98.2023.02.14.14.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 14:21:07 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pS3fd-00FMs4-3D; Wed, 15 Feb 2023 09:21:05 +1100
Date:   Wed, 15 Feb 2023 09:21:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: report block map corruption errors to the
 health tracking system
Message-ID: <20230214222105.GM360264@dread.disaster.area>
References: <20230214055114.4141947-1-david@fromorbit.com>
 <20230214055114.4141947-2-david@fromorbit.com>
 <Y+tARjFLhxzK6Vt0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+tARjFLhxzK6Vt0@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 14, 2023 at 12:03:18AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 14, 2023 at 04:51:12PM +1100, Dave Chinner wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Whenever we encounter a corrupt block mapping, we should report that to
> > the health monitoring system for later reporting.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > [dgc: open coded xfs_metadata_is_sick() macro]
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Just curious:  this is probably from a bigger series, which one is
> that?

[14/2/23 10:36] <djwong> branch @ https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=corruption-health-reports

-Dave.
-- 
Dave Chinner
david@fromorbit.com
