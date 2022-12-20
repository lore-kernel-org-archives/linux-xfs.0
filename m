Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BEAC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 04:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLTEt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 23:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiLTEt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 23:49:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57618CEE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 20:49:55 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 36so7577992pgp.10
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 20:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FOcK2t+OG1nTkwgagVLWfX1vpspjpdal3uvs8Y30Tw=;
        b=3Y++dvg/W0rlFg27cd7sus4vNrOiXqzeSpP4jXbCBSEn4PuWA/q3KWRmN+42E3IS7X
         H+vdMVn2EoojKqwrOOgHe8w/1XzjfW00Ll3YMeUU7UcaivQjthRf+AnPE0NzJfTI7xzD
         dnIYfmh2L5J+zNqXjY4UPF75ZPR8+Y/iXQQAhxwQFowJjtSTOQSXd5xhbZgChg4aNHNX
         wJRedjMqRCkaE4GL/+RcCj5CAalBfs0zrFQLcW9gWack00LvmH0S+sSzFNO+daO7NxNg
         G2Ld4hHRTKN4fFhhi0WLYMK8FdojYh02CZz4xeJxEOALv2D/bXk/f+ejyPUxffGRidjL
         J0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FOcK2t+OG1nTkwgagVLWfX1vpspjpdal3uvs8Y30Tw=;
        b=f8uUrsh/9VTZF7WEYRp5LxSoGIWcqTb4m4Ixr7sPpcqxZjphl2I8CDYuDaShrl4ehE
         l2BS78ztijAo23K13H8PL+fnArGGgzm+8gMauWgmndjsjY1jMejoNMQvy7r93vBcc9VC
         zQYWirZhYn9MLuvjjsNZfwa1PfNKoW1T+RygiWsEozSt8pO8W97u0OXQV7wqTfx/ABwB
         44AEOqzCMHe7zD1wSKTneWYAqR5z3deALjX6uEYIin+RUZuucqTEtH05JFASkvB3XX53
         52Gcn5EtDy3cUGVMJlJuIN9+d/1QPWQHfVQM1hwhT6UeSDXc1+NZNsDfT96z5k2Wjgfm
         /yuA==
X-Gm-Message-State: ANoB5pleScnd6In+rD1Cvmt22E9XB3oMqpQwkNfGTdW7vsGkCA42HJpt
        E86Ol8Pnx2aFh1M/I0eG2OsA9OefknT84Km/
X-Google-Smtp-Source: AA0mqf4WpBfSzD10ZBiWTrb+KKu5RNIkd8Np5I8ncIbh0BPwY45e9vwxUUBqNt2Bnmet/ADEyyHejg==
X-Received: by 2002:a62:fb11:0:b0:56c:3696:ad68 with SMTP id x17-20020a62fb11000000b0056c3696ad68mr45675030pfm.8.1671511794866;
        Mon, 19 Dec 2022 20:49:54 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id d15-20020aa797af000000b00577c70f00eesm7535910pfq.22.2022.12.19.20.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:49:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7UZb-00AZsc-SK; Tue, 20 Dec 2022 15:49:51 +1100
Date:   Tue, 20 Dec 2022 15:49:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: don't assert if cmap covers imap after cycling
 lock
Message-ID: <20221220044951.GJ1971568@dread.disaster.area>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149470312.336919.14005739948269903315.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167149470312.336919.14005739948269903315.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 04:05:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs_reflink_fill_cow_hole, there's a debugging assertion that trips
> if (after cycling the ILOCK to get a transaction) the requeried cow
> mapping overlaps the start of the area being written.  IOWs, it trips if
> the hole in the cow fork that it's supposed to fill has been filled.
> 
> This is trivially possible since we cycled ILOCK_EXCL.  If we trip the
> assertion, then we know that cmap is a delalloc extent because @found is
> false.  Fortunately, the bmapi_write call below will convert the
> delalloc extent to a real unwritten cow fork extent, so all we need to
> do here is remove the assertion.
> 
> It turns out that generic/095 trips this pretty regularly with alwayscow
> mode enabled.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_reflink.c |    2 --
>  1 file changed, 2 deletions(-)

Looks fine.


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
