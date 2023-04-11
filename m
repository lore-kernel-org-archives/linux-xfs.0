Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831F7C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDKXyU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDKXyT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:54:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699AC272B
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:54:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-634b28df952so857069b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681257258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GW977Vd33k6Ea4Cd/W+YeRjND69mu2zabyDqjElxm4M=;
        b=tKfQkfgi+oGWevmfYAiu/YX4AmPNjerWUEIrXYwDGEDf+otIgh8CVqwQnzxmNCs+Gk
         t6m4SGuS9ur7N9J7z/ZhI1LJl/ZxeCcnBU1etJ4MvUOmJLrcGYqnUVjjyK5FCjifX5kq
         XghtWAVtvCnWge2oECRTqi/58fOySvUBznPSXmZRatCx1hC8TelByWoHFGcsBF1B9UZX
         iYzxXGTac2dfHfpWxbmbA9AJfs/scLgGSgYlPrN1ih6mqoPVlYt6TOJd5a9pKFzaf58E
         kRTv0R0U4An/OpBLC5ehWp4S6UzptmGfCPJZXm8p/6UYlZ+8EGvjKX5qQm/FwcW7pu3T
         v6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681257258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GW977Vd33k6Ea4Cd/W+YeRjND69mu2zabyDqjElxm4M=;
        b=e3XYcEbpgFHWJj6QGxj4tks65dKjaG+hTS+Hf6IwDSf5RVHqSK8TA/SwHaigzoQ31W
         9N+FVDIf90DEjnzUFCUn7VDJz1HszBHIoMx/hj7EzuzTf4nI4LZmSkdeqYiwq46JPich
         ggEAc4FXz3RnF4dQZhymphMfN+6tDA+OkZIFkr45nL9WJgKcbIBN9fq1sYzIamCEP3IR
         h6Dwz3K/CZ5Q+Uh9ksiaWsMbNIM7BgaWpFOeAZmiOa4paCSlPJt2QcPGijYPCzGiopgB
         UOEMxyqKXAeWs+3M2qc/RknsNWRccCGvq88rEbBydFJi+pGwsCrsJqEEmE0Q+f/jDfJZ
         E66w==
X-Gm-Message-State: AAQBX9eFw5X+Lps+kvdEkyOVtVhZxkoCwge4p92U/wvNd5IgqCJhsF2u
        cLAPbs5TTLziq+kuEiG/jIVEBw==
X-Google-Smtp-Source: AKy350aP4MIzAjSV6/QC691C70I0os9zettCfE/JpfADBmzuURKIxKUA1CqnpF2HtXVcJc3DxO0hZQ==
X-Received: by 2002:a62:6403:0:b0:63a:c64b:20aa with SMTP id y3-20020a626403000000b0063ac64b20aamr6304970pfb.13.1681257257895;
        Tue, 11 Apr 2023 16:54:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id h12-20020a62b40c000000b00639eb4480f3sm3533954pfn.76.2023.04.11.16.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:54:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmNoU-002Heo-UE; Wed, 12 Apr 2023 09:54:14 +1000
Date:   Wed, 12 Apr 2023 09:54:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <20230411235414.GD3223426@dread.disaster.area>
References: <20230411184934.GK360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411184934.GK360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 11:49:34AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While fuzzing the data fork extent count on a btree-format directory
> with xfs/375, I observed the following (excerpted) splat:
> 
> XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> Call Trace:
>  <TASK>
>  xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  __x64_sys_ioctl+0x82/0xa0
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> The cause of this is a race condition in xfs_ilock_data_map_shared,
> which performs an unlocked access to the data fork to guess which lock
> mode it needs:
> 
> Thread 0                          Thread 1
> 
> xfs_need_iread_extents
> <observe no iext tree>
> xfs_ilock(..., ILOCK_EXCL)
> xfs_iread_extents
> <observe no iext tree>
> <check ILOCK_EXCL>
> <load bmbt extents into iext>
> <notice iext size doesn't
>  match nextents>
>                                   xfs_need_iread_extents
>                                   <observe iext tree>
>                                   xfs_ilock(..., ILOCK_SHARED)
> <tear down iext tree>
> xfs_iunlock(..., ILOCK_EXCL)
>                                   xfs_iread_extents
>                                   <observe no iext tree>
>                                   <check ILOCK_EXCL>
>                                   *BOOM*
> 
> Fix this race by adding a flag to the xfs_ifork structure to indicate
> that we have not yet read in the extent records and changing the
> predicate to look at the flag state, not if_height.  The memory barrier
> ensures that the flag will not be set until the very end of the
> function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: use smp_store_release per reviewer comments

Looks fine to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
