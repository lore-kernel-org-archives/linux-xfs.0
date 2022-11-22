Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6380DC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 22:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiKVWnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiKVWm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2022 17:42:59 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE94DF58D
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 14:42:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d192so15742260pfd.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 14:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OHmFcekX2nghj6K3yYTF3UfA+z88ogrDddAGW0uTMMQ=;
        b=IZKEJ/eyL163tLYNjYsB6V+Orch889GjNf75EuwI63y8CtzNejtTFnpeIeN82rEtAh
         GuzVPJ7PFL5wxV+GoJu2XOVSS/jCtS9Gsx6x0tOeMfnvLE7gF1VrZaicwq/loQAD1sJr
         jSVHnKHktTPdY2YU2RUUYv19mr+Gt7goHhsbzgWuvvMYnsgWSxnVosDrOXl2KDrdaK0H
         31CfwldjP721BvpPL+txGx8Jp3w2P9RUg4AJ/DojrHApn7Sk2vOh3wZdNwIBt0cl7nS9
         dQqG+JymcXtfL/AbRdBt8VEFWzVyr34eBCaUG9p4EMeVFaWuX5hL8anJvtoTFLjIlCrU
         GDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OHmFcekX2nghj6K3yYTF3UfA+z88ogrDddAGW0uTMMQ=;
        b=PSjQJ62ioIjVlfQqbplm/h7zU37drqyogaksqVqDcgI4xryZlJpAXb1MbWKJOCLrjg
         5gIES+PAeDxLgJiY/d7Dpi+XGB9Tg2Ai64klgCwD7hHwGeoi5akLYQ15cr9RxT4KCk/7
         1R912yg6sjOz6EFsJQ1SeUA0W2AG8WffNN+9hPB9dbM8TJuFrLo5EuyFRbizYdQhtEtt
         D16NODdxshEnAyXJd9yFerr7ynLSViaTAIzaukoV9oZ8z8PUx0N/GmiT02RTXSf79GCL
         FhUPZ1oOpNTcGhJztvFLm1E3ps+zFkqMiPLSiq360AVc8iNo5IM9W2cucIYQS/skISUo
         VRKA==
X-Gm-Message-State: ANoB5plc/iomZL2zcw2m81dsG9zuEg2nOPD6N0qhdawHMAZJhPzfl46P
        ai2nZrJjSvza2UcLY2nSADwMImwO/Hn/Ng==
X-Google-Smtp-Source: AA0mqf58wviWfQsfRaSAqOlo8p4navvCEjA52xb4TnyBjrYz+0CHYg862H1If5As/w3Bn21CvgHgIA==
X-Received: by 2002:a17:902:ce90:b0:186:6d34:b7b5 with SMTP id f16-20020a170902ce9000b001866d34b7b5mr9088185plg.37.1669156967537;
        Tue, 22 Nov 2022 14:42:47 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id u5-20020a170903124500b00186c3afb49esm12607967plh.209.2022.11.22.14.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 14:42:46 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxbyV-00HR09-OU; Wed, 23 Nov 2022 09:42:43 +1100
Date:   Wed, 23 Nov 2022 09:42:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Oliver Sang <oliver.sang@intel.com>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Zirong Lang <zlang@redhat.com>,
        linux-xfs@vger.kernel.org, ying.huang@intel.com,
        feng.tang@intel.com, zhengjun.xing@linux.intel.com,
        fengwei.yin@intel.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: account extra freespace btree splits for multiple
 allocations
Message-ID: <20221122224243.GS3600936@dread.disaster.area>
References: <20221109034802.40322-1-hsiangkao@linux.alibaba.com>
 <202211220854.48dad6fd-oliver.sang@intel.com>
 <Y3wm8hwPMXcFNjiO@B-P7TQMD6M-0146.local>
 <Y3yeVzzt5WIIHfhm@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3yeVzzt5WIIHfhm@xsang-OptiPlex-9020>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 22, 2022 at 06:03:03PM +0800, Oliver Sang wrote:
> hi Gao Xiang,
> 
> On Tue, Nov 22, 2022 at 09:33:38AM +0800, Gao Xiang wrote:
> > On Tue, Nov 22, 2022 at 09:09:34AM +0800, kernel test robot wrote:
> > > 
> > > please be noted we noticed Gao Xiang and Dave Chinner have already had lots of
> > > discussion around this patch, which seems there is maybe new version later.
> > > we just sent out this report FYI the possible performance impact of this patch.
> > > 
> > > 
> > > Greeting,
> > > 
> > > FYI, we noticed a -15.1% regression of fxmark.ssd_xfs_MWCM_72_directio.works/sec due to commit:
> > 
> > Thanks for your report!
> > 
> > At a glance, I have no idea why this commit can have performance
> > impacts.  Is the result stable?
> 
> in our tests, the result is quite stable.
>      45589           -15.1%      38687 ±  2%  fxmark.ssd_xfs_MWCM_72_directio.works/sec
> 
> and detail data is as below:
> for this commit:
>   "fxmark.ssd_xfs_MWCM_72_directio.works/sec": [
>     39192.224368,
>     39665.690567,
>     38980.680601,
>     37298.99538,
>     37483.256377,
>     39504.606569
>   ],
> 
> for parent:
>   "fxmark.ssd_xfs_MWCM_72_directio.works/sec": [
>     45381.458009,
>     45314.376204,
>     45724.688965,
>     45751.955937,
>     45614.323267,
>     45747.216475
>   ],

This MWCM workload uses a shared directory. Every worker thread (72
of them) iterates creating a new file, writes 4kB of data to it and
then closes it. There is no synchronisation between worker threads.

The worker threads will lockstep on the directory lock for file
creation, they will all attempt to allocate data in the same AG as
the file is created. Hence writeback will race with file creation
for AG locks, too.  Once the first AG is full, they will all attempt
to allocate in the next AG (file creation and writeback).

IOWs, this workload will race to fill AGs, will exercise the "AG
full so skip to next AG" allocator fallbacks, etc.

Changing where/how AGs are considered full will impact how the AG
selection is made. I'm betting that there's a mismatch between the
code that selects the initial AG for allocation (from
xfs_bmap_btalloc() via the nullfb case) and the code that selects
the actual AG for allocation (xfs_alloc_vextent() w/ NEAR_BNO
policy) as a result of this change. This then results in
xfs_alloc_vextent() trying to initially allocate from an AG that
xfs_alloc_fix_freelist() considers to be full, so it skips the
initial selected AG and starts searching for an AG it can allocate
into.

Combine that with AGF lock contention from 70+ tasks all trying to
allocate in the same location...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
