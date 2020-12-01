Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306C0C64E90
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 00:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB0A3221FF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 00:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgLBAA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 19:00:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbgLBAA4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 19:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606867169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBqctEgUjnUSdhriE5RKXO7txjn/VplepcevOdViy/4=;
        b=AaPDtiDMssq37+OekjFpignSS3o9E9wWYeKagD4Mg8tEqqBHFaidAO1f6vPIr6+6ldMUSP
        AEpHcEvPe712YgiUMCGGkMpKeX7INTTPTer9VYZbdiXcIXhvUkk/M3ZVNvbjPnn05p6xRX
        x6F8V0wmCvKf94/NNkVEaB2cr0Qzc0k=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-_yJ6hakQMlu9akEOEEQSHA-1; Tue, 01 Dec 2020 18:59:24 -0500
X-MC-Unique: _yJ6hakQMlu9akEOEEQSHA-1
Received: by mail-pf1-f200.google.com with SMTP id l11so19634pfc.16
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 15:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tBqctEgUjnUSdhriE5RKXO7txjn/VplepcevOdViy/4=;
        b=a1MdOwbjqgnTZ1B9CqEV0Xr5zAe2CVd+WqR8Fe6wMTPcpM7mwgFdpwDrau1DBLkksn
         YGD7O5VVLlhD+wiqSIZy7BLxEgXyIpOMHHZRU/Uic5uRoAa9iHAa3Ygd3Ch80mxzw+9i
         iq+5PRKnJ9DDcG8HcD3iOK46T+D550rV0ZTEi55NrB2v0EjUjSOw6qWagdP1+s4VYN2c
         Y8PhyRbVXoU9nmchOW5L9VR23Wdfk82BtNK1U0v7izDdB1YkIrlq3jeatcmfcGuMTWt8
         fsalDOglHRIpmIitHpJEfd/Y/V9FJ3mUsVp3yx9x22NFhJCIibu158PIGJYxHqSHI8/V
         vPUA==
X-Gm-Message-State: AOAM533yivjCZrHX93yrK4LnSYWO0AKmodC/nToE3ZFDIMGuu6h6vY2Z
        4WrhBfrOX4tmF5lYVwuRTri3Pi6P7gea2HfYTwKKBlHxrQ6UbwKrpWoBvkqBQYfdLJueeKTLQAn
        GVrx/mi+4kuQHR2/rtgyz
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr171209pjt.228.1606867163543;
        Tue, 01 Dec 2020 15:59:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNIXOAYuh9i6b32OeXnhhz949wI7PT55LqaSmrdhN8O4zQ78Qk3lau3zKRhbes+6oVBoEjsg==
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr171201pjt.228.1606867163386;
        Tue, 01 Dec 2020 15:59:23 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h16sm38706pjt.43.2020.12.01.15.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 15:59:23 -0800 (PST)
Date:   Wed, 2 Dec 2020 07:59:13 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: kill ialloced in xfs_dialloc()
Message-ID: <20201201235913.GB1423765@xiangao.remote.csb>
References: <20201124155130.40848-1-hsiangkao@redhat.com>
 <20201124155130.40848-2-hsiangkao@redhat.com>
 <20201201170420.GG143045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201201170420.GG143045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 09:04:20AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 24, 2020 at 11:51:29PM +0800, Gao Xiang wrote:

...

> > @@ -1799,8 +1797,8 @@ xfs_dialloc(
> >  			goto nextag_relse_buffer;
> >  
> >  
> > -		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
> > -		if (error) {
> > +		error = xfs_ialloc_ag_alloc(tp, agbp);
> > +		if (error < 0) {
> >  			xfs_trans_brelse(tp, agbp);
> >  
> >  			if (error != -ENOSPC)
> > @@ -1811,7 +1809,7 @@ xfs_dialloc(
> >  			return 0;
> >  		}
> >  
> > -		if (ialloced) {
> > +		if (!error) {
> 
> I wonder if this should be "if (error == 0)" because the comment
> for _ialloc_ag_alloc says that 0 and 1 have specific meanings?

I'm fine with either way personally, it could make checkpatch.pl
happy by using "if (!error)" though... (always follow such rule
when I walked into the kernel community...)

Thanks,
Gao Xiang

> 
> Otherwise looks fine to me.
> 
> --D
> 
> >  			/*
> >  			 * We successfully allocated some inodes, return
> >  			 * the current context to the caller so that it
> > -- 
> > 2.18.4
> > 
> 

