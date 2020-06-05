Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DA2C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 01:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB40B2074B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 01:45:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/UVxeVB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgFEBpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 21:45:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47337 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725863AbgFEBpB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 21:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591321500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f/TCsD0DgpoPE3QWXJH5c+Zt8vsWf9D7Rw44sdCwBU0=;
        b=C/UVxeVBe/geqdTQ18jefbluoX5leLuUwgO8LnqBLpu6s+ZDQCVrK1e4AV0m7yAmU5w/yn
        QZtgGMB8Zv90qj7FFPlt/pNYJ+bs3fBEdD9dGzBJBH/4H2AalgysLvcCyrT+PXFn2G2nJb
        0a/axicyLld/9+edTqNf5XAtg3eEAv8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-kSRHODoWN_KAg1SsQ4Zssw-1; Thu, 04 Jun 2020 21:44:59 -0400
X-MC-Unique: kSRHODoWN_KAg1SsQ4Zssw-1
Received: by mail-pf1-f198.google.com with SMTP id m11so2536894pfh.22
        for <linux-xfs@vger.kernel.org>; Thu, 04 Jun 2020 18:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f/TCsD0DgpoPE3QWXJH5c+Zt8vsWf9D7Rw44sdCwBU0=;
        b=XZlhE0Z7z3wt+rFuudiPHliUSb3DXwATFnWTZPAKTD7ag7P8lmF3KbXGVLmy8E2Jey
         IChfDFQfH5uzXsfVGRndcrA67w4vV+Py9cwTeGtPRRTIt6+50XA0MY9uSo4UUioGUf2N
         7bbRu9dwdUMym85T+hUmyGp5qBAFk7qX9bkuIpa7sh7Khj7Fzy+4SzThTmhPel5qtkAr
         x+m2hxfQ3mT4WQsWe9gx4UVambbfMtsSNlq86r+1fVrxpGyrWIET1Wm7YCYJyYNRI355
         2CRrz7vBgVjvmDeFV0Ft1d0urC8aHlu4IO6maIxNsxfIamhLntGSb0yciifuj61JTtKT
         69iw==
X-Gm-Message-State: AOAM533gan3pa+Q8dReRa/b9B6rifwG1mhEyQlriykGmqSL+s0Gs080k
        JOd2V2GRFCuiG9qQ9NvBGknPdXQnqq6TJ0i2zh2KNIgmVYH8Kmr/wuWIJu4MOy+n6ancNv8O8p4
        OcIxrD3HjY1LMpB1aZEyh
X-Received: by 2002:a63:4b0a:: with SMTP id y10mr7190479pga.57.1591321498328;
        Thu, 04 Jun 2020 18:44:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXkWrD5FcDA/SQTB5j6whFpEIxgWr+Uvu5JQb0NGj8hXekB/BcOCsNRjPwRjGFzcZI8dVa9A==
X-Received: by 2002:a63:4b0a:: with SMTP id y10mr7190463pga.57.1591321498075;
        Thu, 04 Jun 2020 18:44:58 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x14sm1217317pfq.80.2020.06.04.18.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 18:44:57 -0700 (PDT)
Date:   Fri, 5 Jun 2020 09:44:47 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200605014447.GA25293@xiangao.remote.csb>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603121156.3399-1-hsiangkao@redhat.com>
 <20200604215917.GS2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604215917.GS2040@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 07:59:17AM +1000, Dave Chinner wrote:
> On Wed, Jun 03, 2020 at 08:11:56PM +0800, Gao Xiang wrote:

...

> 
> Ok, I think we had a small misunderstanding there. I was trying to
> say the asserts that were in the first patch were fine, but we
> didn't really need any more because the new asserts mostly matched
> an existing pattern.
> 
> I wasn't suggesting that we do this everywhere:
> 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 9d84007a5c65..4b8c7cb87b84 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -563,7 +563,9 @@ xfs_ag_get_geometry(
> >  	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
> >  	if (error)
> >  		goto out_agi;
> > -	pag = xfs_perag_get(mp, agno);
> > +
> > +	pag = agi_bp->b_pag;
> > +	ASSERT(pag->pag_agno == agno);
> 
> .... because we've already checked this in xfs_ialloc_read_agi() a
> few lines of code back up the function.
> 
> That's the pattern I was refering to - we tend to check
> relationships when they are first brought into a context, then we
> don't need to check them again in that context.  Hence the asserts
> in xfs_ialloc_read_agi() and xfs_alloc_read_agf() effectively cover
> all the places where we pull the pag from those buffers, and so
> there's no need to validate the correct perag is attached to the
> buffer every time we access it....

Sorry about that, I folded in ASSERTs of my debugging code at that time.
Because that is the straight way to check if somewhere has strange due
to my modification, but some are unnecessary really, I didn't check that,
sorry about that. I will check again and remove unneeded ASSERTs
in the next version.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

