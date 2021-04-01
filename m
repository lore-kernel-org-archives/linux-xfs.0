Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA18C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 02:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A14061077
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 02:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhDAC3s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 22:29:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232565AbhDAC33 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 22:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617244169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bFC/syxTWWRF3Tp46amH2We+j3dm1u7awEAOSUGcGEo=;
        b=eV58VCBBsJ8kNFtNqkF3BueYb7JuG+r+bfvB32ekO+OVAMKR7Q2UZlAsg3NxwF666bfHqt
        fFwXbqfJ1iTFGtWra/kezEaFABgeNm9atDuO8tKMfKheoiuUBtuRu861EpHhd+9jJTB3di
        4pR1V/1+GcJ5j+KewvPuvjqWeG9d6oM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-NoiaBElaOH-vmowlAQc7vQ-1; Wed, 31 Mar 2021 22:29:27 -0400
X-MC-Unique: NoiaBElaOH-vmowlAQc7vQ-1
Received: by mail-pj1-f72.google.com with SMTP id e15so2257718pjg.6
        for <linux-xfs@vger.kernel.org>; Wed, 31 Mar 2021 19:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bFC/syxTWWRF3Tp46amH2We+j3dm1u7awEAOSUGcGEo=;
        b=Ck1g3LR4BD4h7DymFMRMYFSMvEhLCFjjFbxYR/UFG0SesoAPPJVJs0+Dw2bzFfbLN/
         BtKkkqoeBlWcSPbt8LKkrfa2D9+xTiaObZ6VYWqh1xUhARAheRAm/VZ11pH0AlXahHwJ
         BCl5TIJ1e0p8MYDGYQRXBgvKOtTvFN0K8riz7lFxpuFE7hasdhOrBZOA+ljnq8J8HfBL
         TD2NdJanKYGhrfTEf9stJRlqZMmvYRNlErgloW2d/F/Q+y6iC84573iZGKrC339yXzs4
         hvStxbVP4hPmwey73SFg3vIHwsKdutjvD8NczyyRXJW6fcLDScAAEaSLkjhkvgNEfgne
         hYCQ==
X-Gm-Message-State: AOAM533Qo2pjVfQbs2jto6dbAK8UozbgAPKxE/V4y5zm7YjFoN5UXTPt
        LoOrnSLZRWuwo+gUjLNB3CWrlZJNhmp31h4QcdAZrTq56LX4/W1INgoeYL0VWV4nUjN6+RZSFN2
        qd4XRadrUDpfjg2708LSZ
X-Received: by 2002:a17:902:7612:b029:e5:f0dd:8667 with SMTP id k18-20020a1709027612b02900e5f0dd8667mr5880555pll.59.1617244166233;
        Wed, 31 Mar 2021 19:29:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfZ3BeRhTbRAmFiHmIyQQO1croWmDDUDJRXGxQcVuOWGFzlJHSWrWAt9PJY1kHJahBZv2L+w==
X-Received: by 2002:a17:902:7612:b029:e5:f0dd:8667 with SMTP id k18-20020a1709027612b02900e5f0dd8667mr5880544pll.59.1617244166023;
        Wed, 31 Mar 2021 19:29:26 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c193sm3451059pfc.180.2021.03.31.19.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 19:29:25 -0700 (PDT)
Date:   Thu, 1 Apr 2021 10:29:15 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     lixiaokeng <lixiaokeng@huawei.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, sandeen@redhat.com,
        darrick.wong@oracle.com, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] xfs: fix SIGFPE bug in align_ag_geometry
Message-ID: <20210401022915.GA3796795@xiangao.remote.csb>
References: <61b82c3c-5bcf-0c91-4fa5-fa138b52a6a6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <61b82c3c-5bcf-0c91-4fa5-fa138b52a6a6@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 01, 2021 at 09:58:53AM +0800, lixiaokeng wrote:
> In some case, the cfg->dsunit is 32, the cfg->dswidth is zero
> and cfg->agsize is 6400 in align_ag_geometry. So, the
> (cfg->agsize % cfg->dswidth) will lead to coredump.
> 
> Here add check cfg->dswidth. If it is zero, goto validate.
> 

May I ask what's the command line? and is it reproducable on
the latest upstream version?

Thanks,
Gao Xiang

> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  mkfs/xfs_mkfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a135e06..71d3f74 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2725,6 +2725,9 @@ _("agsize rounded to %lld, sunit = %d\n"),
>  				(long long)cfg->agsize, dsunit);
>  	}
> 
> +	if (!cfg->dswidth)
> +		goto validate;
> +
>  	if ((cfg->agsize % cfg->dswidth) == 0 &&
>  	    cfg->dswidth != cfg->dsunit &&
>  	    cfg->agcount > 1) {
> -- 
> 

