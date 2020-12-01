Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F59EC64E90
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 23:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E90AB222B8
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 23:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgLAXvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 18:51:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727635AbgLAXvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 18:51:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606866614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F4lkNiHf4D3oMP51xN3jOFx9+08VJSIxl9zLGVnblus=;
        b=YqEfOUSlSOTKOgREBEA3BWTBOiURILPV+zdyiBtT4pCKkpWfu2IeGK3QjeYLPslx3StGS4
        GSGsyBt+HINsWdoa0vE8gtqeRVPk2FzfBB0iLF2xFA0mBVM8/YW3U2WbLI7/s+2FQHVrtp
        rvzIQgxClHkI8kEMwaUorPiP/0MB2PM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-rQ9HKJJAOQChBTJdVaUt9w-1; Tue, 01 Dec 2020 18:50:12 -0500
X-MC-Unique: rQ9HKJJAOQChBTJdVaUt9w-1
Received: by mail-pg1-f200.google.com with SMTP id i6so1945860pgg.10
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 15:50:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F4lkNiHf4D3oMP51xN3jOFx9+08VJSIxl9zLGVnblus=;
        b=TZttKgpO4fpj1Bj2VZQ4s1FfiWaKZYbUZKdbZX5afTJDsJUSYn3r/1zEyUHgd4zzh5
         SvL8uR2VuXWggFTuoIFjpAI2He58uVCGanxfqpDWthftRmuhErLB/9EANqZSpWljyaUY
         SCokI0oDxOL7lje22mUPIs7jCvgBbSbuOLNrjYfb1o1KozcQbFKqT/BnMvLopMwA03oX
         Lp+d2X+KLCaT0kijIkwOqc+ato7iIGjeIxRq+advP36Ya0FEKGKuP/1NtnEe1E9atiQo
         nz4gwjl1AVtwykXsY4PDtQtttoLJ0ruy9bpxgzdVeJkem0nHeVEA/sGk36NOKXWFaqBB
         cZ0w==
X-Gm-Message-State: AOAM531soJoq8WwXJQ/f77nXnv/t8Baw8UIke1HBs6tsbhKd1C5NyoPz
        lanhDR4FU3F9sP1rSKBB+QN/6FGBg9Q121tAig5cp47c9dOCzOVRb3QFx8pcak3O6ELKTFqCLK+
        L8IB1F+6crxt8MgStEEnT
X-Received: by 2002:a63:4703:: with SMTP id u3mr23311pga.199.1606866611286;
        Tue, 01 Dec 2020 15:50:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQAt97ln+mB6il0cbgO2VU+I4cMZtpF1U71pbLwSSc65WDQcx1OyNJrYF6wuqih1P8FBxINA==
X-Received: by 2002:a63:4703:: with SMTP id u3mr23294pga.199.1606866611015;
        Tue, 01 Dec 2020 15:50:11 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y6sm24481pgg.80.2020.12.01.15.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 15:50:10 -0800 (PST)
Date:   Wed, 2 Dec 2020 07:50:00 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201201235000.GA1423765@xiangao.remote.csb>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
 <20201124155130.40848-2-hsiangkao@redhat.com>
 <20201201102100.GF12730@infradead.org>
 <20201201165511.GE143045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201201165511.GE143045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Tue, Dec 01, 2020 at 08:55:11AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 01, 2020 at 10:21:00AM +0000, Christoph Hellwig wrote:
> > On Tue, Nov 24, 2020 at 11:51:29PM +0800, Gao Xiang wrote:
> > > It's enough to just use return code, and get rid of an argument.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ialloc.c | 22 ++++++++++------------
> > >  1 file changed, 10 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > > index 45cf7e55f5ee..5c8b0210aad3 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > @@ -607,13 +607,14 @@ xfs_inobt_insert_sprec(
> > >  
> > >  /*
> > >   * Allocate new inodes in the allocation group specified by agbp.
> > > - * Return 0 for success, else error code.
> > > + * Return 0 for successfully allocating some inodes in this AG;
> > > + *        1 for skipping to allocating in the next AG;
> > 
> > s/for/when/ for both lines I think.
> > 
> > > + *      < 0 for error code.
> > 
> > and < 0 for errors here maybe.  But I'm not a native speaker either.
> 
> "Returns 0 if inodes were allocated in this AG; 1 if there was no space
> in this AG; or the usual negative error code." ?

Okay, will update this in the next version.

Thanks,
Gao Xiang

> 
> --D
> 
> > Otherwise looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

