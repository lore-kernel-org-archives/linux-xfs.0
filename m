Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936BAC77B60
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Apr 2023 22:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDWWOY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Apr 2023 18:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWWOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Apr 2023 18:14:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459A11AC
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2023 15:14:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b73203e0aso23799757b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2023 15:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682288062; x=1684880062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qqO2U4rhUvtbNofqq6cg020uvvQ9p3C0SwKAoDUqHi0=;
        b=GdO3+FbQ68A20FiUDsoJjnvME08Gd9oPFI5vEVXkZQSDRn3wIk8lafbBU/pvapduhq
         WwC5fLOF5Icy+Wu9OgaHI5sIYFfDNHOKZloAjZym2E1AhJLaNurYs7Sf+ALLY/Xb3SOK
         tFZEgPziOpASKAuZ4bNO7yC+ckv5cfJI7j39KmYTkQLkGpahobYr+BsNaRn/eSHNF2n9
         5cPFoCjcHjwn3G0jyZsGeizeBnHtcuTKdseGxR5toZV8sVHNnNKGR3jYh1+b8zKXvGAI
         rjqZeOhaAqWZmojs3CXcuZFBm8qVh3TCr4W6X5+6mNY6gASJ3tR9Q5EoFxpxjcQe9lOV
         sGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682288062; x=1684880062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqO2U4rhUvtbNofqq6cg020uvvQ9p3C0SwKAoDUqHi0=;
        b=dxazfevRXmED/DtczFNlgPKiIhLYzS8h+7Igqvh0D4m+lRKsvszEZAV0YkuQoa2dNN
         GCqVF/DJQrAdbZq0zDMV5KFUMSjNmu4FFfPLgCehRuUtzjKwwJMIK4pikrxfVP4a7d/T
         wr+SZKze5sUuS830AdGSLB647Zkt4N2kW72Ri465a0Pzxgynynl9MUdexkf49qySD9+7
         +0bETIA0hPCBFpo+D1yoLs27LKXPrnySR9EeKonNA9E60aXawtnanrAtnY68Nf/Lg7cG
         sSvhRO9Kux7TplffQPUfEhcfMhYIoZee3q2fZY3xcPgBf0UXOq55LNghDUfli1KQxTbX
         IGQA==
X-Gm-Message-State: AAQBX9e7yplKA6BvilnZFaLQmMU5C1zisVUqC9iw2n8t+dW3av1Oujnv
        TvtOEYJ425LI/1b2vVvgoadKYA==
X-Google-Smtp-Source: AKy350azunekhuxUD+Ouw4vTbqQZBGUd+hVxZ1eXJ1aIebUZZnMe3InT1RJ93OX/WCwnmhl/YFwoWQ==
X-Received: by 2002:a17:90b:1b4e:b0:247:4fe5:f09c with SMTP id nv14-20020a17090b1b4e00b002474fe5f09cmr13514093pjb.15.1682288061684;
        Sun, 23 Apr 2023 15:14:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adb0200b00246f9725ffcsm5274648pjv.33.2023.04.23.15.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 15:14:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pqhyL-0073x2-SH; Mon, 24 Apr 2023 08:14:17 +1000
Date:   Mon, 24 Apr 2023 08:14:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <20230423221417.GI3223426@dread.disaster.area>
References: <20230421222440.2722482-1-david@fromorbit.com>
 <20230422035300.GL360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422035300.GL360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 08:53:00PM -0700, Darrick J. Wong wrote:
> On Sat, Apr 22, 2023 at 08:24:40AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > On a filesystem with a non-zero stripe unit and a large sequential
> > write, delayed allocation will set a minimum allocation length of
> > the stripe unit. If allocation fails because there are no extents
> > long enough for an aligned minlen allocation, it is supposed to
> > fall back to unaligned allocation which allows single block extents
> > to be allocated.
> > 
> > When the allocator code was rewritting in the 6.3 cycle, this
> > fallback was broken - the old code used args->fsbno as the both the
> > allocation target and the allocation result, the new code passes the
> > target as a separate parameter. The conversion didn't handle the
> > aligned->unaligned fallback path correctly - it reset args->fsbno to
> > the target fsbno on failure which broke allocation failure detection
> > in the high level code and so it never fell back to unaligned
> > allocations.
> > 
> > This resulted in a loop in writeback trying to allocate an aligned
> > block, getting a false positive success, trying to insert the result
> > in the BMBT. This did nothing because the extent already was in the
> > BMBT (merge results in an unchanged extent) and so it returned the
> > prior extent to the conversion code as the current iomap.
> > 
> > Because the iomap returned didn't cover the offset we tried to map,
> > xfs_convert_blocks() then retries the allocation, which fails in the
> > same way and now we have a livelock.
> > 
> > Reported-by: Brian Foster <bfoster@redhat.com>
> > Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Will give this one a spin through the test system over the weekend.
> 
> In the meantime, can one of you come up with a reproducer?  From the
> description, it doesn't sound like that should be too hard -- mount with
> no stripe unit set, fragment the free space, mount with a stripe unit
> set, then run the fs out of space?

No need.

# ./run_check --run-opts "-s xfs_align -g enospc"
Running: MOUNT_OPTIONS= ./check -R xunit -b -s xfs_align -g enospc
SECTION       -- xfs_align
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test2 6.3.0-rc6-dgc+ #1779 SMP PREEMPT_DYNAMIC Fri Apr 14 11:24:18 AEST 2023
MKFS_OPTIONS  -- -f -m rmapbt=1 -dsu=128k,sw=2 /dev/vdb
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vdb /mnt/scratch

generic/015 1s ... 

Hangs immediately on the first ENOSPC test.

IOWs, up to this point, no ENOSPC testing had been done on stripe
aligned filesystems. A hole in the (ever expanding) test matrix we
need to run...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
