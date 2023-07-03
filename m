Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1E1EB64DC
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 22:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjGCWas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 18:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjGCWas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 18:30:48 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB75E62
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jul 2023 15:30:46 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-666edfc50deso3120628b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jul 2023 15:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688423446; x=1691015446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sf0CN9nZx6G7k1920Ouas+gdvtuZLL6M7XfMlyMX+H8=;
        b=IqT4+lp4vdjE1IefcfSEhKt4RSOWrNHT07jJY2ZAzGAg9h0FZ2DNpUxDyl+UVOm5Gl
         ht+Gl23l0MpxZ7fqvCdqSJ3eIQzdUL3Lw3Y5fCAYAAcstPXHrLisFrQ1GiOjX/L8t71U
         8gutNfNxjzoKdrOOpaxhLMoTJHQkOqbsob05Jsmo0AfCYXrQuCNXlR43hyb5VsLLp/8b
         bsdpAH5mPrncmdeA4w7Fwko2sC7WdurBRqq/9iWPxQSplcQCyiP7hqnwFMGa9g1tOi91
         KjdBNtmba5IkQzn1BsY2jk+p4N9qrz1dhEUh8vtx06APx3C/9G8cP3SagYPwyPYMIcct
         QYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688423446; x=1691015446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sf0CN9nZx6G7k1920Ouas+gdvtuZLL6M7XfMlyMX+H8=;
        b=mE9cTO7L3exny0XGyl3HdsagxMomgI+0twP35GosEwhcHCN1OrX0ltQtOD3IGWTUFe
         weWUattN7UJO02C8K5vBKRlcB4sKfpQmXZ+LPbxi/b1XeEkKmA3nd4TlkbldTLclnbUA
         IThXvHlKcFd+6iGSSPU8UL9UKYmQ/qWhgIlgF9QtRxhfun6viqqKbUnKJP7Ge0r7VpvD
         QCCBU20OCgWyRamn5Twp2tqwXfYuNfPo+koUJEQnbcx2QtGwswMVZVjutK4miSK05ziV
         MyxmfhT5Ak3t0C76AvgSSxWM+IxTXskanMw6JQnYVH72ip22k4RIW8BRqhvnMo69AaNN
         lk3Q==
X-Gm-Message-State: ABy/qLZ7xJGJf1qyKVochXcoLWj47KETmHjiYdidxYlkSrC2Bk6H123U
        h3gr1WvBXLdcfD5nN+V4m45UjiwxrGN4/Xtc8Ag=
X-Google-Smtp-Source: APBJJlHgk6AuXkRBpHrnVdFEgltlRKrugy+wP77sCzkgyRwKFjxiYLRCCW8eX/jdX/aQEVHWa7/i/Q==
X-Received: by 2002:a05:6a00:1742:b0:673:6cb4:7b0c with SMTP id j2-20020a056a00174200b006736cb47b0cmr16669139pfc.2.1688423446314;
        Mon, 03 Jul 2023 15:30:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-53-194.pa.vic.optusnet.com.au. [49.186.53.194])
        by smtp.gmail.com with ESMTPSA id e5-20020a62ee05000000b0064f76992905sm14250435pfi.202.2023.07.03.15.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 15:30:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qGS4A-001mPZ-1y;
        Tue, 04 Jul 2023 08:30:42 +1000
Date:   Tue, 4 Jul 2023 08:30:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217572] Initial blocked tasks causing deterioration over
 hours until (nearly) complete system lockup and data loss with PostgreSQL 13
Message-ID: <ZKNMEi3wCFI52eC7@dread.disaster.area>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
 <bug-217572-201763-NK8GwkLh1R@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217572-201763-NK8GwkLh1R@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 03, 2023 at 07:56:36PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217572
> 
> --- Comment #6 from Christian Theune (ct@flyingcircus.io) ---
> Daniel pointed me to this patch they're considering as a valid fix:
> https://lore.kernel.org/linux-fsdevel/20221129001632.GX3600936@dread.disaster.area/

No, that has nothing to do with the problem you are seeing on 6.1.31
kernels. That was a fix for a regression introduced in 6.3-rc1, and
hence does not exist in 6.1.y kernels.

The problem you are tripping over appears to be a livelock in the
page cache iterator infrastructure, not an issue with the filesystem
itself. This has been seen occasionally (maybe once every couple of
months of testing across the entire dev community) during testing
since large folios were enabled in the page cache, but nobody has
been able to reproduce it reliably enough to be able to isolate the
root cause and fix it yet.

If you can reproduce it reliably and quickly, then putting together
a recipe that we can use to trigger it would be a great help.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
