Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28892EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 02:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbjFPCTp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 22:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbjFPCTn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 22:19:43 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2109126B8
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 19:19:43 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f9b4a656deso2506911cf.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 19:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686881982; x=1689473982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JHxDijhNKONt5ruwDIW5g/mmDYU1qwHie9r4lZ/B8p8=;
        b=hHwx34gDeH/y81xDRUltzHwFygdxquZp4Gd4iel8LmqI+VOE9FvXc5WVTOGgoOlvLw
         rDKKX5MpZtqpeZLOXSp8O64Zv1nbBBNzor8pynZM5yK0qPw13jWhijix61Fx+Uxngk3H
         WfjRH4m/CbTnBCCTI+FBUMGfnWt/DiPfNa6fDrwnjqiMHKeb8XB9/XJ6JJmv7gii181x
         N48vbDLtEA5y/9MgB/G9DnePKTiWxMAhxER69kRUI3jPS4tY7m+KE6CAe2wg9xP+A8cb
         ra7Y9rfi3foiNOdQgizZxY7EouWVua6aH0/VftAY9pqPOZRQVs/Pqa2Bp/hdDxrJD5Vw
         cHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686881982; x=1689473982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHxDijhNKONt5ruwDIW5g/mmDYU1qwHie9r4lZ/B8p8=;
        b=FE9fdixMzcdJFDK8UCYZ1TTyhFMZGlKu3fIIV+c6C6Ec6V+aPjWEiHjtplpq1aI846
         ILWviskSjNW9bTshxU27PEnuhWr8vlT+COWsajYbPU0GNlKQrNGHFrF8Z31S7MdnWC6s
         B7dlqdeDKpgAftKHbeqZxH6vwBBiY2hKXFuoHYnhaRDHhnyHe1NjgHpukuRN+FxF2B72
         6EpH+ZRApwr0NNqZ+JoM48OwQrTErBgZztNJclCXAOSuQVLWzC4OeovPx3I2E25YpopQ
         Naffosl4PvN4vUwfhpIN+zdG++uekTV2BDZMOBkFpulHnm/SLx8KSL70dITs/hdemRTU
         +R/A==
X-Gm-Message-State: AC+VfDzNjHN71KeQ/IKMgAQfy1jpZ60I8Hjak4YY/pl1/XZnXhnyl43c
        joPjb+FN8YMgieYBDTKlOI+pqG/0sLBNV3drCfg=
X-Google-Smtp-Source: ACHHUZ7VzeSgr6uq5GPR9MvQjIAidnvdg2NG8W6n6A+X2xAOhLAlNW7dxIA8tCEYpeVaXDHpWlViDA==
X-Received: by 2002:ac8:4e4d:0:b0:3f0:a892:3c0e with SMTP id e13-20020ac84e4d000000b003f0a8923c0emr1010275qtw.47.1686881982277;
        Thu, 15 Jun 2023 19:19:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id x23-20020aa784d7000000b0063f0c9eadc7sm2805880pfn.200.2023.06.15.19.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:19:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9z3q-00CIkc-2u;
        Fri, 16 Jun 2023 12:19:38 +1000
Date:   Fri, 16 Jun 2023 12:19:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, mcgrof@kernel.org,
        hch@infradead.org, ruansy.fnst@fujitsu.com
Subject: Re: [PATCH 3/3] fs: Drop wait_unfrozen wait queue
Message-ID: <ZIvGuiORFJuCK2xy@dread.disaster.area>
References: <168688010689.860947.1788875898367401950.stgit@frogsfrogsfrogs>
 <168688012399.860947.1514236710068241356.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168688012399.860947.1514236710068241356.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 06:48:44PM -0700, Darrick J. Wong wrote:
> From: Jan Kara <jack@suse.cz>
> 
> wait_unfrozen waitqueue is used only in quota code to wait for
> filesystem to become unfrozen. In that place we can just use
> sb_start_write() - sb_end_write() pair to achieve the same. So just
> remove the waitqueue.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/quota/quota.c   |    5 +++--
>  fs/super.c         |    4 ----
>  include/linux/fs.h |    1 -
>  3 files changed, 3 insertions(+), 7 deletions(-)

Yup, nice simplification.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
