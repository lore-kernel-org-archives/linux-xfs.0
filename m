Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDDBC32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 09:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjARJSB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 04:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjARJOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 04:14:42 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D3834550
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 00:31:42 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so905476wms.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 00:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kV+wU0lL+Wy7Ku444/Sa+fRD6GgCXnNEt98R9+p5sHk=;
        b=J+KQR8LUBulNuPDa/XHXACriEf25bOxYj6DsDSjkbldDNgYQg3brgpTA94YileIckx
         NCplxmCaoJt8TF4OS8qPY57Kk6zJNa1nyVEYj3Q5NeMKZgNy5hF8kX5Us4qT5goINF0U
         4ZIr4FX7qRT/VtsdyfQ4pXKVkG9tH5XYKPTwp9TB124djM3oBBQTHNCa4Mkss52yqUGH
         to7tP144ZnQo8M9paaXIf+fNK/P9tSfdWMmHPm5d661bW6F8q4w09IdnCq7K2R7jlsdw
         T59oW1H304gj6LNI2gc/o6TnHEL6R4TcSuDVMr1/AIixndP39QA107U4j+6opBp/S/kV
         Vwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kV+wU0lL+Wy7Ku444/Sa+fRD6GgCXnNEt98R9+p5sHk=;
        b=54LiacN5CkoHc1O2ph5DYsp+X1r9ICUwKXuNwV6yLpMlXnHXANt5GM9yFWR79Wemzl
         YHv+HLZQyFXRHNzwAMyXLTSaWmzTabl/5Pza+oQlgpbTEnQoTJZgGC2Z/toaqp6/SFuj
         Mbe+fezd4AFHVdHv6/qhnSGeEY4cnxhr0gthxBcOBAyMZv+5W8vTjvFUezjN7aSyvqWb
         mpFR7mWAIqJIN64Z+5QIjTjRQiyVw1ksVpAE6630uMdJOwolTWUEZFPWfR/NAkPzfJ5U
         U5B6CvJPGPDpDV1/mnrDnpmfPFMNVnlcCXAKoIlOkKhCFZV7Dj4BjqvdD0vOp4250ky5
         tmXw==
X-Gm-Message-State: AFqh2kpWCymVI9LKunNnFyI5Ps4XsvY6rJgMuHkkPHiMC2ccC1GTfTRX
        3Y/sKZkXucYMAvu7BvRFL3c=
X-Google-Smtp-Source: AMrXdXsq+tFzIOM46P46RFgea/PIOqJlAo76ga6xc/uhNR/rX07h2dWD7yd8rXLJpi6uE8WBllf3xA==
X-Received: by 2002:a7b:ce15:0:b0:3da:2932:b61a with SMTP id m21-20020a7bce15000000b003da2932b61amr5717278wmc.18.1674030700697;
        Wed, 18 Jan 2023 00:31:40 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w8-20020adf8bc8000000b002bdc39849d1sm18681635wra.44.2023.01.18.00.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 00:31:40 -0800 (PST)
Date:   Wed, 18 Jan 2023 11:31:36 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <Y8euaA0WBy3lX962@kadam>
References: <Y8Z+y9j2nT6bQ0Hz@kili>
 <20230117210757.GF360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117210757.GF360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 08:07:57AM +1100, Dave Chinner wrote:
> On Tue, Jan 17, 2023 at 01:56:11PM +0300, Dan Carpenter wrote:
> > Hello Darrick J. Wong,
> > 
> > The patch 908ce71e54f8: "xfs: allow setting and clearing of log
> > incompat feature flags" from Aug 8, 2021, leads to the following
> > Smatch static checker warning:
> > 
> > 	fs/xfs/xfs_mount.c:1315 xfs_add_incompat_log_feature()
> > 	warn: missing error code 'error'
> > 
> > fs/xfs/xfs_mount.c
> >     1280 int
> >     1281 xfs_add_incompat_log_feature(
> >     1282         struct xfs_mount        *mp,
> >     1283         uint32_t                feature)
> >     1284 {
> >     1285         struct xfs_dsb                *dsb;
> >     1286         int                        error;
> >     1287 
> >     1288         ASSERT(hweight32(feature) == 1);
> >     1289         ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
> >     1290 
> >     1291         /*
> >     1292          * Force the log to disk and kick the background AIL thread to reduce
> >     1293          * the chances that the bwrite will stall waiting for the AIL to unpin
> >     1294          * the primary superblock buffer.  This isn't a data integrity
> >     1295          * operation, so we don't need a synchronous push.
> >     1296          */
> >     1297         error = xfs_log_force(mp, XFS_LOG_SYNC);
> >     1298         if (error)
> >     1299                 return error;
> >     1300         xfs_ail_push_all(mp->m_ail);
> >     1301 
> >     1302         /*
> >     1303          * Lock the primary superblock buffer to serialize all callers that
> >     1304          * are trying to set feature bits.
> >     1305          */
> >     1306         xfs_buf_lock(mp->m_sb_bp);
> >     1307         xfs_buf_hold(mp->m_sb_bp);
> >     1308 
> >     1309         if (xfs_is_shutdown(mp)) {
> >     1310                 error = -EIO;
> >     1311                 goto rele;
> >     1312         }
> >     1313 
> >     1314         if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
> > --> 1315                 goto rele;
> >                          ^^^^^^^^^
> > It's not clear to me, why this old code is suddenly showing up as a new
> > warning...  But it does feel like it should be an error path.
> 
> Seems like a smatch issue?
> 
> error at this point will be zero and this test is checking if the
> superblock is already marked with the incompat feature we need to
> add as there can be races with adding and removing the feature flag.
> If it is set once we hold the superblock buffer locked, then we just
> need to release the locked superblock buffer and return 0 to say it
> is set.
> 
> IOWs, it looks to me like the code is correct and the checker hasn't
> understood the code pattern being used....

The Smatch check is working as designed...  The problem was me reading
the code, because I thought an "incompatible" feature would be bad, but
actually the function is called xfs_add_incompat_log_feature() so it's
good.

regards,
dan carpenter

