Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D510AC7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 22:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjDUW1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 18:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUW1a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 18:27:30 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375211B4
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:27:29 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b51fd2972so2256295b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682116049; x=1684708049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=15N/58iELcujBm04ZwatMc+WSo6rUItpoQrYF349VTc=;
        b=xtKHfqLKodRI/nwlmjKUgMkWgTbWMzWKXi3Y89W+R+Rnf1IOVKNCvMsL3JWbKheBFv
         A78sAOXdgd+JR8zPvfG0qKAMr1dqu0XGz5qrzN3K3Iz9HxE0mtiacmAu43FhKddW8M8Y
         elzPXm0Oh/aDI2JJHj/wd1kgQ10e20h1UTXsrFHg/+jK80yPUjFQHeKQ0WafA6iWNBFR
         e1lyYCCmy9d2+LKbfjTY0+JJDwF4WS/yVU5sty29usdLx/HHl3HJlha37pLQXXidUkh6
         L4FiqDAeOrbF57wzmJXPxrzk7/aOgnB7HO5K9vuvtucGT08LDOANv+2Kyce3MxrWuv63
         c/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682116049; x=1684708049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15N/58iELcujBm04ZwatMc+WSo6rUItpoQrYF349VTc=;
        b=SjpiB8CVepwvFMA9RciCsoxWRWGidx+6jXwZ4p3U5eFSvhWL9XZ8I+tgY4PSy9BaR+
         ZCUYVSKt5YyqZ6dISEH8SSD4ixvDrr3HDU2+PqIWY3MbeDc01F9J9CPzR6VcUiDPUqxZ
         HYVZkJnQHyAUD0OzaYUEFHtp8B6rUylDHY2KOomlHLzmLSStQoaUYl/bxylwwuCpteMl
         T0wAggly0DwS+UEV05L8meD/meaKaappN1uKhJjbRKMyaE3V2GnvxJDS38QfkAeRA62B
         ZrdxdsELrjP+nMH1POWTMGJhUff7HGOfF8t1vmdeiIHczMkE8QAzNBKrueEXz/o9gzyD
         IYQQ==
X-Gm-Message-State: AAQBX9dunf/RHYAPDy7U5PWZSuhwuofFYywMJYaF8/l0yRhaHXg2f6bS
        eyooiZeENIzrHLi+1exmPkiGsoyz+XdimV7bS/M=
X-Google-Smtp-Source: AKy350a2yVf2uarQAu7b1Z5HKak8Z8gnzzUWK8LNvjn64EhOqWuFF4eGe1uhhc+8iCz6r//+QN9irw==
X-Received: by 2002:a05:6a00:14d2:b0:63b:7af1:47c9 with SMTP id w18-20020a056a0014d200b0063b7af147c9mr8902941pfu.13.1682116048771;
        Fri, 21 Apr 2023 15:27:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id y19-20020a056a00181300b005ac419804d5sm3546601pfa.98.2023.04.21.15.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 15:27:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppzDx-006DlP-BX; Sat, 22 Apr 2023 08:27:25 +1000
Date:   Sat, 22 Apr 2023 08:27:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [BUG] XFS (delalloc) writeback livelock writing to -ENOSPC on
 dm-thin
Message-ID: <20230421222725.GG3223426@dread.disaster.area>
References: <ZEJtT7vJ9RA4pno4@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEJtT7vJ9RA4pno4@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 07:02:39AM -0400, Brian Foster wrote:
> Hi all,
> 
> The test case is a simple sequential write to XFS backed by a thin
> volume. The test vm is running latest 6.3.0-rc7, has 8xcpu and 8GB RAM,
> and the thin volume is backed by sufficient space in the thin pool.
> I.e.:
> 
> lvcreate --type thin-pool -n tpool -L30G test
> lvcreate -V 20G -n tvol test/tpool
> mkfs.xfs /dev/test/tvol
> mount /dev/test/tvol /mnt
> dd if=/dev/zero of=/mnt/file bs=1M
> 
> The dd command writes until ~1GB or so free space is left in the fs and
> then seems to hit a livelock. From a quick look at tracepoints, XFS
> seems to be spinning in the xfs_convert_blocks() writeback path. df
> shows space consumption no longer changing, the flush worker is spinning
> at 100% and dd is blocked in balance_dirty_pages(). If I kill dd, the
> writeback worker continues spinning and an fsync of the file blocks
> indefinitely.
> 
> If I reset the vm, remount and run the following:
> 
> dd if=/dev/zero of=/mnt/file bs=1M conv=notrunc oflag=append
> 
> ... it then runs to -ENOSPC, as expected.
> 
> I haven't seen this occur when running on a non-thin lvm volume, not
> sure why.

thinp volumes trigger stripe alignment in mkfs, which then use
different allocation strategies at writeback time.

Patch to fix it already sent to the list.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
