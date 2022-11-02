Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FA7C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 00:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKBA3y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 20:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKBA3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 20:29:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2E711C38
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 17:29:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h193so6164123pgc.10
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 17:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3IU/scHPnfBeGjMa47VVBP5wHDp/XohW5mtV5nWEGGY=;
        b=atVvqVD6bHYKbv81YANgyarub8J32O/ZofxIVf9z91/QnBLxPYtHzLUxIA4yK/HitO
         3MwHE2pphDpGrMgcXgao9k8AWq/uXGU//X6OGLWzdrAl4b3Xc/qbTD1LZPjF6Uawllmi
         wdJ7jKX0yXlTXfmpeaTcCaf16WzSESZPvRdLswExG3YW1Ej5RTqGDJQhHb5yJwok9pfk
         YKx+ExqzrAYFz25YymwZTCaPNEJhV8ev5smjh/5KTYO8JoqauuPWzS8MzfKz7Lrswu2s
         QxPc9Q1IDP5TeQMWALnDX6T0hlFeecLWppKGayrgpVAa6+mho8wwiHGK+XtSZKVvdLwP
         nNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3IU/scHPnfBeGjMa47VVBP5wHDp/XohW5mtV5nWEGGY=;
        b=Pzy3PULfA/dpr07Q+JsQ0pcZLx1MCdtXkl1nRVIThUDnHCWNXS5u601TocWo441QOK
         4Xh69EuGvq+6N1UibqiSKU92dPEfmXtWLZ8fdwU3Yf87/H9FF4BR4r/Y7YBYj6Y3prdN
         iUlCfvRgy+mGv2sQabkaCCkiII+UTOv/GzScsW+71mNS+VLlogUxKyz0PjaCdgaXrPm8
         KB79Do+kvUEVxPCcyG4gZdk8uQtvMzQmN7Gqd3uL4RhJRSFzcV6xaJHK8F+DND4Y/U5D
         R0t/xJ25rUiMjHEAVs2i9GmLsxXLCdPDxtpGtQQU7mMiV+nC7wt8KeMzw+QTRjKclC31
         H4YA==
X-Gm-Message-State: ACrzQf10WnFTb950UbLqP9e69Mh+dlD6vNqgmw359mJ8+jiN/yo6AC3k
        xyPIu9c626rb726QR27JLIpYXuF9dtC7Qw==
X-Google-Smtp-Source: AMsMyM6OiVmXE1bKnCXBICVl8uxHg2d4EEbZhgve+AJHi85T5ARMytcp8d/E/8XcI9tY0vHlVfYiQA==
X-Received: by 2002:a63:2352:0:b0:46b:1dac:bc83 with SMTP id u18-20020a632352000000b0046b1dacbc83mr19990376pgm.98.1667348989129;
        Tue, 01 Nov 2022 17:29:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id w2-20020a623002000000b00561beff1e09sm7125600pfw.164.2022.11.01.17.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 17:29:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oq1dZ-009BLp-Kh; Wed, 02 Nov 2022 11:29:45 +1100
Date:   Wed, 2 Nov 2022 11:29:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: ensure that all metadata and data blocks are
 not cow staging extents
Message-ID: <20221102002945.GR3600936@dread.disaster.area>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
 <166473481655.1084209.12908049694500649697.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473481655.1084209.12908049694500649697.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that all filesystem metadata blocks and file data blocks are
> not also marked as CoW staging extents.  The extra checking added here
> was inspired by an actual VM host filesystem corruption incident due to
> bugs in the CoW handling of 4.x kernels.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
