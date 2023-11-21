Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681EAC61D85
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 21:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbjKUVWD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Nov 2023 16:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbjKUVVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2023 16:21:49 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7F31BE1
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2023 13:21:20 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-27ff7fe7fbcso4689004a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2023 13:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1700601680; x=1701206480; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxuOhR39mBFuQZuchwvtqgVaUHlL9G67tC5DvCi1YTE=;
        b=eu6POAvVZYgl1yJAIyrZPMpTD+adKMZwLcwzIaTrB6uu+6fwoaoC9Eb9c5BMyKMSRB
         5kwapiADzVMHGasNO0LRPuJbBIbugKqSyOmAugx8z28nMmQTplKK6JJjNGV5HWz5lhC2
         vW3yx+SV2NNOYFBkZL/W2k3pfyiYxR7eMDGB7vHOYdKB2mjWNa70yWWSfn/R+gXuqjfw
         uvdMSay/5mTp3R0vRuyTeccORQmQfq2QyLqO1xxszgaWJp7aEY42H1xZ3XgKtvFNh3Vv
         6W21FlBV9MQugWNrNTCr0zylc2Xzu3MkFEJm1etfKcf5chKqWDQ5M78Fah9hgHoYUVya
         Fk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700601680; x=1701206480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxuOhR39mBFuQZuchwvtqgVaUHlL9G67tC5DvCi1YTE=;
        b=xMxQHaG6qJTKHZz4dCcV4y2D9X9g0I+oqlJxffwEKXeKVM1GsbYaUDpAZgrLrMxBRz
         WqujecSsjqpebmWR1dMfERxU0gnliT/P5IHiSr5C+Rp07bB+yzWPKeLJkMV5Si+AA3pq
         3s7k/hRY0jXWPSXnONbbwn4s8VJVcgjgFBorhrveEK05E7NcYeQct9nwc0d9HFqlxl2m
         Wo/Z+yc4fiQ3143qnJYJPP6skBgNPwv8oQSmrVIsJZ6iYuM75RPW7bcdWpWVHIIwPRQg
         nXkW6RzqjaBauo/pe9Xq3TGvKfKOP64Iho96f+r2oApkY6be3aNNCl317OpO5iz1xqnT
         69cQ==
X-Gm-Message-State: AOJu0YytsilComGIpvnNgIAly3WF6AKxgQcsvWhM9Vdzmi6sQS+mPFiF
        XJdz1PE/9jGd+fB7IIgqzAb9Qw==
X-Google-Smtp-Source: AGHT+IF5e+02NLRtayb+Xotj5d9pG4Vot1bxMiBkLzXL/fe5s6ebrXZ8A2LPI2Z+c6AcY+/Af/xpFg==
X-Received: by 2002:a17:90b:38c9:b0:27d:3f0c:f087 with SMTP id nn9-20020a17090b38c900b0027d3f0cf087mr544672pjb.25.1700601680042;
        Tue, 21 Nov 2023 13:21:20 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a000c00b0028105e3c7d8sm10652680pja.0.2023.11.21.13.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 13:21:19 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r5YBI-00Fj8C-24;
        Wed, 22 Nov 2023 08:21:16 +1100
Date:   Wed, 22 Nov 2023 08:21:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: clean up dqblk extraction
Message-ID: <ZV0fTCuv2ZNxtmvK@dread.disaster.area>
References: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
 <170050509891.475996.3583155500177528277.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170050509891.475996.3583155500177528277.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 20, 2023 at 10:31:38AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since the introduction of xfs_dqblk in V5, xfs really ought to find the
> dqblk pointer from the dquot buffer, then compute the xfs_disk_dquot
> pointer from the dqblk pointer.  Fix the open-coded xfs_buf_offset calls
> and do the type checking in the correct order.
> 
> Note that this has made no practical difference since the start of the
> xfs_disk_dquot is coincident with the start of the xfs_dqblk.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
