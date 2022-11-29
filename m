Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC852C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 22:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbiK2WhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiK2WhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 17:37:13 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DAE45EDB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:37:12 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f3so14398922pgc.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t763N2jh7rg4kYAponJtkCimLoATeF1Sc8wIRXOylYE=;
        b=oPc9siN1bngML2NEm0rZfCTXEwYqamHUaL2WtAegExSesqOwaUjXlwrUT71y6xmj4M
         rLk5+aIOn6JQsV/c0vVoakq8XEOBNh0o1J48tMxcyAGH2EIBpGFshymYm/Xicz8mvPNx
         BVhoWMdrS72LqV19N9U/CdE0qr7/g2egvSPKVpscttApzUUdxOownpEzoN4UVflagcF+
         T3YWyAwyK+UwiN8Gn04pePrCYlres3vdrd8NSv1K5oEgLVPlJpbodWUe5lA6rzo6DnyF
         xNQ66AnHbnXIj8SPOGHjTEdjm0qi2utSJiUatp9oTacg2hH67iyHm92iSf44My045uUs
         6+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t763N2jh7rg4kYAponJtkCimLoATeF1Sc8wIRXOylYE=;
        b=73x0kJX+xbfGhEHFx0VsWVUEBypYRiHjdWr4qnchc90IpAkSJSM3wcwJUEKAZvroDC
         kqB8dFAuTz2Eb0cOeCRIhPy3/k/GBqA4AVx09rDIcUUwKyrlA2SVK8qBsTee4eyJZ1gC
         foDl/iXcLXMeCx+652jZP2JKjeaoN1ClV8jOOsVSgbQ1IGpuYseCVxTIA52fKKnUzlds
         O1hib3n5zkW9O0TVnIXLoVTaX3AqyWad94XFuJRnxg3Mm+o6aM9Z8IXLiNBycoAtzd2/
         +K44kwFxpGmYgq3sJRmYMw8IEn2S01ecV0OXrVQKOmgNtJdontwA+MxpR9lFSfdx+csA
         Mr+A==
X-Gm-Message-State: ANoB5pmG2acwExbyRe+bAyy++jDjdm352RXAnuxvhSPpmeXk4OMoo1FQ
        HyA9iguy9I/Kds6z6uS0Ge6GT5s8cf/6zg==
X-Google-Smtp-Source: AA0mqf6wlpzf9pF15MuiYVlcwwla4CwGcB26A19Dv/yVkqliiI12PChjMR9zS1vglFdhJUrHAR65eA==
X-Received: by 2002:a63:e70b:0:b0:473:e502:9a21 with SMTP id b11-20020a63e70b000000b00473e5029a21mr33513217pgi.238.1669761432180;
        Tue, 29 Nov 2022 14:37:12 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id u207-20020a6279d8000000b00575da69a16asm10854pfc.179.2022.11.29.14.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 14:37:11 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p09Dw-002b38-W0; Wed, 30 Nov 2022 09:37:09 +1100
Date:   Wed, 30 Nov 2022 09:37:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: estimate post-merge refcounts correctly
Message-ID: <20221129223708.GK3600936@dread.disaster.area>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <166975929675.3768925.10238207487640742011.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166975929675.3768925.10238207487640742011.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 02:01:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upon enabling fsdax + reflink for XFS, xfs/179 began to report refcount
> metadata corruptions after being run.  Specifically, xfs_repair noticed
> single-block refcount records that could be combined but had not been.
> 
> The root cause of this is improper MAXREFCOUNT edge case handling in
> xfs_refcount_merge_extents.  When we're trying to find candidates for a
> refcount btree record merge, we compute the refcount attribute of the
> merged record, but we fail to account for the fact that once a record
> hits rc_refcount == MAXREFCOUNT, it is pinned that way forever.  Hence
> the computed refcount is wrong, and we fail to merge the extents.
> 
> Fix this by adjusting the merge predicates to compute the adjusted
> refcount correctly.
> 
> Fixes: 3172725814f9 ("xfs: adjust refcount of an extent of blocks in refcount btree")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
