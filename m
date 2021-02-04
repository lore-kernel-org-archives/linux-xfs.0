Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B37C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E903064F4E
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhBDJWo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:22:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235030AbhBDJWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 04:22:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612430464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TRTXs0Sdt49BwlaRyUcjv0+pSbIak45tCahdUTwsYlw=;
        b=aXh1kearmh0jYQPQJZmvl63Qr23cbtUvZlQ7nns88Sp5ONhBpmAVQ2bThHZDrtYJc8SnzF
        J3mDSZAGdXBJjALJKB5FXkHvFvpAezrFi9tE5YsFpeG8vea69k5qO8UAUFhmXeDKRCcbPT
        Q+b3eoXQzILg5IQ5GOXEt1hiADwvd1k=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-QxDVFmNiNk2UKUGkPiwzug-1; Thu, 04 Feb 2021 04:21:02 -0500
X-MC-Unique: QxDVFmNiNk2UKUGkPiwzug-1
Received: by mail-pl1-f198.google.com with SMTP id z9so1774665plg.19
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 01:21:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TRTXs0Sdt49BwlaRyUcjv0+pSbIak45tCahdUTwsYlw=;
        b=lv84nLssZl5w+pLop6A4LWgQlfBXe5NI20TIyTIJnVJlNe0nkL4d1Vhpcz6oOubsGv
         DsbJOt9AyGx8sjUUBVjm7/28XyrA0i2t99ePpe69o1TDy0l/yyFhQZ/s1o1UBYaQNuAW
         U5nvPYxO5FazG8zRn16NxpLH1kWg7XPemNBYocBJpjQzV9hdn7Y0kqWmIWM3CuC3GBZl
         z4jNY5fTQ0ldWb4vBQDp7xi0PKJ6++39Yb4aVOIuHO5Mkx6HMxBdCyghwHOS7y23L1M1
         N1mE6SYizJxV7Funs0VnDhljYTejbIajxlGeXs9K/Qr+b8NVvItrqTBluaclMyss0gk8
         QnOg==
X-Gm-Message-State: AOAM5321rgTZ0OBVWKm5Gtkt7mN2/Srzdhf0SNQIIs+eIA9FlI6rnYcY
        yvkV/qnwxo0BSkgmvv5hxLtbyrZKjPgcsdGhWTbDuv+vphAv+lj8+vOFl7gqNqR2Llv9/g2fJ4j
        5yoZF6FkMPKKacSO3Hnif
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr7577062pji.99.1612430461423;
        Thu, 04 Feb 2021 01:21:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzK0WUwfPie7RkYlN1RltaakkJVBddoqcBken0zLbw6SlnRgHK/Af8BF9Cyew3Opu+filG4JQ==
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr7577052pji.99.1612430461256;
        Thu, 04 Feb 2021 01:21:01 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a24sm5547498pff.18.2021.02.04.01.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 01:21:00 -0800 (PST)
Date:   Thu, 4 Feb 2021 17:20:50 +0800
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
Message-ID: <20210204092050.GB149518@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-8-hsiangkao@redhat.com>
 <20210203142359.GC3647012@bfoster>
 <20210203150132.GB935062@xiangao.remote.csb>
 <20210203180140.GI3647012@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203180140.GI3647012@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 01:01:40PM -0500, Brian Foster wrote:
> On Wed, Feb 03, 2021 at 11:01:32PM +0800, Gao Xiang wrote:

...

> > > > @@ -559,6 +560,10 @@ xfs_ag_shrink_space(
> > > >  	be32_add_cpu(&agf->agf_length, -len);
> > > >  
> > > >  	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> > > > +
> > > > +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL))
> > > > +		err2 = -ENOSPC;
> > > > +
> > > 
> > > Seems reasonable, but I feel like this could be broadened to serve as a
> > > generic perag reservation error tag. I suppose we might not be able to
> > > use it on a clean mount, but perhaps it could be reused for growfs and
> > > remount. Hm?
> > 
> > I think it could be done in that way, yet currently the logic is just to
> > verify the shrink error handling case above rather than extend to actually
> > error inject per-AG reservation for now... I could rename the errortag
> > for later reuse (some better naming? I'm not good at this...) in advance
> > yet real per-AG reservation error injection might be more complicated
> > than just error out with -ENOSPC, and it's somewhat out of scope of this
> > patchset for now...
> > 
> 
> I don't think it needs to be any more complicated than the logic you
> have here. Just bury it further down in in the perag res init code,
> rename it to something like ERRTAG_AG_RESV_FAIL, and use it the exact
> same way for shrink testing. For example, maybe drop it into
> __xfs_ag_resv_init() near the xfs_mod_fdblocks() call so we can also
> take advantage of the tracepoint that triggers on -ENOSPC for
> informational purposes:
> 
> 	error = xfs_mod_fdblocks(...);
> 	if (!error && XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
> 		error = -ENOSPC;
> 	if (error) {
> 		...
> 	}

Ok, I didn't look into much more about it since it's out of scope. I'd
try in the next version.

Thanks,
Gao Xiang

> 
> Brian
> 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > Brian
> > 
> 

