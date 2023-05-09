Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254AFC77B75
	for <linux-xfs@archiver.kernel.org>; Tue,  9 May 2023 06:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbjEIGzL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 May 2023 02:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbjEIGzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2023 02:55:00 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23D7AD33
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 23:54:37 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-52caed90d17so2906521a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 08 May 2023 23:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683615277; x=1686207277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8f7AFFRkXXKxkzsTH7JfwHgWYybfOeRANzMf6aB4GvY=;
        b=oS/3s1VQfCdROM7w06UUy1feQDAkekR15S+W+Lck1hb5ImBoiw9PTJrGHvLGdhTWxX
         YIO5QVFOI+XUkjxUqxVV3Jqo2HpFqpr0K5ZFfmXsTsaGMWK05+dMdJyyfOOjAoqu9k0M
         GO33YahzUNlU+1+5U7niPyeqwzkzx/fVZs7IEsHtO22XI+sIS4ZGG2JF9rogkh2/8Q64
         pJ2AA1fb4Lyq/cQl6LGsYw5vjhO7zc7/9CxueqbTm5gm8Zrb451c4H1g7aVDJKy5LfpF
         yP8zbgyeQlqJ/c47Q/1Woo4pxbo+jHEAqO2sNJGFYpVV8etIY3Of/UPdn8K3elJmevyL
         ZXVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683615277; x=1686207277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8f7AFFRkXXKxkzsTH7JfwHgWYybfOeRANzMf6aB4GvY=;
        b=HVG1PKkWsiH5xPoE8sfFwucyPgiClJP5KE9JfKjHVRV3ZffrZSjJbvAn0n/aJiIJm8
         ERcl97MbT36NCkPJRNhh5Dg73tKWY6g7s4gEwgtuCZLtlrjplVvf5e+EUwbQn6dyOwad
         QxWb2qs1dN5gktK182W9yR/uXQC0RO/DfPfv5fhlUX65G96aOOWrPbDoPcoiP8IAQp5Q
         M7g/eECxezt0NydWg7PlxocDv1EKthKe50VONcMvIJC+DFqQDxCvcsP+6iknDXIiyckG
         fq1Ip4r3FHeNjmRw1cHR9UHmYDguPMHO0jEUkAX5tKpUiUgdLfMU3LXxUA+UFeQA7nv4
         E67w==
X-Gm-Message-State: AC+VfDxv/HJxaHdmBNUHushyliUFhhQiUCSxClsOmCFyzYF1pnFfsk6U
        ELRUB1VJkIy3AfxkJzRw8XLMpg==
X-Google-Smtp-Source: ACHHUZ7LdOHTKLDLgTu5Mf4elrCAwM8dbTu05hZuRJn2cRPKqYLnO0y9skDG4YG19caNlHilV8oKBA==
X-Received: by 2002:a17:902:eb46:b0:1a6:5487:3f97 with SMTP id i6-20020a170902eb4600b001a654873f97mr12176228pli.64.1683615277073;
        Mon, 08 May 2023 23:54:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902868700b001aad4be4503sm719394plo.2.2023.05.08.23.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 23:54:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pwHF3-00D7ut-QH; Tue, 09 May 2023 16:54:33 +1000
Date:   Tue, 9 May 2023 16:54:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Dave Chinner <dchinner@redhat.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        ying.huang@intel.com, feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [linus:master] [xfs]  2edf06a50f:  fsmark.files_per_sec -5.7%
 regression
Message-ID: <20230509065433.GT3223426@dread.disaster.area>
References: <202305090905.aff4e0e6-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202305090905.aff4e0e6-oliver.sang@intel.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 09, 2023 at 10:13:19AM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a -5.7% regression of fsmark.files_per_sec on:
> 
> 
> commit: 2edf06a50f5bbe664283f3c55c480fc013221d70 ("xfs: factor xfs_alloc_vextent_this_ag() for  _iterate_ags()")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

This is just a refactoring patch and doesn't change any logic.
Hence I'm sceptical that it actually resulted in a performance
regression. Indeed, the profile indicates a significant change of
behaviour in the allocator and I can't see how the commit above
would cause anything like that.

Was this a result of a bisect? If so, what were the original kernel
versions where the regression was detected?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
