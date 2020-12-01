Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C76EC71155
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 11:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2262220770
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 11:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qxz31QK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388302AbgLAL47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 06:56:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387433AbgLAL47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 06:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606823732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EVm81zhBUb57IykrQ2CEOWL5v8BJ/iVS5hQsDtaW6w=;
        b=Qxz31QK91hjB23oajIR9O2lbUB3ZswU9OdNLSNPrTmnELcfwblh7j67uynqSocoVAZJoV/
        KNi5PhSpFWH9+bbRhmVJf5DVdYmHRu6VLTHZeegQvvhoBqQF6jiGQQxmoODrqkuYtaiztV
        5rziAdRmS1H8qvlwIzxHUAfm5FgQplU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-RhWT6R1RNb6iVKEeWo8fzQ-1; Tue, 01 Dec 2020 06:55:31 -0500
X-MC-Unique: RhWT6R1RNb6iVKEeWo8fzQ-1
Received: by mail-pg1-f198.google.com with SMTP id t7so876586pgr.13
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:55:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0EVm81zhBUb57IykrQ2CEOWL5v8BJ/iVS5hQsDtaW6w=;
        b=XfMhfcN96M88lJ1Nf+xA/fGPKwRvxy7A4Kn1ncVluVsTIIfNxHGSbkwwLA+51Jas2o
         HSGdPmjTDoHQDUHKgSNej5duYqDaeWHl3CBn40F11DpsoM8W0zYcLWJ6vl3SJkRvgApB
         vxwmGBBSWqT0rIzOMXEIj0byjsM5Srrnp2iPk1MLtV1WAlxx6kX3VncHx/KFndXEuxd8
         OtGq8ZzREFotPaj+3qUpTw9DWmMEMzLNduuvm+LgHrvuf0ctA7Oa5aHEcTu0S1PT1Z2x
         SzqODROQlw2+HNvRzSOqbohoaBaghzq5qZ2uQpdT9UUNApYDyhcgAb3YQTF3lxvU5PRI
         Hdow==
X-Gm-Message-State: AOAM5338c7wxxdAuQdKDqq7hWAhPa4KEZE9NDdKlWZJ7SUmnR+A76GgX
        jntrhOwp9BiTxKuG31ioXDCfFARnZREKL22TmpFsJ370NwXY6nmxNrmxWFvnC12wCsVNOI57pWN
        +HLunMiDljB/fslsbnP/y
X-Received: by 2002:a17:90b:33d1:: with SMTP id lk17mr2362948pjb.174.1606823729884;
        Tue, 01 Dec 2020 03:55:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlJUMhetY9YzBLwnve3Xecj93njMmMMPnHuQ2Jj1spBO+0CgToJubRv4gGnTQF44qOyX35Zw==
X-Received: by 2002:a17:90b:33d1:: with SMTP id lk17mr2362937pjb.174.1606823729668;
        Tue, 01 Dec 2020 03:55:29 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a3sm2593417pfo.46.2020.12.01.03.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 03:55:29 -0800 (PST)
Date:   Tue, 1 Dec 2020 19:55:19 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201201115519.GB1323470@xiangao.remote.csb>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
 <20201124155130.40848-2-hsiangkao@redhat.com>
 <20201201102100.GF12730@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201201102100.GF12730@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Tue, Dec 01, 2020 at 10:21:00AM +0000, Christoph Hellwig wrote:
> On Tue, Nov 24, 2020 at 11:51:29PM +0800, Gao Xiang wrote:
> > It's enough to just use return code, and get rid of an argument.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 22 ++++++++++------------
> >  1 file changed, 10 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 45cf7e55f5ee..5c8b0210aad3 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -607,13 +607,14 @@ xfs_inobt_insert_sprec(
> >  
> >  /*
> >   * Allocate new inodes in the allocation group specified by agbp.
> > - * Return 0 for success, else error code.
> > + * Return 0 for successfully allocating some inodes in this AG;
> > + *        1 for skipping to allocating in the next AG;
> 
> s/for/when/ for both lines I think.
> 
> > + *      < 0 for error code.
> 
> and < 0 for errors here maybe.  But I'm not a native speaker either.
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks for your review! I'm now spilting Dave's patch for better review
as well (also already with some update since some lack of modification),
will re-test and resend together with this series later.

Thanks,
Gao Xiang


