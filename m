Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471AAC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 15:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CB5564F86
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 15:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhBCPDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:03:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233210AbhBCPDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 10:03:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612364507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d7YFEMkh/ZwxqCF94V1CuYOkLJQVwRqXnixKpPLudTU=;
        b=T1/Nt8bQaJuXozxl6+QJCep0Fp2X+Ua8LyeOPdxxWMWo9B1qA8jNmo+R6Qkrx05u/Z/NJV
        yZx70FBrbtq7eI5E85r7c6yiHYyuzz7GTwyiK6oWJPYfpXlwSXs6MIXhT9ByQdgbpc59vY
        40RB/QHvzcLJDwEN+gPZnvVdNMiK9s8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-48c9ex72N-CdSMuVaowaYA-1; Wed, 03 Feb 2021 10:01:45 -0500
X-MC-Unique: 48c9ex72N-CdSMuVaowaYA-1
Received: by mail-pl1-f197.google.com with SMTP id 42so21041plb.10
        for <linux-xfs@vger.kernel.org>; Wed, 03 Feb 2021 07:01:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d7YFEMkh/ZwxqCF94V1CuYOkLJQVwRqXnixKpPLudTU=;
        b=CFd/yoL4YMwRewGNlVSBToNMVLUi6z+qyBm3PouBsLoNouyTPdXuO3RfLXML5MYNHj
         NsIFsppWVV57ZZ2qKfvfowSt3HoswaMzQnoCAcw7jKk2s/2x/c7S+bOBlRPvZ4j540q/
         m7KWTN0lIJMi+lYhlWd/QmaErS0bLAv7DidCDwGldmKLZbZFhneA0QHQUAn+YsEqEIgL
         PNBNRuVBpa/HSmWH85iAiJYKcRv5QNtczix1OsWRpvV2vYW0Gd29rIcURLL3L+rftB51
         +5DZF01v5s6wUELE9QxhCPJyYeD8zxSmttGShfw+QhwMT90XnF4a2D/19dnESoGB0djK
         pO+Q==
X-Gm-Message-State: AOAM5328rFC9LLJ8oKWypE62uy19UIGDcrwrxnCtLHrWfkIim4QUqgZF
        F9+RISOnvgUlEegsuOPtCnuesAsNaT1eNPeXN8dCot/ChDFRHBCOki9DP43l43TvHaMK6obHPti
        SLMDh3XJRl1koGDjrIGLv
X-Received: by 2002:a62:aa0a:0:b029:1c2:1baa:eaea with SMTP id e10-20020a62aa0a0000b02901c21baaeaeamr3593696pff.52.1612364503825;
        Wed, 03 Feb 2021 07:01:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJza+4YmHc6QinzaAHYjq/YHAHgQgLrfT/TwRjhXwKvDifzzUt2nLmAdCz8mLn+O5OklCgdEBw==
X-Received: by 2002:a62:aa0a:0:b029:1c2:1baa:eaea with SMTP id e10-20020a62aa0a0000b02901c21baaeaeamr3593681pff.52.1612364503605;
        Wed, 03 Feb 2021 07:01:43 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n7sm2483026pjm.49.2021.02.03.07.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 07:01:42 -0800 (PST)
Date:   Wed, 3 Feb 2021 23:01:32 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v6 7/7] xfs: add error injection for per-AG resv failure
 when shrinkfs
Message-ID: <20210203150132.GB935062@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-8-hsiangkao@redhat.com>
 <20210203142359.GC3647012@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203142359.GC3647012@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Wed, Feb 03, 2021 at 09:23:59AM -0500, Brian Foster wrote:
> On Tue, Jan 26, 2021 at 08:56:21PM +0800, Gao Xiang wrote:
> > per-AG resv failure after fixing up freespace is hard to test in an
> > effective way, so directly add an error injection path to observe
> > such error handling path works as expected.
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c       | 5 +++++
> >  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
> >  fs/xfs/xfs_error.c           | 2 ++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index c6e68e265269..5076913c153f 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -23,6 +23,7 @@
> >  #include "xfs_ag_resv.h"
> >  #include "xfs_health.h"
> >  #include "xfs_error.h"
> > +#include "xfs_errortag.h"
> >  #include "xfs_bmap.h"
> >  #include "xfs_defer.h"
> >  #include "xfs_log_format.h"
> > @@ -559,6 +560,10 @@ xfs_ag_shrink_space(
> >  	be32_add_cpu(&agf->agf_length, -len);
> >  
> >  	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> > +
> > +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL))
> > +		err2 = -ENOSPC;
> > +
> 
> Seems reasonable, but I feel like this could be broadened to serve as a
> generic perag reservation error tag. I suppose we might not be able to
> use it on a clean mount, but perhaps it could be reused for growfs and
> remount. Hm?

I think it could be done in that way, yet currently the logic is just to
verify the shrink error handling case above rather than extend to actually
error inject per-AG reservation for now... I could rename the errortag
for later reuse (some better naming? I'm not good at this...) in advance
yet real per-AG reservation error injection might be more complicated
than just error out with -ENOSPC, and it's somewhat out of scope of this
patchset for now...

Thanks,
Gao Xiang

> 
> Brian

