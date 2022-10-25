Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D6EFA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 19:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiJYTIj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 15:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiJYTIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 15:08:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE4FD8EDC
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:08:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so17426315pji.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN+h6p0McW0BEHTgo4rH5pBFbGjIkaHWwgpP8e/9WS4=;
        b=m5ZnHT3VJ9i4y70wI/7yShi7rOAXk2FxlK8SFdWMV7TkLF1FwCoAL0dq6Js7g0NQ4o
         gOR5IzXbP3Lda0tzj9FcvsDL7lXpodhu8DGa568sgVJv/QcGgpZvKJupLAdphcDDi95F
         EZesUAXgrR8Pj2yZv0Qq9mzs9k+bBRJPPipyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZN+h6p0McW0BEHTgo4rH5pBFbGjIkaHWwgpP8e/9WS4=;
        b=TVavCpeYcmSr9l8De5w9KT0zmYIlmkgbqkec9G9e7DQiLdkrh1z+oSBwCGQDnbxBd1
         F/Q6gfh2eD4FWwBWYlD1DINo1m4t/n/Oby/oufvJPWZDkux/JU7cH4Kj8PLvSgyadBIw
         fetbYyIL3ophIug0YDm/x0JXQRpYVYAd+2InrwfWy4CPgOoz291xTFww1nJYwrc8MmH8
         8OGApzvIfdmr54oRpMgBmyNQetjEzEBTzFEBkkr5XYmbi/1UVXGf9VNqd1UxqrbZQi+t
         X9yKjvXDgHQltpHAqzhyK26LUdC1yBGbbsp5QpiPKhazQg5lzAxa+LATMrY93ow6j4j2
         iV9g==
X-Gm-Message-State: ACrzQf3wSNLWqh+wwEizodhWAFDsf4bYp5LmvrC4+Oq8dE5ez9hPvjuy
        fwkILOdaYLgxftLZBe9uT6XtsA==
X-Google-Smtp-Source: AMsMyM4iglybgxpQoq3Hrg4bH0SJUYqrpqLpSHtTU2i2AJ27pbg+ea8sluTuNaKerMyJLkv7KOU0Yg==
X-Received: by 2002:a17:903:22c1:b0:185:5276:92e5 with SMTP id y1-20020a17090322c100b00185527692e5mr40005071plg.134.1666724916451;
        Tue, 25 Oct 2022 12:08:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y20-20020a170902b49400b00179e1f08634sm1500502plr.222.2022.10.25.12.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 12:08:35 -0700 (PDT)
Date:   Tue, 25 Oct 2022 12:08:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 5/6] xfs: fix memcpy fortify errors in EFI log format
 copying
Message-ID: <202210251155.CA54C478@keescook>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664717980.2688790.14877643421674738495.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664717980.2688790.14877643421674738495.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> memcpy.  Since we're already fixing problems with BUI item copying, we
> should fix it everything else.
> 
> An extra difficulty here is that the ef[id]_extents arrays are declared
> as single-element arrays.  This is not the convention for flex arrays in
> the modern kernel, and it causes all manner of problems with static
> checking tools, since they often cannot tell the difference between a
> single element array and a flex array.
> 
> So for starters, change those array[1] declarations to array[]
> declarations to signal that they are proper flex arrays and adjust all
> the "size-1" expressions to fit the new declaration style.

This looks very familiar! :)

https://lore.kernel.org/linux-xfs/20210419082804.2076124-1-hch@lst.de/

It seems like it might make more sense to start with hch's series, and
see what's missing?

> 
> Next, refactor the xfs_efi_copy_format function to handle the copying of
> the head and the flex array members separately.  While we're at it, fix
> a minor validation deficiency in the recovery function.

This feels like 3 separate logical changes in a single patch, but,
regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

This will proactively fix XFS under CONFIG_UBSAN_BOUNDS once
-fstrict-flex-arrays is added. Thank you!

-- 
Kees Cook
