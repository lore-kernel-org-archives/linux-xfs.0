Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00054C38A02
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 00:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJaAPw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 20:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaAPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 20:15:51 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7E3958A
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 17:15:50 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k15so1272639pfg.2
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 17:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rj4yY6GYW9KIrbFBLmSgzC0IvmD+5MMlxMCcbEeeB/c=;
        b=HWUp5P5TiyRKeNwFDAhWzmQFtmylYTzX8cTeCqgczBDyXAqv+P8GzzbhFTvleaMkRU
         3ayqDHHOiyJZN5y6IhwiFD611Bso27ZADZuxKcOj3A+Ns9hREpwuiBbwPpdfb3lKOUlG
         D50OrTAjaYfGXTqNas5VGek6yOdMDC96wP0FS5DHSEj4IQ96BRoy92Qe0t+sfXB7njkU
         Roz2EkXuyTYTR5wXAl4qpil+K/cmHunhTZ1p2qx7glpjYSDdnTccnup/VftC8yvo/JSN
         avB47PJVXAupV6s6uCAgTOYTEMfBh/pIm9QQvVEC2FlqQtSIHDeOQcSj5KBUcINoQxsp
         qnnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rj4yY6GYW9KIrbFBLmSgzC0IvmD+5MMlxMCcbEeeB/c=;
        b=EddH2WTaQlre+0+tWFUwNdCdyBMNjb3Anzew8Ws09hREjj0pHM6oH5TqQ3Vod6pUo6
         UnanbDCEelD2804IzIyyM8ZlHUvORF/w0v/ToMvS+spLLOgCrp+WGXOff4+ITgnqtunU
         7VeGHmmElNgY4AbWCf+9DI974kunGHHRh5rBSYjcLQhgi+2ThpQbXHBxLmG7y8+jNK1N
         +J5wokCiCq8SyF5enxgd8FzZj9aRHvR569E3n0D4r8ugGkRY0eNyPwMS7H9zHGUQcBId
         TYXps0pDlLoN1lMC+P0ezFY57n/R2ktEmFl19bhcVxvdvBDpyLuJbdoVZu1/Wu/k00uv
         e4lQ==
X-Gm-Message-State: ACrzQf3bIwAh3Pb397aXcpWp2GekW1lCS7m0QBdBmBO61/RSAVet9Oj2
        jHMxXNqAq0APvXtdORJErhQmOcJZnRH9Wg==
X-Google-Smtp-Source: AMsMyM5PI92hbf1obpVRO/pvVORfFp/ocMaU76p9joKz54OqCUz2Rpv1vHxpVcKQ/qJE0sIfGfpt2A==
X-Received: by 2002:a63:251:0:b0:46e:9da8:1f93 with SMTP id 78-20020a630251000000b0046e9da81f93mr10190654pgc.490.1667175349999;
        Sun, 30 Oct 2022 17:15:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id c130-20020a624e88000000b0056bf5e54961sm3173136pfb.161.2022.10.30.17.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 17:15:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1opISv-008O18-SZ; Mon, 31 Oct 2022 11:15:45 +1100
Date:   Mon, 31 Oct 2022 11:15:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: create a predicate to verify per-AG extents
Message-ID: <20221031001545.GJ3600936@dread.disaster.area>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
 <166717329319.417886.15868613353170498219.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166717329319.417886.15868613353170498219.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 30, 2022 at 04:41:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a predicate function to verify that a given agbno/blockcount pair
> fit entirely within a single allocation group and don't suffer
> mathematical overflows.  Refactor the existng open-coded logic; we're
> going to add more calls to this function in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.h       |   15 +++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.c    |    6 +-----
>  fs/xfs/libxfs/xfs_refcount.c |    6 +-----
>  fs/xfs/libxfs/xfs_rmap.c     |    9 ++-------
>  fs/xfs/scrub/alloc.c         |    4 +---
>  fs/xfs/scrub/ialloc.c        |    5 ++---
>  fs/xfs/scrub/refcount.c      |    5 ++---
>  7 files changed, 24 insertions(+), 26 deletions(-)

Nice!

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
