Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC601C38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 00:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJZAld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiJZAlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 20:41:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA08C3563
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 17:41:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso663435pjc.2
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 17:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jeVo+tFN+g22cHPxC9toUWQp6ZQChsigYm+MiHzXZvw=;
        b=PjfMDuRPmAMPGnvqu/Ys7ME2qcUXh0QamnOATxfRTSJHXiNCW12W1KPeEODQYQ4jL0
         cPUPkkxo3vHbBAOJzDGazQBcUKKCuk56gtKNuMiQw0F2SHmNcAZ2m7VQkXKdLoJ7nWnx
         7p38MO/M06651fSE/xnfoX3B/xwv67I52q5LO09J3V9mQBfcQgUr8r8ofJi2qBd+jHbl
         VFMnUq2zeJoXRa+r162oxQCdzug8uW+DRaQvazXDjC2KNIdR4P2rOTL0352G3wxh66ik
         a0voDst5nub7uc83I7F97bzoXXcm1ZWAML6/+HwlXBN+28hAtbjjoNFU1RAx5+GiHiFg
         OCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jeVo+tFN+g22cHPxC9toUWQp6ZQChsigYm+MiHzXZvw=;
        b=XdtzUsB8yFTUHA0OtqCXaaVemqXI2ANeyXOvgvosLEoV0R+aTwiRjhqMUe2kYZqNQD
         rRbqJ6mWrJz2E6+r8DcS522Gz0CplMHtHXn2RT3nzHybc9v7tL36bJxLJga4OZDVcKGQ
         0jKjKeGtlmT1UCBA/eQm9Yd3y6/0Lx+ki0AgnPct3oQZPf8C0ntZgPiZh6As10E8kdV1
         5xAniQhaJxBjOdUoklrWc67T5Wqf7NnnBWX7oohoWRmWn/PjgNWHZbut0C3dX3CD/ZGL
         F4wlNBZ0d/toA51X0HAqBscYP81oy5cXq2He9KAXxLhzVxc7Ss2PdTau7u4KY5ZIZ5aR
         vE9g==
X-Gm-Message-State: ACrzQf0kBV1TIMHqJKU2b0TYafUVsH1vxwLFKjgsp+MJXR6+IVJMzpiC
        z1Nu6Df4/zADZk3GQ6WbqmWhUZErBfIyzQ==
X-Google-Smtp-Source: AMsMyM6UYIlILcYRb/UZh/enDmNiczQqCPPLyevDfjojK3zzTQDDRZt6B5CfSlAVQ5pvFBMm2l9vvQ==
X-Received: by 2002:a17:902:e845:b0:186:c8b9:24e1 with SMTP id t5-20020a170902e84500b00186c8b924e1mr4234073plg.125.1666744886978;
        Tue, 25 Oct 2022 17:41:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id bf11-20020a170902b90b00b00186881688f2sm1729912plb.220.2022.10.25.17.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 17:41:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onUTz-006QGa-Rk; Wed, 26 Oct 2022 11:41:23 +1100
Date:   Wed, 26 Oct 2022 11:41:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: rename XFS_REFC_COW_START to _COWFLAG
Message-ID: <20221026004123.GL3600936@dread.disaster.area>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
 <166664721160.2690245.14106535587593195050.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664721160.2690245.14106535587593195050.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:33:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We've been (ab)using XFS_REFC_COW_START as both an integer quantity and
> a bit flag, even though it's *only* a bit flag.  Rename the variable to
> reflect its nature and update the cast target since we're not supposed
> to be comparing it to xfs_agblock_t now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_format.h         |    2 +-
>  fs/xfs/libxfs/xfs_refcount.c       |   18 +++++++++---------
>  fs/xfs/libxfs/xfs_refcount_btree.c |    4 ++--
>  3 files changed, 12 insertions(+), 12 deletions(-)

Seems fine, but I think this will change quite a bit if helpers get
used for most of these XFS_REFC_COW_START checks...

-- 
Dave Chinner
david@fromorbit.com
