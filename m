Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CF0C7EE22
	for <linux-xfs@archiver.kernel.org>; Wed, 10 May 2023 07:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjEJH1L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 03:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjEJH1K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 03:27:10 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49A12698
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 00:27:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ab1ce53ca6so49725005ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 00:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683703629; x=1686295629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=McVVawIkViLX1vOxEsh93QtrtJxXFm8iChxbnlAyIg0=;
        b=rf6qZuWoZCAXj7YN2VFW7ZKhtSVhDw6ZB6VJKEtHvT5975sqFIEIKyITTsRci4feeq
         XZd24NpQcHl7PpFaCHCke/cKrjnx36bAv53V7Vb0laQX/L8n94iACMUJX5bOiMDOLr5E
         ZZIOEwAz+GA0ucV1CkzR7a2QfOrbOGWb3esKINbnNJ7ib/BsCWY8sQjKIVEmt3OTi7vk
         W6uKtrZvMqMtbDFQVeOnBjHSKCli/8bH95EmXudOV6XLT8sj/uZ9Aa+S5/5D8tIlHCCb
         7Y9UvTXMbM4Jw7JtM6UmgeD7mL/IrOQntrkH/QCOGNfzZtUB8Fvg0d0PXiZ3Tv3tY//t
         5q7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683703629; x=1686295629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McVVawIkViLX1vOxEsh93QtrtJxXFm8iChxbnlAyIg0=;
        b=VaEWZs89OvMBunGHXgSJ9FNH+HMOYZ0cohBD55eBJNTaHRRjmgbEFjPSigszURrHmc
         5sK34G9iGhNm+vIRj7/9vqpMl0l3eMhkyJq0vibNcY5+xVINZ+K4Lrms+SDcq+fzJNsL
         tsnV3T1AEPFSxcEAZNHefFfnF0G7OXZ4djGG3EglMRDtUY4tFVe31GRhETGnPN4eOAZ2
         /G3K3IErS5akF5KOIRZKxRtlV9U0gve4ZgtFhAqSW0V/glum+wsvkZdFk2CBUch4SRsj
         rUuSBZPTYhig8t1Eq9MJmcwtwkAL+AdS7x9HgoKCc0lGhiDJjHs8yWHOSblCnXnlZQF0
         2lEw==
X-Gm-Message-State: AC+VfDzINiYF8DclVjjzHXibEzR8pPcDAozT/0CQxzrB2fhtm7RdCgZ5
        PBRZGU7mnxpH3Dh8KoZsx7/tQXPZTASV8A3kvBY=
X-Google-Smtp-Source: ACHHUZ4quZOp/3ubZZL4+kNGcdQXi3yauLXS+ZWxa9ivApVV/SGlqA3SPSkO+UDe6nR8ljzh026+Fg==
X-Received: by 2002:a17:902:cece:b0:1a6:413c:4a3e with SMTP id d14-20020a170902cece00b001a6413c4a3emr21396424plg.5.1683703629255;
        Wed, 10 May 2023 00:27:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902c3cc00b0019f3cc463absm3014130plj.0.2023.05.10.00.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 00:27:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pweE6-00DX52-1b; Wed, 10 May 2023 17:27:06 +1000
Date:   Wed, 10 May 2023 17:27:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: performance regression between 6.1.x and 5.15.x
Message-ID: <20230510072706.GX3223426@dread.disaster.area>
References: <20230509203751.E6D2.409509F4@e16-tech.com>
 <20230509221411.GU3223426@dread.disaster.area>
 <20230510134648.ACDD.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510134648.ACDD.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 10, 2023 at 01:46:49PM +0800, Wang Yugui wrote:
> > Ok, that is further back in time than I expected. In terms of XFS,
> > there are only two commits between 5.16..5.17 that might impact
> > performance:
> > 
> > ebb7fb1557b1 ("xfs, iomap: limit individual ioend chain lengths in writeback")
> > 
> > and
> > 
> > 6795801366da ("xfs: Support large folios")
> > 
> > To test whether ebb7fb1557b1 is the cause, go to
> > fs/iomap/buffered-io.c and change:
> > 
> > -#define IOEND_BATCH_SIZE        4096
> > +#define IOEND_BATCH_SIZE        1048576
> > This will increase the IO submission chain lengths to at least 4GB
> > from the 16MB bound that was placed on 5.17 and newer kernels.
> > 
> > To test whether 6795801366da is the cause, go to fs/xfs/xfs_icache.c
> > and comment out both calls to mapping_set_large_folios(). This will
> > ensure the page cache only instantiates single page folios the same
> > as 5.16 would have.
> 
> 6.1.x with 'mapping_set_large_folios remove' and 'IOEND_BATCH_SIZE=1048576'
> 	fio WRITE: bw=6451MiB/s (6764MB/s)
> 
> still  performance regression when compare to linux 5.16.20
> 	fio WRITE: bw=7666MiB/s (8039MB/s),
> 
> but the performance regression is not too big, then difficult to bisect.
> We noticed samle level  performance regression  on btrfs too.
> so maby some problem of some code that is  used by both btrfs and xfs
> such as iomap and mm/folio.

Yup, that's quite possibly something like the multi-gen LRU changes,
but that's not the regression we need to find. :/

> 6.1.x  with 'mapping_set_large_folios remove' only'
> 	fio   WRITE: bw=2676MiB/s (2806MB/s)
> 
> 6.1.x with 'IOEND_BATCH_SIZE=1048576' only'
> 	fio WRITE: bw=5092MiB/s (5339MB/s),
> 	fio  WRITE: bw=6076MiB/s (6371MB/s)
> 
> maybe we need more fix or ' ebb7fb1557b1 ("xfs, iomap: limit
> individual ioend chain lengths in writeback")'.

OK, can you re-run the two 6.1.x kernels above (the slow and the
fast) and record the output of `iostat -dxm 1` whilst the
fio test is running? I want to see what the overall differences in
the IO load on the devices are between the two runs. This will tell
us how the IO sizes and queue depths change between the two kernels,
etc.

Right now I'm suspecting a contention interaction between write(),
do_writepages() and folio_end_writeback()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
