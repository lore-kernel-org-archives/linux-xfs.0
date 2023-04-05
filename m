Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C50EC7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 23:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjDEXEW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 19:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDEXEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 19:04:21 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF3461B3
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 16:04:20 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id ix20so35864089plb.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 16:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680735860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KrKOMt3UyE7cKr4ReAMcPC7o/oJjZhoBrpSamEnzwcU=;
        b=iBasCSC6te0W78R7Bld/4KqgYzDWUZzqACRfp85/HVPjnIURY/CCvj/MiI6rm+++ti
         gqpugla/+KDIYJg63rR+HSbATePR4WT4ESQqUSZbNXhXwDsDekOQI3dc/hhfGsX4ZmQH
         ecTKCtm9wkF//A0omDOb3qG1mFeJtK6feClVFbSUVOuk+pMTKJePNaAaUzd151jRcXcN
         DByT2oDMO7+9+lh1FRHXVJeLQZdjpwBHrNdyfejgPhOeMKO+SfFKXC+BSv2ILVK7l638
         6WjxIUoe58jT0iOyh0VhO3qcTR60vFv7HyGZ3OdUkrwxLi3TmR49uTk80nkqRXSgT7Hb
         bdmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrKOMt3UyE7cKr4ReAMcPC7o/oJjZhoBrpSamEnzwcU=;
        b=E6y6/w9MWJ3EhrpQMMrV3uMSWX03yzE8NhE1m7U0Xz9axwFbmL8zxiblURcOfLg9la
         4VakfSNWbcGPv2WuhnWia6GF+bTwb8UGnxRnpW0telyDKxmlH+JOcvDgNP1L5gYleW47
         is4CxYpWRfiWNchrMExKgaB8kkPuPNmQAD68+BBn+zXEEGyiH2TZBF/gkk2G4kHUumB5
         M2ECfTTVum1zIL1cPwStYVI6J2K04F5/z4ZQnaGycWUuvjGVUYxTqQrrRUnL30j60ahA
         YyxCSgYMSJfWEmb5aa5KZOsct4LHoqy5pCARimZadyYpSwu1riYpTIrtjXC7v/v8upbZ
         sySA==
X-Gm-Message-State: AAQBX9eDMXrXZfyjVzu3A2MFLYoCKkOIGjF0821ujcfcBcZXZikxy5Jm
        /ofMtyfA0GW2MvbLvRd8JoFwbQ==
X-Google-Smtp-Source: AKy350b+42w1smjir37jF3mpwW0jtsgJwT9OCuZ/HHxaFRTXRFnztFkwSl+Lgm5digRUYn3uj9z7oA==
X-Received: by 2002:a17:902:f152:b0:199:1b8a:42a8 with SMTP id d18-20020a170902f15200b001991b8a42a8mr6304205plb.6.1680735859685;
        Wed, 05 Apr 2023 16:04:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id b18-20020a63e712000000b005038291e5cbsm9739867pgi.35.2023.04.05.16.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 16:04:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pkCAp-00HVND-O9; Thu, 06 Apr 2023 09:04:15 +1000
Date:   Thu, 6 Apr 2023 09:04:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Ryosuke Yasuoka <ryasuoka@redhat.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use for_each_perag() to iterate all available AGs
Message-ID: <20230405230415.GT3223426@dread.disaster.area>
References: <20230404084701.2791683-1-ryasuoka@redhat.com>
 <20230405010403.GO3223426@dread.disaster.area>
 <CAHpthZoWRWS2bXFDQrB+iOz7AA_ZLGJKmytHjN582VaWQ_TRwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHpthZoWRWS2bXFDQrB+iOz7AA_ZLGJKmytHjN582VaWQ_TRwg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 05:04:14PM +0900, Ryosuke Yasuoka wrote:
> Dave,
> 
> Thank you for reviewing my requests.
> 
> > > for_each_perag_wrap() doesn't expect 0 as 2nd arg.
> > > To iterate all the available AGs, just use for_each_perag() instead.
> >
> > Thanks, Ryosuke-san. IIUC, this is a fix for the recent sysbot
> > reported filestreams oops regression?
> >
> > Can you include the context of the failure it reported (i.e. the
> > trace from the oops), and the 'reported-by' tag for the syzbot
> > report?
> >
> > It should probably also include a 'Fixes: bd4f5d09cc93 ("xfs:
> > refactor the filestreams allocator pick functions")' tag as well.
> 
> No. my request is in the same code area where syzbot bug was reported,
> but it might not be relevant. A kernel applying my patch got the same Oops.
> 
> I'm indeed checking the syzbot's bug and I realized that this small bug fix
> is not related to it based on my tests. Thus I sent the patch
> as a separate one.
> 
> > While this will definitely avoid the oops, I don't think it is quite
> > right. If we want to iterate all AGs, then we should be starting the
> > iteration at AG 0, not start_agno. i.e.
> >
> > +                       for_each_perag(args->mp, 0, args->pag)
> 
> I agree with your proposal because it is more direct.
> However, as the current for_each_perag() macro always assigns 0 to (agno),
> it will cause compilation errors.

Yup, I didn't compile test my suggestion - i just quickly wrote it
down to demonstrate what I was thinking. I expect that you have
understood that using for_each_perag() was what I was suggesting is
used, not that the sample code I wrote is exactly correct. IOWs,

		for_each_perag(args->mp, start_agno, args->pag)

would have worked, even though the code does not do what it looks
like it should from the context of start_agno. Which means this
would be better:

		start_agno = 0;
		for_each_perag_from(args->mp, start_agno, args->pag)

because it directly documents the value we are iterating from.

> Although I haven't checked other callers deeply, we should modify
> the macro as follows:
> 
>  #define for_each_perag(mp, agno, pag) \
> -   (agno) = 0; \
>   for_each_perag_from((mp), (agno), (pag))

That is not correct, either. agno needs to be a variable - it is
the loop agno counter that tracks the iteration.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
