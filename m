Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2277C77B7A
	for <linux-xfs@archiver.kernel.org>; Sun, 21 May 2023 02:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjEUCtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 May 2023 22:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjEUCtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 May 2023 22:49:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F52109
        for <linux-xfs@vger.kernel.org>; Sat, 20 May 2023 19:49:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-2554696544cso342433a91.2
        for <linux-xfs@vger.kernel.org>; Sat, 20 May 2023 19:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684637362; x=1687229362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4CmIoMNb5RGTtBWysZDeW/jRh4muNV9pKU+hLoKMv8=;
        b=nsamtAPRT51Xf1sCC78d0FFqiBP3AxVH+T1ODoSta+Nx+rEGKR+HZi6qBgosIuwp8W
         CCqs0qLKciMjgv1lOZa3lDwTOsQ0K7zuAWIvCyPQvhJVV1ZA1Z2WOGT39wEznX5bHX6X
         KEIeGJapJBB0WQHtsUY62hOdQd3VQN7Vu0fpJdYrJi7AOdn9zxq5yvNod9YBar9X2mu2
         tkMYFCQJ0DFPHFmB0AzlIlczDmYIYgEhWQD2v5kB4O6/6OVLSMaMWlcjNNrcuqNaC3kM
         bjwFEHa2Da40ooAERT0qUFvColxX1CE4oDj6vx9uTvYtZK0SOeUjNYosI+26SHuIYgt1
         bg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684637362; x=1687229362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4CmIoMNb5RGTtBWysZDeW/jRh4muNV9pKU+hLoKMv8=;
        b=Ru6XLzHck2L9P9DtZsSzdILibQvhVEsfAYkI6kZSzeQZ5ACbMLa7IOvZ+W2+KVaf+v
         NuUyFDK9IPTiJzxB4WduIMSO+qqMRQG4jT6ztufb+r9pXP5CFSKvlFswXjFin2qDj+fb
         UrSESfPyGBfWx1OSIJCs8aPa1I2ligYQ/avl6Q2S1fXntTukLcnldoRr13v2SGL37+4N
         BzO3DEoRr+YK8ifcgBNzL67rUWmM/MYrXeZQuJnxa8T1XdxQi7vyKu3m6GnwD78PpJ2w
         lU7IuBIhWi/udGT4TE3oAUL7WapqtGJZ56ZgKLmep+e2DL2V56lOZNAUYNnPg5zDwr7D
         7X+A==
X-Gm-Message-State: AC+VfDw2DgAUYCtJGif4FMsVIUTAzys2HXEWEC46Tm1lD7FfVZbTgnvt
        PSe9ygk9Yttrs7X9UQGCVQsnqw==
X-Google-Smtp-Source: ACHHUZ6VDqnI1Ix5LSZFm33BRLHdcoFWGY8mKDg+gOxy/r8h/7uG1lDWMzTg7JSlMg7SBkRzF4+5EA==
X-Received: by 2002:a17:902:f549:b0:1a6:ff51:270 with SMTP id h9-20020a170902f54900b001a6ff510270mr9097319plf.29.1684637362069;
        Sat, 20 May 2023 19:49:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id y19-20020a170902ed5300b001a9873495f2sm2152335plb.233.2023.05.20.19.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 May 2023 19:49:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q0Z8I-001ygJ-2A;
        Sun, 21 May 2023 12:49:18 +1000
Date:   Sun, 21 May 2023 12:49:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 0/3] Create large folios in iomap buffered write path
Message-ID: <ZGmGrtnYF8Z1InD4@dread.disaster.area>
References: <20230520163603.1794256-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520163603.1794256-1-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 20, 2023 at 05:36:00PM +0100, Matthew Wilcox (Oracle) wrote:
> Wang Yugui has a workload which would be improved by using large folios.

I think that's a bit of a misrepresentation of the situation. The
workload in question has regressed from ~8GB/s to 2.5GB/s due to
page cache structure contention caused by XFS limiting writeback bio
chain length to bound worst case IO completion latency in 5.15. This
causes several tasks attempting concurrent exclusive locking of the
mapping tree: write(), writeback IO submission, writeback IO
completion and multiple memory reclaim tasks (both direct and
background). Limiting worse case latency means that IO completion is
accessing the mapping tree much more frequently (every 16MB, instead
of 16-32GB), and that has driven this workload into lock contention
breakdown.

This was shown in profiles indicating the regression was caused
by page cache contention causing excessive CPU usage in the
writeback flusher thread limiting IO submission rates. This is not
something we can fix in XFS - it's a exclusive lock access
issue in the page cache...

Mitigating the performance regression by enabling large folios for
XFS doesn't actually fix any of the locking problems, it just
reduces lock traffic in the IO path by a couple of orders of
magnitude. The problem will come back as bandwidth increases again.
Also, the same problem will affect other filesystems that aren't
capable of using large folios.

Hence I think we really need to document this problem with the
mitigations being proposed so that, in future, we know how to
recognise when we hit these page cache limitations again. i.e.
I think it would also be a good idea to include some of the
analysis that pointed to the page cache contention problem here
(either in the cover letter so it can be used as a merge tag
message, or in a commit), rather than present it as "here's a
performance improvement" without any context of what problem it's
actually mitigating....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
