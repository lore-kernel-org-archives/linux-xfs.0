Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686F6C76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 01:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbjDEBEJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 21:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbjDEBEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 21:04:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7887D1FE8
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 18:04:07 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id kq3so32944492plb.13
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 18:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680656647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wnup48kNbwmS3XgWTsGF004OeqwAJMW3we57q8YBy5k=;
        b=0VJ8Q9+9CSuh+W3dVtEi0tdl+V+R1MkWb+sjU4rD3CnmbjZUbLJZWbPbCyQu/RNIvu
         wPR65/pSPUW7kYxR6QQ35soqixLkhM5NCs1F3w4Ayitf/4nD+jF+dEuQD2HMdG72Evcy
         wbDAwckJpo4wCM/kU1h63ndSSXr6dNthxcxDMhiv09sQdWS+ZTq8bpXNYMSXPUm2kvFy
         MCzJXSRSonB7wyIZD6i3Qfqa7820FAKkv/Zo63RdG6TTc46My81zIHroklMvns0xOatv
         3HSy4Pq52/syJIAJ7QlU1NyEG1oSnSiWaEHFuOJR324h3yqXL/F/R0knF9kxjCA64q+w
         wd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680656647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wnup48kNbwmS3XgWTsGF004OeqwAJMW3we57q8YBy5k=;
        b=YpoqFoNgmmgYfRjZyFQPaDmwtxlIfqhpT//OmXZvq2rKNlHKg5PwhY1xsEEUg1nUGs
         g0TopNJHW203Br4dIgn08CpIm4gD1OH/UhD1Nw0I7ML7NNTAittTYYPt/eA2ULRWkn1w
         usFR+X17PHLwNLB2SKRiVtTMXzlFMAMEkxYQrRv3DuygywqiGDqS6fhj72A3ZhhsJNeZ
         6M65b6kiCTD6e0GKjdpbhybK8jQdeKuwlJZI42585RUqNr2xUR5wsPa5Nk0t2rSumj+5
         8zCBLoYQTIUOpP5cKvokIoKULWTOMGcs/AOlPwfdzrbcbZOfvrOdXGK1XV+HLeoRBUrt
         EdQQ==
X-Gm-Message-State: AAQBX9di5zP3blfrJtAsCSyg5svlM5biwIYJ7AUVDImYSstfQTwR4jl6
        yBqMF95Gq6AyFARG+YyDhQUyZQ==
X-Google-Smtp-Source: AKy350b4jeXFFgyCyMumPUPEfLWcaS8tR6iV/68X5r2IUbpaA8UIKVqQPQqc/PQt/1KAOc+06CTCIw==
X-Received: by 2002:a17:90b:3b46:b0:23d:449a:db70 with SMTP id ot6-20020a17090b3b4600b0023d449adb70mr4872400pjb.28.1680656646898;
        Tue, 04 Apr 2023 18:04:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id gc6-20020a17090b310600b0023b15e61f07sm180633pjb.12.2023.04.04.18.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 18:04:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pjrZD-00H8rp-8L; Wed, 05 Apr 2023 11:04:03 +1000
Date:   Wed, 5 Apr 2023 11:04:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Ryosuke Yasuoka <ryasuoka@redhat.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use for_each_perag() to iterate all available AGs
Message-ID: <20230405010403.GO3223426@dread.disaster.area>
References: <20230404084701.2791683-1-ryasuoka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404084701.2791683-1-ryasuoka@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2023 at 05:47:01PM +0900, Ryosuke Yasuoka wrote:
> for_each_perag_wrap() doesn't expect 0 as 2nd arg.
> To iterate all the available AGs, just use for_each_perag() instead.

Thanks, Ryosuke-san. IIUC, this is a fix for the recent sysbot
reported filestreams oops regression?

Can you include the context of the failure it reported (i.e. the
trace from the oops), and the 'reported-by' tag for the syzbot
report?

It should probably also include a 'Fixes: bd4f5d09cc93 ("xfs:
refactor the filestreams allocator pick functions")' tag as well.

> Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
> ---
>  fs/xfs/xfs_filestream.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 22c13933c8f8..48f43c340c58 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -151,7 +151,7 @@ xfs_filestream_pick_ag(
>  		 * grab.
>  		 */
>  		if (!max_pag) {
> -			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
> +			for_each_perag(args->mp, start_agno, args->pag)
>  				break;

While this will definitely avoid the oops, I don't think it is quite
right. If we want to iterate all AGs, then we should be starting the
iteration at AG 0, not start_agno. i.e.

+			for_each_perag(args->mp, 0, args->pag)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
