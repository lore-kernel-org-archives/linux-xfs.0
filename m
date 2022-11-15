Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8172CC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 03:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiKODCV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237897AbiKODCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 22:02:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C581F9FE
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 18:58:58 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso12571856pjc.5
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 18:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XqfECdiVnMwAa9orPEnNFiBonB3NC5wrVZu54+Jb88k=;
        b=qf0BkpX6zBgk6g/aODk/OVbro3CP1nHyV1vgPZUj+T6JDyj7hiodABcxzU+7GaSaZs
         cztOXzJY4FrzdVZWBTdKdCRuHNIeZ2+J7zD5IV2xEUjIQNFpH5ET0neTe7l0EE8UDyHn
         PPCvHJ36K75KyrGHfDY/BNQB/zXzJhCTnMBI5/pEbFSj4JfOhsVDtlxWN1tX3ozM2uag
         isUyyNNOYCZz+YSaJxwZ4o8ksjmiOeqCAR2ogRmEf0X0zlNZVNmRZR7QT+owGfjJktGB
         XaQQiZ2APgfug2X9lrcZj8pzPmXQERFMH5qcpQFeBalBtFxYs8MQdRlWPqi/OYWhu8Dv
         4yXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqfECdiVnMwAa9orPEnNFiBonB3NC5wrVZu54+Jb88k=;
        b=rAUGJVSCJpI/4hwq6c+EamaKv2emslUvqu0L1fpJC1DDl+fbN3VlFp+7XG253cFE7h
         UZLl2JaWLOCUpc/mm2ixlwgJgolElW52y6Wcli4kcvMAmUuviFLtPjMW3/ksCHmaXvG/
         xbCc+X9XHnTIUXrGPQ09tf65WB2Zpu+Tygnx0568Cesv43flbOcRiWNcWoQWqPWjBqOw
         vuGZQBRYNtb4Q6VpeULDFy7KYUcJk2J8aBdboOaRSqzQZWHVT5SgyGZBGoRVAiy+7ckO
         1TzyBWxEB3hIBow8hTbVtgZK3sMVrcJpEDHjc2Sdrb0QmG22NISgMpNVtvVFKvKhIeZE
         EyNA==
X-Gm-Message-State: ANoB5pkaVPhKRO3D1dKjyJ1L5upqqJgIG603eDVHrzub51aPHHFzipLO
        8g44GC+L6SXAQ7Q8L9jhVXwNOhuiqt9uDQ==
X-Google-Smtp-Source: AA0mqf6vz3JUlpP9stqsLbJZkEmz9E1beQNcfh783v1ufAtkPLuqPr34ewJKi5DjFOhp/hqBGaKEUA==
X-Received: by 2002:a17:902:e782:b0:17f:7ed1:7da5 with SMTP id cp2-20020a170902e78200b0017f7ed17da5mr2109058plb.101.1668481137947;
        Mon, 14 Nov 2022 18:58:57 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id l12-20020a170903244c00b0017f592a7eccsm8344793pls.298.2022.11.14.18.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 18:58:57 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oumA2-00ELkw-ST; Tue, 15 Nov 2022 13:58:54 +1100
Date:   Tue, 15 Nov 2022 13:58:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: check inode core when scrubbing metadata files
Message-ID: <20221115025854.GV3600936@dread.disaster.area>
References: <166473482605.1084588.1965700384229898125.stgit@magnolia>
 <166473482636.1084588.10974246607672500827.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473482636.1084588.10974246607672500827.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:26AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Metadata files (e.g. realtime bitmaps and quota files) do not show up in
> the bulkstat output, which means that scrub-by-handle does not work;
> they can only be checked through a specific scrub type.  Therefore, each
> scrub type calls xchk_metadata_inode_forks to check the metadata for
> whatever's in the file.
> 
> Unfortunately, that function doesn't actually check the inode record
> itself.  Refactor the function a bit to make that happen.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/common.c |   40 ++++++++++++++++++++++++++++++++++------
>  1 file changed, 34 insertions(+), 6 deletions(-)

Looks reasonable. Will there be more metadata inode types to scrub
in future?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
