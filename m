Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813B1C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 02:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46B4261057
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 02:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhDACyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 22:54:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhDACxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 22:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617245631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D42lu9W2KznFv1+gKHDSotZgj6bUs9Enbl+V/r8tax4=;
        b=U9L9WhNqBSboD410X+4Mz85VvA085avgibVocdlTS5DG/BPnQuPJTHC3MTHrj9AsQ7qMqD
        cBEMU4z8183ix2tUArQbYkLH2QA3ml5a/ExrXAxLY25l8eM8S4ZSxjlfdNG/LXKI3ZxPo2
        1E9RH7PO4rFKOkk55KKlbG8i6ayBBxM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-dbGOa85CNc-_2_KeikTBIA-1; Wed, 31 Mar 2021 22:53:49 -0400
X-MC-Unique: dbGOa85CNc-_2_KeikTBIA-1
Received: by mail-pf1-f197.google.com with SMTP id o206so1316171pfd.1
        for <linux-xfs@vger.kernel.org>; Wed, 31 Mar 2021 19:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D42lu9W2KznFv1+gKHDSotZgj6bUs9Enbl+V/r8tax4=;
        b=f21Y+Sm3nQ0xIeq7CwLtjpJR6nT8jVUx2PRFY6tuIn9RBWhs0/Evp2vfXsKq7dD0Tc
         1R25cH913YRZwA9guuKxxiHFzZP7zsau/GPtIebDDIerEXcFI/qc5kkqwAhtK9Ny1Qwa
         QW9fNtVR6AnF2HCACPyLrr0PBD9Ct3C1nbr5stwx5y9gD9a/+kBk5kAqTRlRBcYJkDT8
         RJU3Pmk2qjSzLDOZCvzoLLmLjd4f2+y+TmRdLM5Qn+39Kw4K+guQqQl0e2116xZuWsuY
         TXDvhSSD+6tOXwt9QylfmTR5PwSOR1hUhDm5iBOvmU8lnlSm+56FwBz3CGUuni0WKmRz
         7Tsg==
X-Gm-Message-State: AOAM530AwLALR/Mpj2muYrFkXlB1QRL5RJu4ubWtbonrz2j9tWs4imd7
        QxnBgDv3XZOolGIDdJ0mP56+Zu2RgKFYDIU+McOC37oxX3HwFpVa3X3n2nAqUtZQ60j9F5blhDM
        jZ1yw2cWJfeD5OYjc96DV
X-Received: by 2002:a17:90a:f403:: with SMTP id ch3mr6575634pjb.126.1617245628502;
        Wed, 31 Mar 2021 19:53:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6fF8LEQO4QnGHq1gSF8pElnFC3muanTgH6kx5iCSIdHYp8XoTU4uEwodJxhI5h6uqJcp4Uw==
X-Received: by 2002:a17:90a:f403:: with SMTP id ch3mr6575621pjb.126.1617245628309;
        Wed, 31 Mar 2021 19:53:48 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm3228660pgv.74.2021.03.31.19.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 19:53:47 -0700 (PDT)
Date:   Thu, 1 Apr 2021 10:53:37 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     lixiaokeng <lixiaokeng@huawei.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, sandeen@redhat.com,
        darrick.wong@oracle.com, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] xfs: fix SIGFPE bug in align_ag_geometry
Message-ID: <20210401025337.GD3589611@xiangao.remote.csb>
References: <61b82c3c-5bcf-0c91-4fa5-fa138b52a6a6@huawei.com>
 <20210401022915.GA3796795@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210401022915.GA3796795@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 01, 2021 at 10:29:15AM +0800, Gao Xiang wrote:
> On Thu, Apr 01, 2021 at 09:58:53AM +0800, lixiaokeng wrote:
> > In some case, the cfg->dsunit is 32, the cfg->dswidth is zero
> > and cfg->agsize is 6400 in align_ag_geometry. So, the
> > (cfg->agsize % cfg->dswidth) will lead to coredump.
> > 
> > Here add check cfg->dswidth. If it is zero, goto validate.
> > 
> 
> May I ask what's the command line? and is it reproducable on
> the latest upstream version?

Btw, according to the line number of your patch format, it seems
your patch was based on "v4.17.0". May I ask which version you
were testing? If so, that is an outdated version, it'd be better
to try with latest version first.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang
> 
> > Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> > ---
> >  mkfs/xfs_mkfs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index a135e06..71d3f74 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2725,6 +2725,9 @@ _("agsize rounded to %lld, sunit = %d\n"),
> >  				(long long)cfg->agsize, dsunit);
> >  	}
> > 
> > +	if (!cfg->dswidth)
> > +		goto validate;
> > +
> >  	if ((cfg->agsize % cfg->dswidth) == 0 &&
> >  	    cfg->dswidth != cfg->dsunit &&
> >  	    cfg->agcount > 1) {
> > -- 
> > 

