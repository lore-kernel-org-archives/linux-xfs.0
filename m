Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61340C74A5B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCRAjW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCRAjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:39:18 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48882A163
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:39:17 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v21so7042378ple.9
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679099957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dju/kwwr7M4zq7eXK8lZTVPjnEr7TjDzQbkU3XtGdRU=;
        b=Ppsd6BrrNEjHuMSByKAJHneflCABARPDK6cM6Qo692hcwnEgbISzob8uK3KSDDgQV1
         dgdJlE9u5AeJkTg8HkYk3bZpmiuA48MRqhB3cWaE6ATTDa53XECkDMtRgA5TJPrwLLgv
         Tmlgop+oKnTXBHCzjUpssLQwVX6/3uZIHor3Vbjkl2XaE8v0GbPwfMtkYezi+wi1l719
         QXFzOA4EHbMur4ZGs236WOriKhX1sEJhd8CyfHxLn9ZD1i8FZJqxdt67yjpVFnr74zrF
         YN8omzR5SxtgdAyCMSbTqwu1Wj/R+kk2qEGT9INeH1F2NJOKAwCJWWPsLZttbr2G3r82
         l6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679099957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dju/kwwr7M4zq7eXK8lZTVPjnEr7TjDzQbkU3XtGdRU=;
        b=GxJm1bvHwvXrBmEI0qZjHB7HmMO6hDfT0ITqxjGrmQyBlSKeCsvgaxiZR+1P/aiTsw
         8UxOXnzdmJlt7U9A8vv6xVbseCJhPOe2D6GuEsragXySdVMixURZOZMxKuvWccYTpx2g
         sUWg4ymtXsH9v+zpgYpvFSuPLhmM9gEuCG+E29nNo4C9QhX4NgDtVw14zeqmhozxZuCs
         9v0I1XgaFIXn2wPy92Y8q3SbiQcrgfYrD47QA4WlaP2ubSpL8Km1qQKNe9BpJClNPoWO
         V1v9G+EqCcn1kPIzKTZ9/wm/vCOmDTBFSoNGxMX6cMS9iIUr8pDIcjNyaE8jQ8lPExdg
         MkzA==
X-Gm-Message-State: AO0yUKWx8faPNsPfVJoCn+oiK8/2SPDPrStzPbCshuP4e91uiZ/f0nGR
        3TJ9U4D1dcguSAnu+BnQlQgm/A==
X-Google-Smtp-Source: AK7set+S/elGuOJOsq63eoE1wLBLBKxEXQXFUuSsAePPep1svyJqdsNHIgRH2UcZQJ0mIkkIv8QIvQ==
X-Received: by 2002:a17:902:ce87:b0:19a:9434:af30 with SMTP id f7-20020a170902ce8700b0019a9434af30mr10117856plg.18.1679099957158;
        Fri, 17 Mar 2023 17:39:17 -0700 (PDT)
Received: from destitution (pa49-196-94-140.pa.vic.optusnet.com.au. [49.196.94.140])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902820800b0019a7ef5e9a8sm2124109pln.82.2023.03.17.17.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 17:39:16 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pdKbK-000J8m-0L;
        Sat, 18 Mar 2023 11:39:14 +1100
Date:   Sat, 18 Mar 2023 11:39:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tracepoints for each of the externally visible
 allocators
Message-ID: <ZBUIMllXvBrvP9md@destitution>
References: <20230316164743.GL11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316164743.GL11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2023 at 09:47:43AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are now five separate space allocator interfaces exposed to the
> rest of XFS for five different strategies to find space.  Add
> tracepoints for each of them so that I can tell from a trace dump
> exactly which ones got called and what happened underneath them.  Add a
> sixth so it's more obvious if an allocation actually happened.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   17 +++++++++++++++++
>  fs/xfs/xfs_trace.h        |    7 +++++++
>  2 files changed, 24 insertions(+)

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
