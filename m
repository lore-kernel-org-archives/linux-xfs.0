Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22298C6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 21:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCHVZm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 16:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCHVZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 16:25:40 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC85CF9B1
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 13:25:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id fr5-20020a17090ae2c500b0023af8a036d2so3075555pjb.5
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 13:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678310733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bmzOoZCs46sKhyhk59+DKFkb2aMBcXcrxeigQ+YCTU4=;
        b=x+EOuqn0mahV8jZh36jVG1TqrbzDt4BkgHSUp64S/nzFR4bMgwuOV+A7UWHRqC1Fra
         tJNV4Gs3xd3tNPygxRby1lh2exQb1616GniHerwmF1ZZwPVmRqRz0uhMm92Qb+5s/JAI
         w3SM2Q/oHxZdVaAMVsOu00dzNvekOlF+Td2IBs1We1cpDEA6JK8w8K0rQUnLC24xJP+Y
         HJuvddvXWtILX8pClXLxfRdn3HZinj7K5mCAImuLcIt0LBOO0t6jJSwLO5RRtNPDLuSs
         aSnkU473AdphasIATUDAV/md8kxR7DoOy45rEy+1dHhLdX6mK471kCuchTCeYjqL6e5P
         ew7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678310733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmzOoZCs46sKhyhk59+DKFkb2aMBcXcrxeigQ+YCTU4=;
        b=HrDEY1ylHFHfnywRlheYH0uwyJx+MAe2Q313qFuZHLX9FeHz5IOfBI+pbbaRfasrER
         X49/AmE+Uy20vvz33MF422j0WkWGVID2U0Lu2rfc+V+t2gGMp/RSTS2l5pJxwniafUIT
         C4hWHFmhQObeh7/nWci6IjaWfpIL8GsKvUDM26a/3TATj7d1GMUCVEuNGVrLKJqSSnBF
         VIqJV5/1y/DPLDj6vKF5sqsrQrPiEyJxUAS/pnQZqQMai/meLTSank7eyHa/cBijU9JB
         nDFp1y8vZWIi1+cNEUWdl1OY6J5bAqS1PXK5PizpQFBpNsAMq5Wr5X4dMP8bWSM4v7xd
         SB4w==
X-Gm-Message-State: AO0yUKWqxkIXafGmAz0HcvDgcvyb1v9lBmMBT9UHPBEq+ko0l7cqDHtk
        g4L8Kvd/7+9E3DP6PVOzwv5qdQ==
X-Google-Smtp-Source: AK7set8yE4FKZ4iGjtNFh1nXJmjGKqxf5HRTViI0SSES4LOMIfUP8zBqmb/iTGtU5aDyftUVC3B8oQ==
X-Received: by 2002:a05:6a20:a624:b0:cc:92ee:b119 with SMTP id bb36-20020a056a20a62400b000cc92eeb119mr15111745pzb.45.1678310733057;
        Wed, 08 Mar 2023 13:25:33 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id a14-20020a62e20e000000b00582f222f088sm9837681pfi.47.2023.03.08.13.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 13:25:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pa1Ht-006RAm-Na; Thu, 09 Mar 2023 08:25:29 +1100
Date:   Thu, 9 Mar 2023 08:25:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 0/2] Ignore non-LRU-based reclaim in memcg reclaim
Message-ID: <20230308212529.GL360264@dread.disaster.area>
References: <20230228085002.2592473-1-yosryahmed@google.com>
 <20230308160056.GA414058@cmpxchg.org>
 <CAJD7tka=6b-U3m0FdMoP=9nC8sYuJ9thghb9muqN5hQ5ZMrDag@mail.gmail.com>
 <20230308201629.GB476158@cmpxchg.org>
 <CAJD7tkbDN2LUG_EZHV8VZd3M4-wtY9TCO5uS2c5qvqEWpoMvoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbDN2LUG_EZHV8VZd3M4-wtY9TCO5uS2c5qvqEWpoMvoA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 08, 2023 at 12:24:08PM -0800, Yosry Ahmed wrote:
> > I tried to come up with something better, but wasn't happy with any of
> > the options, either. So I defaulted to just leaving it alone :-)
> >
> > It's part of the shrinker API and the name hasn't changed since the
> > initial git import of the kernel tree. It should be fine, churn-wise.
> 
> Last attempt, just update_reclaim_state() (corresponding to
> flush_reclaim_state() below). It doesn't tell a story, but neither
> does incrementing a counter in current->reclaim_state. If that doesn't
> make you happy I'll give up now and leave it as-is :)

This is used in different subsystem shrinkers outside mm/, so the
name needs to be correctly namespaced. Please prefix it with the
subsystem the function belongs to, at minimum.

mm_account_reclaimed_pages() is what is actually being done here.
It is self describing  and leaves behind no ambiguity as to what is
being accounted and why, nor which subsystem the accounting belongs
to.

It doesn't matter what the internal mm/vmscan structures are called,
all we care about is telling the mm infrastructure how many extra
pages were freed by the shrinker....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
