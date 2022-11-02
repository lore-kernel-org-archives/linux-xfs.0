Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F20C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 20:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiKBU5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiKBU5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 16:57:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AA462CE
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 13:57:11 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y203so3361127pfb.4
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 13:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ti8mIzj+TP0LyR01/Qhhq2q9nGsTXQtvwV8BztKYQHE=;
        b=xwZxSAv8L0Z6e+uG8Nq+EE22a9+HrwZ5O4Q6MpcqnBJGQXXD/N/cn2Jig+QZ2YufUN
         fHiCLq1RMzY+0QvZc0QlnKtiT4C/5mb6DSOGbO2ggtghM79q43zmjlDwLlHbOzWWOMAD
         Oq9QlTj4qqS8v4S4l07UzEAbVnAoSNjLPqRgvDPEcR/C6ruae94WsX5ohTNs7DnxiDJK
         7vhiXDZXFGsjNR1ACqbOR0/qYugcewZLRKCvu1xyI9R70LWRQjURUCDoHxMLfu36CDEU
         87alkUdOozEjL3Oos+ZsIP9B3e2+10+3tv2Yr2T+4aciI7fLHdsF0zeT8RfbXggz/kqv
         dE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ti8mIzj+TP0LyR01/Qhhq2q9nGsTXQtvwV8BztKYQHE=;
        b=7oKjHHqDUAQCyiUpbzwxV5EXf20xuA6zDpnorNPvZSpqzC60Fxzf4wRn0wwNy0dDgV
         3ySYuKMk8nW1/QJx+m5tOin2dceM4x2CzHTZMBbgIZc1BeEqlzsKYuGdasBUn/GYS0d/
         JrEYuX4nUJ+NVvQhpLf4kwK0SWSgK28MDo7HytHXZq+hmBsv8V1Wd/w13DX4Odl2He1N
         KDRabAfYcAc+OiVsqnYe8vbG3Ucq5cw8zsMRHwTMizsKgkIYhXH/zwu8AAI+0u1AGUHh
         FXGw6Xf6++IyTtF8rTZ1zmEuVTkXJ2lBbuKRBFjX9cvGTGvI4PGeWGsDJrrujK15SpJB
         RTKg==
X-Gm-Message-State: ACrzQf0S6j+vkWl4KRkIL5R+uAjpC+07Vgtxd1eN+Ue7+BLXaiHIlBhI
        ETxilSOKeScEehlXBFds/lgtRQ==
X-Google-Smtp-Source: AMsMyM6LRV5SGHM3NJ3dKDZwFWV30FZRt3aK3aSzEMLRr3i9Ab+umTG0YurOjwt51IS2JD+MLXdgEQ==
X-Received: by 2002:a63:6905:0:b0:43c:d4:eef4 with SMTP id e5-20020a636905000000b0043c00d4eef4mr22635108pgc.126.1667422630987;
        Wed, 02 Nov 2022 13:57:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id y29-20020aa79e1d000000b0056b6d31ac8asm9141151pfq.178.2022.11.02.13.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:57:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqKnL-009WFH-KY; Thu, 03 Nov 2022 07:57:07 +1100
Date:   Thu, 3 Nov 2022 07:57:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: buffered write failure should not truncate the
 page cache
Message-ID: <20221102205707.GY3600936@dread.disaster.area>
References: <20221101003412.3842572-1-david@fromorbit.com>
 <20221101003412.3842572-5-david@fromorbit.com>
 <Y2IbOl9hI7knhcDT@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2IbOl9hI7knhcDT@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 12:24:42AM -0700, Christoph Hellwig wrote:
> Just a little dumb question while I'm wrapping my head around the change
> here - why do we even punch the pagecache to start with?

We don't. It's just wrong because it assumes that the write() owns
the range of the page cache and it only contains no non-zero data
because the write allocated the delalloc range and therefore the
write was into a hole and therefore, by definition, it contains no
non-zero data.

Hence if the write is short, we punched out the page cache under the
assumption that it will only remove cached zeroes from the cache. If
those zeroes are dirty for some reason (zeroing prior to the iomap
hole/unwritten detection?) we don't need to write them and have to
be removed from the page caceh before we punch out the underlying
delalloc extent.

Unfortunately, this assumption has always been compeltely invalid
because both writeback and mmap page faults access to the page cache
can race with write()...

> As long as the
> regions that we failed to write to aren't marked uptdate (at the page
> or block level for sub-block writes), who cares if they remain in the
> page cache for now?

Exactly - that's the premise this patchset is based on - we only
need to care about dirty pages across the range of the delalloc
extent, and nothing else matters as it will be properly instantiated
with new delalloc backing if it gets dirtied in future...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
