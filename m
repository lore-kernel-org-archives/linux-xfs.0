Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB180C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93DBD235FF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgLGOWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:22:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgLGOWW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:22:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607350855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JLDMVhSIGIMERc5PZhOo57C42S41fmMhHnQ7kmISmW0=;
        b=bBLAHD8wGIRkPihrMIgAmoOhH0sEHIx5AxEm9YVVh5cge2tjvR/eVbuFP+4VmVNf+rxNB/
        IXdOikQIEO5nS1ifVEbuVcwvEIeKqs1vkTPTvhUOtOHIK41PAtEa9ctkpUiPmYPVUCDpi0
        gqu7hXZc3ppQ4cdkZUYHPt8klM7D8m0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-u-mmneYVMc-k-sAhT4wxoA-1; Mon, 07 Dec 2020 09:20:54 -0500
X-MC-Unique: u-mmneYVMc-k-sAhT4wxoA-1
Received: by mail-pg1-f200.google.com with SMTP id l7so8855926pgq.16
        for <linux-xfs@vger.kernel.org>; Mon, 07 Dec 2020 06:20:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JLDMVhSIGIMERc5PZhOo57C42S41fmMhHnQ7kmISmW0=;
        b=djWoWiPDYQT+GYgooVhrOo13ukJn2+PPa5/35kwXW+tsYUQfCqszBA13ZqePjADkFR
         SkLa96llCuyCnxVxQ9Yhq7o1U+UnfUoD2LeKULZC+7AxlVq9RSN6Ba3S6heil13phesP
         C8iongKCMewl/5lgVBWeAAUmPQLdOmSZVnf9O2bWVbIAyIFR5VqXoJbKMFKQ3JZgfB4k
         rLSvI3NCpSSFYyT7hGaJJGl0e6Y0/sOz/gbY7CKopRGL7BRffmuxVht088Nva5vlguSH
         Mqx0uvBp0+yGwWFqUxzA+osB23RewPK6511L5N18XI/6iefcaxDfl3KfovdS9MnZ7PPb
         uTjg==
X-Gm-Message-State: AOAM531RFE7GANiMiOsm+CgjDiKFyJW9Dnu7pjbZuKdG5lcI48vn0X5u
        WCNbNEcxNWim8lPYXdiQ7xoyZ+fTDZ7fBAzIr0J6wg5m4FMzkmtKe1HKuADqQ0Af5BUkP/Ga/C1
        DHXWk+pCsGrP1gEaFOKc5
X-Received: by 2002:aa7:8499:0:b029:19e:6c5:b103 with SMTP id u25-20020aa784990000b029019e06c5b103mr5406927pfn.13.1607350853007;
        Mon, 07 Dec 2020 06:20:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxE2/7kl6A+K/kNbtip+FCDemP7TZ9r+nukmSOoSZ6UOPFMpoLQyd/3/Tbtt40Xh2Rq3zGtWg==
X-Received: by 2002:aa7:8499:0:b029:19e:6c5:b103 with SMTP id u25-20020aa784990000b029019e06c5b103mr5406917pfn.13.1607350852817;
        Mon, 07 Dec 2020 06:20:52 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w1sm6199687pjt.23.2020.12.07.06.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:20:52 -0800 (PST)
Date:   Mon, 7 Dec 2020 22:20:41 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 4/6] xfs: move xfs_dialloc_roll() into xfs_dialloc()
Message-ID: <20201207142041.GC2817641@xiangao.remote.csb>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-5-hsiangkao@redhat.com>
 <20201207135336.GE29249@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201207135336.GE29249@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 02:53:36PM +0100, Christoph Hellwig wrote:
> >  
> >  		if (ialloced) {
> >  			/*
> > +			 * We successfully allocated some inodes, roll the
> > +			 * transaction so they can allocate one of the free
> > +			 * inodes we just prepared for them.
> 
> Maybe:
> 
> 			/*
> 			 * We successfully allocated space for an inode cluster
> 			 * in this AG.  Roll the transaction so that we can
> 			 * allocate one of the new inodes.
> 			 */

Okay, will update.

Thanks,
Gao Xiang

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

