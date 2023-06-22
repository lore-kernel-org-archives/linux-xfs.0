Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28F3EB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 05:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjFVF3w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 01:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjFVF3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 01:29:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B0C1AC
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:29:50 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-553a1f13d9fso3974074a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687411790; x=1690003790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=anvZw6cO8MKlWn1hIrVh5wjoOcSzm1ZkgJQlB41QQfE=;
        b=Y2+fQmqkTRf9iW+K4H5FPnGgJp91MYVPv6KEb+nrxSB0eXaqxilrhqNq1YSb4ZVsq/
         psSTLjRxKCOROPdO+W09otz1naDlbIO4WTNGMm59M9N2XXO1Aw7LHRtWjH417OjJa1Ch
         uibnIAzf021+su/Im2Q6bS7FXAJj7cIfNu3/1kxgeGKqRLv0TKsv5S4dXN8eHFjgpuzw
         NmdJrH2MCXa5OSQfJN7ztxkjReCQmS3uuQ7nz6KtyAx9TCorsOhM/VXZsdquY57iVZta
         4Pm3eqi2iLIeayHkuYkwr9r4IdhRgbmrqkwnUDHWHXlw3SSl1ovryLjy0U7dRo5/KfSN
         MLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687411790; x=1690003790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anvZw6cO8MKlWn1hIrVh5wjoOcSzm1ZkgJQlB41QQfE=;
        b=SApwFnjQdmfYCtKetQJtVeLB0pSDUeT70G+s4/kCU4pguXfp/6l6alUHAwLMoV6PsS
         awObKbmc4G1DHsghixxbUhazkyoRMGDioIdyOoQMAnZDyW6pqRYFd6Q9Kp2dy3ldfrfc
         yu7utzJOrbchrnE5P03oqY+plR5CEZfGP0E7gexHcYuAuDELmF4/3fubBgM5NVBKZuoU
         iMHrkKZFNp7UBmUcvirQb/Z/NaMPvEoJ8CkeYopVPgw1CLka+5KY4ncvmHtqkU4/jNK9
         1dcvYDM42w/d7HOEjJR6hbsCOmuXqIXzdqvyrmJngq5xau+sHfa9Z7rW+0VQGOhPUpSL
         OPgg==
X-Gm-Message-State: AC+VfDxQxDSX9TfhMEfmBBUxXNXApdfSRBIa9KCOLyBi1sV/0zbz/UO9
        Rj5HWEM3tgULCVA9sgQ+SL5KVA==
X-Google-Smtp-Source: ACHHUZ7YS4UnVaitvJxmT+5c774eroZcdYqIVSoMb1zUI8iiJhlNafiqbNvrjjAl58cyJaTqtkX9zg==
X-Received: by 2002:a17:90a:7064:b0:25e:2db8:cc5f with SMTP id f91-20020a17090a706400b0025e2db8cc5fmr17391121pjk.40.1687411789845;
        Wed, 21 Jun 2023 22:29:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id a19-20020a656413000000b005287a0560c9sm3668682pgv.1.2023.06.21.22.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 22:29:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCCt8-00EjK1-2q;
        Thu, 22 Jun 2023 15:29:46 +1000
Date:   Thu, 22 Jun 2023 15:29:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Lars Wendler <polynomial-c@gmx.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: po/de.po: Fix possible typo which makes
 gettext-0.22 unhappy
Message-ID: <ZJPcSvOp1Fvrb5Wm@dread.disaster.area>
References: <ZJNyn817MpCB3nbr@dread.disaster.area>
 <20230622052354.12849-1-polynomial-c@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622052354.12849-1-polynomial-c@gmx.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 22, 2023 at 07:23:54AM +0200, Lars Wendler wrote:
> The removed line contains "%.lf" with a lowercase letter L.
> The added line contains "%.1f" where the lowercase letter L was replaced
> with the digit 1.
> 
> Signed-off-by: Lars Wendler <polynomial-c@gmx.de>
> ---
>  po/de.po | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/po/de.po b/po/de.po
> index 944b0e91..a6f8fde1 100644
> --- a/po/de.po
> +++ b/po/de.po
> @@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
>  #: .././estimate/xfs_estimate.c:191
>  #, c-format
>  msgid "%s will take about %.1f megabytes\n"
> -msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
> +msgstr "%s wird etwa %.1f Megabytes einnehmen\n"
> 
>  #: .././estimate/xfs_estimate.c:198
>  #, c-format

Thanks Lars, looks good!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
