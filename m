Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD111EE49A0
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbjHXXx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbjHXXxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:53:09 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B7E19BE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:53:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bc3d94d40fso3749895ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692921187; x=1693525987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKw+D7LxTAF/DhFgciZRKtPBiC9Quf+JbX8aY/76faY=;
        b=PXdFs5xrg+FwaMkpA6MkRjylS6TTQfLP1wlQVUHlXKqXKKApToE5iGYueHcyEnEbjT
         u0I3rXDr9ZzG9EF9Kyps3SGAD0yaPHp6xeDYXuR+vFrHS3ggN+KRm0qySLIGRuMQf8yG
         QDyYrSiP9M2foWi0VWz0kwTuO4w6iMCvXZ4ggF+1acqxaYY11fayM532nLUFv4CbmElg
         iGrGC66EpYOzxcz3yMDpSB8ljEOCo+JMdxN6vCGsSn/+6yyBkv8sauo1CUTW5k0vgbSc
         THjYV6A3ivazQS6XGFamlYHHvM8cMpyF+SrQWoayWVUmh1UY7e4WQDQ7TH8P991OkWS9
         SqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692921187; x=1693525987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKw+D7LxTAF/DhFgciZRKtPBiC9Quf+JbX8aY/76faY=;
        b=LOjufG6S/D9qFWDFHF6fgZNAvNBekWFuO99l0kd8X+MXlCiWIfMJR/XgHTf9V+AyQI
         KAHflUci79bKW1YzI4baqvrBmtCagWb2tJa3Pqk8zADtS7YV1SBtkfovs+vBeatDV/2A
         WEjabfY7V3nnvVZlnb4tgCh55Iq/jqdmHbTGgM2BJYRm067lcasYv/yoO4qaFn1Er6az
         H5BKgJ9ISR3o/UQYxMDXBTnDw8bDwhyJWv4iW6+Vl4TG3wZUjMnNqCQiJDnKslhhQ2Z+
         W56PonoZM7SKEiUIf6AIwvXeRZYDUAkmUocIZVNr1nxlelW/A0RwA1kRy28Z0WP3wdAx
         Dhyg==
X-Gm-Message-State: AOJu0YwAPANv/eUrayX3OPW0/RSsT6b5d/N6V9THJZkdX0pBjBwNMDXP
        qZDuGL6DFoHvlKdPrHiVQrj48w==
X-Google-Smtp-Source: AGHT+IHoVTVpJYK5ma429YYM3EMNcMs3kVDGUhB4xvENNG0kP/iiu93TFbt8TyloFPkah+t7F3t5gw==
X-Received: by 2002:a17:902:8695:b0:1b8:2c6f:3248 with SMTP id g21-20020a170902869500b001b82c6f3248mr16122761plo.39.1692921187212;
        Thu, 24 Aug 2023 16:53:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b001bda42a216bsm245861plf.100.2023.08.24.16.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 16:53:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZK8O-0066Au-0H;
        Fri, 25 Aug 2023 09:53:04 +1000
Date:   Fri, 25 Aug 2023 09:53:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, tglx@linutronix.de, peterz@infradead.org,
        ritesh.list@gmail.com, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix per-cpu CIL structure aggregation racing
 with dying cpus
Message-ID: <ZOftYLqVCMSWxmk/@dread.disaster.area>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
 <169291928016.219974.17814488726880866494.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291928016.219974.17814488726880866494.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 04:21:20PM -0700, Darrick J. Wong wrote:
> @@ -554,6 +560,7 @@ xlog_cil_insert_items(
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
>  	int			space_used;
>  	int			order;
> +	unsigned int		cpu_nr;
>  	struct xlog_cil_pcp	*cilpcp;
>  
>  	ASSERT(tp);
> @@ -577,7 +584,12 @@ xlog_cil_insert_items(
>  	 * can't be scheduled away between split sample/update operations that
>  	 * are done without outside locking to serialise them.
>  	 */
> -	cilpcp = get_cpu_ptr(cil->xc_pcp);
> +	cpu_nr = get_cpu();
> +	cilpcp = this_cpu_ptr(cil->xc_pcp);
> +
> +	/* Tell the future push that there was work added by this CPU. */
> +	if (!cpumask_test_cpu(cpu_nr, &ctx->cil_pcpmask))
> +		cpumask_test_and_set_cpu(cpu_nr, &ctx->cil_pcpmask);
>  
>  	/*
>  	 * We need to take the CIL checkpoint unit reservation on the first

This code also needs the put_cpu_ptr(cil->xc_pcp) converted to
put_cpu(), even though they end up doing exactly the same thing.

Other than that, it looks good. I'll pull this into my test trees
and give it a run...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
