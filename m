Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB540C00A5A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Jan 2023 23:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjAQXUg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 18:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjAQXUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 18:20:05 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECB28CE5E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 13:08:01 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d8so2520535pjc.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 13:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2WJx7cXFqv0MpwFUa3OcUjODddHwSD0U15t+2fawe7A=;
        b=ifu5pPc5Cv/vpJKcVlY6SBv/TeT+FXZrmg1Shwx1A8NAwSF8j4aDtqPWihAU8osc9/
         gh09unlZnUAA1uw8exuRduVyKKulM0Fpv9z3Khu/vRCskvb8HuShtEAAzDPrXNEeXPQl
         MQ0pltYAPCpJWepYmcKvy4JBwPK6uUFl4bwBVVW7z7YE0c8NcHqy6ZKDEhAIlxLO+taq
         d+LaqCWqpieWhWDxWCtZNNs1//BdcmBiBlBpyhr80HH7VXkIiEpz15wKsLJkFa7Sdept
         8T2Ui/GI7sR9JoCSu3fLUCcPy69W/H1sM95erXqf+CwS9x2VLyW3W20naOmvvRdBMSPK
         3UOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2WJx7cXFqv0MpwFUa3OcUjODddHwSD0U15t+2fawe7A=;
        b=02dc/a2Yf8cfjdYhSfvqpk9kfaUnvPC6ZkR6msTUQigK/0eWY0P8a6JsC2QR0SkJA/
         /mUftN+kSfb3mRlHycjKCVvN0jpY5tyByMqrhN2uJ5bIYFQRxP2yEcndAv2GvL+5ORui
         eWEX4SVFzbGNEdl5aV1zerMTmxgIHu+DDSb1cHDhdOHF5Z5MhiXKyA83/cw+eVaNSjpD
         kxgslgH4gVcQ7LiLKQgLb1pkO2AQFDJ/FMpZS0bgwjznZ/g2w+Q/vnNDoVhZ2f/rbPnM
         EbQbYZA5H78NqzHWY5D2WHK1ItgLMAY4fBx1dHKa/aaDAuxeHRFUm2QBUWaFG3ErwvtY
         E9Sw==
X-Gm-Message-State: AFqh2kpmqFX1EMOiZW0jpd+x2sGCPh13k/oNz6Bld/OG8GKSftZA2jOO
        ZSlyQAwe6qK+PTsQjzM0wyelASE3JdC78pCb
X-Google-Smtp-Source: AMrXdXsbZ14eS7fX3nqEdakWG3ocogLtNkIfFT7qyhu7h4kyw8ZacpWepxOCfzyLCWUT1AfLrX6xjg==
X-Received: by 2002:a17:902:e193:b0:194:a6e3:4781 with SMTP id y19-20020a170902e19300b00194a6e34781mr3949131pla.35.1673989681302;
        Tue, 17 Jan 2023 13:08:01 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902da8300b0018725c2fc46sm21412212plx.303.2023.01.17.13.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 13:08:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pHtBV-004ILa-0U; Wed, 18 Jan 2023 08:07:57 +1100
Date:   Wed, 18 Jan 2023 08:07:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20230117210757.GF360264@dread.disaster.area>
References: <Y8Z+y9j2nT6bQ0Hz@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8Z+y9j2nT6bQ0Hz@kili>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 01:56:11PM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 908ce71e54f8: "xfs: allow setting and clearing of log
> incompat feature flags" from Aug 8, 2021, leads to the following
> Smatch static checker warning:
> 
> 	fs/xfs/xfs_mount.c:1315 xfs_add_incompat_log_feature()
> 	warn: missing error code 'error'
> 
> fs/xfs/xfs_mount.c
>     1280 int
>     1281 xfs_add_incompat_log_feature(
>     1282         struct xfs_mount        *mp,
>     1283         uint32_t                feature)
>     1284 {
>     1285         struct xfs_dsb                *dsb;
>     1286         int                        error;
>     1287 
>     1288         ASSERT(hweight32(feature) == 1);
>     1289         ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
>     1290 
>     1291         /*
>     1292          * Force the log to disk and kick the background AIL thread to reduce
>     1293          * the chances that the bwrite will stall waiting for the AIL to unpin
>     1294          * the primary superblock buffer.  This isn't a data integrity
>     1295          * operation, so we don't need a synchronous push.
>     1296          */
>     1297         error = xfs_log_force(mp, XFS_LOG_SYNC);
>     1298         if (error)
>     1299                 return error;
>     1300         xfs_ail_push_all(mp->m_ail);
>     1301 
>     1302         /*
>     1303          * Lock the primary superblock buffer to serialize all callers that
>     1304          * are trying to set feature bits.
>     1305          */
>     1306         xfs_buf_lock(mp->m_sb_bp);
>     1307         xfs_buf_hold(mp->m_sb_bp);
>     1308 
>     1309         if (xfs_is_shutdown(mp)) {
>     1310                 error = -EIO;
>     1311                 goto rele;
>     1312         }
>     1313 
>     1314         if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
> --> 1315                 goto rele;
>                          ^^^^^^^^^
> It's not clear to me, why this old code is suddenly showing up as a new
> warning...  But it does feel like it should be an error path.

Seems like a smatch issue?

error at this point will be zero and this test is checking if the
superblock is already marked with the incompat feature we need to
add as there can be races with adding and removing the feature flag.
If it is set once we hold the superblock buffer locked, then we just
need to release the locked superblock buffer and return 0 to say it
is set.

IOWs, it looks to me like the code is correct and the checker hasn't
understood the code pattern being used....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
