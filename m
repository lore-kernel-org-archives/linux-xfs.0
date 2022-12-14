Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EB2C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 00:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiLNAwo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 19:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbiLNAwn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 19:52:43 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D74E33
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 16:52:41 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so5364770pjj.4
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 16:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ytdItsM2Xar/RTDIIXTN4FFHM5FuGxJ0jScfhnlv+Hw=;
        b=Lg6kQm4W8jT97eWq7bPLt/6IWPhUVvQaiQhaV6zechdyZ9Z3AaWn6i9xyexo2XT3nZ
         cNhc8ABT50LibGeZqwaX9uhJCvUkcHloOzzXWsc35VNtMSeiMQi66zXKdE2DrrEvlTkF
         CYELDHAZ+Y9RbX3eI0civ1mlwHQCT7zmGcBbFM+8meIUIl5Oqht9k5tMw2ZAAcUyFyWN
         wVQsr3pB7demOQrO3J4/ghtYoH817RWqH735xigsLWkG9Z4Q2DIPnl+B1UIvcVEQcQ3x
         q4ju6Zq42/UkvRxnIVCbjhZ9cyTXgMN0Am1VEcPIBNqK8VBPLNqNBVuGyzZyzgequacW
         Dq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytdItsM2Xar/RTDIIXTN4FFHM5FuGxJ0jScfhnlv+Hw=;
        b=E3pYaFVNpv9d/3Abg9bJr/hZe66J7l8kUzd50bZBVN/PC6XZ4N+kDbQ2+D+OI10SjV
         +Wfa+G6xlJh+Y+rk/TVGcH6i8ccSriFZoMaDiCtwM+W2GmHgFGmPH7hzqj3xuqPTPQWh
         0c2YWectAYXuH37bADVJGlqPXKKxgdNm0LlobVCEL8xKyt6QyoDp1I/egLONKy9gSb9H
         ZA3B/FZFEOEJsuh3N+LVd5k0Zhk3jZhzk34XIuFISFF684L966bDuob1sLYTVFj498R9
         jVoAnWTR+fR2IM4GTkDLmspeD9K4ij0W/rq9sYAcSSZb02zFWHCQpGOX9QVXwEgvuXtr
         P17w==
X-Gm-Message-State: ANoB5pnSFNXMNpTS6s2W+DsZNRlUSxAgWt7lXrG3fk9hueJLpLF/i362
        UfxcCXjsv1tHO8PAmejtaOsEAVz+ehMUw2Ji
X-Google-Smtp-Source: AA0mqf4/ZKH86m0Bjq1BVKaNKM5auH0xF+cmmexda5Jgc+KoOCVDHd6tesvs8UUi5kp0seTSmuiIWQ==
X-Received: by 2002:a17:90a:c304:b0:20d:bd63:830a with SMTP id g4-20020a17090ac30400b0020dbd63830amr22920417pjt.49.1670979161031;
        Tue, 13 Dec 2022 16:52:41 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id gx13-20020a17090b124d00b00219e38b42f5sm128924pjb.26.2022.12.13.16.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 16:52:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5G0j-0089Hj-LX; Wed, 14 Dec 2022 11:52:37 +1100
Date:   Wed, 14 Dec 2022 11:52:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Add const qualifiers
Message-ID: <20221214005237.GA3600936@dread.disaster.area>
References: <20221213205446.2998033-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213205446.2998033-1-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 08:54:45PM +0000, Matthew Wilcox (Oracle) wrote:
> With a container_of() that preserves const, the compiler warns about
> all these places which are currently casting away the const.  For
> the IUL_ITEM() helper, we want to also make it const-preserving,
> and in every other case, we want to just add a const qualifier.

....

> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> index 43005ce8bd48..ff82a93f8a24 100644
> --- a/fs/xfs/xfs_iunlink_item.c
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -20,10 +20,7 @@
>  
>  struct kmem_cache	*xfs_iunlink_cache;
>  
> -static inline struct xfs_iunlink_item *IUL_ITEM(struct xfs_log_item *lip)
> -{
> -	return container_of(lip, struct xfs_iunlink_item, item);
> -}
> +#define IUL_ITEM(lip) container_of(lip, struct xfs_iunlink_item, item)

I think this is somewhat of a step backwards. We moved these log
item type conversions from macros to static inlines to add type
checking so the compiler would catch the type conversion bugs we
found that the macros didn't warn about....

Which makes me ask: why do we even care about const here? What
actual real world problem are you trying to fix with these changes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
